// @testmode wasi
import Debug "mo:core@2.4/Debug";
import Text "mo:core@2.4/Text";

import { test; suite } "mo:test";

import { JSON } "../src";

// `expectEncode` asserts the exact wire bytes produced by
// `JSON.fromCandid(#Text payload)`. Used for every escape category.
//
// `roundTrip` additionally re-parses the encoded form and asserts the
// original Text is restored. We use it only for escape forms the
// underlying JSON parser is known to support out of the box (named
// short-forms `\b \f \n \r \t \" \\`, plus literal pass-through of
// printable ASCII). The `\u00XX` fallback for unnamed control chars
// U+0000..U+001F is exercised by `expectEncode` only — round-tripping
// those depends on a separate parser-side `\u` handling improvement.
func expectEncode(name : Text, payload : Text, expectedWire : Text) {
    test(
        name,
        func() {
            let encoded = switch (JSON.fromCandid(#Text payload)) {
                case (#ok t) t;
                case (#err e) {
                    Debug.print("encode failed: " # e);
                    assert false;
                    return;
                };
            };
            if (encoded != expectedWire) {
                Debug.print("encode wire mismatch:");
                Debug.print("  expected: " # expectedWire);
                Debug.print("  actual:   " # encoded);
                assert false;
            };
        },
    );
};

func roundTrip(name : Text, payload : Text, expectedWire : Text) {
    test(
        name,
        func() {
            let encoded = switch (JSON.fromCandid(#Text payload)) {
                case (#ok t) t;
                case (#err e) {
                    Debug.print("encode failed: " # e);
                    assert false;
                    return;
                };
            };
            if (encoded != expectedWire) {
                Debug.print("encode wire mismatch:");
                Debug.print("  expected: " # expectedWire);
                Debug.print("  actual:   " # encoded);
                assert false;
            };
            let decoded = switch (JSON.toCandid(encoded)) {
                case (#ok(#Text t)) t;
                case (#ok other) {
                    Debug.print("decode wrong shape: " # debug_show other);
                    assert false;
                    return;
                };
                case (#err e) {
                    Debug.print("decode failed: " # e);
                    assert false;
                    return;
                };
            };
            if (decoded != payload) {
                Debug.print("round-trip mismatch:");
                Debug.print("  original:  " # payload);
                Debug.print("  decoded:   " # decoded);
                assert false;
            };
        },
    );
};

suite(
    "JSON string-escape (encoder side, RFC 8259 §7)",
    func() {
        // Named short-forms — round-trip with the existing parser.
        roundTrip("backslash", "a\\b", "\"a\\\\b\"");
        roundTrip("double-quote", "a\"b", "\"a\\\"b\"");
        roundTrip("newline", "a\nb", "\"a\\nb\"");
        roundTrip("carriage return", "a\rb", "\"a\\rb\"");
        roundTrip("tab", "a\tb", "\"a\\tb\"");
        roundTrip("backspace U+0008", "a\u{08}b", "\"a\\bb\"");
        roundTrip("form feed U+000C", "a\u{0c}b", "\"a\\fb\"");
        roundTrip(
            "literal `\\n\\n` is not collapsed to two newlines",
            "\\n\\n",
            "\"\\\\n\\\\n\"",
        );
        roundTrip(
            "OpenAI-style multi-line user content with backslash",
            "Hello\nworld with a \\ slash",
            "\"Hello\\nworld with a \\\\ slash\"",
        );

        // \u00XX fallback — encode-only. Round-trip needs a parser-side
        // improvement that lives in a separate change.
        expectEncode("NUL U+0000", "a\u{00}b", "\"a\\u0000b\"");
        expectEncode("U+0001 (start-of-heading)", "a\u{01}b", "\"a\\u0001b\"");
        expectEncode("U+001F (boundary, last control char)", "a\u{1f}b", "\"a\\u001fb\"");
        // U+0020 (space) is NOT a control char and must NOT be escaped — round-trip is safe.
        roundTrip("U+0020 (space, just above boundary)", "a b", "\"a b\"");
    },
);
