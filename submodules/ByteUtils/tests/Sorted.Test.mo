// @testmode wasi
import List "mo:core/List";
import Blob "mo:core/Blob";
import Text "mo:core/Text";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Int8 "mo:core/Int8";
import Iter "mo:core/Iter";
import Int32 "mo:core/Int32";
import Int16 "mo:core/Int16";
import Int64 "mo:core/Int64";
import Float "mo:core/Float";
import Nat64 "mo:core/Nat64";
import Nat16 "mo:core/Nat16";
import Nat32 "mo:core/Nat32";
import Bool "mo:core/Bool";

import Int "mo:core/Int";
import Map "mo:core/Map";

import { test; suite } "mo:test";

import Fuzz "mo:fuzz";

import ByteUtils "../src";

// `core` has no `Iter.equal`; this is the `Itertools.equal` it replaces.
func iterEqual<T>(a : Iter.Iter<T>, b : Iter.Iter<T>, eq : (T, T) -> Bool) : Bool {
    loop {
        switch (a.next(), b.next()) {
            case (null, null) { return true };
            case (?x, ?y) { if (not eq(x, y)) { return false } };
            case _ { return false };
        };
    };
};

func xorshift128plus(seed : Nat) : { next() : Nat } {
    var state0 : Nat64 = Nat64.fromNat(seed);
    var state1 : Nat64 = Nat64.fromNat(seed + 1);
    if (state0 == 0) state0 := 1;
    if (state1 == 0) state1 := 2;

    {
        next = func() : Nat {
            var s1 = state0;
            let s0 = state1;
            state0 := s0;
            s1 ^= s1 << 23 : Nat64;
            state1 := s1 ^ s0 ^ (s1 >> 18 : Nat64) ^ (s0 >> 5 : Nat64);
            Nat64.toNat(state1 +% s0); // Use wrapping addition
        };
    };
};

let fuzz = Fuzz.create(xorshift128plus(0xdeadbeef));
let limit = 1_000;

// Test data generation
type TestData = {
    nat8 : Nat8;
    nat16 : Nat16;
    nat32 : Nat32;
    nat64 : Nat64;
    int8 : Int8;
    int16 : Int16;
    int32 : Int32;
    int64 : Int64;
    float : Float;
    bool : Bool;
    text : Text;
};

let inputs = List.empty<TestData>();

let sorted_nat8s = Map.empty<Nat8, Nat>();
let sorted_nat16s = Map.empty<Nat16, Nat>();
let sorted_nat32s = Map.empty<Nat32, Nat>();
let sorted_nat64s = Map.empty<Nat64, Nat>();
let sorted_int8s = Map.empty<Int8, Nat>();
let sorted_int16s = Map.empty<Int16, Nat>();
let sorted_int32s = Map.empty<Int32, Nat>();
let sorted_int64s = Map.empty<Int64, Nat>();
let sorted_floats = Map.empty<Float, Nat>();

for (i in Nat.rangeInclusive(0, limit - 1)) {
    let record : TestData = {
        nat8 = fuzz.nat8.random();
        nat16 = fuzz.nat16.random();
        nat32 = fuzz.nat32.random();
        nat64 = fuzz.nat64.random();
        int8 = fuzz.int8.random();
        int16 = fuzz.int16.random();
        int32 = fuzz.int32.random();
        int64 = fuzz.int64.random();
        float = fuzz.float.random();
        bool = fuzz.bool.random();
        text = fuzz.text.randomAlphanumeric(fuzz.nat.randomRange(1, 50));
    };
    List.add(inputs, record);


    Map.add(sorted_nat8s, Nat8.compare, record.nat8, i);
    Map.add(sorted_nat16s, Nat16.compare, record.nat16, i);
    Map.add(sorted_nat32s, Nat32.compare, record.nat32, i);
    Map.add(sorted_nat64s, Nat64.compare, record.nat64, i);
    Map.add(sorted_int8s, Int8.compare, record.int8, i);
    Map.add(sorted_int16s, Int16.compare, record.int16, i);
    Map.add(sorted_int32s, Int32.compare, record.int32, i);
    Map.add(sorted_int64s, Int64.compare, record.int64, i);
    Map.add(sorted_floats, Float.compare, record.float, i);

};

suite(
    "ByteUtils Sorted: sortable encodings maintain correct order",
    func() {
        test(
            "Nat8 sortable encoding",
            func() {

                let encoded_nat8s = Map.empty<Blob, Nat>();

                for ((i, r) in Iter.enumerate(List.values(inputs))) {

                    let encoded = Blob.fromArray(ByteUtils.Sorted.fromNat8(r.nat8));
                    Map.add(encoded_nat8s, Blob.compare, encoded, i);
                };

                // Verify same ordering
                assert iterEqual(
                    Map.values(sorted_nat8s),
                    Map.values(encoded_nat8s),
                    Nat.equal,
                );

                // Verify round-trip conversion
                assert iterEqual(
                    Map.keys(sorted_nat8s),
                    Iter.map<Blob, Nat8>(
                        Map.keys(encoded_nat8s),
                        func(b : Blob) : Nat8 {
                            ByteUtils.Sorted.toNat8(b.vals());
                        },
                    ),
                    Nat8.equal,
                );
            },
        );

        test(
            "Nat16 sortable encoding",
            func() {

                let encoded_nat16s = Map.empty<Blob, Nat>();

                for ((i, r) in Iter.enumerate(List.values(inputs))) {

                    let encoded = Blob.fromArray(ByteUtils.Sorted.fromNat16(r.nat16));
                    Map.add(encoded_nat16s, Blob.compare, encoded, i);
                };

                assert iterEqual(
                    Map.values(sorted_nat16s),
                    Map.values(encoded_nat16s),
                    Nat.equal,
                );

                assert iterEqual(
                    Map.keys(sorted_nat16s),
                    Iter.map<Blob, Nat16>(
                        Map.keys(encoded_nat16s),
                        func(b : Blob) : Nat16 {
                            ByteUtils.Sorted.toNat16(b.vals());
                        },
                    ),
                    Nat16.equal,
                );
            },
        );

        test(
            "Nat32 sortable encoding",
            func() {
                let encoded_nat32s = Map.empty<Blob, Nat>();

                for ((i, r) in Iter.enumerate(List.values(inputs))) {

                    let encoded = Blob.fromArray(ByteUtils.Sorted.fromNat32(r.nat32));
                    Map.add(encoded_nat32s, Blob.compare, encoded, i);
                };

                assert iterEqual(
                    Map.values(sorted_nat32s),
                    Map.values(encoded_nat32s),
                    Nat.equal,
                );

                assert iterEqual(
                    Map.keys(sorted_nat32s),
                    Iter.map<Blob, Nat32>(
                        Map.keys(encoded_nat32s),
                        func(b : Blob) : Nat32 {
                            ByteUtils.Sorted.toNat32(b.vals());
                        },
                    ),
                    Nat32.equal,
                );
            },
        );

        test(
            "Nat64 sortable encoding",
            func() {
                let encoded_nat64s = Map.empty<Blob, Nat>();

                for ((i, r) in Iter.enumerate(List.values(inputs))) {

                    let encoded = Blob.fromArray(ByteUtils.Sorted.fromNat64(r.nat64));
                    Map.add(encoded_nat64s, Blob.compare, encoded, i);
                };

                assert iterEqual(
                    Map.values(sorted_nat64s),
                    Map.values(encoded_nat64s),
                    Nat.equal,
                );

                assert iterEqual(
                    Map.keys(sorted_nat64s),
                    Iter.map<Blob, Nat64>(
                        Map.keys(encoded_nat64s),
                        func(b : Blob) : Nat64 {
                            ByteUtils.Sorted.toNat64(b.vals());
                        },
                    ),
                    Nat64.equal,
                );
            },
        );

        test(
            "Int8 sortable encoding",
            func() {
                let encoded_int8s = Map.empty<Blob, Nat>();

                // Test full range of Int8 values
                for ((i, r) in Iter.enumerate(List.values(inputs))) {

                    let encoded = Blob.fromArray(ByteUtils.Sorted.fromInt8(r.int8));
                    Map.add(encoded_int8s, Blob.compare, encoded, i);
                };

                assert iterEqual(
                    Map.values(sorted_int8s),
                    Map.values(encoded_int8s),
                    Nat.equal,
                );

                // Verify negative values sort before positive values
                let neg_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt8(-1));
                let zero_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt8(0));
                let pos_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt8(1));

                assert neg_encoded < zero_encoded;
                assert zero_encoded < pos_encoded;

                assert iterEqual(
                    Map.keys(sorted_int8s),
                    Iter.map<Blob, Int8>(
                        Map.keys(encoded_int8s),
                        func(b : Blob) : Int8 {
                            ByteUtils.Sorted.toInt8(b.vals());
                        },
                    ),
                    Int8.equal,
                );
            },
        );

        test(
            "Int16 sortable encoding",
            func() {
                let encoded_int16s = Map.empty<Blob, Nat>();

                for ((i, r) in Iter.enumerate(List.values(inputs))) {

                    let encoded = Blob.fromArray(ByteUtils.Sorted.fromInt16(r.int16));
                    Map.add(encoded_int16s, Blob.compare, encoded, i);
                };

                assert iterEqual(
                    Map.values(sorted_int16s),
                    Map.values(encoded_int16s),
                    Nat.equal,
                );

                // Test boundary values
                let min_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt16(Int16.minValue));
                let zero_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt16(0));
                let max_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt16(Int16.maxValue));

                assert min_encoded < zero_encoded;
                assert zero_encoded < max_encoded;

                assert iterEqual(
                    Map.keys(sorted_int16s),
                    Iter.map<Blob, Int16>(
                        Map.keys(encoded_int16s),
                        func(b : Blob) : Int16 {
                            ByteUtils.Sorted.toInt16(b.vals());
                        },
                    ),
                    Int16.equal,
                );
            },
        );

        test(
            "Int32 sortable encoding",
            func() {
                let encoded_int32s = Map.empty<Blob, Nat>();

                for ((i, r) in Iter.enumerate(List.values(inputs))) {

                    let encoded = Blob.fromArray(ByteUtils.Sorted.fromInt32(r.int32));
                    Map.add(encoded_int32s, Blob.compare, encoded, i);
                };

                assert iterEqual(
                    Map.values(sorted_int32s),
                    Map.values(encoded_int32s),
                    Nat.equal,
                );

                // Test boundary values
                let min_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt32(Int32.minValue));
                let zero_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt32(0));
                let max_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt32(Int32.maxValue));

                assert min_encoded < zero_encoded;
                assert zero_encoded < max_encoded;

                assert iterEqual(
                    Map.keys(sorted_int32s),
                    Iter.map<Blob, Int32>(
                        Map.keys(encoded_int32s),
                        func(b : Blob) : Int32 {
                            ByteUtils.Sorted.toInt32(b.vals());
                        },
                    ),
                    Int32.equal,
                );
            },
        );

        test(
            "Int64 sortable encoding",
            func() {
                let encoded_int64s = Map.empty<Blob, Nat>();

                for ((i, r) in Iter.enumerate(List.values(inputs))) {

                    let encoded = Blob.fromArray(ByteUtils.Sorted.fromInt64(r.int64));
                    Map.add(encoded_int64s, Blob.compare, encoded, i);
                };

                assert iterEqual(
                    Map.values(sorted_int64s),
                    Map.values(encoded_int64s),
                    Nat.equal,
                );

                // Test boundary values
                let min_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt64(Int64.minValue));
                let zero_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt64(0));
                let max_encoded = Blob.fromArray(ByteUtils.Sorted.fromInt64(Int64.maxValue));

                assert min_encoded < zero_encoded;
                assert zero_encoded < max_encoded;

                assert iterEqual(
                    Map.keys(sorted_int64s),
                    Iter.map<Blob, Int64>(
                        Map.keys(encoded_int64s),
                        func(b : Blob) : Int64 {
                            ByteUtils.Sorted.toInt64(b.vals());
                        },
                    ),
                    Int64.equal,
                );
            },
        );

        test(
            "Float sortable encoding",
            func() {
                let encoded_floats = Map.empty<Blob, Nat>();

                for ((i, r) in Iter.enumerate(List.values(inputs))) {

                    let encoded = Blob.fromArray(ByteUtils.Sorted.fromFloat(r.float));
                    Map.add(encoded_floats, Blob.compare, encoded, i);
                };

                assert iterEqual(
                    Map.values(sorted_floats),
                    Map.values(encoded_floats),
                    Nat.equal,
                );

                // Test that negative floats sort before positive floats
                let neg_encoded = Blob.fromArray(ByteUtils.Sorted.fromFloat(-1.0));
                let zero_encoded = Blob.fromArray(ByteUtils.Sorted.fromFloat(0.0));
                let pos_encoded = Blob.fromArray(ByteUtils.Sorted.fromFloat(1.0));

                assert neg_encoded < zero_encoded;
                assert zero_encoded < pos_encoded;

                assert iterEqual(
                    Map.keys(sorted_floats),
                    Iter.map<Blob, Float>(
                        Map.keys(encoded_floats),
                        func(b : Blob) : Float {
                            ByteUtils.Sorted.toFloat(b.vals());
                        },
                    ),
                    func(a : Float, b : Float) : Bool {
                        // For floating-point values, we need to account for small precision differences
                        let epsilon : Float = 0.0000001;
                        Float.equal(a, b, epsilon);
                    },
                );
            },
        );

    },
);
