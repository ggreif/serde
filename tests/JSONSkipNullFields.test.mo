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

func emits(name : Text, value : Candid.Candid, skipNulls : Bool, expected : Text) {
    test(
        name,
        func() {
            switch (JSON.fromCandidWith(value, skipNulls)) {
                case (#ok actual) {
                    if (actual != expected) {
                        Debug.print("output mismatch:");
                        Debug.print("  expected: " # expected);
                        Debug.print("  actual:   " # actual);
                        assert false;
                    };
                };
                case (#err e) {
                    Debug.print("conversion failed: " # e);
                    assert false;
                };
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
