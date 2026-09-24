// @testmode wasi
import Debug "mo:core/Debug";
import Nat "mo:core/Nat";
import Text "mo:core/Text";

import { test; suite } "mo:test";

import { JSON } "../src";

// Nesting depth. A recursive-descent parser consumes Wasm stack per
// level, so the depth at which a deeply-nested response body stops
// parsing — and *how* it stops — is part of the library's contract.
// Nothing tested it before.
//
// The ceiling checked here is 512. That is deliberate: it is the limit
// a recursion-guarded parser is expected to enforce, and staying at or
// below it keeps these assertions true for any parser that guards at
// 512 or higher.

// `[[[...1...]]]` — `depth` brackets deep.
func nestedArray(depth : Nat) : Text {
    var acc = "1";
    for (_ in Nat.range(0, depth)) { acc := "[" # acc # "]" };
    acc;
};

// `{"a":{"a":...1...}}` — `depth` objects deep.
func nestedObject(depth : Nat) : Text {
    var acc = "1";
    for (_ in Nat.range(0, depth)) { acc := "{\"a\":" # acc # "}" };
    acc;
};

func accepts(name : Text, input : Text) {
    test(
        name,
        func() {
            switch (JSON.toCandid(input)) {
                case (#ok _) ();
                case (#err e) {
                    Debug.print("expected acceptance, got error: " # e);
                    assert false;
                };
            };
        },
    );
};

suite(
    "JSON nesting depth",
    func() {
        suite(
            "nested arrays",
            func() {
                accepts("depth 1", nestedArray(1));
                accepts("depth 10", nestedArray(10));
                accepts("depth 64", nestedArray(64));
                accepts("depth 256", nestedArray(256));
                accepts("depth 512", nestedArray(512));
            },
        );

        suite(
            "nested objects",
            func() {
                accepts("depth 1", nestedObject(1));
                accepts("depth 10", nestedObject(10));
                accepts("depth 64", nestedObject(64));
                accepts("depth 256", nestedObject(256));
                accepts("depth 512", nestedObject(512));
            },
        );

        test(
            "a nested value survives the descent intact",
            func() {
                // Depth alone proves the parser did not fall over; this
                // proves it also came back with the right value rather
                // than an empty husk of the right shape.
                let #ok(parsed) = JSON.toCandid(nestedArray(8)) else {
                    Debug.print("depth-8 array failed to parse");
                    return assert false;
                };
                var cursor = parsed;
                var level = 0;
                while (level < 8) {
                    switch (cursor) {
                        case (#Array inner) {
                            assert inner.size() == 1;
                            cursor := inner[0];
                        };
                        case (other) {
                            Debug.print("level " # Nat.toText(level) # " is not an array: " # debug_show other);
                            return assert false;
                        };
                    };
                    level += 1;
                };
                assert cursor == #Nat(1);
            },
        );
    },
);
