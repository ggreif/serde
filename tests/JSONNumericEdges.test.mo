// @testmode wasi
import Debug "mo:core/Debug";
import Float "mo:core/Float";
import Text "mo:core/Text";

import { test; suite } "mo:test";

import { Candid; JSON } "../src";

// Numeric boundaries on the parse side. JSON has a single `number`
// type; this library splits it into #Nat / #Int / #Float on the way in,
// and where that boundary falls was previously untested.
//
// Every case here is exercised through the public `toCandid`, which is
// what a generated connector calls on an HTTP response body.
func parsesAs(name : Text, input : Text, expected : Candid.Candid) {
    test(
        name,
        func() {
            switch (JSON.toCandid(input)) {
                case (#ok value) {
                    if (not Candid.equal(value, expected)) {
                        Debug.print("parse mismatch for: " # input);
                        Debug.print("  expected: " # debug_show expected);
                        Debug.print("  actual:   " # debug_show value);
                        assert false;
                    };
                };
                case (#err e) {
                    Debug.print("parse failed for " # input # ": " # e);
                    assert false;
                };
            };
        },
    );
};

suite(
    "JSON numeric edges",
    func() {
        suite(
            "integers are arbitrary precision, not 64-bit",
            func() {
                // Motoko's Nat/Int are bignums, and the parser must not
                // narrow through a machine word on the way. The three
                // cases below straddle the 64-bit boundary that a
                // narrowing implementation would wrap at.
                parsesAs("Nat64 max", "18446744073709551615", #Nat(18_446_744_073_709_551_615));
                parsesAs("Nat64 max + 1", "18446744073709551616", #Nat(18_446_744_073_709_551_616));
                parsesAs("Int64 min", "-9223372036854775808", #Int(-9_223_372_036_854_775_808));
                parsesAs(
                    "30 digits, far past any machine word",
                    "123456789012345678901234567890",
                    #Nat(123_456_789_012_345_678_901_234_567_890),
                );
            },
        );

        suite(
            "sign and zero",
            func() {
                parsesAs("zero", "0", #Nat(0));
                parsesAs("negative integer", "-42", #Int(-42));
                // JSON's `-0` is a distinct token but not a distinct
                // integer: it lands on #Nat(0), not #Int(0) and not a
                // negative float. Pinning this because the sign handling
                // is the natural place for an off-by-one.
                parsesAs("negative zero collapses to Nat 0", "-0", #Nat(0));
            },
        );

        // …and this is where that off-by-one actually was. The previous
        // parser applied the sign to the integer part and then added the
        // fraction, so every negative number whose integer part is zero
        // came back positive: -0.5 parsed as 0.5. Anything with a
        // non-zero integer part (-1.5, -10.5) was fine, which is exactly
        // why it survived so long — and why all four magnitudes are
        // pinned here rather than one representative.
        suite(
            "a negative fraction keeps its sign",
            func() {
                parsesAs("zero integer part", "-0.5", #Float(-0.5));
                parsesAs("zero integer part, two digits", "-0.25", #Float(-0.25));
                parsesAs("zero integer part, small", "-0.125", #Float(-0.125));
                parsesAs("non-zero integer part", "-1.5", #Float(-1.5));
                parsesAs("two-digit integer part", "-10.5", #Float(-10.5));
                parsesAs("three-digit integer part", "-100.25", #Float(-100.25));
            },
        );

        suite(
            "a fractional part or an exponent makes it a Float",
            func() {
                // Only exactly-representable values are compared for
                // equality here; inexact ones are checked by magnitude
                // below, so the assertions don't depend on the parser's
                // rounding path.
                parsesAs("simple fraction", "1.5", #Float(1.5));
                parsesAs("negative fraction", "-1.5", #Float(-1.5));
                parsesAs("exponent promotes an integer to Float", "1E2", #Float(100.0));
                parsesAs("lower-case exponent", "1e2", #Float(100.0));
                parsesAs("negative exponent", "1E-2", #Float(0.01));

                // RFC 8259's `exp` production is `e [ minus | plus ]
                // 1*DIGIT` — the plus is explicitly allowed. The
                // previous parser rejected every one of these as
                // malformed, which made perfectly ordinary API responses
                // unparseable.
                parsesAs("explicitly-signed positive exponent", "1e+2", #Float(100.0));
                parsesAs("signed exponent, upper case", "1E+2", #Float(100.0));
                parsesAs("signed exponent with a fraction", "1.5e+3", #Float(1500.0));
                parsesAs("zero with a signed exponent", "0e+0", #Float(0.0));
            },
        );

        test(
            "very large exponent stays finite and keeps its magnitude",
            func() {
                // 1e300 is within Float range. The exact bit pattern is
                // not worth pinning, but it must not overflow to
                // infinity, collapse to zero, or fall back to an
                // integer.
                switch (JSON.toCandid("1e300")) {
                    case (#ok(#Float f)) {
                        if (not (f > 1.0e299 and f < 1.0e301)) {
                            Debug.print("1e300 parsed out of range: " # Float.toText(f));
                            assert false;
                        };
                    };
                    case (#ok other) {
                        Debug.print("1e300 wrong shape: " # debug_show other);
                        assert false;
                    };
                    case (#err e) {
                        Debug.print("1e300 failed to parse: " # e);
                        assert false;
                    };
                };
            },
        );
    },
);
