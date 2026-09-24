// @testmode wasi
import Debug "mo:core/Debug";
import Nat "mo:core/Nat";
import Text "mo:core/Text";

import { test; suite } "mo:test";
import Fuzz "mo:fuzz";

import { Candid; URLEncoded } "../src";

// Round-trip properties for the form encoder, and a record of where it
// currently loses data.
//
// UrlEncoded had example-based tests only. It is also the codec behind
// every generated connector that posts a form body, so what it does to
// an arbitrary user-supplied string matters well beyond this repo.

type Form = { msg : Text };

let fuzz = Fuzz.fromSeed(0x0f0e3d17);
let limit = 500;

// Encode `{ msg = payload }`, decode it again, hand back what came out.
func roundTrip(payload : Text) : { #value : Text; #encodeErr : Text; #decodeErr : Text; #shape } {
    let wire = switch (URLEncoded.toText(to_candid ({ msg = payload }), ["msg"], null)) {
        case (#ok t) t;
        case (#err e) return #encodeErr(e);
    };
    switch (URLEncoded.fromText(wire, null)) {
        case (#ok blob) {
            let decoded : ?Form = from_candid (blob);
            switch (decoded) {
                case (?form) #value(form.msg);
                case null #shape;
            };
        };
        case (#err e) #decodeErr(e);
    };
};

func survives(name : Text, payload : Text) {
    test(
        name,
        func() {
            switch (roundTrip(payload)) {
                case (#value got) {
                    if (got != payload) {
                        Debug.print("round-trip mismatch:");
                        Debug.print("  sent: " # payload);
                        Debug.print("  got:  " # got);
                        assert false;
                    };
                };
                case (other) {
                    Debug.print("round-trip failed for " # payload # ": " # debug_show other);
                    assert false;
                };
            };
        },
    );
};

// Decode `msg=<raw>` and check the Candid type the reader chose.
func infers(name : Text, raw : Text, expected : Candid.Candid) {
    test(
        name,
        func() {
            let #ok(blob) = URLEncoded.fromText("msg=" # raw, null) else {
                Debug.print("decode failed for msg=" # raw);
                return assert false;
            };
            let #ok(values) = Candid.decode(blob, ["msg"], null) else {
                Debug.print("candid decode failed for msg=" # raw);
                return assert false;
            };
            let actual = values[0];
            let wanted : Candid.Candid = #Record([("msg", expected)]);
            if (not Candid.equal(actual, wanted)) {
                Debug.print("inference mismatch for msg=" # raw);
                Debug.print("  expected: " # debug_show wanted);
                Debug.print("  actual:   " # debug_show actual);
                assert false;
            };
        },
    );
};

suite(
    "UrlEncoded round-trip",
    func() {
        suite(
            "fuzzed values",
            func() {
                test(
                    "alphabetic payloads",
                    func() {
                        // Alphabetic, and never empty. Both
                        // restrictions dodge the decoder's type
                        // inference rather than hide it: an all-digit
                        // or empty payload comes back as #Nat or
                        // #Null instead of #Text, which is pinned
                        // explicitly in the suites below.
                        for (_ in Nat.range(0, limit)) {
                            let payload = fuzz.text.randomAlphabetic(fuzz.nat.randomRange(1, 40));
                            switch (roundTrip(payload)) {
                                case (#value got) {
                                    if (got != payload) {
                                        Debug.print("mismatch: sent " # payload # ", got " # got);
                                        assert false;
                                    };
                                };
                                case (other) {
                                    Debug.print("failed for " # payload # ": " # debug_show other);
                                    assert false;
                                };
                            };
                        };
                    },
                );
            },
        );

        suite(
            "characters that survive today",
            func() {
                survives("plain word", "plain");
                survives("space", "Hello World");
                survives("percent sign", "100%");
                survives("plus", "a+b");
                survives("hash", "a#b");
                survives("non-ASCII", "h\u{e9}llo");
            },
        );

        // ------------------------------------------------------------
        // KNOWN DEFECT — characterisation tests.
        //
        // The codec does no percent-encoding in either direction. A
        // value containing one of the format's own delimiters is
        // therefore written to the wire raw, and the reader cannot tell
        // it from structure:
        //
        //   `&` makes the wire text un-decodable outright
        //   `=` silently truncates the value at the first `=`
        //
        // The assertions below pin the *broken* behaviour so it is
        // visible in the suite rather than only in a bug report. When
        // percent-encoding is implemented these two tests must be
        // rewritten as `survives(...)` — the failure is the reminder.
        // ------------------------------------------------------------
        suite(
            "characters that are lost today (see comment above)",
            func() {
                test(
                    "`&` in a value breaks decoding",
                    func() {
                        switch (roundTrip("a&b")) {
                            case (#decodeErr _) ();
                            case (other) {
                                Debug.print("`&` no longer breaks decoding — got " # debug_show other);
                                Debug.print("If percent-encoding was implemented, make this a `survives` case.");
                                assert false;
                            };
                        };
                    },
                );
                test(
                    "`=` in a value is silently truncated",
                    func() {
                        switch (roundTrip("a=b")) {
                            case (#value "a") ();
                            case (other) {
                                Debug.print("`=` no longer truncates — got " # debug_show other);
                                Debug.print("If percent-encoding was implemented, make this a `survives` case.");
                                assert false;
                            };
                        };
                    },
                );
                test(
                    "an empty value decodes as null, not as an empty string",
                    func() {
                        // `msg=` is a present field with an empty
                        // value, but it comes back as #Null — so an
                        // empty form field is indistinguishable from an
                        // absent one, and a record whose field is typed
                        // Text fails to decode at all.
                        switch (roundTrip("")) {
                            case (#shape) ();
                            case (other) {
                                Debug.print("empty value now round-trips — got " # debug_show other);
                                Debug.print("If this was fixed, make it a `survives` case.");
                                assert false;
                            };
                        };
                    },
                );
                test(
                    "a percent-escape in input is not decoded",
                    func() {
                        // `%20` arrives as three literal characters, not
                        // as a space: the reader is not RFC 3986-aware.
                        let #ok(blob) = URLEncoded.fromText("msg=Hello%20World", null) else {
                            Debug.print("unexpected decode failure");
                            return assert false;
                        };
                        let decoded : ?Form = from_candid (blob);
                        switch (decoded) {
                            case (?form) {
                                if (form.msg != "Hello%20World") {
                                    Debug.print("percent-decoding appears implemented; got " # form.msg);
                                    Debug.print("Update this test to assert \"Hello World\".");
                                    assert false;
                                };
                            };
                            case null { assert false };
                        };
                    },
                );
            },
        );

        // The wire format carries no type information, so the
        // decoder infers one from each value's spelling. That is a
        // reasonable design, but it is invisible at the call site and
        // decides whether a record with a `Text` field decodes at all —
        // so the table is pinned here rather than left to be
        // rediscovered.
        suite(
            "values are typed by how they are spelled",
            func() {
                infers("digits become Nat", "1", #Nat(1));
                infers("a leading minus makes it Int", "-7", #Int(-7));
                infers("a decimal point makes it Float", "1.5", #Float(1.5));
                infers("true/false become Bool", "true", #Bool(true));
                infers("the word null becomes Null", "null", #Null);

                // …and everything else stays Text, including spellings
                // that look numeric but are not canonical.
                infers("letters stay Text", "abc", #Text("abc"));
                infers("mixed stays Text", "1a", #Text("1a"));
                infers("a leading zero stays Text", "007", #Text("007"));
                infers("exponent notation stays Text", "1e3", #Text("1e3"));
            },
        );

        suite(
            "malformed input",
            func() {
                test(
                    "a key with no value is rejected",
                    func() {
                        switch (URLEncoded.fromText("name", null)) {
                            case (#err _) ();
                            case (#ok _) {
                                Debug.print("expected rejection of a bare key");
                                assert false;
                            };
                        };
                    },
                );
                test(
                    "empty input yields an empty result rather than an error",
                    func() {
                        switch (URLEncoded.fromText("", null)) {
                            case (#ok _) ();
                            case (#err e) {
                                Debug.print("empty input rejected: " # e);
                                assert false;
                            };
                        };
                    },
                );
            },
        );
    },
);
