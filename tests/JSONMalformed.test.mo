// @testmode wasi
import Debug "mo:core/Debug";
import Text "mo:core/Text";

import { test; suite } "mo:test";

import { JSON } "../src";

// Negative tests. Every input below is *not* valid JSON, and the parser
// must say so by returning #err — never by trapping, and never by
// quietly producing a value.
//
// The suite had no negative tests before this file: all 27 occurrences
// of `#err` were error-unwrapping on the success path, so nothing
// pinned the parser's rejection behaviour. A parser that silently
// accepted garbage — or trapped on it, taking the canister down mid
// outcall-response — would have gone unnoticed.
func rejects(name : Text, input : Text) {
    test(
        name,
        func() {
            switch (JSON.toCandid(input)) {
                case (#err _) ();
                case (#ok value) {
                    Debug.print("expected rejection of: " # input);
                    Debug.print("  but parsed as: " # debug_show value);
                    assert false;
                };
            };
        },
    );
};

suite(
    "JSON parser rejects malformed input",
    func() {
        suite(
            "truncated",
            func() {
                rejects("unterminated string", "{\"a\": \"x");
                rejects("unterminated array", "[1, 2");
                rejects("unterminated object", "{\"a\":1");
                rejects("empty input", "");
                rejects("whitespace only", "   ");
                rejects("naked colon", ":");
            },
        );

        suite(
            "structural",
            func() {
                rejects("trailing comma in object", "{\"a\":1,}");
                rejects("trailing comma in array", "[1,2,]");
                rejects("unquoted key", "{a:1}");
                rejects("single-quoted string", "'a'");
                rejects("missing colon", "{\"a\" 1}");
                rejects("missing comma between members", "{\"a\":1 \"b\":2}");
                rejects("mismatched brackets", "[1}");
            },
        );

        suite(
            "bad literals",
            func() {
                rejects("bare word", "nope");
                // JSON literals are lower-case; `True` is not `true`.
                rejects("capitalised True", "True");
                // NaN and Infinity are JavaScript, not JSON — RFC 8259
                // has no way to write a non-finite number.
                rejects("NaN literal", "NaN");
                rejects("Infinity literal", "Infinity");
            },
        );

        suite(
            "bad escapes",
            func() {
                rejects("unknown escape \\q", "\"a\\qb\"");
                rejects("truncated \\u escape", "\"\\u12\"");
                rejects("lone high surrogate", "\"\\ud800\"");
            },
        );

        suite(
            "malformed numbers",
            func() {
                rejects("leading plus", "+1");
                rejects("bare fraction", ".5");
                rejects("trailing decimal point", "1.");
                rejects("double minus", "--1");
            },
        );

        suite(
            "trailing content",
            func() {
                // A complete value followed by anything else is not a
                // document: the parser must not stop early and report
                // success on the prefix.
                rejects("second value", "1 2");
                rejects("junk after object", "{\"a\":1} x");
            },
        );
    },
);
