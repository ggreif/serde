# Benchmark Results



<details>

<summary>bench/serde.bench.mo $({\color{green}-0.08\%})$</summary>

### Benchmarking Serde

_Benchmarking the performance with 1k calls_


Instructions: ${\color{red}+0.00\\%}$
Heap: ${\color{green}-0.09\\%}$
Stable Memory: ${\color{gray}0\\%}$
Garbage Collection: ${\color{red}+0.00\\%}$


**Instructions**

|                                     |                                decode() |                                  encode() |
| :---------------------------------- | --------------------------------------: | ----------------------------------------: |
| Serde: One Shot                     | 1_030_660_016 $({\color{red}+0.00\\%})$ | 2_075_643_548 $({\color{green}-0.00\\%})$ |
| Serde: One Shot sans type inference |   488_529_317 $({\color{red}+0.00\\%})$ |   1_479_668_063 $({\color{red}+0.01\\%})$ |
| Motoko (to_candid(), from_candid()) |    38_891_912 $({\color{red}+0.00\\%})$ |    11_640_515 $({\color{green}-0.03\\%})$ |
| Serde: Single Type Serializer       |   229_243_283 $({\color{red}+0.01\\%})$ |     445_303_379 $({\color{red}+0.03\\%})$ |


**Heap**

|                                     |                              decode() |                               encode() |
| :---------------------------------- | ------------------------------------: | -------------------------------------: |
| Serde: One Shot                     | 16.65 MiB $({\color{green}-0.00\\%})$ |   2.32 MiB $({\color{green}-0.66\\%})$ |
| Serde: One Shot sans type inference |  -19.55 MiB $({\color{red}+0.02\\%})$ |  11.11 MiB $({\color{green}-0.02\\%})$ |
| Motoko (to_candid(), from_candid()) |  1.16 MiB $({\color{green}-0.03\\%})$ | 668.52 KiB $({\color{green}-0.01\\%})$ |
| Serde: Single Type Serializer       | 15.87 MiB $({\color{green}-0.01\\%})$ | -41.71 MiB $({\color{green}-0.00\\%})$ |


**Garbage Collection**

|                                     |                              decode() |                             encode() |
| :---------------------------------- | ------------------------------------: | -----------------------------------: |
| Serde: One Shot                     | 56.57 MiB $({\color{green}-0.00\\%})$ | 119.07 MiB $({\color{red}+0.00\\%})$ |
| Serde: One Shot sans type inference |   60.07 MiB $({\color{red}+0.00\\%})$ |  55.07 MiB $({\color{red}+0.01\\%})$ |
| Motoko (to_candid(), from_candid()) |            0 B $({\color{gray}0\\%})$ |           0 B $({\color{gray}0\\%})$ |
| Serde: Single Type Serializer       |            0 B $({\color{gray}0\\%})$ |  60.07 MiB $({\color{red}+0.00\\%})$ |


</details>
Saving results to .bench/serde.bench.json

<details>

<summary>bench/types.bench.mo $({\color{gray}0\%})$</summary>

### Benchmarking Serde by Data Types

_Performance comparison across all supported Candid data types with 1k operations_


Instructions: ${\color{gray}0\\%}$
Heap: ${\color{gray}0\\%}$
Stable Memory: ${\color{gray}0\\%}$
Garbage Collection: ${\color{gray}0\\%}$


**Instructions**

|                  |                             encode() |               encode(sans inference) |                           decode() |             decode(sans inference) |
| :--------------- | -----------------------------------: | -----------------------------------: | ---------------------------------: | ---------------------------------: |
| Nat              |    16_555_116 $({\color{gray}0\\%})$ |    11_966_655 $({\color{gray}0\\%})$ |   3_216_030 $({\color{gray}0\\%})$ |   3_154_354 $({\color{gray}0\\%})$ |
| Nat8             |    15_113_687 $({\color{gray}0\\%})$ |    10_518_464 $({\color{gray}0\\%})$ |   3_038_599 $({\color{gray}0\\%})$ |   2_975_883 $({\color{gray}0\\%})$ |
| Nat16            |    15_846_460 $({\color{gray}0\\%})$ |    11_244_783 $({\color{gray}0\\%})$ |   3_118_694 $({\color{gray}0\\%})$ |   3_055_336 $({\color{gray}0\\%})$ |
| Nat32            |    16_889_979 $({\color{gray}0\\%})$ |    12_281_726 $({\color{gray}0\\%})$ |   3_295_445 $({\color{gray}0\\%})$ |   3_230_713 $({\color{gray}0\\%})$ |
| Nat64            |    18_736_750 $({\color{gray}0\\%})$ |    14_122_114 $({\color{gray}0\\%})$ |   3_613_976 $({\color{gray}0\\%})$ |   3_548_268 $({\color{gray}0\\%})$ |
| Int              |    16_880_373 $({\color{gray}0\\%})$ |    12_298_872 $({\color{gray}0\\%})$ |   3_278_453 $({\color{gray}0\\%})$ |   3_211_737 $({\color{gray}0\\%})$ |
| Int8             |    15_132_360 $({\color{gray}0\\%})$ |    10_544_283 $({\color{gray}0\\%})$ |   3_064_442 $({\color{gray}0\\%})$ |   2_996_718 $({\color{gray}0\\%})$ |
| Int16            |    15_867_519 $({\color{gray}0\\%})$ |    11_272_834 $({\color{gray}0\\%})$ |   3_146_401 $({\color{gray}0\\%})$ |   3_077_669 $({\color{gray}0\\%})$ |
| Int32            |    16_911_054 $({\color{gray}0\\%})$ |    12_309_729 $({\color{gray}0\\%})$ |   3_323_104 $({\color{gray}0\\%})$ |   3_253_364 $({\color{gray}0\\%})$ |
| Int64            |    18_770_963 $({\color{gray}0\\%})$ |    14_162_876 $({\color{gray}0\\%})$ |   3_646_227 $({\color{gray}0\\%})$ |   3_575_479 $({\color{gray}0\\%})$ |
| Float            |    27_009_664 $({\color{gray}0\\%})$ |    22_371_155 $({\color{gray}0\\%})$ |  14_513_119 $({\color{gray}0\\%})$ |  14_441_363 $({\color{gray}0\\%})$ |
| Bool             |    15_206_881 $({\color{gray}0\\%})$ |    10_569_732 $({\color{gray}0\\%})$ |   3_073_661 $({\color{gray}0\\%})$ |   3_017_665 $({\color{gray}0\\%})$ |
| Text             |    19_592_897 $({\color{gray}0\\%})$ |    14_941_899 $({\color{gray}0\\%})$ |   4_009_440 $({\color{gray}0\\%})$ |   3_937_068 $({\color{gray}0\\%})$ |
| Null             |    14_381_349 $({\color{gray}0\\%})$ |     9_638_597 $({\color{gray}0\\%})$ |  17_283_671 $({\color{gray}0\\%})$ |  12_413_555 $({\color{gray}0\\%})$ |
| Empty            |    14_392_808 $({\color{gray}0\\%})$ |     9_643_448 $({\color{gray}0\\%})$ |  17_319_130 $({\color{gray}0\\%})$ |  12_421_406 $({\color{gray}0\\%})$ |
| Principal        |    28_227_197 $({\color{gray}0\\%})$ |    23_564_430 $({\color{gray}0\\%})$ |   5_899_613 $({\color{gray}0\\%})$ |   5_826_985 $({\color{gray}0\\%})$ |
| Blob             |    58_762_765 $({\color{gray}0\\%})$ |    46_876_560 $({\color{gray}0\\%})$ |  15_054_202 $({\color{gray}0\\%})$ |  13_488_702 $({\color{gray}0\\%})$ |
| Option(Nat)      |    25_221_664 $({\color{gray}0\\%})$ |    14_520_172 $({\color{gray}0\\%})$ |   4_983_884 $({\color{gray}0\\%})$ |   3_420_144 $({\color{gray}0\\%})$ |
| Option(Text)     |    26_712_448 $({\color{gray}0\\%})$ |    16_019_165 $({\color{gray}0\\%})$ |   5_361_624 $({\color{gray}0\\%})$ |   3_782_876 $({\color{gray}0\\%})$ |
| Array(Nat8)      |    45_434_497 $({\color{gray}0\\%})$ |    19_043_382 $({\color{gray}0\\%})$ |   6_388_415 $({\color{gray}0\\%})$ |   4_824_059 $({\color{gray}0\\%})$ |
| Array(Text)      |    70_560_187 $({\color{gray}0\\%})$ |    43_704_230 $({\color{gray}0\\%})$ |  13_914_746 $({\color{gray}0\\%})$ |  12_336_782 $({\color{gray}0\\%})$ |
| Array(Record)    |    75_207_177 $({\color{gray}0\\%})$ |    46_668_293 $({\color{gray}0\\%})$ |  25_851_625 $({\color{gray}0\\%})$ |  12_482_885 $({\color{gray}0\\%})$ |
| Record(Simple)   |    54_929_782 $({\color{gray}0\\%})$ |    35_659_483 $({\color{gray}0\\%})$ |  20_869_156 $({\color{gray}0\\%})$ |  11_872_256 $({\color{gray}0\\%})$ |
| Record(Nested)   |   184_592_863 $({\color{gray}0\\%})$ |   135_436_180 $({\color{gray}0\\%})$ | 119_537_265 $({\color{gray}0\\%})$ |  25_292_120 $({\color{gray}0\\%})$ |
| Tuple(Mixed)     |    64_619_190 $({\color{gray}0\\%})$ |    53_536_257 $({\color{gray}0\\%})$ |  28_659_254 $({\color{gray}0\\%})$ |  14_379_032 $({\color{gray}0\\%})$ |
| Variant(Simple)  |    37_327_710 $({\color{gray}0\\%})$ |    29_396_646 $({\color{gray}0\\%})$ |  36_820_070 $({\color{gray}0\\%})$ |   5_872_002 $({\color{gray}0\\%})$ |
| Variant(Complex) |   121_098_522 $({\color{gray}0\\%})$ |   175_449_897 $({\color{gray}0\\%})$ | 195_597_312 $({\color{gray}0\\%})$ |  17_718_779 $({\color{gray}0\\%})$ |
| Large Text       | 1_123_743_560 $({\color{gray}0\\%})$ | 1_119_099_068 $({\color{gray}0\\%})$ | 271_707_055 $({\color{gray}0\\%})$ | 271_640_971 $({\color{gray}0\\%})$ |
| Large Array      | 1_914_730_224 $({\color{gray}0\\%})$ |   841_831_418 $({\color{gray}0\\%})$ | 258_021_784 $({\color{gray}0\\%})$ | 256_462_957 $({\color{gray}0\\%})$ |
| Deep Nesting     |   139_695_256 $({\color{gray}0\\%})$ |    91_432_721 $({\color{gray}0\\%})$ |  52_562_633 $({\color{gray}0\\%})$ |  18_097_716 $({\color{gray}0\\%})$ |
| Wide Record      |   212_496_733 $({\color{gray}0\\%})$ |   147_936_376 $({\color{gray}0\\%})$ | 128_361_675 $({\color{gray}0\\%})$ |  65_740_966 $({\color{gray}0\\%})$ |


**Heap**

|                  |                           encode() |            encode(sans inference) |                          decode() |            decode(sans inference) |
| :--------------- | ---------------------------------: | --------------------------------: | --------------------------------: | --------------------------------: |
| Nat              |    1.92 MiB $({\color{gray}0\\%})$ |   1.27 MiB $({\color{gray}0\\%})$ | 537.32 KiB $({\color{gray}0\\%})$ | 513.88 KiB $({\color{gray}0\\%})$ |
| Nat8             |  -18.11 MiB $({\color{gray}0\\%})$ |   1.22 MiB $({\color{gray}0\\%})$ | 537.32 KiB $({\color{gray}0\\%})$ | 513.88 KiB $({\color{gray}0\\%})$ |
| Nat16            |     1.9 MiB $({\color{gray}0\\%})$ |   1.25 MiB $({\color{gray}0\\%})$ | 537.32 KiB $({\color{gray}0\\%})$ | 513.88 KiB $({\color{gray}0\\%})$ |
| Nat32            |    1.93 MiB $({\color{gray}0\\%})$ |   1.28 MiB $({\color{gray}0\\%})$ | 537.32 KiB $({\color{gray}0\\%})$ | 513.88 KiB $({\color{gray}0\\%})$ |
| Nat64            |    1.98 MiB $({\color{gray}0\\%})$ | -13.64 MiB $({\color{gray}0\\%})$ |  540.2 KiB $({\color{gray}0\\%})$ | 516.76 KiB $({\color{gray}0\\%})$ |
| Int              |    1.94 MiB $({\color{gray}0\\%})$ |   1.29 MiB $({\color{gray}0\\%})$ | 537.32 KiB $({\color{gray}0\\%})$ | 513.88 KiB $({\color{gray}0\\%})$ |
| Int8             |    1.87 MiB $({\color{gray}0\\%})$ |   1.22 MiB $({\color{gray}0\\%})$ | 537.32 KiB $({\color{gray}0\\%})$ | 513.88 KiB $({\color{gray}0\\%})$ |
| Int16            |     1.9 MiB $({\color{gray}0\\%})$ |   1.25 MiB $({\color{gray}0\\%})$ | 537.32 KiB $({\color{gray}0\\%})$ | 513.88 KiB $({\color{gray}0\\%})$ |
| Int32            |    1.93 MiB $({\color{gray}0\\%})$ |   1.28 MiB $({\color{gray}0\\%})$ | 537.32 KiB $({\color{gray}0\\%})$ | 513.88 KiB $({\color{gray}0\\%})$ |
| Int64            |  -17.94 MiB $({\color{gray}0\\%})$ |   1.33 MiB $({\color{gray}0\\%})$ |  540.2 KiB $({\color{gray}0\\%})$ | 516.76 KiB $({\color{gray}0\\%})$ |
| Float            |    2.39 MiB $({\color{gray}0\\%})$ |   1.74 MiB $({\color{gray}0\\%})$ |   1.06 MiB $({\color{gray}0\\%})$ |   1.04 MiB $({\color{gray}0\\%})$ |
| Bool             |    1.87 MiB $({\color{gray}0\\%})$ |   1.22 MiB $({\color{gray}0\\%})$ | 537.32 KiB $({\color{gray}0\\%})$ | 513.88 KiB $({\color{gray}0\\%})$ |
| Text             |  -12.92 MiB $({\color{gray}0\\%})$ |   1.33 MiB $({\color{gray}0\\%})$ | 575.71 KiB $({\color{gray}0\\%})$ | 552.27 KiB $({\color{gray}0\\%})$ |
| Null             |    1.84 MiB $({\color{gray}0\\%})$ |   1.18 MiB $({\color{gray}0\\%})$ |   2.32 MiB $({\color{gray}0\\%})$ |   1.63 MiB $({\color{gray}0\\%})$ |
| Empty            |    1.84 MiB $({\color{gray}0\\%})$ |   1.18 MiB $({\color{gray}0\\%})$ |   2.32 MiB $({\color{gray}0\\%})$ |   1.63 MiB $({\color{gray}0\\%})$ |
| Principal        |  -17.77 MiB $({\color{gray}0\\%})$ |   1.47 MiB $({\color{gray}0\\%})$ | 617.01 KiB $({\color{gray}0\\%})$ | 593.57 KiB $({\color{gray}0\\%})$ |
| Blob             |    4.37 MiB $({\color{gray}0\\%})$ |   2.79 MiB $({\color{gray}0\\%})$ |    1.6 MiB $({\color{gray}0\\%})$ |   1.35 MiB $({\color{gray}0\\%})$ |
| Option(Nat)      |   -12.1 MiB $({\color{gray}0\\%})$ |   1.38 MiB $({\color{gray}0\\%})$ | 791.26 KiB $({\color{gray}0\\%})$ | 536.57 KiB $({\color{gray}0\\%})$ |
| Option(Text)     |     2.8 MiB $({\color{gray}0\\%})$ |   1.41 MiB $({\color{gray}0\\%})$ | 809.28 KiB $({\color{gray}0\\%})$ | 554.59 KiB $({\color{gray}0\\%})$ |
| Array(Nat8)      |    4.04 MiB $({\color{gray}0\\%})$ |   1.58 MiB $({\color{gray}0\\%})$ | 931.32 KiB $({\color{gray}0\\%})$ | 676.63 KiB $({\color{gray}0\\%})$ |
| Array(Text)      |  -15.41 MiB $({\color{gray}0\\%})$ |   1.96 MiB $({\color{gray}0\\%})$ |    1.2 MiB $({\color{gray}0\\%})$ | 975.87 KiB $({\color{gray}0\\%})$ |
| Array(Record)    |    6.08 MiB $({\color{gray}0\\%})$ | -11.94 MiB $({\color{gray}0\\%})$ |    2.4 MiB $({\color{gray}0\\%})$ |   1.42 MiB $({\color{gray}0\\%})$ |
| Record(Simple)   |    4.24 MiB $({\color{gray}0\\%})$ |   2.17 MiB $({\color{gray}0\\%})$ |   2.18 MiB $({\color{gray}0\\%})$ |   1.36 MiB $({\color{gray}0\\%})$ |
| Record(Nested)   |   -7.61 MiB $({\color{gray}0\\%})$ |    6.7 MiB $({\color{gray}0\\%})$ |  -7.25 MiB $({\color{gray}0\\%})$ |   2.42 MiB $({\color{gray}0\\%})$ |
| Tuple(Mixed)     |    4.99 MiB $({\color{gray}0\\%})$ |   3.64 MiB $({\color{gray}0\\%})$ | -17.23 MiB $({\color{gray}0\\%})$ |   1.29 MiB $({\color{gray}0\\%})$ |
| Variant(Simple)  |    3.59 MiB $({\color{gray}0\\%})$ |   1.86 MiB $({\color{gray}0\\%})$ |   2.64 MiB $({\color{gray}0\\%})$ | 726.18 KiB $({\color{gray}0\\%})$ |
| Variant(Complex) |   -5.81 MiB $({\color{gray}0\\%})$ |   9.63 MiB $({\color{gray}0\\%})$ |  -8.73 MiB $({\color{gray}0\\%})$ |   1.68 MiB $({\color{gray}0\\%})$ |
| Large Text       | -755.49 KiB $({\color{gray}0\\%})$ |  -6.09 MiB $({\color{gray}0\\%})$ |   6.38 MiB $({\color{gray}0\\%})$ |   6.36 MiB $({\color{gray}0\\%})$ |
| Large Array      |    6.28 MiB $({\color{gray}0\\%})$ |   2.28 MiB $({\color{gray}0\\%})$ |  10.99 MiB $({\color{gray}0\\%})$ |  -2.97 MiB $({\color{gray}0\\%})$ |
| Deep Nesting     |   -6.76 MiB $({\color{gray}0\\%})$ |   5.82 MiB $({\color{gray}0\\%})$ |  -9.47 MiB $({\color{gray}0\\%})$ |   2.08 MiB $({\color{gray}0\\%})$ |
| Wide Record      |    9.71 MiB $({\color{gray}0\\%})$ |   5.03 MiB $({\color{gray}0\\%})$ |  -8.38 MiB $({\color{gray}0\\%})$ |  -7.56 MiB $({\color{gray}0\\%})$ |


**Garbage Collection**

|                  |                         encode() |           encode(sans inference) |                         decode() |           decode(sans inference) |
| :--------------- | -------------------------------: | -------------------------------: | -------------------------------: | -------------------------------: |
| Nat              |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Nat8             | 19.97 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Nat16            |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Nat32            |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Nat64            |       0 B $({\color{gray}0\\%})$ | 14.94 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int              |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int8             |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int16            |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int32            |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int64            | 19.91 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Float            |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Bool             |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Text             | 14.89 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Null             |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Empty            |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Principal        | 19.87 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Blob             |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Option(Nat)      | 14.85 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Option(Text)     |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Array(Nat8)      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Array(Text)      | 19.82 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Array(Record)    |       0 B $({\color{gray}0\\%})$ |  14.8 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Record(Simple)   |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Record(Nested)   | 19.78 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ | 14.76 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Tuple(Mixed)     |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ | 19.75 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Variant(Simple)  |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Variant(Complex) | 14.73 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ | 19.71 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Large Text       | 14.45 MiB $({\color{gray}0\\%})$ | 19.15 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Large Array      | 77.79 MiB $({\color{gray}0\\%})$ | 18.74 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ | 13.69 MiB $({\color{gray}0\\%})$ |
| Deep Nesting     | 18.68 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ | 13.68 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Wide Record      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ | 18.63 MiB $({\color{gray}0\\%})$ | 13.63 MiB $({\color{gray}0\\%})$ |


</details>
Saving results to .bench/types.bench.json

<details>

<summary>submodules/ByteUtils/bench/BigEndian.bench.mo $({\color{gray}0\%})$</summary>

### ByteUtils library Benchmarks: Big Endian Conversions

_Benchmarking the performance with 10k calls for type-to-bytes and bytes-to-type conversions_


Instructions: ${\color{gray}0\\%}$
Heap: ${\color{gray}0\\%}$
Stable Memory: ${\color{gray}0\\%}$
Garbage Collection: ${\color{gray}0\\%}$


**Instructions**

|            |                      Type to Bytes |                      Bytes to Type |
| :--------- | ---------------------------------: | ---------------------------------: |
| Nat8       |   4_146_573 $({\color{gray}0\\%})$ |  12_727_559 $({\color{gray}0\\%})$ |
| Nat16      |   5_987_870 $({\color{gray}0\\%})$ |  15_458_628 $({\color{gray}0\\%})$ |
| Nat32      |   6_409_079 $({\color{gray}0\\%})$ |  22_159_673 $({\color{gray}0\\%})$ |
| Nat64      |   7_607_286 $({\color{gray}0\\%})$ |  34_731_093 $({\color{gray}0\\%})$ |
| Int8       |   4_270_417 $({\color{gray}0\\%})$ |  12_771_419 $({\color{gray}0\\%})$ |
| Int16      |   6_131_714 $({\color{gray}0\\%})$ |  15_592_456 $({\color{gray}0\\%})$ |
| Int32      |   6_552_923 $({\color{gray}0\\%})$ |  22_293_501 $({\color{gray}0\\%})$ |
| Int64      |   9_208_249 $({\color{gray}0\\%})$ |  36_347_414 $({\color{gray}0\\%})$ |
| Float      | 621_969_809 $({\color{gray}0\\%})$ | 584_630_412 $({\color{gray}0\\%})$ |
| LEB128_64  | 249_632_291 $({\color{gray}0\\%})$ | 272_364_918 $({\color{gray}0\\%})$ |
| SLEB128_64 | 336_261_565 $({\color{gray}0\\%})$ | 278_411_187 $({\color{gray}0\\%})$ |


**Heap**

|            |                     Type to Bytes |                     Bytes to Type |
| :--------- | --------------------------------: | --------------------------------: |
| Nat8       | 348.36 KiB $({\color{gray}0\\%})$ |   1.48 MiB $({\color{gray}0\\%})$ |
| Nat16      | 817.11 KiB $({\color{gray}0\\%})$ |   1.48 MiB $({\color{gray}0\\%})$ |
| Nat32      |    1.1 MiB $({\color{gray}0\\%})$ |   1.48 MiB $({\color{gray}0\\%})$ |
| Nat64      |   1.71 MiB $({\color{gray}0\\%})$ |   1.77 MiB $({\color{gray}0\\%})$ |
| Int8       | 348.36 KiB $({\color{gray}0\\%})$ |   1.48 MiB $({\color{gray}0\\%})$ |
| Int16      | 817.11 KiB $({\color{gray}0\\%})$ |   1.48 MiB $({\color{gray}0\\%})$ |
| Int32      |    1.1 MiB $({\color{gray}0\\%})$ |   1.48 MiB $({\color{gray}0\\%})$ |
| Int64      |      2 MiB $({\color{gray}0\\%})$ | -52.12 MiB $({\color{gray}0\\%})$ |
| Float      |  33.15 MiB $({\color{gray}0\\%})$ | -20.99 MiB $({\color{gray}0\\%})$ |
| LEB128_64  |  13.34 MiB $({\color{gray}0\\%})$ |  12.29 MiB $({\color{gray}0\\%})$ |
| SLEB128_64 | -32.77 MiB $({\color{gray}0\\%})$ |  12.81 MiB $({\color{gray}0\\%})$ |


**Garbage Collection**

|            |                    Type to Bytes |                    Bytes to Type |
| :--------- | -------------------------------: | -------------------------------: |
| Nat8       |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Nat16      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Nat32      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Nat64      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int8       |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int16      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int32      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int64      |       0 B $({\color{gray}0\\%})$ | 54.18 MiB $({\color{gray}0\\%})$ |
| Float      |       0 B $({\color{gray}0\\%})$ | 49.18 MiB $({\color{gray}0\\%})$ |
| LEB128_64  |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| SLEB128_64 | 54.18 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |


</details>
Saving results to .bench/BigEndian.bench.json

<details>

<summary>submodules/ByteUtils/bench/LittleEndian.bench.mo $({\color{gray}0\%})$</summary>

### ByteUtils library Benchmarks: Little Endian Conversions

_Benchmarking the performance with 10k calls for type-to-bytes and bytes-to-type conversions_


Instructions: ${\color{gray}0\\%}$
Heap: ${\color{gray}0\\%}$
Stable Memory: ${\color{gray}0\\%}$
Garbage Collection: ${\color{gray}0\\%}$


**Instructions**

|            |                      Type to Bytes |                      Bytes to Type |
| :--------- | ---------------------------------: | ---------------------------------: |
| Nat8       |   4_146_573 $({\color{gray}0\\%})$ |  12_727_559 $({\color{gray}0\\%})$ |
| Nat16      |   5_987_870 $({\color{gray}0\\%})$ |  15_458_628 $({\color{gray}0\\%})$ |
| Nat32      |   6_409_079 $({\color{gray}0\\%})$ |  22_159_673 $({\color{gray}0\\%})$ |
| Nat64      |   7_607_286 $({\color{gray}0\\%})$ |  34_731_093 $({\color{gray}0\\%})$ |
| Int8       |   4_270_417 $({\color{gray}0\\%})$ |  12_771_419 $({\color{gray}0\\%})$ |
| Int16      |   6_131_714 $({\color{gray}0\\%})$ |  15_592_456 $({\color{gray}0\\%})$ |
| Int32      |   6_552_923 $({\color{gray}0\\%})$ |  22_293_501 $({\color{gray}0\\%})$ |
| Int64      |   9_208_249 $({\color{gray}0\\%})$ |  36_347_414 $({\color{gray}0\\%})$ |
| Float      | 614_929_809 $({\color{gray}0\\%})$ | 577_590_412 $({\color{gray}0\\%})$ |
| LEB128_64  | 249_632_291 $({\color{gray}0\\%})$ | 272_364_918 $({\color{gray}0\\%})$ |
| SLEB128_64 | 336_261_565 $({\color{gray}0\\%})$ | 278_411_187 $({\color{gray}0\\%})$ |


**Heap**

|            |                     Type to Bytes |                     Bytes to Type |
| :--------- | --------------------------------: | --------------------------------: |
| Nat8       | 348.36 KiB $({\color{gray}0\\%})$ |   1.48 MiB $({\color{gray}0\\%})$ |
| Nat16      | 817.11 KiB $({\color{gray}0\\%})$ |   1.48 MiB $({\color{gray}0\\%})$ |
| Nat32      |    1.1 MiB $({\color{gray}0\\%})$ |   1.48 MiB $({\color{gray}0\\%})$ |
| Nat64      |   1.71 MiB $({\color{gray}0\\%})$ |   1.77 MiB $({\color{gray}0\\%})$ |
| Int8       | 348.36 KiB $({\color{gray}0\\%})$ |   1.48 MiB $({\color{gray}0\\%})$ |
| Int16      | 817.11 KiB $({\color{gray}0\\%})$ |   1.48 MiB $({\color{gray}0\\%})$ |
| Int32      |    1.1 MiB $({\color{gray}0\\%})$ |   1.48 MiB $({\color{gray}0\\%})$ |
| Int64      |      2 MiB $({\color{gray}0\\%})$ | -52.12 MiB $({\color{gray}0\\%})$ |
| Float      |  33.15 MiB $({\color{gray}0\\%})$ | -20.99 MiB $({\color{gray}0\\%})$ |
| LEB128_64  |  13.34 MiB $({\color{gray}0\\%})$ |  12.29 MiB $({\color{gray}0\\%})$ |
| SLEB128_64 | -32.77 MiB $({\color{gray}0\\%})$ |  12.81 MiB $({\color{gray}0\\%})$ |


**Garbage Collection**

|            |                    Type to Bytes |                    Bytes to Type |
| :--------- | -------------------------------: | -------------------------------: |
| Nat8       |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Nat16      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Nat32      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Nat64      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int8       |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int16      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int32      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int64      |       0 B $({\color{gray}0\\%})$ | 54.18 MiB $({\color{gray}0\\%})$ |
| Float      |       0 B $({\color{gray}0\\%})$ | 49.18 MiB $({\color{gray}0\\%})$ |
| LEB128_64  |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| SLEB128_64 | 54.18 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |


</details>
Saving results to .bench/LittleEndian.bench.json

<details>

<summary>submodules/ByteUtils/bench/Sorted.bench.mo $({\color{gray}0\%})$</summary>

### ByteUtils library Benchmarks: Sorted Encodings

_Benchmarking the performance with 10k calls for type-to-bytes and bytes-to-type conversions using sortable encodings_


Instructions: ${\color{gray}0\\%}$
Heap: ${\color{gray}0\\%}$
Stable Memory: ${\color{gray}0\\%}$
Garbage Collection: ${\color{gray}0\\%}$


**Instructions**

|       |                      Type to Bytes |                      Bytes to Type |
| :---- | ---------------------------------: | ---------------------------------: |
| Nat8  |   4_146_333 $({\color{gray}0\\%})$ |  12_730_263 $({\color{gray}0\\%})$ |
| Nat16 |   5_987_694 $({\color{gray}0\\%})$ |  15_461_332 $({\color{gray}0\\%})$ |
| Nat32 |   6_408_871 $({\color{gray}0\\%})$ |  22_162_377 $({\color{gray}0\\%})$ |
| Nat64 |   7_609_113 $({\color{gray}0\\%})$ |  34_727_519 $({\color{gray}0\\%})$ |
| Int8  |   4_310_177 $({\color{gray}0\\%})$ |  12_792_075 $({\color{gray}0\\%})$ |
| Int16 |   6_101_538 $({\color{gray}0\\%})$ |  15_483_144 $({\color{gray}0\\%})$ |
| Int32 |   6_522_715 $({\color{gray}0\\%})$ |  22_184_189 $({\color{gray}0\\%})$ |
| Int64 |   7_681_033 $({\color{gray}0\\%})$ |  34_791_424 $({\color{gray}0\\%})$ |
| Float | 636_777_445 $({\color{gray}0\\%})$ | 622_833_681 $({\color{gray}0\\%})$ |


**Heap**

|       |                     Type to Bytes |                     Bytes to Type |
| :---- | --------------------------------: | --------------------------------: |
| Nat8  | 348.36 KiB $({\color{gray}0\\%})$ |   1.48 MiB $({\color{gray}0\\%})$ |
| Nat16 | 817.11 KiB $({\color{gray}0\\%})$ |   1.48 MiB $({\color{gray}0\\%})$ |
| Nat32 |    1.1 MiB $({\color{gray}0\\%})$ |   1.48 MiB $({\color{gray}0\\%})$ |
| Nat64 |   1.71 MiB $({\color{gray}0\\%})$ | -55.08 MiB $({\color{gray}0\\%})$ |
| Int8  | 348.36 KiB $({\color{gray}0\\%})$ |   1.48 MiB $({\color{gray}0\\%})$ |
| Int16 | 817.11 KiB $({\color{gray}0\\%})$ |   1.48 MiB $({\color{gray}0\\%})$ |
| Int32 |    1.1 MiB $({\color{gray}0\\%})$ |   1.48 MiB $({\color{gray}0\\%})$ |
| Int64 |   1.71 MiB $({\color{gray}0\\%})$ |   1.77 MiB $({\color{gray}0\\%})$ |
| Float |  34.37 MiB $({\color{gray}0\\%})$ | -20.91 MiB $({\color{gray}0\\%})$ |


**Garbage Collection**

|       |              Type to Bytes |                    Bytes to Type |
| :---- | -------------------------: | -------------------------------: |
| Nat8  | 0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Nat16 | 0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Nat32 | 0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Nat64 | 0 B $({\color{gray}0\\%})$ | 56.85 MiB $({\color{gray}0\\%})$ |
| Int8  | 0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int16 | 0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int32 | 0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int64 | 0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Float | 0 B $({\color{gray}0\\%})$ | 51.85 MiB $({\color{gray}0\\%})$ |


</details>
Saving results to .bench/Sorted.bench.json
