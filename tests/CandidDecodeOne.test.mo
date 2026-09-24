// @testmode wasi
import Debug "mo:core/Debug";
import Text "mo:core/Text";

import { test; suite } "mo:test";

import { Candid } "../src";

// `Candid.decodeOne` — the single-value convenience over `decode`. It
// is exported from the package root and had zero test references, so
// neither its success path nor its arity check was covered.

type User = { name : Text; id : Nat };

suite(
    "Candid.decodeOne",
    func() {
        test(
            "returns the value itself, not a one-element list",
            func() {
                let blob = to_candid ({ name = "John"; id = 123 : Nat });
                switch (Candid.decodeOne(blob, ["name", "id"], null)) {
                    case (#ok value) {
                        // Members come back in Candid's field-hash
                        // order, not source order — `id` precedes
                        // `name` here. That is the wire's ordering and
                        // decoding preserves it.
                        assert Candid.equal(
                            value,
                            #Record([("id", #Nat(123)), ("name", #Text("John"))]),
                        );
                    };
                    case (#err e) {
                        Debug.print("decodeOne failed: " # e);
                        assert false;
                    };
                };
            },
        );

        test(
            "agrees with decode on a single value",
            func() {
                let blob = to_candid ("hello");
                let #ok(one) = Candid.decodeOne(blob, [], null) else return assert false;
                let #ok(many) = Candid.decode(blob, [], null) else return assert false;
                assert many.size() == 1;
                assert Candid.equal(one, many[0]);
            },
        );

        test(
            "rejects a blob holding two values",
            func() {
                // The arity check is the whole point of the function;
                // without it the caller would silently see only the
                // first value.
                let blob = to_candid (1, 2);
                switch (Candid.decodeOne(blob, [], null)) {
                    case (#err e) {
                        assert Text.contains(e, #text "instead got 2");
                    };
                    case (#ok value) {
                        Debug.print("expected an arity error, got: " # debug_show value);
                        assert false;
                    };
                };
            },
        );

        test(
            "rejects a blob holding no values",
            func() {
                let blob = to_candid ();
                switch (Candid.decodeOne(blob, [], null)) {
                    case (#err e) {
                        assert Text.contains(e, #text "instead got 0");
                    };
                    case (#ok value) {
                        Debug.print("expected an arity error, got: " # debug_show value);
                        assert false;
                    };
                };
            },
        );
    },
);
