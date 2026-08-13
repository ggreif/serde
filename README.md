# Benchmark Results



<details>

<summary>bench/serde.bench.mo $({\color{green}-1465473.45\%})$</summary>

### Benchmarking Serde

_Benchmarking the performance with 1k calls_


Instructions: ${\color{red}+86.12\\%}$
Heap: ${\color{green}-1465668.71\\%}$
Stable Memory: ${\color{gray}0\\%}$
Garbage Collection: ${\color{red}+109.13\\%}$


**Instructions**

|                                     |                                  decode() |                                 encode() |
| :---------------------------------- | ----------------------------------------: | ---------------------------------------: |
| Serde: One Shot                     | 1_030_642_122 $({\color{red}+161.28\\%})$ | 2_075_676_973 $({\color{red}+87.79\\%})$ |
| Serde: One Shot sans type inference |   488_511_439 $({\color{red}+116.55\\%})$ | 1_479_502_498 $({\color{red}+65.92\\%})$ |
| Motoko (to_candid(), from_candid()) |     38_890_400 $({\color{red}+24.19\\%})$ |    11_643_918 $({\color{red}+28.49\\%})$ |
| Serde: Single Type Serializer       |   229_225_592 $({\color{red}+104.75\\%})$ |  445_178_924 $({\color{red}+100.01\\%})$ |


**Heap**

|                                     |                                     decode() |                                      encode() |
| :---------------------------------- | -------------------------------------------: | --------------------------------------------: |
| Serde: One Shot                     |       16.65 MiB $({\color{red}+1005.04\\%})$ |       2.33 MiB $({\color{red}+793668.83\\%})$ |
| Serde: One Shot sans type inference | -19.55 MiB $({\color{green}-7535135.29\\%})$ |     11.11 MiB $({\color{red}+4282455.88\\%})$ |
| Motoko (to_candid(), from_candid()) |      1.16 MiB $({\color{red}+445767.65\\%})$ |     668.57 KiB $({\color{red}+251597.06\\%})$ |
| Serde: Single Type Serializer       |    15.87 MiB $({\color{red}+6116770.59\\%})$ | -41.72 MiB $({\color{green}-16081479.41\\%})$ |


**Garbage Collection**

|                                     |                              decode() |                              encode() |
| :---------------------------------- | ------------------------------------: | ------------------------------------: |
| Serde: One Shot                     | 56.57 MiB $({\color{red}+129.57\\%})$ | 119.07 MiB $({\color{red}+90.41\\%})$ |
| Serde: One Shot sans type inference | 60.07 MiB $({\color{red}+242.22\\%})$ |  55.07 MiB $({\color{red}+62.18\\%})$ |
| Motoko (to_candid(), from_candid()) |     0 B $({\color{green}-100.00\\%})$ |     0 B $({\color{green}-100.00\\%})$ |
| Serde: Single Type Serializer       |     0 B $({\color{green}-100.00\\%})$ | 60.07 MiB $({\color{red}+648.66\\%})$ |


</details>
Saving results to .bench/serde.bench.json

<details>

<summary>bench/types.bench.mo $({\color{red}+20321.62\%})$</summary>

### Benchmarking Serde by Data Types

_Performance comparison across all supported Candid data types with 1k operations_


Instructions: ${\color{red}+19912.19\\%}$
Heap: ${\color{red}+409.42\\%}$
Stable Memory: ${\color{gray}0\\%}$
Garbage Collection: ${\color{gray}0\\%}$


**Instructions**

|                  |                                    encode() |                      encode(sans inference) |                                  decode() |                    decode(sans inference) |
| :--------------- | ------------------------------------------: | ------------------------------------------: | ----------------------------------------: | ----------------------------------------: |
| Nat              |    16_555_116 $({\color{red}+22674.33\\%})$ |    11_966_655 $({\color{red}+18453.82\\%})$ |   3_216_030 $({\color{red}+21825.48\\%})$ |   3_154_354 $({\color{red}+10461.69\\%})$ |
| Nat8             |    15_113_687 $({\color{red}+20855.72\\%})$ |    10_518_464 $({\color{red}+16277.27\\%})$ |   3_038_599 $({\color{red}+20921.09\\%})$ |    2_975_883 $({\color{red}+9829.54\\%})$ |
| Nat16            |    15_846_460 $({\color{red}+21525.72\\%})$ |    11_244_783 $({\color{red}+17021.34\\%})$ |   3_118_694 $({\color{red}+20209.29\\%})$ |    3_055_336 $({\color{red}+9696.51\\%})$ |
| Nat32            |    16_889_979 $({\color{red}+22404.07\\%})$ |    12_281_726 $({\color{red}+18027.47\\%})$ |   3_295_445 $({\color{red}+19700.79\\%})$ |    3_230_713 $({\color{red}+9752.14\\%})$ |
| Nat64            |    18_736_750 $({\color{red}+23979.82\\%})$ |    14_122_114 $({\color{red}+19844.24\\%})$ |   3_613_976 $({\color{red}+19216.78\\%})$ |    3_548_268 $({\color{red}+9987.47\\%})$ |
| Int              |    16_880_373 $({\color{red}+22314.81\\%})$ |    12_298_872 $({\color{red}+17793.43\\%})$ |   3_278_453 $({\color{red}+18871.43\\%})$ |    3_211_737 $({\color{red}+9328.54\\%})$ |
| Int8             |    15_132_360 $({\color{red}+20190.92\\%})$ |    10_544_283 $({\color{red}+15337.96\\%})$ |   3_064_442 $({\color{red}+18000.66\\%})$ |    2_996_718 $({\color{red}+8706.11\\%})$ |
| Int16            |    15_867_519 $({\color{red}+20852.48\\%})$ |    11_272_834 $({\color{red}+16061.31\\%})$ |   3_146_401 $({\color{red}+17545.68\\%})$ |    3_077_669 $({\color{red}+8631.47\\%})$ |
| Int32            |    16_911_054 $({\color{red}+21722.97\\%})$ |    12_309_729 $({\color{red}+17041.84\\%})$ |   3_323_104 $({\color{red}+17277.52\\%})$ |    3_253_364 $({\color{red}+8726.99\\%})$ |
| Int64            |    18_770_963 $({\color{red}+23297.61\\%})$ |    14_162_876 $({\color{red}+18823.45\\%})$ |   3_646_227 $({\color{red}+17108.92\\%})$ |    3_575_479 $({\color{red}+9012.05\\%})$ |
| Float            |    27_009_664 $({\color{red}+26203.93\\%})$ |    22_371_155 $({\color{red}+22840.07\\%})$ |  14_513_119 $({\color{red}+29624.16\\%})$ |  14_441_363 $({\color{red}+21392.04\\%})$ |
| Bool             |    15_206_881 $({\color{red}+19608.75\\%})$ |    10_569_732 $({\color{red}+14515.23\\%})$ |   3_073_661 $({\color{red}+15838.09\\%})$ |    3_017_665 $({\color{red}+7834.96\\%})$ |
| Text             |    19_592_897 $({\color{red}+23839.90\\%})$ |    14_941_899 $({\color{red}+19235.26\\%})$ |   4_009_440 $({\color{red}+17103.47\\%})$ |    3_937_068 $({\color{red}+9204.63\\%})$ |
| Null             |    14_381_349 $({\color{red}+18573.20\\%})$ |     9_638_597 $({\color{red}+13109.35\\%})$ |  17_283_671 $({\color{red}+19473.81\\%})$ |  12_413_555 $({\color{red}+14731.36\\%})$ |
| Empty            |    14_392_808 $({\color{red}+18488.15\\%})$ |     9_643_448 $({\color{red}+12988.28\\%})$ |  17_319_130 $({\color{red}+19403.52\\%})$ |  12_421_406 $({\color{red}+14613.64\\%})$ |
| Principal        |    28_227_197 $({\color{red}+28490.29\\%})$ |    23_564_430 $({\color{red}+24681.19\\%})$ |   5_899_613 $({\color{red}+17394.85\\%})$ |   5_826_985 $({\color{red}+10753.02\\%})$ |
| Blob             |    58_762_765 $({\color{red}+24012.35\\%})$ |    46_876_560 $({\color{red}+22189.48\\%})$ |  15_054_202 $({\color{red}+15187.80\\%})$ |  13_488_702 $({\color{red}+11455.67\\%})$ |
| Option(Nat)      |    25_221_664 $({\color{red}+21641.69\\%})$ |    14_520_172 $({\color{red}+16218.10\\%})$ |   4_983_884 $({\color{red}+18413.00\\%})$ |    3_420_144 $({\color{red}+7414.32\\%})$ |
| Option(Text)     |    26_712_448 $({\color{red}+22113.91\\%})$ |    16_019_165 $({\color{red}+17066.76\\%})$ |   5_361_624 $({\color{red}+17513.17\\%})$ |    3_782_876 $({\color{red}+7572.87\\%})$ |
| Array(Nat8)      |    45_434_497 $({\color{red}+33192.66\\%})$ |    19_043_382 $({\color{red}+20602.03\\%})$ |   6_388_415 $({\color{red}+21500.73\\%})$ |    4_824_059 $({\color{red}+9785.97\\%})$ |
| Array(Text)      |    70_560_187 $({\color{red}+37607.31\\%})$ |    43_704_230 $({\color{red}+34078.11\\%})$ |  13_914_746 $({\color{red}+23919.10\\%})$ |  12_336_782 $({\color{red}+15833.64\\%})$ |
| Array(Record)    |    75_207_177 $({\color{red}+25131.47\\%})$ |    46_668_293 $({\color{red}+22743.58\\%})$ |  25_851_625 $({\color{red}+34894.21\\%})$ |  12_482_885 $({\color{red}+14379.63\\%})$ |
| Record(Simple)   |            54_929_782 (no previous results) |            35_659_483 (no previous results) |          20_869_156 (no previous results) |          11_872_256 (no previous results) |
| Record(Nested)   |   184_592_863 $({\color{red}+24153.75\\%})$ |   135_436_180 $({\color{red}+25510.63\\%})$ | 119_537_265 $({\color{red}+38517.34\\%})$ |  25_292_120 $({\color{red}+16930.01\\%})$ |
| Tuple(Mixed)     |            64_619_190 (no previous results) |            53_536_257 (no previous results) |          28_659_254 (no previous results) |          14_379_032 (no previous results) |
| Variant(Simple)  |    37_327_710 $({\color{red}+24795.10\\%})$ |    29_396_646 $({\color{red}+20739.08\\%})$ |  36_820_070 $({\color{red}+57786.82\\%})$ |   5_872_002 $({\color{red}+10760.40\\%})$ |
| Variant(Complex) |   121_098_522 $({\color{red}+12515.45\\%})$ |   175_449_897 $({\color{red}+21592.81\\%})$ | 195_597_312 $({\color{red}+46795.26\\%})$ |  17_718_779 $({\color{red}+14185.42\\%})$ |
| Large Text       | 1_123_743_560 $({\color{red}+19178.23\\%})$ | 1_119_099_068 $({\color{red}+19096.62\\%})$ | 271_707_055 $({\color{red}+14145.66\\%})$ | 271_640_971 $({\color{red}+13964.05\\%})$ |
| Large Array      | 1_914_730_224 $({\color{red}+31591.00\\%})$ |   841_831_418 $({\color{red}+30669.70\\%})$ | 258_021_784 $({\color{red}+21024.48\\%})$ | 256_462_957 $({\color{red}+20517.95\\%})$ |
| Deep Nesting     |   139_695_256 $({\color{red}+22166.45\\%})$ |    91_432_721 $({\color{red}+20985.67\\%})$ |  52_562_633 $({\color{red}+41921.20\\%})$ |  18_097_716 $({\color{red}+14753.92\\%})$ |
| Wide Record      |   212_496_733 $({\color{red}+24893.62\\%})$ |   147_936_376 $({\color{red}+29070.03\\%})$ | 128_361_675 $({\color{red}+38010.33\\%})$ |  65_740_966 $({\color{red}+19824.10\\%})$ |


**Heap**

|                  |                                   encode() |                     encode(sans inference) |                                  decode() |                    decode(sans inference) |
| :--------------- | -----------------------------------------: | -----------------------------------------: | ----------------------------------------: | ----------------------------------------: |
| Nat              |      1.92 MiB $({\color{red}+9860.21\\%})$ |      1.27 MiB $({\color{red}+7591.88\\%})$ |   537.32 KiB $({\color{red}+5094.64\\%})$ |   513.88 KiB $({\color{red}+4894.46\\%})$ |
| Nat8             | -18.11 MiB $({\color{green}-94147.90\\%})$ |      1.22 MiB $({\color{red}+7311.53\\%})$ |   537.32 KiB $({\color{red}+5114.33\\%})$ |   513.88 KiB $({\color{red}+4913.49\\%})$ |
| Nat16            |       1.9 MiB $({\color{red}+9776.32\\%})$ |      1.25 MiB $({\color{red}+7493.29\\%})$ |   537.32 KiB $({\color{red}+5104.46\\%})$ |   513.88 KiB $({\color{red}+4903.96\\%})$ |
| Nat32            |      1.93 MiB $({\color{red}+9922.84\\%})$ |      1.28 MiB $({\color{red}+7665.62\\%})$ |   537.32 KiB $({\color{red}+5084.85\\%})$ |   513.88 KiB $({\color{red}+4884.99\\%})$ |
| Nat64            |     1.98 MiB $({\color{red}+10150.23\\%})$ | -13.64 MiB $({\color{green}-82705.73\\%})$ |    540.2 KiB $({\color{red}+5065.86\\%})$ |   516.76 KiB $({\color{red}+4867.71\\%})$ |
| Int              |      1.94 MiB $({\color{red}+9990.64\\%})$ |      1.29 MiB $({\color{red}+7744.34\\%})$ |   537.32 KiB $({\color{red}+5094.64\\%})$ |   513.88 KiB $({\color{red}+4894.46\\%})$ |
| Int8             |      1.87 MiB $({\color{red}+9621.75\\%})$ |      1.22 MiB $({\color{red}+7311.53\\%})$ |   537.32 KiB $({\color{red}+5114.33\\%})$ |   513.88 KiB $({\color{red}+4913.49\\%})$ |
| Int16            |       1.9 MiB $({\color{red}+9776.32\\%})$ |      1.25 MiB $({\color{red}+7493.29\\%})$ |   537.32 KiB $({\color{red}+5104.46\\%})$ |   513.88 KiB $({\color{red}+4903.96\\%})$ |
| Int32            |      1.93 MiB $({\color{red}+9922.84\\%})$ |      1.28 MiB $({\color{red}+7665.62\\%})$ |   537.32 KiB $({\color{red}+5084.85\\%})$ |   513.88 KiB $({\color{red}+4884.99\\%})$ |
| Int64            | -17.94 MiB $({\color{green}-93121.67\\%})$ |      1.33 MiB $({\color{red}+7950.98\\%})$ |    540.2 KiB $({\color{red}+5065.86\\%})$ |   516.76 KiB $({\color{red}+4867.71\\%})$ |
| Float            |     2.39 MiB $({\color{red}+11877.99\\%})$ |     1.74 MiB $({\color{red}+10028.45\\%})$ |     1.06 MiB $({\color{red}+9614.88\\%})$ |     1.04 MiB $({\color{red}+9451.67\\%})$ |
| Bool             |      1.87 MiB $({\color{red}+9621.75\\%})$ |      1.22 MiB $({\color{red}+7311.53\\%})$ |   537.32 KiB $({\color{red}+5114.33\\%})$ |   513.88 KiB $({\color{red}+4913.49\\%})$ |
| Text             | -12.92 MiB $({\color{green}-66980.59\\%})$ |      1.33 MiB $({\color{red}+7949.83\\%})$ |   575.71 KiB $({\color{red}+5372.78\\%})$ |   552.27 KiB $({\color{red}+5177.42\\%})$ |
| Null             |      1.84 MiB $({\color{red}+9472.42\\%})$ |      1.18 MiB $({\color{red}+7102.46\\%})$ |    2.32 MiB $({\color{red}+11725.94\\%})$ |     1.63 MiB $({\color{red}+9637.53\\%})$ |
| Empty            |      1.84 MiB $({\color{red}+9472.42\\%})$ |      1.18 MiB $({\color{red}+7102.46\\%})$ |    2.32 MiB $({\color{red}+11725.94\\%})$ |     1.63 MiB $({\color{red}+9637.53\\%})$ |
| Principal        | -17.77 MiB $({\color{green}-90907.49\\%})$ |      1.47 MiB $({\color{red}+8675.40\\%})$ |   617.01 KiB $({\color{red}+5446.14\\%})$ |   593.57 KiB $({\color{red}+5261.82\\%})$ |
| Blob             |     4.37 MiB $({\color{red}+15788.72\\%})$ |     2.79 MiB $({\color{red}+12876.32\\%})$ |     1.6 MiB $({\color{red}+10186.88\\%})$ |     1.35 MiB $({\color{red}+8735.75\\%})$ |
| Option(Nat)      |  -12.1 MiB $({\color{green}-54565.38\\%})$ |      1.38 MiB $({\color{red}+8056.01\\%})$ |   791.26 KiB $({\color{red}+7319.85\\%})$ |   536.57 KiB $({\color{red}+5060.11\\%})$ |
| Option(Text)     |      2.8 MiB $({\color{red}+12457.56\\%})$ |      1.41 MiB $({\color{red}+8221.22\\%})$ |   809.28 KiB $({\color{red}+7365.80\\%})$ |   554.59 KiB $({\color{red}+5144.77\\%})$ |
| Array(Nat8)      |     4.04 MiB $({\color{red}+16817.12\\%})$ |      1.58 MiB $({\color{red}+9196.36\\%})$ |   931.32 KiB $({\color{red}+8513.37\\%})$ |   676.63 KiB $({\color{red}+6315.48\\%})$ |
| Array(Text)      | -15.41 MiB $({\color{green}-61768.56\\%})$ |     1.96 MiB $({\color{red}+11036.63\\%})$ |      1.2 MiB $({\color{red}+9726.01\\%})$ |   975.87 KiB $({\color{red}+7861.19\\%})$ |
| Array(Record)    |     6.08 MiB $({\color{red}+19016.20\\%})$ | -11.94 MiB $({\color{green}-58352.24\\%})$ |     2.4 MiB $({\color{red}+17781.64\\%})$ |    1.42 MiB $({\color{red}+11017.88\\%})$ |
| Record(Simple)   |             4.24 MiB (no previous results) |             2.17 MiB (no previous results) |            2.18 MiB (no previous results) |            1.36 MiB (no previous results) |
| Record(Nested)   |  -7.61 MiB $({\color{green}-14674.27\\%})$ |      6.7 MiB $({\color{red}+21764.89\\%})$ | -7.25 MiB $({\color{green}-31851.03\\%})$ |    2.42 MiB $({\color{red}+14524.23\\%})$ |
| Tuple(Mixed)     |             4.99 MiB (no previous results) |             3.64 MiB (no previous results) |          -17.23 MiB (no previous results) |            1.29 MiB (no previous results) |
| Variant(Simple)  |     3.59 MiB $({\color{red}+15013.20\\%})$ |     1.86 MiB $({\color{red}+10224.37\\%})$ |    2.64 MiB $({\color{red}+22157.61\\%})$ |   726.18 KiB $({\color{red}+6816.00\\%})$ |
| Variant(Complex) |   -5.81 MiB $({\color{green}-9428.89\\%})$ |     9.63 MiB $({\color{red}+23632.11\\%})$ | -8.73 MiB $({\color{green}-33774.01\\%})$ |    1.68 MiB $({\color{red}+11397.81\\%})$ |
| Large Text       |  -755.49 KiB $({\color{green}-627.71\\%})$ |   -6.09 MiB $({\color{green}-4547.63\\%})$ |     6.38 MiB $({\color{red}+4740.57\\%})$ |     6.36 MiB $({\color{red}+4725.16\\%})$ |
| Large Array      |      6.28 MiB $({\color{red}+2771.25\\%})$ |      2.28 MiB $({\color{red}+2479.20\\%})$ |   10.99 MiB $({\color{red}+13192.67\\%})$ |  -2.97 MiB $({\color{green}-3700.81\\%})$ |
| Deep Nesting     |  -6.76 MiB $({\color{green}-13119.62\\%})$ |     5.82 MiB $({\color{red}+20369.03\\%})$ | -9.47 MiB $({\color{green}-58452.19\\%})$ |    2.08 MiB $({\color{red}+14102.76\\%})$ |
| Wide Record      |     9.71 MiB $({\color{red}+22175.89\\%})$ |     5.03 MiB $({\color{red}+19449.04\\%})$ | -8.38 MiB $({\color{green}-29024.63\\%})$ | -7.56 MiB $({\color{green}-27588.16\\%})$ |


**Garbage Collection**

|                  |                                encode() |                  encode(sans inference) |                                decode() |                  decode(sans inference) |
| :--------------- | --------------------------------------: | --------------------------------------: | --------------------------------------: | --------------------------------------: |
| Nat              |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Nat8             | 19.97 MiB $({\color{red}+Infinity\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Nat16            |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Nat32            |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Nat64            |              0 B $({\color{gray}0\\%})$ | 14.94 MiB $({\color{red}+Infinity\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Int              |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Int8             |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Int16            |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Int32            |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Int64            | 19.91 MiB $({\color{red}+Infinity\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Float            |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Bool             |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Text             | 14.89 MiB $({\color{red}+Infinity\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Null             |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Empty            |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Principal        | 19.87 MiB $({\color{red}+Infinity\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Blob             |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Option(Nat)      | 14.85 MiB $({\color{red}+Infinity\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Option(Text)     |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Array(Nat8)      |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Array(Text)      | 19.82 MiB $({\color{red}+Infinity\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Array(Record)    |              0 B $({\color{gray}0\\%})$ |  14.8 MiB $({\color{red}+Infinity\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Record(Simple)   |               0 B (no previous results) |               0 B (no previous results) |               0 B (no previous results) |               0 B (no previous results) |
| Record(Nested)   | 19.78 MiB $({\color{red}+Infinity\\%})$ |              0 B $({\color{gray}0\\%})$ | 14.76 MiB $({\color{red}+Infinity\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Tuple(Mixed)     |               0 B (no previous results) |               0 B (no previous results) |         19.75 MiB (no previous results) |               0 B (no previous results) |
| Variant(Simple)  |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Variant(Complex) | 14.73 MiB $({\color{red}+Infinity\\%})$ |              0 B $({\color{gray}0\\%})$ | 19.71 MiB $({\color{red}+Infinity\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Large Text       | 14.45 MiB $({\color{red}+Infinity\\%})$ | 19.15 MiB $({\color{red}+Infinity\\%})$ |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Large Array      | 77.79 MiB $({\color{red}+Infinity\\%})$ | 18.74 MiB $({\color{red}+Infinity\\%})$ |              0 B $({\color{gray}0\\%})$ | 13.69 MiB $({\color{red}+Infinity\\%})$ |
| Deep Nesting     | 18.68 MiB $({\color{red}+Infinity\\%})$ |              0 B $({\color{gray}0\\%})$ | 13.68 MiB $({\color{red}+Infinity\\%})$ |              0 B $({\color{gray}0\\%})$ |
| Wide Record      |              0 B $({\color{gray}0\\%})$ |              0 B $({\color{gray}0\\%})$ | 18.63 MiB $({\color{red}+Infinity\\%})$ | 13.63 MiB $({\color{red}+Infinity\\%})$ |


</details>
Saving results to .bench/types.bench.json
No previous results found "/home/runner/work/serde/serde/.bench/BigEndian.bench.json"

<details>

<summary>submodules/ByteUtils/bench/BigEndian.bench.mo $({\color{gray}0\%})$</summary>

### ByteUtils library Benchmarks: Big Endian Conversions

_Benchmarking the performance with 10k calls for type-to-bytes and bytes-to-type conversions_


Instructions: ${\color{gray}0\\%}$
Heap: ${\color{gray}0\\%}$
Stable Memory: ${\color{gray}0\\%}$
Garbage Collection: ${\color{gray}0\\%}$


**Instructions**

|            | Type to Bytes | Bytes to Type |
| :--------- | ------------: | ------------: |
| Nat8       |     4_146_573 |    12_727_559 |
| Nat16      |     5_987_870 |    15_458_628 |
| Nat32      |     6_409_079 |    22_159_673 |
| Nat64      |     7_607_286 |    34_731_093 |
| Int8       |     4_270_417 |    12_771_419 |
| Int16      |     6_131_714 |    15_592_456 |
| Int32      |     6_552_923 |    22_293_501 |
| Int64      |     9_208_249 |    36_347_414 |
| Float      |   621_969_809 |   584_630_412 |
| LEB128_64  |   249_632_291 |   272_364_918 |
| SLEB128_64 |   336_261_565 |   278_411_187 |


**Heap**

|            | Type to Bytes | Bytes to Type |
| :--------- | ------------: | ------------: |
| Nat8       |    348.36 KiB |      1.48 MiB |
| Nat16      |    817.11 KiB |      1.48 MiB |
| Nat32      |       1.1 MiB |      1.48 MiB |
| Nat64      |      1.71 MiB |      1.77 MiB |
| Int8       |    348.36 KiB |      1.48 MiB |
| Int16      |    817.11 KiB |      1.48 MiB |
| Int32      |       1.1 MiB |      1.48 MiB |
| Int64      |         2 MiB |    -52.12 MiB |
| Float      |     33.15 MiB |    -20.99 MiB |
| LEB128_64  |     13.34 MiB |     12.29 MiB |
| SLEB128_64 |    -32.77 MiB |     12.81 MiB |


**Garbage Collection**

|            | Type to Bytes | Bytes to Type |
| :--------- | ------------: | ------------: |
| Nat8       |           0 B |           0 B |
| Nat16      |           0 B |           0 B |
| Nat32      |           0 B |           0 B |
| Nat64      |           0 B |           0 B |
| Int8       |           0 B |           0 B |
| Int16      |           0 B |           0 B |
| Int32      |           0 B |           0 B |
| Int64      |           0 B |     54.18 MiB |
| Float      |           0 B |     49.18 MiB |
| LEB128_64  |           0 B |           0 B |
| SLEB128_64 |     54.18 MiB |           0 B |


</details>
Saving results to .bench/BigEndian.bench.json
No previous results found "/home/runner/work/serde/serde/.bench/LittleEndian.bench.json"

<details>

<summary>submodules/ByteUtils/bench/LittleEndian.bench.mo $({\color{gray}0\%})$</summary>

### ByteUtils library Benchmarks: Little Endian Conversions

_Benchmarking the performance with 10k calls for type-to-bytes and bytes-to-type conversions_


Instructions: ${\color{gray}0\\%}$
Heap: ${\color{gray}0\\%}$
Stable Memory: ${\color{gray}0\\%}$
Garbage Collection: ${\color{gray}0\\%}$


**Instructions**

|            | Type to Bytes | Bytes to Type |
| :--------- | ------------: | ------------: |
| Nat8       |     4_146_573 |    12_727_559 |
| Nat16      |     5_987_870 |    15_458_628 |
| Nat32      |     6_409_079 |    22_159_673 |
| Nat64      |     7_607_286 |    34_731_093 |
| Int8       |     4_270_417 |    12_771_419 |
| Int16      |     6_131_714 |    15_592_456 |
| Int32      |     6_552_923 |    22_293_501 |
| Int64      |     9_208_249 |    36_347_414 |
| Float      |   614_929_809 |   577_590_412 |
| LEB128_64  |   249_632_291 |   272_364_918 |
| SLEB128_64 |   336_261_565 |   278_411_187 |


**Heap**

|            | Type to Bytes | Bytes to Type |
| :--------- | ------------: | ------------: |
| Nat8       |    348.36 KiB |      1.48 MiB |
| Nat16      |    817.11 KiB |      1.48 MiB |
| Nat32      |       1.1 MiB |      1.48 MiB |
| Nat64      |      1.71 MiB |      1.77 MiB |
| Int8       |    348.36 KiB |      1.48 MiB |
| Int16      |    817.11 KiB |      1.48 MiB |
| Int32      |       1.1 MiB |      1.48 MiB |
| Int64      |         2 MiB |    -52.12 MiB |
| Float      |     33.15 MiB |    -20.99 MiB |
| LEB128_64  |     13.34 MiB |     12.29 MiB |
| SLEB128_64 |    -32.77 MiB |     12.81 MiB |


**Garbage Collection**

|            | Type to Bytes | Bytes to Type |
| :--------- | ------------: | ------------: |
| Nat8       |           0 B |           0 B |
| Nat16      |           0 B |           0 B |
| Nat32      |           0 B |           0 B |
| Nat64      |           0 B |           0 B |
| Int8       |           0 B |           0 B |
| Int16      |           0 B |           0 B |
| Int32      |           0 B |           0 B |
| Int64      |           0 B |     54.18 MiB |
| Float      |           0 B |     49.18 MiB |
| LEB128_64  |           0 B |           0 B |
| SLEB128_64 |     54.18 MiB |           0 B |


</details>
Saving results to .bench/LittleEndian.bench.json
No previous results found "/home/runner/work/serde/serde/.bench/Sorted.bench.json"

<details>

<summary>submodules/ByteUtils/bench/Sorted.bench.mo $({\color{gray}0\%})$</summary>

### ByteUtils library Benchmarks: Sorted Encodings

_Benchmarking the performance with 10k calls for type-to-bytes and bytes-to-type conversions using sortable encodings_


Instructions: ${\color{gray}0\\%}$
Heap: ${\color{gray}0\\%}$
Stable Memory: ${\color{gray}0\\%}$
Garbage Collection: ${\color{gray}0\\%}$


**Instructions**

|       | Type to Bytes | Bytes to Type |
| :---- | ------------: | ------------: |
| Nat8  |     4_146_333 |    12_730_263 |
| Nat16 |     5_987_694 |    15_461_332 |
| Nat32 |     6_408_871 |    22_162_377 |
| Nat64 |     7_609_113 |    34_727_519 |
| Int8  |     4_310_177 |    12_792_075 |
| Int16 |     6_101_538 |    15_483_144 |
| Int32 |     6_522_715 |    22_184_189 |
| Int64 |     7_681_033 |    34_791_424 |
| Float |   636_777_445 |   622_833_681 |


**Heap**

|       | Type to Bytes | Bytes to Type |
| :---- | ------------: | ------------: |
| Nat8  |    348.36 KiB |      1.48 MiB |
| Nat16 |    817.11 KiB |      1.48 MiB |
| Nat32 |       1.1 MiB |      1.48 MiB |
| Nat64 |      1.71 MiB |    -55.08 MiB |
| Int8  |    348.36 KiB |      1.48 MiB |
| Int16 |    817.11 KiB |      1.48 MiB |
| Int32 |       1.1 MiB |      1.48 MiB |
| Int64 |      1.71 MiB |      1.77 MiB |
| Float |     34.37 MiB |    -20.91 MiB |


**Garbage Collection**

|       | Type to Bytes | Bytes to Type |
| :---- | ------------: | ------------: |
| Nat8  |           0 B |           0 B |
| Nat16 |           0 B |           0 B |
| Nat32 |           0 B |           0 B |
| Nat64 |           0 B |     56.85 MiB |
| Int8  |           0 B |           0 B |
| Int16 |           0 B |           0 B |
| Int32 |           0 B |           0 B |
| Int64 |           0 B |           0 B |
| Float |           0 B |     51.85 MiB |


</details>
Saving results to .bench/Sorted.bench.json
