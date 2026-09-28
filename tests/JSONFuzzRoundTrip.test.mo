// @testmode wasi
import Array "mo:core/Array";
import Debug "mo:core/Debug";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Text "mo:core/Text";

import { test; suite } "mo:test";
import Fuzz "mo:fuzz";

import { Candid; JSON } "../src";

// Property test: `toCandid . fromCandid` is the identity.
//
// The suite already fuzzes the Candid codec (PrimitiveType.Test.mo,
// Candid.Large.test.mo, Stress.test.mo) but nothing fuzzed JSON — every
// JSON case was a hand-written literal, so the encoder and parser were
// only ever agreed with each other on inputs somebody thought of.
// Random text is where escaping bugs live: the string-escape defect
// that broke OpenAI request bodies was exactly this shape.
//
// Floats are included, and they are the reason this file is worth
// having. The previous printer emitted two decimal places and nothing
// more, so the round-trip was not the identity for almost any real
// value: 123.123456789 came back 123.12, pi came back 3.14, and 1e-300
// came back 0. Every connector sending a float — quantities, rates,
// coordinates, ratings — silently lost precision. A property test over
// random doubles is what pins the fix.

let fuzz = Fuzz.fromSeed(0x5e2de10a);
let limit = 500;

func roundTrips(value : Candid.Candid) : Bool {
    let encoded = switch (JSON.fromCandid(value)) {
        case (#ok t) t;
        case (#err e) {
            Debug.print("encode failed for " # debug_show value # ": " # e);
            return false;
        };
    };
    switch (JSON.toCandid(encoded)) {
        case (#ok decoded) {
            if (not Candid.equal(decoded, value)) {
                Debug.print("round-trip mismatch:");
                Debug.print("  original: " # debug_show value);
                Debug.print("  wire:     " # encoded);
                Debug.print("  decoded:  " # debug_show decoded);
                return false;
            };
            true;
        };
        case (#err e) {
            Debug.print("decode failed for wire " # encoded # ": " # e);
            Debug.print("  (original: " # debug_show value # ")");
            false;
        };
    };
};

suite(
    "JSON round-trip properties",
    func() {
        test(
            "arbitrary Text",
            func() {
                // randomText draws from the full generator alphabet,
                // control characters and quotes included — the cases
                // that must be escaped on the way out and restored on
                // the way back in.
                for (_ in Nat.range(0, limit)) {
                    let value = fuzz.text.randomText(fuzz.nat.randomRange(0, 40));
                    assert roundTrips(#Text(value));
                };
            },
        );

        test(
            "alphanumeric Text",
            func() {
                for (_ in Nat.range(0, limit)) {
                    let value = fuzz.text.randomAlphanumeric(fuzz.nat.randomRange(0, 40));
                    assert roundTrips(#Text(value));
                };
            },
        );

        test(
            "Nat",
            func() {
                for (_ in Nat.range(0, limit)) {
                    let value = fuzz.nat.randomRange(0, 2 ** 64);
                    assert roundTrips(#Nat(value));
                };
            },
        );

        test(
            "Int",
            func() {
                // Negative only: a non-negative #Int serialises to the
                // same digits as the equivalent #Nat and comes back as
                // #Nat, so the sign is what carries the type here.
                for (_ in Nat.range(0, limit)) {
                    let value = fuzz.int.randomRange(-(2 ** 64), -1);
                    assert roundTrips(#Int(value));
                };
            },
        );

        test(
            "Bool",
            func() {
                for (_ in Nat.range(0, limit)) {
                    assert roundTrips(#Bool(fuzz.bool.random()));
                };
            },
        );

        test(
            "Float, over the whole range the generator produces",
            func() {
                for (_ in Nat.range(0, limit)) {
                    assert roundTrips(#Float(fuzz.float.random()));
                };
            },
        );

        test(
            "Float, in the range everyday payloads live in",
            func() {
                for (_ in Nat.range(0, limit)) {
                    assert roundTrips(#Float(fuzz.float.randomRange(-1000.0, 1000.0)));
                };
            },
        );

        test(
            "Float values that the old printer destroyed",
            func() {
                // Named rather than random, because each of these is a
                // specific way two decimal places was not enough. The
                // comment against each is what the old printer emitted.
                assert roundTrips(#Float(123.123456789)); // 123.12
                assert roundTrips(#Float(3.141592653589793)); // 3.14
                assert roundTrips(#Float(0.1)); // 0.10
                assert roundTrips(#Float(2.0)); // 2.00
                assert roundTrips(#Float(-0.5)); // -0.50, reparsed as 0.5
                assert roundTrips(#Float(1.0e300)); // a 300-digit expansion
                assert roundTrips(#Float(1.0e-300)); // 0.00 — total loss
                assert roundTrips(#Float(-1.0e-300));
                assert roundTrips(#Float(0.0));
            },
        );

        test(
            "records of random text",
            func() {
                // Composite values: key order, separators and nesting
                // all have to survive alongside the escaping.
                for (_ in Nat.range(0, limit)) {
                    let value : Candid.Candid = #Record([
                        ("name", #Text(fuzz.text.randomText(fuzz.nat.randomRange(0, 20)))),
                        ("id", #Nat(fuzz.nat.randomRange(0, 2 ** 32))),
                        ("active", #Bool(fuzz.bool.random())),
                    ]);
                    assert roundTrips(value);
                };
            },
        );

        test(
            "arrays of random text",
            func() {
                for (_ in Nat.range(0, limit)) {
                    let size = fuzz.nat.randomRange(0, 8);
                    let items = Array.tabulate<Candid.Candid>(
                        size,
                        func(_) = #Text(fuzz.text.randomText(fuzz.nat.randomRange(0, 15))),
                    );
                    assert roundTrips(#Array(items));
                };
            },
        );
    },
);
