// @testmode wasi
import Debug "mo:core/Debug";
import Principal "mo:core/Principal";
import Text "mo:core/Text";

import { test; suite } "mo:test";

import { Candid } "../src";

// Coverage for `Candid.fromText` — the textual Candid reader under
// src/Candid/Text/Parser/ (15 modules, ~900 lines). It had no direct
// tests: nothing in the suite called `fromText`, so the whole parser
// was reachable only incidentally.
//
// Note the signature: `fromText : Text -> [Candid]`, with no Result.
// Input it cannot handle does not come back as an error — it traps.
// That rules out negative tests here, since a trap takes the test
// runner's process down with it rather than failing one case. Three
// inputs are known to trap and are therefore only recorded, not
// asserted:
//
//   Candid.fromText("(1.5)")         — float literals
//   Candid.fromText("(blob \"abc\")")  — blob literals
//   Candid.fromText("record { a = 1 }") — a value without the
//                                          surrounding parentheses
//
// The first two are gaps in the grammar; the third is arguably correct
// (an argument sequence is parenthesised) but trapping is a harsh way
// to say so. Either way the surface would be safer returning a Result.

func parses(name : Text, input : Text, expected : [Candid.Candid]) {
    test(
        name,
        func() {
            let actual = Candid.fromText(input);
            if (actual.size() != expected.size()) {
                Debug.print("arity mismatch for " # input);
                Debug.print("  expected: " # debug_show expected);
                Debug.print("  actual:   " # debug_show actual);
                return assert false;
            };
            for (i in actual.keys()) {
                if (not Candid.equal(actual[i], expected[i])) {
                    Debug.print("value mismatch for " # input);
                    Debug.print("  expected: " # debug_show expected);
                    Debug.print("  actual:   " # debug_show actual);
                    return assert false;
                };
            };
        },
    );
};

suite(
    "Candid text parser",
    func() {
        suite(
            "scalars",
            func() {
                parses("nat", "(123)", [#Nat(123)]);
                parses("negative int", "(-42)", [#Int(-42)]);
                parses("bool", "(true)", [#Bool(true)]);
                parses("null", "(null)", [#Null]);
                parses("text", "(\"John\")", [#Text("John")]);
                parses("principal", "(principal \"aaaaa-aa\")", [#Principal(Principal.fromText("aaaaa-aa"))]);
            },
        );

        suite(
            "escapes inside text",
            func() {
                parses("newline escape is resolved", "(\"a\\nb\")", [#Text("a\nb")]);
            },
        );

        suite(
            "compound values",
            func() {
                parses(
                    "record",
                    "(record { name = \"John\"; id = 123 })",
                    [#Record([("name", #Text("John")), ("id", #Nat(123))])],
                );
                parses("empty record", "(record {})", [#Record([])]);
                parses("variant", "(variant { ok = 1 })", [#Variant("ok", #Nat(1))]);
                parses("vector", "(vec { 1; 2; 3 })", [#Array([#Nat(1), #Nat(2), #Nat(3)])]);
                parses("empty vector", "(vec {})", [#Array([])]);
                parses("option", "(opt 5)", [#Option(#Nat(5))]);
                parses("option of null", "(opt null)", [#Option(#Null)]);
            },
        );

        suite(
            "nesting",
            func() {
                parses(
                    "record in record in vector",
                    "(record { a = record { b = vec { 1; 2 } } })",
                    [#Record([("a", #Record([("b", #Array([#Nat(1), #Nat(2)]))]))])],
                );
                parses(
                    "record inside a variant",
                    "(variant { err = record { code = 404 } })",
                    [#Variant("err", #Record([("code", #Nat(404))]))],
                );
                parses(
                    "vector of records",
                    "(vec { record { a = 1 }; record { a = 2 } })",
                    [#Array([#Record([("a", #Nat(1))]), #Record([("a", #Nat(2))])])],
                );
            },
        );

        suite(
            "argument sequences",
            func() {
                // `fromText` returns a list because Candid's textual
                // form describes an argument *sequence*, not one value.
                // Nothing pinned the multi-value case before.
                parses(
                    "three values of different types",
                    "(1, \"two\", true)",
                    [#Nat(1), #Text("two"), #Bool(true)],
                );
            },
        );
    },
);
