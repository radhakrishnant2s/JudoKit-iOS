//
//  Constants.h
//  JudoKitObjC
//
//  Copyright (c) 2019 Alternative Payments Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#ifndef JPConstants_h
#define JPConstants_h

#import <Foundation/Foundation.h>

/* Patterns */
static NSString *kVISAPattern = @"XXXX XXXX XXXX XXXX";
static NSString *kAMEXPattern = @"XXXX XXXXXX XXXXX";
static NSString *kDinersClubPattern = @"XXXX XXXXXX XXXX";

static NSString *kVisaPrefixes = @"4";
static NSString *kUATPPrefixes = @"1";
static NSString *kDankortPrefixes = @"5019";
static NSString *kInterPaymentPrefixes = @"636";
static NSString *kChinaUnionPayPrefixes = @"62";
static NSString *kAMEXPrefixes = @"34,37";

static NSString *kMaestroPrefixes = @"5018,5020,5038,5893,6304,6759,6761,6762,6763";
static NSString *kDinersClubPrefixes = @"36,38,39,309,300,301,302,303,304,305";
static NSString *kInstaPaymentPrefixes = @"637,638,639";

static NSString *kJCBPrefixes = @"3528,3529,3530,3531,3532,3533,3534,3535,3536,3537,3538,3539,3540,3541,3542,3543,3544,3545,3546,3547,3548,3549,3550,3551,3552,3553,3554,3555,3556,3557,3558,3559,3560,3561,3562,3563,3564,3565,3566,3567,3568,3569,3570,3571,3572,3573,3574,3575,3576,3577,3578,3579,3580,3581,3582,3583,3584,3585,3586,3587,3588,3589";

static NSString *kMasterCardPrefixes = @"51,52,53,54,55,2221,2222,2223,2224,2225,2226,2227,2228,2229,2230,2231,2232,2233,2234,2235,2236,2237,2238,2239,2240,2241,2242,2243,2244,2245,2246,2247,2248,2249,2250,2251,2252,2253,2254,2255,2256,2257,2258,2259,2260,2261,2262,2263,2264,2265,2266,2267,2268,2269,2270,2271,2272,2273,2274,2275,2276,2277,2278,2279,2280,2281,2282,2283,2284,2285,2286,2287,2288,2289,2290,2291,2292,2293,2294,2295,2296,2297,2298,2299,2300,2301,2302,2303,2304,2305,2306,2307,2308,2309,2310,2311,2312,2313,2314,2315,2316,2317,2318,2319,2320,2321,2322,2323,2324,2325,2326,2327,2328,2329,2330,2331,2332,2333,2334,2335,2336,2337,2338,2339,2340,2341,2342,2343,2344,2345,2346,2347,2348,2349,2350,2351,2352,2353,2354,2355,2356,2357,2358,2359,2360,2361,2362,2363,2364,2365,2366,2367,2368,2369,2370,2371,2372,2373,2374,2375,2376,2377,2378,2379,2380,2381,2382,2383,2384,2385,2386,2387,2388,2389,2390,2391,2392,2393,2394,2395,2396,2397,2398,2399,2400,2401,2402,2403,2404,2405,2406,2407,2408,2409,2410,2411,2412,2413,2414,2415,2416,2417,2418,2419,2420,2421,2422,2423,2424,2425,2426,2427,2428,2429,2430,2431,2432,2433,2434,2435,2436,2437,2438,2439,2440,2441,2442,2443,2444,2445,2446,2447,2448,2449,2450,2451,2452,2453,2454,2455,2456,2457,2458,2459,2460,2461,2462,2463,2464,2465,2466,2467,2468,2469,2470,2471,2472,2473,2474,2475,2476,2477,2478,2479,2480,2481,2482,2483,2484,2485,2486,2487,2488,2489,2490,2491,2492,2493,2494,2495,2496,2497,2498,2499,2500,2501,2502,2503,2504,2505,2506,2507,2508,2509,2510,2511,2512,2513,2514,2515,2516,2517,2518,2519,2520,2521,2522,2523,2524,2525,2526,2527,2528,2529,2530,2531,2532,2533,2534,2535,2536,2537,2538,2539,2540,2541,2542,2543,2544,2545,2546,2547,2548,2549,2550,2551,2552,2553,2554,2555,2556,2557,2558,2559,2560,2561,2562,2563,2564,2565,2566,2567,2568,2569,2570,2571,2572,2573,2574,2575,2576,2577,2578,2579,2580,2581,2582,2583,2584,2585,2586,2587,2588,2589,2590,2591,2592,2593,2594,2595,2596,2597,2598,2599,2600,2601,2602,2603,2604,2605,2606,2607,2608,2609,2610,2611,2612,2613,2614,2615,2616,2617,2618,2619,2620,2621,2622,2623,2624,2625,2626,2627,2628,2629,2630,2631,2632,2633,2634,2635,2636,2637,2638,2639,2640,2641,2642,2643,2644,2645,2646,2647,2648,2649,2650,2651,2652,2653,2654,2655,2656,2657,2658,2659,2660,2661,2662,2663,2664,2665,2666,2667,2668,2669,2670,2671,2672,2673,2674,2675,2676,2677,2678,2679,2680,2681,2682,2683,2684,2685,2686,2687,2688,2689,2690,2691,2692,2693,2694,2695,2696,2697,2698,2699,2700,2701,2702,2703,2704,2705,2706,2707,2708,2709,2710,2711,2712,2713,2714,2715,2716,2717,2718,2719,2720";

static NSString *kDiscoverPrefixes = @"65,6011,644,645,646,647,648,649,622126,622127,622128,622129,622130,622131,622132,622133,622134,622135,622136,622137,622138,622139,622140,622141,622142,622143,622144,622145,622146,622147,622148,622149,622150,622151,622152,622153,622154,622155,622156,622157,622158,622159,622160,622161,622162,622163,622164,622165,622166,622167,622168,622169,622170,622171,622172,622173,622174,622175,622176,622177,622178,622179,622180,622181,622182,622183,622184,622185,622186,622187,622188,622189,622190,622191,622192,622193,622194,622195,622196,622197,622198,622199,622200,622201,622202,622203,622204,622205,622206,622207,622208,622209,622210,622211,622212,622213,622214,622215,622216,622217,622218,622219,622220,622221,622222,622223,622224,622225,622226,622227,622228,622229,622230,622231,622232,622233,622234,622235,622236,622237,622238,622239,622240,622241,622242,622243,622244,622245,622246,622247,622248,622249,622250,622251,622252,622253,622254,622255,622256,622257,622258,622259,622260,622261,622262,622263,622264,622265,622266,622267,622268,622269,622270,622271,622272,622273,622274,622275,622276,622277,622278,622279,622280,622281,622282,622283,622284,622285,622286,622287,622288,622289,622290,622291,622292,622293,622294,622295,622296,622297,622298,622299,622300,622301,622302,622303,622304,622305,622306,622307,622308,622309,622310,622311,622312,622313,622314,622315,622316,622317,622318,622319,622320,622321,622322,622323,622324,622325,622326,622327,622328,622329,622330,622331,622332,622333,622334,622335,622336,622337,622338,622339,622340,622341,622342,622343,622344,622345,622346,622347,622348,622349,622350,622351,622352,622353,622354,622355,622356,622357,622358,622359,622360,622361,622362,622363,622364,622365,622366,622367,622368,622369,622370,622371,622372,622373,622374,622375,622376,622377,622378,622379,622380,622381,622382,622383,622384,622385,622386,622387,622388,622389,622390,622391,622392,622393,622394,622395,622396,622397,622398,622399,622400,622401,622402,622403,622404,622405,622406,622407,622408,622409,622410,622411,622412,622413,622414,622415,622416,622417,622418,622419,622420,622421,622422,622423,622424,622425,622426,622427,622428,622429,622430,622431,622432,622433,622434,622435,622436,622437,622438,622439,622440,622441,622442,622443,622444,622445,622446,622447,622448,622449,622450,622451,622452,622453,622454,622455,622456,622457,622458,622459,622460,622461,622462,622463,622464,622465,622466,622467,622468,622469,622470,622471,622472,622473,622474,622475,622476,622477,622478,622479,622480,622481,622482,622483,622484,622485,622486,622487,622488,622489,622490,622491,622492,622493,622494,622495,622496,622497,622498,622499,622500,622501,622502,622503,622504,622505,622506,622507,622508,622509,622510,622511,622512,622513,622514,622515,622516,622517,622518,622519,622520,622521,622522,622523,622524,622525,622526,622527,622528,622529,622530,622531,622532,622533,622534,622535,622536,622537,622538,622539,622540,622541,622542,622543,622544,622545,622546,622547,622548,622549,622550,622551,622552,622553,622554,622555,622556,622557,622558,622559,622560,622561,622562,622563,622564,622565,622566,622567,622568,622569,622570,622571,622572,622573,622574,622575,622576,622577,622578,622579,622580,622581,622582,622583,622584,622585,622586,622587,622588,622589,622590,622591,622592,622593,622594,622595,622596,622597,622598,622599,622600,622601,622602,622603,622604,622605,622606,622607,622608,622609,622610,622611,622612,622613,622614,622615,622616,622617,622618,622619,622620,622621,622622,622623,622624,622625,622626,622627,622628,622629,622630,622631,622632,622633,622634,622635,622636,622637,622638,622639,622640,622641,622642,622643,622644,622645,622646,622647,622648,622649,622650,622651,622652,622653,622654,622655,622656,622657,622658,622659,622660,622661,622662,622663,622664,622665,622666,622667,622668,622669,622670,622671,622672,622673,622674,622675,622676,622677,622678,622679,622680,622681,622682,622683,622684,622685,622686,622687,622688,622689,622690,622691,622692,622693,622694,622695,622696,622697,622698,622699,622700,622701,622702,622703,622704,622705,622706,622707,622708,622709,622710,622711,622712,622713,622714,622715,622716,622717,622718,622719,622720,622721,622722,622723,622724,622725,622726,622727,622728,622729,622730,622731,622732,622733,622734,622735,622736,622737,622738,622739,622740,622741,622742,622743,622744,622745,622746,622747,622748,622749,622750,622751,622752,622753,622754,622755,622756,622757,622758,622759,622760,622761,622762,622763,622764,622765,622766,622767,622768,622769,622770,622771,622772,622773,622774,622775,622776,622777,622778,622779,622780,622781,622782,622783,622784,622785,622786,622787,622788,622789,622790,622791,622792,622793,622794,622795,622796,622797,622798,622799,622800,622801,622802,622803,622804,622805,622806,622807,622808,622809,622810,622811,622812,622813,622814,622815,622816,622817,622818,622819,622820,622821,622822,622823,622824,622825,622826,622827,622828,622829,622830,622831,622832,622833,622834,622835,622836,622837,622838,622839,622840,622841,622842,622843,622844,622845,622846,622847,622848,622849,622850,622851,622852,622853,622854,622855,622856,622857,622858,622859,622860,622861,622862,622863,622864,622865,622866,622867,622868,622869,622870,622871,622872,622873,622874,622875,622876,622877,622878,622879,622880,622881,622882,622883,622884,622885,622886,622887,622888,622889,622890,622891,622892,622893,622894,622895,622896,622897,622898,622899,622900,622901,622902,622903,622904,622905,622906,622907,622908,622909,622910,622911,622912,622913,622914,622915,622916,622917,622918,622919,622920,622921,622922,622923,622924,622925";

static NSString *const kMonthYearDateFormat = @"MM/yy";
static NSString *const kCurrencyEuro = @"EUR";
static NSString *const kFailureReasonUserAbort = @"USER_ABORT";

static NSUInteger const kSecurityCodeLengthAmex = 4;
static NSUInteger const kSecurityCodeLengthDefault = 3;

static NSString *const kSecurityCodePlaceholderhAmex = @"CID";
static NSString *const kSecurityCodePlaceholderhVisa = @"CVV2";
static NSString *const kSecurityCodePlaceholderhMasterCard = @"CVC2";
static NSString *const kSecurityCodePlaceholderhChinaUnionPay = @"CVN2";
static NSString *const kSecurityCodePlaceholderhJCB = @"CAV2";
static NSString *const kSecurityCodePlaceholderDefault = @"CVV";

static int const kJPCountryNumericCodeUK = 826;
static int const kJPCountryNumericCodeUSA = 840;
static int const kJPCountryNumericCodeCanada = 124;

static NSString *const kJudoErrorDomain = @"com.judo.error";

static int const kMaximumLengthForConsumerReference = 40;

static int const kJPMaxAMEXCardLength = 15;
static int const kJPMaxDinersClubCardLength = 14;
static int const kJPMaxDefaultCardLength = 16;

#endif /* JPConstants_h */
