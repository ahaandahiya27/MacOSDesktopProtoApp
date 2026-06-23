# Solutions — Mathematics (Class 7), Chapter 11: Finding Common Ground — Paper 5

**Paper 5 — (progressively harder)**

Marking: **+4** correct, **−1** wrong, **0** unattempted. Maximum marks **240**.

<!--
Coverage matrix (Paper 5 — hardest tier):
- Prime-factorisation HCF/LCM, ratios, square/even/total factor counts, number-from-property ... Q1-Q12
- HCF*LCM = product, missing number, pair-counting via co-prime factorisations ......... Q13-Q22
- Tiling / cutting / grouping / measuring (HCF + unit conversion, count combinations) .. Q23-Q34
- Meeting again: bells, lights, tracks, gears, clocks (LCM, laps, include/exclude start) Q35-Q46
- Remainder problems (same r, same unknown r, add/subtract, mixed congruences) ........ Q47-Q56
- Co-prime logic, divisibility chains, common multiples in a range .................... Q57-Q60
-->

## Answer Key

| Q | Ans | Q | Ans | Q | Ans | Q | Ans | Q | Ans | Q | Ans |
|---|-----|---|-----|---|-----|---|-----|---|-----|---|-----|
| 1 | D | 11 | B | 21 | B | 31 | B | 41 | B | 51 | B |
| 2 | A | 12 | A | 22 | D | 32 | D | 42 | B | 52 | D |
| 3 | A | 13 | C | 23 | A | 33 | A | 43 | D | 53 | A |
| 4 | C | 14 | D | 24 | C | 34 | B | 44 | C | 54 | B |
| 5 | D | 15 | D | 25 | C | 35 | C | 45 | B | 55 | C |
| 6 | C | 16 | D | 26 | C | 36 | D | 46 | B | 56 | A |
| 7 | A | 17 | B | 27 | A | 37 | C | 47 | D | 57 | D |
| 8 | B | 18 | D | 28 | A | 38 | B | 48 | B | 58 | A |
| 9 | A | 19 | B | 29 | A | 39 | D | 49 | C | 59 | C |
| 10 | C | 20 | A | 30 | C | 40 | D | 50 | A | 60 | C |

Answer-key distribution: A = 15, B = 15, C = 15, D = 15.

---

## Worked Solutions

**1. (D)** The ratio LCM : HCF equals the product of each prime raised to the difference of its two exponents. For 2: 3 - 2 = 1; for 3: 3 - 1 = 2; for 5: 2 - 1 = 1; for 7: 1 - 0 = 1. So LCM/HCF = 2^1 x 3^2 x 5^1 x 7^1 = 2 x 9 x 5 x 7 = 630. The value 60 is the HCF itself, 37800 is the LCM itself, and 210 drops the square on the 3.

**2. (A)** 1800 = 2^3 x 3^2 x 5^2. A square factor uses only even exponents. For 2 the even choices are 0 or 2 (2 ways), for 3 they are 0 or 2 (2 ways), for 5 they are 0 or 2 (2 ways). That gives 2 x 2 x 2 = 8 square factors. Counting odd exponents too gives the full factor count, and miscounting the 2-prime as having three even options leads to 9.

**3. (A)** 7560 = 2^3 x 3^3 x 5 x 7. The number of factors is (3+1)(3+1)(1+1)(1+1) = 4 x 4 x 2 x 2 = 64. Forgetting the +1 on one prime, or multiplying exponents instead of (exponent+1), produces the smaller wrong totals.

**4. (C)** 1800 = 2^3 x 3^2 x 5^2 has (3+1)(2+1)(2+1) = 36 factors in all. The ODD factors use 2^0 only: (2+1)(2+1) = 9 of them. Even factors = total - odd = 36 - 9 = 27. Mistaking 9 (the odd count) for the answer is the trap.

**5. (D)** A multiple of 24 must contain 2^3 x 3 at least. To get exactly 18 = 2 x 3 x 3 factors with small value, try 2^5 x 3^2 = 32 x 9 = 288, which has (5+1)(2+1) = 18 factors and is divisible by 24. Smaller multiples of 24 such as 144 = 2^4 x 3^2 give (4+1)(2+1) = 15 factors, and 240 gives 20 factors, so 288 is the least.

**6. (C)** Exactly 12 factors means (a+1)(b+1) = 12 with a > b >= 1. The valid factorisations are a=3, b=2 giving N = 2^3 x 3^2 = 72, and a=5, b=1 giving N = 2^5 x 3 = 96. The smallest is 72. The value 96 is the larger valid case, 144 = 2^4 x 3^2 has 15 factors, and 108 = 2^2 x 3^3 has b greater than a.

**7. (A)** We need a 3-digit number divisible by 2 x 3 x 5 = 30, of the form 2^a 3^b 5^c with no other primes. Among multiples of 30 below 1000, 960 = 2^6 x 3 x 5 qualifies (only primes 2,3,5). The larger 990 = 2 x 3^2 x 5 x 11 contains the prime 11, so it is disqualified; 900 = 2^2 x 3^2 x 5^2 is valid but smaller than 960.

**8. (B)** HCF uses the lowest power of each COMMON prime: 2 -> min(4,2) = 2^2; 3 -> min(2,3) = 3^2; 5 -> min(1,2) = 5^1; the prime 7 appears in only one number so it is excluded. HCF = 4 x 9 x 5 = 180. Taking highest powers gives a much larger LCM, and including 7 or mis-taking 5^2 inflates the answer.

**9. (A)** LCM uses the highest power of EVERY prime present: 2 -> max(4,2) = 2^4; 3 -> max(2,3) = 3^3; 5 -> max(1,2) = 5^2; 7 -> 7^1. So LCM = 2^4 x 3^3 x 5^2 x 7. Using lowest powers gives the HCF, ADDING exponents (2^6 x 3^5 ...) is the classic error, and dropping the 7 leaves out a prime that is genuinely present.

**10. (C)** Common factors of two numbers are exactly the factors of their HCF. HCF(540, 756) = 108 = 2^2 x 3^3, which has (2+1)(3+1) = 12 factors. So there are 12 common factors. Using the wrong HCF, or counting factors of 36 = 2^2 x 3^2 (which gives 9), is the trap.

**11. (B)** Since 9 and 14 are co-prime, the numbers are 9 x 8 = 72 and 14 x 8 = 112, and HCF = 8 as required. LCM = 9 x 14 x 8 = 1008 (equivalently the product 72 x 112 = 8064 divided by HCF 8). The value 112 is just the larger number, and 126 = 9 x 14 forgets the common factor.

**12. (A)** With co-prime ratio parts 7 and 12, the numbers are 7h and 12h, and their LCM is 7 x 12 x h = 84h. Setting 84h = 420 gives h = 5, the HCF. The numbers are 35 and 60. Confusing the HCF with a ratio part (7 or 12), or with 84 = 7 x 12, are the traps.

**13. (C)** For two numbers, HCF x LCM = product. So LCM = product / HCF = 4320 / 12 = 360. Multiplying instead (4320 x 12) or dividing the wrong way (12/4320 then inverted to give 30 or 120) are the errors.

**14. (D)** Product = 18 x (HCF)^2 = 18 x 225 = 4050. Since HCF x LCM = product, LCM = product / HCF = 4050 / 15 = 270. Equivalently, dividing product = 18 x HCF^2 by HCF gives LCM = 18 x HCF = 18 x 15 = 270. Reporting the product 4050 or HCF^2 = 225 instead of the LCM is the trap.

**15. (D)** Product of the two numbers = HCF x LCM = 18 x 1260 = 22680. The other number = 22680 / 126 = 180. Check: HCF(126, 180) = 18 and LCM(126, 180) = 1260. The value 140 = LCM/9 is a miscalculation, and 1260 just repeats the LCM.

**16. (D)** LCM = 21 x 12 = 252. Product = HCF x LCM = 12 x 252 = 3024. The value 252 is only the LCM, 144 = HCF^2, and 63504 = 252^2 squares the LCM by mistake.

**17. (B)** Co-prime numbers both above 1 with product 1763 must be its two prime factors. 1763 = 41 x 43, and 41, 43 are both prime so HCF = 1. The pair 1 and 1763 fails 'each greater than 1'; 23 x 77 = 1771 not 1763; and 37 x 49 = 1813 not 1763.

**18. (D)** Write a = 12m, b = 12n with HCF(m, n) = 1 and m x n = 720/12 = 60 = 2^2 x 3 x 5. The co-prime factor pairs of 60 are (1, 60), (4, 15), (3, 20), (5, 12) — four unordered pairs (split each of the 3 prime-power blocks to one side: 2^(3-1) = 4 ways). So 4 pairs exist.

**19. (B)** Set a = 9m, b = 9n, HCF(m, n) = 1, m x n = 1890/9 = 210 = 2 x 3 x 5 x 7. With four distinct prime blocks, the number of co-prime ordered splits is 2^4 = 16, so unordered pairs = 16/2 = 8. The value 4 corresponds to only three prime blocks.

**20. (A)** Removing the common factor 7, the remaining product 11 x 13 x 17 x 19 has 4 distinct prime blocks to distribute between the two co-prime parts: 2^4 = 16 ordered, hence 16/2 = 8 unordered pairs with a < b. Forgetting to halve gives 16, and using three blocks gives 4.

**21. (B)** Let the numbers be 36m and 36n with HCF(m, n) = 1. Then 36(m + n) = 1080, so m + n = 30. Co-prime pairs with m < n summing to 30: (1, 29), (7, 23), (11, 19), (13, 17) — four pairs. Pairs like (3, 27) or (5, 25) share a factor and are excluded.

**22. (D)** Using HCF x LCM = n x 48 for the pair, n = (16 x 240) / 48 = 3840 / 48 = 80. Check: HCF(80, 48) = 16 and LCM(80, 48) = 240. The value 240 just repeats the LCM and 16 the HCF.

**23. (A)** For any pair of numbers the HCF must divide the LCM exactly. Check each: 240 / 16 = 15, 280 / 14 = 20, 450 / 15 = 30 — all whole numbers, so those three are possible. But 250 / 18 = 13.9..., not a whole number, so 18 cannot be the HCF when 250 is the LCM. Hence HCF 18 with LCM 250 is impossible.

**24. (C)** The largest equal number of bouquets is HCF(480, 600, 720). Factorising: 480 = 2^5 x 3 x 5, 600 = 2^3 x 3 x 5^2, 720 = 2^4 x 3^2 x 5. Lowest powers: 2^3 x 3 x 5 = 120. So 120 bouquets. The value 240 does not divide 600, and 60 is not the largest.

**25. (C)** Each bouquet gets 600 / 120 = 5 lilies (and 480/120 = 4 roses, 720/120 = 6 tulips). Picking the rose count 4 or the tulip count 6 by mistake is the trap.

**26. (C)** Convert to cm: 1134 cm by 756 cm. The largest square tile that divides both exactly has side HCF(1134, 756). 1134 = 2 x 3^4 x 7, 756 = 2^2 x 3^3 x 7; lowest powers give 2 x 3^3 x 7 = 378 cm. The smaller values divide both but are not the largest.

**27. (A)** Tiles along the length: 1134 / 378 = 3; along the width: 756 / 378 = 2. Total = 3 x 2 = 6 tiles. Adding instead of multiplying, or using a smaller tile, gives the wrong counts.

**28. (A)** In centimetres the lengths are 800, 1400 and 2100. The greatest common piece length is HCF(800, 1400, 2100) = 100 cm. (800 = 2^5 x 5^2, 1400 = 2^3 x 5^2 x 7, 2100 = 2^2 x 3 x 5^2 x 7; lowest powers 2^2 x 5^2 = 100.) So 100 cm, i.e. 1 m, per piece.

**29. (A)** We need HCF(493, 551, 667). Each is a multiple of 29: 493 = 29 x 17, 551 = 29 x 19, 667 = 29 x 23. The cofactors 17, 19, 23 are distinct primes, so the HCF is exactly 29. The distractors are those cofactors, which divide only one number each.

**30. (C)** The capacity is HCF(221, 323, 391). Each is a multiple of 17: 221 = 17 x 13, 323 = 17 x 19, 391 = 17 x 23. Since 13, 19, 23 are distinct primes, the HCF is 17 L. The distractors are the cofactors that each divide only one drum.

**31. (B)** Plot side = HCF(1517, 1739) = 37 (since 1517 = 37 x 41 and 1739 = 37 x 47). Along the 1739 m side the number of plots is 1739 / 37 = 47. Along the 1517 m side it would be 41, which is the trap option.

**32. (D)** Largest equal row size = HCF(1056, 792). 1056 = 2^5 x 3 x 11, 792 = 2^3 x 3^2 x 11; lowest powers 2^3 x 3 x 11 = 264. Rows = 1056/264 + 792/264 = 4 + 3 = 7. Using a half-size row of 132 doubles the count to 14.

**33. (A)** Bundle size = HCF(825, 675, 1125). 825 = 3 x 5^2 x 11, 675 = 3^3 x 5^2, 1125 = 3^2 x 5^3; lowest powers 3 x 5^2 = 75. So 75 cards per bundle. The value 25 = 5^2 drops the common 3, and 150 does not divide 675.

**34. (B)** Bag size = HCF(144, 180, 240) = 12 kg (144 = 2^4 x 3^2, 180 = 2^2 x 3^2 x 5, 240 = 2^4 x 3 x 5; lowest powers 2^2 x 3 = 12). Bags = 144/12 + 180/12 + 240/12 = 12 + 15 + 20 = 47. The value 12 is just the bag size, 20 is only the pulses count, and 94 doubles the answer.

**35. (C)** In centimetres the lengths are 1105, 1547 and 1989. The rod length is HCF(1105, 1547, 1989) = 221 (since 1105 = 221 x 5, 1547 = 221 x 7, 1989 = 221 x 9). So 221 cm. The factors 13 and 17 (since 221 = 13 x 17) divide it but are not the greatest.

**36. (D)** They next coincide after LCM(24, 36, 48, 60). Highest powers: 24 = 2^3 x 3, 36 = 2^2 x 3^2, 48 = 2^4 x 3, 60 = 2^2 x 3 x 5 -> 2^4 x 3^2 x 5 = 720 minutes. 360 misses the 2^4, and 1440 doubles needlessly.

**37. (C)** They next meet after LCM(63, 84, 105) = 1260 s. The fastest runner has the shortest lap time, 63 s, so completes 1260 / 63 = 20 laps. Using the slowest (105 s) gives 12, and the middle (84 s) gives 15 — both traps for misreading 'fastest'.

**38. (B)** They next meet after LCM(40, 48, 60) = 240 s. The slowest cyclist has the longest lap time, 60 s, completing 240 / 60 = 4 laps. The fastest (40 s) does 6 and the middle (48 s) does 5 — picking those misreads 'slowest'.

**39. (D)** They realign after the same number of teeth has passed both gears, which is LCM(40, 48) = 240 teeth. Since the meshing point advances by one tooth on each gear together, 240 teeth of the smaller gear pass (and 240 of the larger too). The product 40 x 48 = 1920 over-counts, and 8 is the HCF.

**40. (D)** They toll together every LCM(6, 9, 12) = 36 seconds. In 30 minutes = 1800 seconds there are 1800 / 36 = 50 such coincidences after the start. Including the start would give 51; halving wrongly gives 25.

**41. (B)** All four coincide every LCM(10, 15, 20, 25) = 300 seconds. In 3600 seconds there are 3600 / 300 = 12 intervals, giving 12 coincidences after the start plus the start itself = 13. Forgetting the start gives 12; using a wrong period of 60 s gives 61.

**42. (B)** Next coincidence after LCM(14, 21, 35) minutes. 14 = 2 x 7, 21 = 3 x 7, 35 = 5 x 7 -> 2 x 3 x 5 x 7 = 210 minutes = 3 h 30 min. Adding to 9:00 am gives 12:30 pm. Using 7 minutes (the HCF) gives 9:07; mis-adding gives 11:00 am.

**43. (D)** Next together after LCM(42, 70, 84). 42 = 2 x 3 x 7, 70 = 2 x 5 x 7, 84 = 2^2 x 3 x 7 -> 2^2 x 3 x 5 x 7 = 420 s. 210 misses the 2^2, and 14 is the HCF, not the LCM.

**44. (C)** They leave together every LCM(45, 60) = 180 minutes = 3 hours. Adding 3 hours to 6:00 am gives 9:00 am. Using the HCF 15 min, or LCM 90 min, gives the earlier wrong times.

**45. (B)** First reunion at LCM(56, 70, 84) = 840 s. A completes 840/56 = 15 laps, C completes 840/84 = 10 laps, so A does 15 - 10 = 5 more. Using B (70 s -> 12 laps) in place of one runner, or reading the totals as the difference, gives the wrong gaps.

**46. (B)** They coincide every LCM(30, 45, 75) seconds. 30 = 2 x 3 x 5, 45 = 3^2 x 5, 75 = 3 x 5^2 -> 2 x 3^2 x 5^2 = 450 seconds = 7 min 30 s. So at 10:07:30. Using 15 s (the HCF) or a wrong LCM gives the other times.

**47. (D)** Such a number is LCM(12, 15, 20) x k + 7. LCM = 60, and the smallest value (k = 1) is 60 + 7 = 67. Reporting just the LCM 60, or taking k = 2 (127), or subtracting instead of adding (53) are the traps.

**48. (B)** LCM(8, 12, 18) = 72. The greatest 3-digit multiple of 72 is 72 x 13 = 936; adding the remainder gives 936 + 5 = 941. (Check 941 < 1000 and 941 - 5 = 936 = 72 x 13.) Forgetting to add 5 gives 936; mis-taking the LCM gives the others.

**49. (C)** LCM(18, 24, 30) = 360. The number plus 13 must be a multiple of 360, so the smallest positive number is 360 - 13 = 347. Check: 347 + 13 = 360, divisible by all three. Adding 13 instead of subtracting (373), or stopping at 360, are the errors.

**50. (A)** When the remainder is the same but unknown, the divisor divides every pairwise DIFFERENCE. Differences: 5097 - 2961 = 2136, 6873 - 5097 = 1776, 6873 - 2961 = 3912. HCF(2136, 1776, 3912) = 24. (24 divides all three differences; 48 does not divide 1776 evenly? 1776/48 = 37 — it does, but 48 must also divide 2136: 2136/48 = 44.5, so 48 fails.) Hence 24.

**51. (B)** Leaving remainder 1 on 2,3,4,5,6 means the number is LCM(2,3,4,5,6) x k + 1 = 60k + 1. We also need 7 | (60k + 1). Test k = 1 -> 61 (61/7 not whole); k = 2 -> 121 (no); k = 3 -> 181 (no); k = 4 -> 241 (no); k = 5 -> 301 = 7 x 43 (yes). So 301. The others fail the divisible-by-7 condition.

**52. (D)** In both cases the deficit is the same: 12 - 5 = 7 and 18 - 11 = 7. So the number is 7 less than a common multiple of 12 and 18: it equals LCM(12, 18) x k - 7 = 36k - 7. The smallest positive value (k = 1) is 36 - 7 = 29. Check: 29 = 12 x 2 + 5 and 29 = 18 x 1 + 11.

**53. (A)** Remainder 2 on 5, 6 and 8 means the number is LCM(5, 6, 8) x k + 2 = 120k + 2. We also need 7 to divide 120k + 2. Testing k = 1, 2, 3, 4 gives 122, 242, 362, 482 — none divisible by 7. At k = 5 the number is 602 = 7 x 86, which works. So 602 is the smallest. The trap 122 is the first candidate that fails the divisible-by-7 test.

**54. (B)** In each case the remainder is 7 less than the divisor (16 - 9 = 7, 24 - 17 = 7, 40 - 33 = 7). So the number is 7 short of a common multiple: LCM(16, 24, 40) x k - 7 = 240k - 7. The smallest positive value is 240 - 7 = 233. Check: 233 = 16 x 14 + 9, 233 = 24 x 9 + 17, 233 = 40 x 5 + 33.

**55. (C)** LCM(8, 12, 18) = 72. The smallest 4-digit multiple of 72: 72 x 13 = 936 (3-digit), 72 x 14 = 1008 (4-digit). So 1008. The number 1080 = 72 x 15 is a 4-digit multiple but not the smallest, and 1000, 1044 are not multiples of 72.

**56. (A)** Remainder 4 in each case means the number is LCM(6, 9, 15) x k + 4. LCM = 90, so the smallest value above 4 is 90 + 4 = 94. Reporting the LCM 90 alone, taking k = 2 (184), or mis-LCM-ing are the traps.

**57. (D)** Co-prime numbers above 1 with product 1591 must be its two prime factors: 1591 = 37 x 43, both prime. The pair 1 and 1591 violates 'each greater than 1'; 31 x 51 = 1581 and 41 x 39 = 1599, neither equals 1591.

**58. (A)** 9 = 3^2, 16 = 2^4, 35 = 5 x 7 share no prime between any pair, so they are pairwise co-prime. In 8, 12 share 2; in 6, 21 share 3; in 10, 14 share 2 — each of those sets has a pair with HCF > 1.

**59. (C)** Any number divisible by both 18 and 24 is divisible by their LCM = 72 (18 = 2 x 3^2, 24 = 2^3 x 3 -> 2^3 x 3^2 = 72). It need NOT be divisible by 144 or 432, which require higher powers. 36 divides 72 but is not the largest guaranteed divisor.

**60. (C)** Common multiples of 16 and 18 are the multiples of LCM(16, 18) = 144. Multiples of 144 up to 600: 144, 288, 432, 576 — that is floor(600/144) = 4 of them. Using 16 + 18 or a wrong LCM gives the larger counts.
