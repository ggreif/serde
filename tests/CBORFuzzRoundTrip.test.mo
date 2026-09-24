// @testmode wasi
import Debug "mo:core/Debug";
import Nat "mo:core/Nat";
import Text "mo:core/Text";

import { test; suite } "mo:test";
import Fuzz "mo:fuzz";

import { CBOR } "../src";

// Property test for the CBOR codec: encode a Candid blob to CBOR,
// decode it back, and compare the Motoko value.
//
// CBOR had example-based tests only. Unlike JSON it is a binary format,
// where length prefixes and major-type headers change shape at
// power-of-two boundaries — 23/24, 255/256, 65535/65536 — which is
// precisely what a fixed set of hand-written examples tends to miss.

type Form = { msg : Text; id : Nat; flag : Bool };

let fuzz = Fuzz.fromSeed(0x0cb0e777);
let limit = 300;

func roundTripsForm(value : Form) : Bool {
    let candid = to_candid (value);
    let cbor = switch (CBOR.encode(candid, ["msg", "id", "flag"], null)) {
        case (#ok b) b;
        case (#err e) {
            Debug.print("encode failed for " # debug_show value # ": " # e);
            return false;
        };
    };
    let back = switch (CBOR.decode(cbor, null)) {
        case (#ok b) b;
        case (#err e) {
            Debug.print("decode failed for " # debug_show value # ": " # e);
            return false;
        };
    };
    let decoded : ?Form = from_candid (back);
    switch (decoded) {
        case (?got) {
            if (got != value) {
                Debug.print("round-trip mismatch:");
                Debug.print("  original: " # debug_show value);
                Debug.print("  decoded:  " # debug_show got);
                return false;
            };
            true;
        };
        case null {
            Debug.print("decoded blob did not match the record shape: " # debug_show value);
            false;
        };
    };
};

suite(
    "CBOR round-trip properties",
    func() {
        test(
            "records of random text, nat and bool",
            func() {
                for (_ in Nat.range(0, limit)) {
                    let value = {
                        msg = fuzz.text.randomText(fuzz.nat.randomRange(0, 40));
                        id = fuzz.nat.randomRange(0, 2 ** 32);
                        flag = fuzz.bool.random();
                    };
                    assert roundTripsForm(value);
                };
            },
        );

        test(
            "Nat values across CBOR's header-size boundaries",
            func() {
                // CBOR switches encoding width at each of these: an
                // off-by-one in the header logic shows up here and
                // nowhere else.
                let boundaries : [Nat] = [
                    0,
                    23,
                    24,
                    255,
                    256,
                    65535,
                    65536,
                    4294967295,
                    4294967296,
                ];
                for (n in boundaries.vals()) {
                    assert roundTripsForm({ msg = "x"; id = n; flag = true });
                };
            },
        );

        test(
            "Text lengths across CBOR's header-size boundaries",
            func() {
                // Length 0 is omitted: an empty Text is not the
                // subject here, and it is already pinned as a defect
                // in UrlEncodedRoundTrip.test.mo.
                for (len in [1, 23, 24, 255, 256, 1000].vals()) {
                    var msg = "";
                    for (_ in Nat.range(0, len)) { msg #= "a" };
                    assert roundTripsForm({ msg = msg; id = 1; flag = false });
                };
            },
        );
    },
);
