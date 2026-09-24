// @testmode wasi
import Debug "mo:core/Debug";
import Text "mo:core/Text";

import { test; suite } "mo:test";

import { Candid; JSON } "../src";

// `JSON.fromCandidWith` — `fromCandid` plus an explicit
// `skip_null_fields` flag. Exported from the package root, and it had
// zero test references: the flag was only ever reachable through the
// `Options` record passed to `toText`, so this entry point and the
// exact scope of the skipping were both uncovered.
//
// The scope matters to callers: an API that rejects explicit nulls
// needs the fields gone, while one that distinguishes "absent" from
// "null" needs them kept.

// Compare what was emitted with `expected` as *values*, by parsing
// both back. The question here is which members survive the conversion,
// not how the printer spaces its separators — so this stays true
// whether the output is `{"a": 1}` or `{"a":1}`.
func emits(name : Text, value : Candid.Candid, skipNulls : Bool, expected : Text) {
    test(
        name,
        func() {
            let actual = switch (JSON.fromCandidWith(value, skipNulls)) {
                case (#ok t) t;
                case (#err e) {
                    Debug.print("conversion failed: " # e);
                    return assert false;
                };
            };
            let #ok(actualValue) = JSON.toCandid(actual) else {
                Debug.print("emitted text does not parse back: " # actual);
                return assert false;
            };
            let #ok(expectedValue) = JSON.toCandid(expected) else {
                Debug.print("expected text is not valid JSON: " # expected);
                return assert false;
            };
            if (not Candid.equal(actualValue, expectedValue)) {
                Debug.print("output mismatch:");
                Debug.print("  expected: " # expected);
                Debug.print("  actual:   " # actual);
                assert false;
            };
        },
    );
};

let record : Candid.Candid = #Record([("name", #Text("John")), ("nick", #Null)]);

suite(
    "JSON.fromCandidWith(skip_null_fields)",
    func() {
        emits("false keeps a null member", record, false, "{\"name\": \"John\", \"nick\": null}");
        emits("true drops a null member", record, true, "{\"name\": \"John\"}");

        test(
            "fromCandid is fromCandidWith(_, false)",
            func() {
                // Byte-for-byte here: these are two paths through the
                // same printer, so any difference at all is a bug.
                let #ok(viaShorthand) = JSON.fromCandid(record) else return assert false;
                let #ok(viaExplicit) = JSON.fromCandidWith(record, false) else return assert false;
                assert viaShorthand == viaExplicit;
            },
        );

        emits(
            "skipping reaches nested records",
            #Record([("a", #Record([("b", #Null), ("c", #Nat(1))]))]),
            true,
            "{\"a\": {\"c\": 1}}",
        );

        // The flag names *fields*, and these two cases show it means
        // exactly that: a null that is not a record member stays.
        emits("a top-level null is still emitted", #Null, true, "null");
        emits(
            "nulls inside an array are still emitted",
            #Array([#Null, #Nat(1)]),
            true,
            "[null, 1]",
        );
    },
);
