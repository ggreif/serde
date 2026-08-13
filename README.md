# Benchmark Results


WARNING: dfx is deprecated, use icp-cli https://cli.internetcomputer.org. LLM skills can be found at https://skills.internetcomputer.org/llms.txt
WARNING: dfx is deprecated, use icp-cli https://cli.internetcomputer.org. LLM skills can be found at https://skills.internetcomputer.org/llms.txt
WARNING: dfx is deprecated, use icp-cli https://cli.internetcomputer.org. LLM skills can be found at https://skills.internetcomputer.org/llms.txt
WARNING: dfx is deprecated, use icp-cli https://cli.internetcomputer.org. LLM skills can be found at https://skills.internetcomputer.org/llms.txt
WARNING: dfx is deprecated, use icp-cli https://cli.internetcomputer.org. LLM skills can be found at https://skills.internetcomputer.org/llms.txt
WARNING: dfx is deprecated, use icp-cli https://cli.internetcomputer.org. LLM skills can be found at https://skills.internetcomputer.org/llms.txt
2026-08-13 13:58:51.326787671 UTC: [Canister kpqmh-a7777-77777-aaaea-cai] Generating test data for all types...
2026-08-13 13:58:51.326787671 UTC: [Canister kpqmh-a7777-77777-aaaea-cai] Generated test data for all types
WARNING: dfx is deprecated, use icp-cli https://cli.internetcomputer.org. LLM skills can be found at https://skills.internetcomputer.org/llms.txt

<details>

<summary>bench/serde.bench.mo $({\color{green}-404226.10\%})$</summary>

### Benchmarking Serde

_Benchmarking the performance with 1k calls_


Instructions: ${\color{red}+44.10\\%}$
Heap: ${\color{green}-404285.47\\%}$
Stable Memory: ${\color{gray}0\\%}$
Garbage Collection: ${\color{red}+15.27\\%}$


**Instructions**

|                                     |                                decode() |                                 encode() |
| :---------------------------------- | --------------------------------------: | ---------------------------------------: |
| Serde: One Shot                     | 813_407_208 $({\color{red}+106.21\\%})$ | 1_639_765_323 $({\color{red}+48.35\\%})$ |
| Serde: One Shot sans type inference |  374_591_632 $({\color{red}+66.05\\%})$ | 1_155_262_464 $({\color{red}+29.56\\%})$ |
| Motoko (to_candid(), from_candid()) |   34_602_178 $({\color{red}+10.50\\%})$ |      9_693_320 $({\color{red}+6.97\\%})$ |
| Serde: Single Type Serializer       |  156_768_091 $({\color{red}+40.03\\%})$ |   322_977_708 $({\color{red}+45.11\\%})$ |


**Heap**

|                                     |                                     decode() |                                  encode() |
| :---------------------------------- | -------------------------------------------: | ----------------------------------------: |
| Serde: One Shot                     |        10.51 MiB $({\color{red}+597.61\\%})$ |  4.83 MiB $({\color{red}+1645603.90\\%})$ |
| Serde: One Shot sans type inference |  -8.34 MiB $({\color{green}-3214500.00\\%})$ |  7.39 MiB $({\color{red}+2849197.06\\%})$ |
| Motoko (to_candid(), from_candid()) |    644.72 KiB $({\color{red}+242619.12\\%})$ | 602.96 KiB $({\color{red}+226895.59\\%})$ |
| Serde: Single Type Serializer       | -21.96 MiB $({\color{green}-8467697.06\\%})$ |  9.04 MiB $({\color{red}+3483000.00\\%})$ |


**Garbage Collection**

|                                     |                              decode() |                              encode() |
| :---------------------------------- | ------------------------------------: | ------------------------------------: |
| Serde: One Shot                     |  28.78 MiB $({\color{red}+16.81\\%})$ |  59.8 MiB $({\color{green}-4.37\\%})$ |
| Serde: One Shot sans type inference |  29.84 MiB $({\color{red}+70.00\\%})$ | 27.8 MiB $({\color{green}-18.12\\%})$ |
| Motoko (to_candid(), from_candid()) |     0 B $({\color{green}-100.00\\%})$ |     0 B $({\color{green}-100.00\\%})$ |
| Serde: Single Type Serializer       | 29.84 MiB $({\color{red}+357.86\\%})$ |     0 B $({\color{green}-100.00\\%})$ |


</details>
Saving results to .bench/serde.bench.json

<details>

<summary>bench/types.bench.mo $({\color{red}+4765.21\%})$</summary>

### Benchmarking Serde by Data Types

_Performance comparison across all supported Candid data types with 1k operations_


Instructions: ${\color{red}+15570.94\\%}$
Heap: ${\color{green}-10805.73\\%}$
Stable Memory: ${\color{gray}0\\%}$
Garbage Collection: ${\color{gray}0\\%}$


**Instructions**

|                  |                                    encode() |                    encode(sans inference) |                                  decode() |                    decode(sans inference) |
| :--------------- | ------------------------------------------: | ----------------------------------------: | ----------------------------------------: | ----------------------------------------: |
| Nat              |    20_255_760 $({\color{red}+27765.18\\%})$ |   9_499_294 $({\color{red}+14628.27\\%})$ |   2_590_894 $({\color{red}+17563.58\\%})$ |    2_531_990 $({\color{red}+8377.83\\%})$ |
| Nat8             |    12_293_065 $({\color{red}+16944.82\\%})$ |   8_434_081 $({\color{red}+13031.88\\%})$ |   2_479_972 $({\color{red}+17056.50\\%})$ |    2_420_697 $({\color{red}+7977.07\\%})$ |
| Nat16            |    12_835_633 $({\color{red}+17416.83\\%})$ |   8_972_172 $({\color{red}+13561.06\\%})$ |   2_525_740 $({\color{red}+16347.90\\%})$ |    2_465_787 $({\color{red}+7806.20\\%})$ |
| Nat32            |    13_585_033 $({\color{red}+18000.59\\%})$ |   9_716_787 $({\color{red}+14241.70\\%})$ |   2_644_705 $({\color{red}+15790.79\\%})$ |    2_584_074 $({\color{red}+7780.20\\%})$ |
| Nat64            |    14_883_086 $({\color{red}+19027.23\\%})$ |  11_008_375 $({\color{red}+15446.80\\%})$ |   2_830_930 $({\color{red}+15031.38\\%})$ |    2_769_621 $({\color{red}+7773.83\\%})$ |
| Int              |    13_635_101 $({\color{red}+18005.54\\%})$ |   9_785_741 $({\color{red}+14137.12\\%})$ |   2_638_810 $({\color{red}+15170.01\\%})$ |    2_576_823 $({\color{red}+7464.65\\%})$ |
| Int8             |    12_302_840 $({\color{red}+16396.83\\%})$ |   8_449_001 $({\color{red}+12270.24\\%})$ |   2_497_124 $({\color{red}+14649.70\\%})$ |    2_434_459 $({\color{red}+7053.86\\%})$ |
| Int16            |    12_845_408 $({\color{red}+16861.89\\%})$ |   8_987_092 $({\color{red}+12784.35\\%})$ |   2_542_892 $({\color{red}+14161.07\\%})$ |    2_479_549 $({\color{red}+6934.58\\%})$ |
| Int32            |    13_607_941 $({\color{red}+17460.45\\%})$ |   9_744_979 $({\color{red}+13470.32\\%})$ |   2_665_857 $({\color{red}+13840.58\\%})$ |    2_601_836 $({\color{red}+6959.27\\%})$ |
| Int64            |    14_906_534 $({\color{red}+18480.68\\%})$ |  11_039_262 $({\color{red}+14649.89\\%})$ |   2_853_618 $({\color{red}+13368.09\\%})$ |    2_788_919 $({\color{red}+7007.52\\%})$ |
| Float            |    19_051_793 $({\color{red}+18453.99\\%})$ |  15_164_443 $({\color{red}+15450.09\\%})$ |   8_013_077 $({\color{red}+16311.50\\%})$ |   7_947_700 $({\color{red}+11727.99\\%})$ |
| Bool             |    12_354_629 $({\color{red}+15912.12\\%})$ |   8_468_000 $({\color{red}+11609.07\\%})$ |   2_504_243 $({\color{red}+12885.44\\%})$ |    2_450_188 $({\color{red}+6342.78\\%})$ |
| Text             |    15_509_719 $({\color{red}+18850.81\\%})$ |  11_613_650 $({\color{red}+14928.40\\%})$ |   3_144_810 $({\color{red}+13393.56\\%})$ |    3_079_077 $({\color{red}+7176.91\\%})$ |
| Null             |    11_741_426 $({\color{red}+15145.44\\%})$ |   7_777_215 $({\color{red}+10558.39\\%})$ |  14_122_110 $({\color{red}+15893.33\\%})$ |  10_049_699 $({\color{red}+11907.10\\%})$ |
| Empty            |    11_749_410 $({\color{red}+15074.23\\%})$ |   7_780_721 $({\color{red}+10460.15\\%})$ |  14_147_294 $({\color{red}+15831.64\\%})$ |  10_055_573 $({\color{red}+11811.22\\%})$ |
| Principal        |    21_496_178 $({\color{red}+21672.69\\%})$ |  17_593_038 $({\color{red}+18401.46\\%})$ |   4_304_462 $({\color{red}+12664.55\\%})$ |    4_238_695 $({\color{red}+7794.76\\%})$ |
| Blob             |    44_694_185 $({\color{red}+18239.54\\%})$ |  34_784_566 $({\color{red}+16439.82\\%})$ |  11_170_972 $({\color{red}+11244.31\\%})$ |    9_888_727 $({\color{red}+8371.60\\%})$ |
| Option(Nat)      |    20_322_818 $({\color{red}+17418.76\\%})$ |  11_440_154 $({\color{red}+12756.71\\%})$ |   4_005_157 $({\color{red}+14777.45\\%})$ |    2_724_234 $({\color{red}+5885.35\\%})$ |
| Option(Text)     |    21_385_986 $({\color{red}+17684.46\\%})$ |  12_509_682 $({\color{red}+13305.86\\%})$ |   4_269_463 $({\color{red}+13925.37\\%})$ |    2_977_862 $({\color{red}+5940.04\\%})$ |
| Array(Nat8)      |    35_652_434 $({\color{red}+26024.74\\%})$ |  14_758_187 $({\color{red}+15943.60\\%})$ |   5_046_962 $({\color{red}+16964.96\\%})$ |    3_765_851 $({\color{red}+7617.38\\%})$ |
| Array(Text)      |    53_143_726 $({\color{red}+28299.97\\%})$ |  31_924_301 $({\color{red}+24865.83\\%})$ |  10_165_474 $({\color{red}+17447.25\\%})$ |   8_874_517 $({\color{red}+11361.93\\%})$ |
| Array(Record)    |    60_055_134 $({\color{red}+20048.06\\%})$ |  36_741_925 $({\color{red}+17884.74\\%})$ |  20_419_221 $({\color{red}+27540.61\\%})$ |   9_910_224 $({\color{red}+11395.45\\%})$ |
| Record(Simple)   |            43_094_213 (no previous results) |          27_449_150 (no previous results) |          16_681_882 (no previous results) |           9_449_569 (no previous results) |
| Record(Nested)   |   146_433_538 $({\color{red}+19139.98\\%})$ | 107_103_913 $({\color{red}+20153.07\\%})$ |  95_524_429 $({\color{red}+30759.83\\%})$ |  19_764_590 $({\color{red}+13208.14\\%})$ |
| Tuple(Mixed)     |            50_284_173 (no previous results) |          41_152_169 (no previous results) |          20_869_375 (no previous results) |           9_557_706 (no previous results) |
| Variant(Simple)  |    29_826_180 $({\color{red}+19792.08\\%})$ |  22_997_704 $({\color{red}+16202.91\\%})$ |  30_472_018 $({\color{red}+47806.71\\%})$ |    4_703_871 $({\color{red}+8599.92\\%})$ |
| Variant(Complex) |    97_029_865 $({\color{red}+10008.10\\%})$ | 142_933_417 $({\color{red}+17572.43\\%})$ | 157_214_739 $({\color{red}+37592.88\\%})$ |  13_884_727 $({\color{red}+11094.29\\%})$ |
| Large Text       |   796_614_784 $({\color{red}+13566.22\\%})$ | 792_724_036 $({\color{red}+13498.10\\%})$ |  168_997_601 $({\color{red}+8760.58\\%})$ |  168_937_182 $({\color{red}+8646.62\\%})$ |
| Large Array      | 1_389_023_119 $({\color{red}+22889.94\\%})$ | 587_564_634 $({\color{red}+21376.02\\%})$ | 172_711_365 $({\color{red}+14040.04\\%})$ | 171_434_468 $({\color{red}+13682.21\\%})$ |
| Deep Nesting     |   114_948_649 $({\color{red}+18222.01\\%})$ |  74_870_971 $({\color{red}+17166.29\\%})$ |  42_248_953 $({\color{red}+33675.92\\%})$ |  15_224_016 $({\color{red}+12395.29\\%})$ |
| Wide Record      |   170_391_572 $({\color{red}+19941.26\\%})$ | 114_805_590 $({\color{red}+22537.31\\%})$ | 111_117_964 $({\color{red}+32890.70\\%})$ |  55_342_311 $({\color{red}+16672.58\\%})$ |


**Heap**

|                  |                                      encode() |                    encode(sans inference) |                                  decode() |                    decode(sans inference) |
| :--------------- | --------------------------------------------: | ----------------------------------------: | ----------------------------------------: | ----------------------------------------: |
| Nat              | -239.73 MiB $({\color{green}-1244262.36\\%})$ |   659.07 KiB $({\color{red}+3804.72\\%})$ |   269.21 KiB $({\color{red}+2502.61\\%})$ |   258.27 KiB $({\color{red}+2410.14\\%})$ |
| Nat8             |       977.02 KiB $({\color{red}+4854.77\\%})$ |   634.98 KiB $({\color{red}+3664.59\\%})$ |   269.21 KiB $({\color{red}+2512.47\\%})$ |   258.27 KiB $({\color{red}+2419.70\\%})$ |
| Nat16            |       992.64 KiB $({\color{red}+4932.02\\%})$ |   650.61 KiB $({\color{red}+3755.44\\%})$ |   269.21 KiB $({\color{red}+2507.53\\%})$ |   258.27 KiB $({\color{red}+2414.91\\%})$ |
| Nat32            |      1007.49 KiB $({\color{red}+5005.25\\%})$ |   665.45 KiB $({\color{red}+3841.58\\%})$ |   270.29 KiB $({\color{red}+2508.10\\%})$ |   259.35 KiB $({\color{red}+2415.84\\%})$ |
| Nat64            |         1.01 MiB $({\color{red}+5122.80\\%})$ | -9.29 MiB $({\color{green}-56396.72\\%})$ |   270.64 KiB $({\color{red}+2488.16\\%})$ |   259.71 KiB $({\color{red}+2396.62\\%})$ |
| Int              |      1015.41 KiB $({\color{red}+5046.41\\%})$ |   673.37 KiB $({\color{red}+3889.42\\%})$ |   269.21 KiB $({\color{red}+2502.61\\%})$ |   258.27 KiB $({\color{red}+2410.14\\%})$ |
| Int8             |       977.02 KiB $({\color{red}+4854.77\\%})$ |   634.98 KiB $({\color{red}+3664.59\\%})$ |   269.21 KiB $({\color{red}+2512.47\\%})$ |   258.27 KiB $({\color{red}+2419.70\\%})$ |
| Int16            |       992.64 KiB $({\color{red}+4932.02\\%})$ |   650.61 KiB $({\color{red}+3755.44\\%})$ |   269.21 KiB $({\color{red}+2507.53\\%})$ |   258.27 KiB $({\color{red}+2414.91\\%})$ |
| Int32            |     -6.92 MiB $({\color{green}-36032.11\\%})$ |   666.53 KiB $({\color{red}+3847.96\\%})$ |   270.29 KiB $({\color{red}+2508.10\\%})$ |   259.35 KiB $({\color{red}+2415.84\\%})$ |
| Int64            |         1.01 MiB $({\color{red}+5130.08\\%})$ |   691.11 KiB $({\color{red}+3988.81\\%})$ |   270.64 KiB $({\color{red}+2488.16\\%})$ |   259.71 KiB $({\color{red}+2396.62\\%})$ |
| Float            |         1.14 MiB $({\color{red}+5596.87\\%})$ |   822.48 KiB $({\color{red}+4575.88\\%})$ |   432.49 KiB $({\color{red}+3775.29\\%})$ |   421.55 KiB $({\color{red}+3695.88\\%})$ |
| Bool             |       977.02 KiB $({\color{red}+4854.77\\%})$ |   634.98 KiB $({\color{red}+3664.59\\%})$ |   269.21 KiB $({\color{red}+2512.47\\%})$ |   258.27 KiB $({\color{red}+2419.70\\%})$ |
| Text             |     -8.91 MiB $({\color{green}-46235.32\\%})$ |   692.59 KiB $({\color{red}+3990.01\\%})$ |   289.96 KiB $({\color{red}+2656.44\\%})$ |   279.03 KiB $({\color{red}+2566.33\\%})$ |
| Null             |       960.61 KiB $({\color{red}+4780.27\\%})$ |   616.08 KiB $({\color{red}+3560.18\\%})$ |     1.19 MiB $({\color{red}+5947.70\\%})$ |   855.14 KiB $({\color{red}+4876.52\\%})$ |
| Empty            |       960.61 KiB $({\color{red}+4780.27\\%})$ |   616.08 KiB $({\color{red}+3560.18\\%})$ |     1.19 MiB $({\color{red}+5947.70\\%})$ | -7.05 MiB $({\color{green}-42121.12\\%})$ |
| Principal        |         1.09 MiB $({\color{red}+5451.12\\%})$ |   770.14 KiB $({\color{red}+4381.81\\%})$ |    315.3 KiB $({\color{red}+2734.16\\%})$ |   304.36 KiB $({\color{red}+2649.36\\%})$ |
| Blob             |         2.23 MiB $({\color{red}+8007.94\\%})$ |     1.42 MiB $({\color{red}+6487.54\\%})$ |   830.33 KiB $({\color{red}+5111.18\\%})$ |   699.08 KiB $({\color{red}+4361.83\\%})$ |
| Option(Nat)      |         1.41 MiB $({\color{red}+6268.05\\%})$ |  -9.2 MiB $({\color{green}-54551.69\\%})$ |   400.86 KiB $({\color{red}+3659.01\\%})$ |   269.61 KiB $({\color{red}+2492.82\\%})$ |
| Option(Text)     |         1.43 MiB $({\color{red}+6327.66\\%})$ |   735.74 KiB $({\color{red}+4139.23\\%})$ |   410.61 KiB $({\color{red}+3687.96\\%})$ |   279.36 KiB $({\color{red}+2541.89\\%})$ |
| Array(Nat8)      |         2.07 MiB $({\color{red}+8585.24\\%})$ |   822.54 KiB $({\color{red}+4627.66\\%})$ |   471.68 KiB $({\color{red}+4262.32\\%})$ | -7.51 MiB $({\color{green}-73038.93\\%})$ |
| Array(Text)      |         2.27 MiB $({\color{red}+8995.57\\%})$ |        1 MiB $({\color{red}+5596.06\\%})$ |   632.62 KiB $({\color{red}+4951.50\\%})$ |   501.37 KiB $({\color{red}+3990.22\\%})$ |
| Array(Record)    |         3.15 MiB $({\color{red}+9789.26\\%})$ |      1.5 MiB $({\color{red}+7222.68\\%})$ | -8.62 MiB $({\color{green}-64451.81\\%})$ |   748.56 KiB $({\color{red}+5630.59\\%})$ |
| Record(Simple)   |                2.18 MiB (no previous results) |            1.12 MiB (no previous results) |            1.12 MiB (no previous results) |          717.31 KiB (no previous results) |
| Record(Nested)   |      -1.44 MiB $({\color{green}-2862.95\\%})$ |    3.56 MiB $({\color{red}+11499.32\\%})$ | -5.88 MiB $({\color{green}-25824.52\\%})$ |     1.28 MiB $({\color{red}+7612.67\\%})$ |
| Tuple(Mixed)     |                2.53 MiB (no previous results) |           -5.95 MiB (no previous results) |            1.25 MiB (no previous results) |          615.55 KiB (no previous results) |
| Variant(Simple)  |         1.85 MiB $({\color{red}+7675.32\\%})$ |   998.98 KiB $({\color{red}+5323.97\\%})$ |    1.44 MiB $({\color{red}+12008.00\\%})$ |   380.64 KiB $({\color{red}+3525.11\\%})$ |
| Variant(Complex) |      -5.14 MiB $({\color{green}-8361.22\\%})$ |    5.14 MiB $({\color{red}+12576.03\\%})$ |  -1.84 MiB $({\color{green}-7203.50\\%})$ |   924.45 KiB $({\color{red}+6062.99\\%})$ |
| Large Text       |      -2.04 MiB $({\color{green}-1562.31\\%})$ | -334.47 KiB $({\color{green}-338.38\\%})$ |     3.77 MiB $({\color{red}+2763.13\\%})$ |  -5.42 MiB $({\color{green}-4216.68\\%})$ |
| Large Array      |         5.19 MiB $({\color{red}+2273.48\\%})$ |     1.63 MiB $({\color{red}+1745.30\\%})$ |      5.5 MiB $({\color{red}+6552.52\\%})$ |   -3.4 MiB $({\color{green}-4227.35\\%})$ |
| Deep Nesting     |    -494.11 KiB $({\color{green}-1029.40\\%})$ |     3.1 MiB $({\color{red}+10793.67\\%})$ |    2.22 MiB $({\color{red}+13602.80\\%})$ |     1.12 MiB $({\color{red}+7556.53\\%})$ |
| Wide Record      |      -3.11 MiB $({\color{green}-7234.39\\%})$ | -3.88 MiB $({\color{green}-15186.13\\%})$ |    5.99 MiB $({\color{red}+20562.33\\%})$ | -5.31 MiB $({\color{green}-19417.85\\%})$ |


**Garbage Collection**

|                  |                                 encode() |                 encode(sans inference) |                               decode() |                 decode(sans inference) |
| :--------------- | ---------------------------------------: | -------------------------------------: | -------------------------------------: | -------------------------------------: |
| Nat              | 233.62 MiB $({\color{red}+Infinity\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Nat8             |               0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Nat16            |               0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Nat32            |               0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Nat64            |               0 B $({\color{gray}0\\%})$ | 9.96 MiB $({\color{red}+Infinity\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Int              |               0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Int8             |               0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Int16            |               0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Int32            |   7.91 MiB $({\color{red}+Infinity\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Int64            |               0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Float            |               0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Bool             |               0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Text             |   9.92 MiB $({\color{red}+Infinity\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Null             |               0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Empty            |               0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ | 7.88 MiB $({\color{red}+Infinity\\%})$ |
| Principal        |               0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Blob             |               0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Option(Nat)      |               0 B $({\color{gray}0\\%})$ | 9.89 MiB $({\color{red}+Infinity\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Option(Text)     |               0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Array(Nat8)      |               0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ | 7.84 MiB $({\color{red}+Infinity\\%})$ |
| Array(Text)      |               0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Array(Record)    |               0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ | 9.85 MiB $({\color{red}+Infinity\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Record(Simple)   |                0 B (no previous results) |              0 B (no previous results) |              0 B (no previous results) |              0 B (no previous results) |
| Record(Nested)   |   7.81 MiB $({\color{red}+Infinity\\%})$ |             0 B $({\color{gray}0\\%})$ | 9.82 MiB $({\color{red}+Infinity\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Tuple(Mixed)     |                0 B (no previous results) |         7.78 MiB (no previous results) |              0 B (no previous results) |              0 B (no previous results) |
| Variant(Simple)  |               0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Variant(Complex) |    9.8 MiB $({\color{red}+Infinity\\%})$ |             0 B $({\color{gray}0\\%})$ | 7.74 MiB $({\color{red}+Infinity\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Large Text       |   9.51 MiB $({\color{red}+Infinity\\%})$ | 7.45 MiB $({\color{red}+Infinity\\%})$ |             0 B $({\color{gray}0\\%})$ | 9.18 MiB $({\color{red}+Infinity\\%})$ |
| Large Array      |  38.79 MiB $({\color{red}+Infinity\\%})$ | 9.11 MiB $({\color{red}+Infinity\\%})$ |             0 B $({\color{gray}0\\%})$ | 8.77 MiB $({\color{red}+Infinity\\%})$ |
| Deep Nesting     |   6.72 MiB $({\color{red}+Infinity\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |             0 B $({\color{gray}0\\%})$ |
| Wide Record      |   8.75 MiB $({\color{red}+Infinity\\%})$ | 6.69 MiB $({\color{red}+Infinity\\%})$ |             0 B $({\color{gray}0\\%})$ | 8.71 MiB $({\color{red}+Infinity\\%})$ |


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
| Nat8       |     3_245_276 |    10_305_424 |
| Nat16      |     4_876_107 |    12_016_255 |
| Nat32      |     5_378_717 |    17_395_168 |
| Nat64      |     6_047_723 |    26_247_871 |
| Int8       |     3_318_232 |    10_308_380 |
| Int16      |     4_879_063 |    12_019_211 |
| Int32      |     6_258_171 |    18_275_689 |
| Int64      |     7_620_679 |    27_800_827 |
| Float      |   369_901_373 |   290_021_359 |
| LEB128_64  |   190_550_257 |   204_398_923 |
| SLEB128_64 |   272_965_604 |   209_873_902 |


**Heap**

|            | Type to Bytes | Bytes to Type |
| :--------- | ------------: | ------------: |
| Nat8       |    166.13 KiB |    791.13 KiB |
| Nat16      |    400.51 KiB |    791.13 KiB |
| Nat32      |    556.76 KiB |       850 KiB |
| Nat64      |    869.26 KiB |    947.38 KiB |
| Int8       |    166.13 KiB |    791.13 KiB |
| Int16      |    400.51 KiB |    791.13 KiB |
| Int32      |    615.73 KiB |    908.81 KiB |
| Int64      |         1 MiB |      1.08 MiB |
| Float      |    -13.97 MiB |      8.75 MiB |
| LEB128_64  |      6.74 MiB |    -18.47 MiB |
| SLEB128_64 |     11.46 MiB |      6.55 MiB |


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
| Int64      |           0 B |           0 B |
| Float      |     26.76 MiB |           0 B |
| LEB128_64  |           0 B |     24.74 MiB |
| SLEB128_64 |           0 B |           0 B |


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
| Nat8       |     3_245_276 |    10_305_424 |
| Nat16      |     4_876_107 |    12_016_255 |
| Nat32      |     5_378_717 |    17_395_168 |
| Nat64      |     6_047_723 |    26_247_871 |
| Int8       |     3_318_232 |    10_308_380 |
| Int16      |     4_879_063 |    12_019_211 |
| Int32      |     6_258_171 |    18_275_689 |
| Int64      |     7_620_679 |    27_800_827 |
| Float      |   363_501_373 |   283_621_359 |
| LEB128_64  |   190_550_257 |   204_398_923 |
| SLEB128_64 |   272_965_604 |   209_873_902 |


**Heap**

|            | Type to Bytes | Bytes to Type |
| :--------- | ------------: | ------------: |
| Nat8       |    166.13 KiB |    791.13 KiB |
| Nat16      |    400.51 KiB |    791.13 KiB |
| Nat32      |    556.76 KiB |       850 KiB |
| Nat64      |    869.26 KiB |    947.38 KiB |
| Int8       |    166.13 KiB |    791.13 KiB |
| Int16      |    400.51 KiB |    791.13 KiB |
| Int32      |    615.73 KiB |    908.81 KiB |
| Int64      |         1 MiB |      1.08 MiB |
| Float      |    -13.97 MiB |      8.75 MiB |
| LEB128_64  |      6.74 MiB |    -18.47 MiB |
| SLEB128_64 |     11.46 MiB |      6.55 MiB |


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
| Int64      |           0 B |           0 B |
| Float      |     26.76 MiB |           0 B |
| LEB128_64  |           0 B |     24.74 MiB |
| SLEB128_64 |           0 B |           0 B |


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
| Nat8  |     3_245_264 |    10_235_412 |
| Nat16 |     4_876_095 |    11_956_243 |
| Nat32 |     5_375_203 |    17_316_651 |
| Nat64 |     6_047_711 |    26_177_859 |
| Int8  |     3_338_220 |    10_238_368 |
| Int16 |     4_899_051 |    11_959_199 |
| Int32 |     5_399_791 |    17_410_677 |
| Int64 |     6_070_667 |    26_240_815 |
| Float |   381_219_689 |   319_261_209 |


**Heap**

|       | Type to Bytes | Bytes to Type |
| :---- | ------------: | ------------: |
| Nat8  |    166.13 KiB |    791.13 KiB |
| Nat16 |    400.51 KiB |    791.13 KiB |
| Nat32 |    556.76 KiB |    849.26 KiB |
| Nat64 |    869.26 KiB |    947.38 KiB |
| Int8  |    166.13 KiB |    791.13 KiB |
| Int16 |    400.51 KiB |    791.13 KiB |
| Int32 |    556.76 KiB |    850.22 KiB |
| Int64 |    869.26 KiB |    947.38 KiB |
| Float |    -14.79 MiB |     10.16 MiB |


**Garbage Collection**

|       | Type to Bytes | Bytes to Type |
| :---- | ------------: | ------------: |
| Nat8  |           0 B |           0 B |
| Nat16 |           0 B |           0 B |
| Nat32 |           0 B |           0 B |
| Nat64 |           0 B |           0 B |
| Int8  |           0 B |           0 B |
| Int16 |           0 B |           0 B |
| Int32 |           0 B |           0 B |
| Int64 |           0 B |           0 B |
| Float |     28.19 MiB |           0 B |


</details>
Saving results to .bench/Sorted.bench.json
