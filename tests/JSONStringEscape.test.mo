// @testmode wasi
import Debug "mo:core/Debug";
import Text "mo:core/Text";

import { test; suite } "mo:test";

import { JSON } "../src";

// Each round-trip asserts:
//   1. encoder produces the expected wire bytes (the JSON-quoted form),
//   2. decoder restores the original Text.
// Round-trip is the strict test: an encoder that mis-escapes will
// either fail validation (decoder rejects) or come back with a
// different Text on parse.
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
        // Named short-form escapes — each in isolation.
        roundTrip("backslash", "a\\b", "\"a\\\\b\"");
        roundTrip("double-quote", "a\"b", "\"a\\\"b\"");
        roundTrip("newline", "a\nb", "\"a\\nb\"");
        roundTrip("carriage return", "a\rb", "\"a\\rb\"");
        roundTrip("tab", "a\tb", "\"a\\tb\"");
        roundTrip("backspace U+0008", "a\u{08}b", "\"a\\bb\"");
        roundTrip("form feed U+000C", "a\u{0c}b", "\"a\\fb\"");

        // \u00XX fallback for unnamed control chars.
        roundTrip("NUL U+0000", "a\u{00}b", "\"a\\u0000b\"");
        roundTrip("U+0001 (start-of-heading)", "a\u{01}b", "\"a\\u0001b\"");
        roundTrip("U+001F (boundary, last control char)", "a\u{1f}b", "\"a\\u001fb\"");
        // U+0020 (space) is NOT a control char and must NOT be escaped.
        roundTrip("U+0020 (space, just above boundary)", "a b", "\"a b\"");

        // Adversarial: input already looks like an escape sequence.
        // The literal four chars `\`, `n`, `\`, `n` must encode as eight
        // chars (each backslash doubled), not as two newlines.
        roundTrip(
            "literal `\\n\\n` is not collapsed to two newlines",
            "\\n\\n",
            "\"\\\\n\\\\n\"",
        );

        // OpenAI repro: a multi-line user-content string containing both
        // a backslash and a newline. With the pre-fix encoder, OpenAI
        // returns HTTP 400 "we could not parse the JSON body".
        roundTrip(
            "OpenAI-style multi-line user content with backslash",
            "Hello\nworld with a \\ slash",
            "\"Hello\\nworld with a \\\\ slash\"",
        );
    },
);
