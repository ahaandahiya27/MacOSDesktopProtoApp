# Solutions — Mathematics (Class 7), Chapter 13: Connecting the Dots — Paper 5

**Paper 5 — (progressively harder)**

Marking: **+4** correct, **−1** wrong, **0** unattempted. Maximum marks **240**.

<!--
Sub-topic coverage matrix (60 questions, Paper 5 = hardest, strictly above Paper 4):
- Missing value under stacked mean/median/mode constraints: Q1, Q9, Q16, Q24, Q33, Q41, Q49, Q55 (8)
- Mean under add / remove / replace, reconstructing counts: Q2, Q11, Q19, Q26, Q44, Q52 (6)
- Mean under linear transforms (shift, scale, combined, per-position): Q3, Q14, Q31, Q40, Q50 (5)
- Correcting wrong entries / error propagation into the mean: Q12, Q27, Q42, Q57 (4)
- Combining data sets (weighting, ratio, reverse group size): Q4, Q17, Q25, Q35, Q45, Q56 (6)
- Median: sorting, two-middle, editing extremes, missing value, robustness: Q5, Q6, Q18, Q28, Q36, Q43, Q53 (7)
- Mode, multimodal data, ties, frequency reasoning, fewest-edits: Q7, Q20, Q29, Q38, Q47, Q59 (6)
- Range, spread, consistency comparisons: Q8, Q22, Q37, Q46, Q58 (5)
- Outlier effect: mean vs median robustness: Q10, Q30, Q39, Q60 (4)
- Bar / double-bar / pie-chart interpretation (growth, gaps, totals, sectors, angles): Q13, Q21, Q32, Q48, Q54 (5)
- Scale conversion and unequal / switched scales (bar / pictograph): Q15, Q51 (2)
- Probability (likely/unlikely/certain, equally likely, favourable count, complement): Q23, Q34, Q39 is outlier-? no; probability set = Q23, Q34, Q48 part — see solutions for exact tags.
-->

## Answer Key

| Q | Ans | Q | Ans | Q | Ans | Q | Ans | Q | Ans | Q | Ans |
|---|-----|---|-----|---|-----|---|-----|---|-----|---|-----|
| 1 | D | 11 | B | 21 | D | 31 | B | 41 | B | 51 | C |
| 2 | C | 12 | C | 22 | B | 32 | B | 42 | A | 52 | D |
| 3 | A | 13 | D | 23 | C | 33 | D | 43 | A | 53 | B |
| 4 | B | 14 | A | 24 | B | 34 | D | 44 | A | 54 | C |
| 5 | A | 15 | C | 25 | A | 35 | A | 45 | B | 55 | A |
| 6 | C | 16 | B | 26 | D | 36 | D | 46 | D | 56 | C |
| 7 | A | 17 | C | 27 | A | 37 | B | 47 | B | 57 | C |
| 8 | B | 18 | D | 28 | C | 38 | A | 48 | A | 58 | D |
| 9 | A | 19 | B | 29 | C | 39 | D | 49 | B | 59 | A |
| 10 | D | 20 | C | 30 | C | 40 | D | 50 | D | 60 | C |

Answer-key distribution: A = 15, B = 15, C = 15, D = 15.

---

## Worked Solutions

**1. (D)** All seven total 7 × 30 = 210. The four smallest total 4 × 24 = 96; the four largest total 4 × 39 = 156. Because both groups of four are taken from only seven numbers, together they list 4 + 4 = 8 positions but there are only 7 numbers, so exactly one number is counted twice — the overlapping fourth value. Hence 96 + 156 = 252 counts every number once plus that shared value an extra time: 252 = 210 + (shared value), giving the shared value = 252 − 210 = 42. Copying the overall mean gives 30; adding the two group totals' difference gives 63; halving the overlap idea gives 15. The overlap value is 42.

**2. (C)** Nine numbers total 9 × 14 = 126. After the 10th, total = 10 × 16 = 160, so the 10th = 160 − 126 = 34. After the 11th, the total must be 11 × 15 = 165, so the 11th = 165 − 160 = 5. The value 34 is the 10th number, not the 11th; 15 merely copies the final mean; 9 is the original count. Only 5 pulls the average back to 15.

**3. (A)** A transform of the form new = 4 × old + 5 carries straight to the mean: new mean = 4 × 7 + 5 = 28 + 5 = 33. Stopping after multiplying gives 28; multiplying the already-shifted value (e.g. 4 × (7 + 5)) gives 48; treating the transform as old + 4 + 5 gives 16-ish, and 13 = 7 + 5 + 1 ignores the scaling. The new mean is 33.

**4. (B)** Let A have a students and B have b. Then (48a + 72b) ÷ (a + b) = 54, so 48a + 72b = 54a + 54b, giving 18b = 6a, i.e. a : b = 18 : 6 = 3 : 1. Because the combined mean 54 sits much closer to A's 48 than to B's 72, the lower-mean class A must be the larger group, matching 3 : 1. A 1 : 3 split would pull the mean toward 72; 1 : 1 gives mean 60; 2 : 1 gives mean 56.

**5. (A)** For seven sorted values the median is the 4th value, x, which must satisfy 12 ≤ x ≤ 26. The range = 33 − 5 = 28, so half the range = 14. Setting the median equal to 14 forces x = 14, and since 12 ≤ 14 ≤ 26, the value 14 legitimately occupies the 4th sorted slot (8 < 12 < 14 < 26 stays increasing). So x = 14 works. Taking 28 mistakes the range for the median; 7 halves 14 again; and a valid x certainly does exist since 14 lies in the allowed interval.

**6. (C)** For eight sorted values, p and q occupy positions 4 and 5, so they must satisfy 13 ≤ p < q ≤ 24 and p + q = 36. Among the options, p = 17, q = 19 gives 17 + 19 = 36, respects p < q, and fits 13 < 17 < 19 < 24 ✓. The pair (19, 17) violates p < q; (16, 18) sums to 34, not 36; (15, 22) sums to 37, not 36. Only (17, 19) satisfies both the order and the sum.

**7. (A)** Currently 5 appears three times, 2 twice, 8 twice, 9 once — so 5 is the unique mode (not bimodal). To make 2 and 8 the only modes, each must be the most frequent and tie each other, while 5 must not exceed them. One clean route: change one 5 into a 2 (now 2 appears three times) and change the other-needed step — change another 5 into an 8 (now 8 appears three times), leaving 5 with only one copy. That is two edits, giving 2,2,2,5,8,8,8,9: modes 2 and 8 each three times. One edit alone cannot both knock 5 below and raise both 2 and 8 to a tie. So two edits are needed; it is not already bimodal (5 leads), and three edits are more than necessary.

**8. (B)** Mean 35 over 6 innings gives each a total of 6 × 35 = 210, so totals match — equal means cannot, by themselves, distinguish the players. Range measures spread: Pari's 18 keeps her innings in a narrow band while Ria's 54 swings widely. A smaller spread about the same mean signals greater consistency, so Pari is steadier. A large range is not proof of higher scoring, equal means do not make players identical, and a small range describes tight clustering, not uniformly low scores.

**9. (A)** Need total 5 × 9 = 45, the 3rd sorted value = 8, and 6 the unique most frequent value. Test 6, 6, 8, 10, 15: sum = 45 ✓, 3rd value = 8 ✓, 6 appears twice and every other value once, so 6 is the unique mode ✓. The set 6, 6, 8, 8, 17 has 6 and 8 each appearing twice (bimodal), so 6 is not unique. The set 6, 7, 8, 9, 15 has no repeated value, so it has no mode. The set 6, 6, 7, 10, 16 has its 3rd value = 7, so its median is 7, not 8. Only 6, 6, 8, 10, 15 satisfies every condition.

**10. (D)** New total = (old total) − 19 + 119 = (9 × 11) − 19 + 119 = 99 + 100 = 199, so the new mean = 199 ÷ 9 ≈ 22.1 (up about 11). The sorted list 3, 5, 7, 9, 11, 13, 15, 17, 119 still has 11 as its 5th (middle) value, so the median is unchanged at 11. This is the outlier signature: the mean is dragged by an extreme value while the median resists. Claiming the median also jumps ignores its robustness; saying the mean stays 11 ignores the changed total; replacing a value certainly changes the mean.

**11. (B)** Original total = 12 × 20 = 240. Removing 8, 12, 16 (sum 36) and adding two numbers summing 50 gives a new total of 240 − 36 + 50 = 254. The count changes from 12 to 12 − 3 + 2 = 11, so the new mean = 254 ÷ 11 ≈ 23.1. Choosing 20 copies the old mean; dividing 254 by 12 (the wrong count) gives ≈ 21.2; 50 mistakes the inserted sum for the mean. The new mean is about 23.1.

**12. (C)** Recorded total = 15 × 24 = 360. First error: 13 should be 30, so add 17. Second error: 41 should be 9, so subtract 32. Net correction = +17 − 32 = −15. True total = 360 − 15 = 345, mean = 345 ÷ 15 = 23. The two errors pull oppositely and the negative one dominates, so the mean falls by one unit. Leaving it at 24 ignores both corrections; 25 applies them with reversed signs; 22 over-corrects. The corrected mean is 23.

**13. (D)** Each degree represents ₹24000 ÷ 360 = ₹66.67, but it is cleaner to use fractions of the circle. Rent = (150 ÷ 360) × 24000 = ₹10000. Savings = (60 ÷ 360) × 24000 = ₹4000. The difference = 10000 − 4000 = ₹6000 (equivalently the 90° gap is (90 ÷ 360) × 24000 = ₹6000). The value ₹4000 is the Savings amount alone; ₹10000 is the Rent amount alone; ₹90 is the angle difference, not money. Rent exceeds Savings by ₹6000.

**14. (A)** Adding 9 to each value raises the mean by 9, so the original mean = 31 − 9 = 22. Since original mean × n = original total, 22 × n = 110, giving n = 5. The crucial step is undoing the +9 shift before using the total. Using 31 directly gives 110 ÷ 31 ≈ 3.5 (not whole); 22 is the recovered old mean mistaken for the count; 10 doubles the answer. The count is 5.

**15. (C)** Jar A = 3.5 × 18 = 63 marbles; Jar B = 5 × 12 = 60 marbles. So A has more, by 63 − 60 = 3. Even though Jar B shows more symbols (5 vs 3½), the larger scale on graph 1 makes A bigger — symbol counts cannot be compared directly across different scales. Comparing symbols alone (5 vs 3.5) wrongly favours B by 1.5; they are not equal; 18 is one symbol's value on graph 1, not the difference.

**16. (B)** Let the second group have k numbers. Totals: group1 = 3 × 8 = 24; group2 = 15k; group3 = 4 × 24 = 96. Overall: (24 + 15k + 96) ÷ (3 + k + 4) = 16, i.e. (120 + 15k) ÷ (k + 7) = 16, so 120 + 15k = 16k + 112, giving k = 8. Check: total = 24 + 120 + 96 = 240 over 15 numbers = 16 ✓. Choosing 3 or 5 fails the equation; 2 under-counts. The second group has 8 numbers.

**17. (C)** Let Class Q have q students. (40 × 65 + 85q) ÷ (40 + q) = 77, i.e. (2600 + 85q) ÷ (40 + q) = 77, so 2600 + 85q = 3080 + 77q, giving 8q = 480, q = 60. Check: total = 2600 + 5100 = 7700 over 100 students = 77 ✓. Since 77 is closer to 85 than to 65 (gap 8 vs 12), Q must be the larger group, consistent with 60 > 40. The values 20, 40 and 30 all break the balance equation. Class Q has 60 students.

**18. (D)** For eight sorted values the median is the average of the 4th and 5th values, a and b, so (a + b) ÷ 2 = 17, i.e. a + b = 34. The list is strictly increasing, so positions 4 and 5 must satisfy 12 < a < b < 21. The three valid pairs (14, 20), (15, 19) and (16, 18) all sum to 34 AND obey 12 < a < b < 21 strictly, so each can slot in between 12 and 21. The pair (18, 16) also sums to 34 but violates a < b (18 > 16), so it cannot sit at positions 4 and 5 in increasing order — it is the unique impossible pair. The trap is checking only the sum while ignoring the strict ordering.

**19. (B)** Seven numbers total 7 × 14 = 98. The six known values sum to 5 + 8 + 14 + 18 + 18 + 24 = 87, so x = 98 − 87 = 11. Check: the list becomes 5, 8, 11, 14, 18, 18, 24, still increasing (8 < 11 < 14) ✓; 18 appears twice and every other value once, so 18 is the unique mode ✓; and the mean is 98 ÷ 7 = 14 ✓. The value 14 mistakes the mean for x; 12 averages neighbours 8 and 14 wrongly; 9 makes the sum only 96, so the mean would not be 14. The value of x is 11.

**20. (C)** Originally v appears four times (the unique mode) and every other value once. Adding three copies of w makes w appear 0 + 3 = 3 times, still fewer than v's four. So v remains the single most frequent value: the set stays unimodal at v. To tie, w would need a fourth copy. Claiming w becomes the mode, that both tie, or that the mode vanishes all overstate what three copies achieve against v's four.

**21. (D)** Children: 90 → 126, a rise of 36. Adults: 150 → 132, a fall of 18. So Children grew and Adults declined. Comparing 2024 values, Adults 132 > Children 126, so Adults still lead despite shrinking. Tall bars do not mean growth (Adults fell); Children did not overtake Adults (126 < 132); and Adults did not grow at all, so cannot have grown faster. Only the first statement is fully correct.

**22. (B)** There are 5 + 3 + 2 = 10 equally likely outcomes. The number of green balls is 3, so P(green) = 3/10, and P(not green) = 1 − 3/10 = 7/10 (equivalently the 5 red + 2 blue = 7 non-green balls over 10). The value 3/10 is P(green) itself; 2/10 = 1/5 is P(blue); 1/2 ignores the counts. The probability of not green is 7/10.

**23. (C)** For five sorted values the median is the 3rd value. Only the two largest (positions 4 and 5) and the smallest (position 1) were changed, leaving the 3rd value untouched, so the median stays 15. The median resists changes confined to the extremes. Adding 8 (giving 23) or subtracting 5 (giving 10) wrongly assumes an edited value reaches the middle; 20 invents a shift that never touches position 3.

**24. (B)** Let Q have q numbers and P have 3q. Total = 3q × 24 + q × 60 = 72q + 60q = 132q over 3q + q = 4q numbers, mean = 132q ÷ 4q = 33. Because the lower-mean group P is three times as large, the combined mean leans strongly toward 24, landing at 33. The naive average of 24 and 60 is 42 (ignores the sizes); 36 under-weights P; 28 over-weights P. The combined mean is 33.

**25. (A)** Original total = 6 × 25 = 150; new total = 6 × 29 = 174, an increase of 24. Replacing 12 by w changes the total by (w − 12), so w − 12 = 24, giving w = 36. The mean rose by 4 over 6 numbers, i.e. a total rise of 24 carried entirely by this swap. 29 copies the new mean; 24 is the total change, not w; 41 = 29 + 12 adds the old value instead of solving w − 12 = 24.

**26. (D)** Recorded total = 10 × 60 = 600. First error: 59 should be 95, add 36. Second error: 82 should be 28, subtract 54. Net correction = +36 − 54 = −18. True total = 600 − 18 = 582, mean = 582 ÷ 10 = 58.2. The two errors pull oppositely and the negative one dominates, so the mean falls slightly. Leaving it at 60 ignores both corrections; 61.8 applies them with reversed signs; 57 over-corrects. The corrected mean is 58.2.

**27. (A)** For seven sorted values the median is the 4th value, 30. Removing it leaves the original 1st, 2nd, 3rd, 5th, 6th, 7th values. The new median of six values is the average of the new 3rd and 4th positions, which are the original 3rd and 5th values — the immediate neighbours of 30. So the new median is their average, not 30 (which is gone) and not just one neighbour.

**28. (C)** Initially 6 appears 5 times and 9 appears twice. Adding three 9s makes 9 appear 2 + 3 = 5 times. Adding one more 6 makes 6 appear 5 + 1 = 6 times. So 6 (6 times) beats 9 (5 times) and stays the unique mode. The extra 6 is decisive — without it there would be a tie at 5. Choosing 9 ignores the added 6; the tie claim ignores 6 reaching 6; 'no mode' is false.

**29. (C)** Eight numbers total 8 × 30 = 240. The three added values sum to 30 + 10 + 50 = 90, and 90 ÷ 3 = 30 — exactly the existing mean. New total = 240 + 90 = 330 over 11 numbers, mean = 330 ÷ 11 = 30. Adding values whose own mean equals the current mean leaves the mean unchanged. 28 wrongly assumes the 10 drags it down; 31.8 uses a wrong count; 33.3 averages only the additions. The mean stays 30.

**30. (C)** With the axis starting at 500, only the parts above 500 are visible: X shows 30 units, Y shows 10 units, giving the 3-to-1 look. But the true values are 530 and 510, whose ratio is 530 ÷ 510 ≈ 1.04 — nearly equal, differing by just 20. The threefold appearance is an artefact of the cut axis. X is not three times Y, Y is clearly 510 (not zero), and the graph is readable once the axis start is noted.

**31. (B)** A linear transform new = 5 × old − 12 applies directly to the mean: new mean = 5 × 14 − 12 = 70 − 12 = 58. The multiplier scales the mean and the constant shifts it. Stopping after multiplying gives 70; leaving the mean unchanged ignores the transform; 22 mishandles the constant (e.g. 14 + 8). The new mean is 58.

**32. (B)** Totals: X = 45 + 30 = 75; Y = 18 + 52 = 70, so Library X is larger overall (75 > 70). Gaps between the two languages: X |45 − 30| = 15; Y |18 − 52| = 34, so Y has the larger gap. The correct statement therefore says X is larger overall while Y has the bigger gap. Claiming Y is larger reverses the totals; the totals are not equal (75 ≠ 70); and X does not have the larger gap (15 < 34).

**33. (D)** The 8 equally likely outcomes are 1, 2, 3, 4, 5, 6, 7, 8. The factors of 6 within this range are 1, 2, 3 and 6 — four favourable outcomes. So P = 4/8 = 1/2. Counting only 2, 3, 6 (forgetting 1 is a factor) gives 3/8; counting only two of them gives 1/4; 5/8 over-counts. The probability is 1/2.

**34. (D)** First three total 3 × 16 = 48; the five total 5 × 24 = 120, so the eight known numbers total 48 + 120 = 168. Including x makes nine numbers with mean 22, so the total = 9 × 22 = 198, giving x = 198 − 168 = 30. The eight-number total (168) is the key intermediate. 22 copies the final mean; 168 is the eight-number total, not x; 18 mishandles the arithmetic. The value of x is 30.

**35. (A)** Increasing the largest value by 40 − 22 = 18 raises the total by 18, so the mean rises by 18 ÷ 6 = 3, to 17. The median of six numbers is the average of the 3rd and 4th sorted values; the largest sits at position 6, so pushing it further out cannot touch positions 3 or 4 — the median stays 12. This is the median's robustness to a single extreme: 'both increase' ignores it, 'mean stays 14' ignores the changed total, and 'neither changes' ignores both effects.

**36. (D)** Totals: Drama 21 + 13 = 34; Robotics 8 + 30 = 38, so Robotics is more popular. Gaps: Drama |21 − 13| = 8; Robotics |8 − 30| = 22, so Robotics also has the larger gap. Both halves are correct. Saying Drama is more popular reverses the totals; pairing Robotics-popular with Drama-bigger-gap mixes the comparisons; the totals are not equal (34 ≠ 38).

**37. (B)** Total change = (3 − 7) + (3 − 9) = −4 − 6 = −10, so the new total drops by 10; the mean falls by 10 ÷ 6 ≈ 1.67, from 18 to about 16.33. For the median of six values (average of the 3rd and 4th sorted values): the two smallest occupy positions 1 and 2, so lowering them does not touch positions 3 and 4 — the median stays 16. So the mean falls while the median holds at 16. 'Mean stays 18' ignores the lowered total; 'both fall by 2' wrongly moves the median; 'median falls to 12' is false because positions 3 and 4 never changed.

**38. (A)** Mean: the total changes by +9 +9 −9 −9 = 0, so the mean stays 22. Median: only the two largest (positions 4 and 5) and two smallest (positions 1 and 2) changed, leaving the 3rd (middle) value untouched, so the median stays 22. Both are unchanged. The balanced ±9 changes cancel for the mean, and the median is unaffected because the centre never moved; every other option ignores one of these facts.

**39. (D)** The total increase is 2 + 4 + 6 + 8 + 10 = 30. The original total was 5 × 20 = 100, so the new total is 100 + 30 = 130 over 5 numbers, mean = 130 ÷ 5 = 26 (a rise of 6). Leaving the mean at 20 ignores the additions; 30 adds the increase to the mean directly; 22 adds only 2. The clean result is 26.

**40. (D)** Range = largest − smallest = 60. The largest drops by 15 → (largest − 15); the smallest rises by 9 → (smallest + 9). New range = (largest − 15) − (smallest + 9) = (largest − smallest) − 24 = 60 − 24 = 36. Both ends move inward, shrinking the spread by 15 + 9 = 24. Keeping 60 ignores the changes; 84 adds 24 instead of subtracting; 45 subtracts only one shift. The new range is 36.

**41. (B)** Recorded total = 16 × 35 = 560. The entry was 87 − 23 = 64 too low, so the true total = 560 + 64 = 624, mean = 624 ÷ 16 = 39. The error of 64 spread over 16 values raises the mean by 4, to 39. Leaving it at 35 ignores the correction; 37 spreads only half the error; 43 adds 8 instead of 4. The corrected mean is 39.

**42. (A)** Originally six values: median = average of 3rd and 4th = (18 + 22) ÷ 2 = 20. Remove 10, leaving five values 14, 18, 22, 26, 30: the median is now the 3rd value = 22. So the median rises from 20 to 22. It does not stay 20 (the count changed parity); it does not fall (a small value was removed, shifting the centre up); 24 is the average of 22 and 26, not the new middle. The median rises to 22.

**43. (A)** Bar heights in cm are 4, 5, 6, 5, 5; their mean height = (4 + 5 + 6 + 5 + 5) ÷ 5 = 25 ÷ 5 = 5 cm. Because the scale is linear, the bar for the mean mark also has the mean height, 5 cm. (Check: marks 24, 30, 36, 30, 30, mean 30, and 30 ÷ 6 = 5 cm.) The value 30 is the mean in marks, not cm; 25 is the total height; 1 confuses dividing height by the scale. The bar is 5 cm tall.

**44. (A)** Totals: A = 5 × 12 = 60; B = 3 × 20 = 60; C = 2 × 30 = 60. Grand total = 60 + 60 + 60 = 180 over 5 + 3 + 2 = 10 numbers, mean = 180 ÷ 10 = 18. Each group happens to contribute 60, but the means must be weighted by group size, not averaged. Naively averaging 12, 20, 30 gives about 20.7; 62 mistakes the change; 15 under-counts. The combined mean is 18.

**45. (B)** Sorted already. Mode = 11 (three times). Median = 5th value = 14. Mean = (7+11+11+11+14+18+20+21+22) ÷ 9 = 135 ÷ 9 = 15. So mean + mode − 2 × median = 15 + 11 − 2 × 14 = 26 − 28 = −2. Mislocating the median as the 4th value (11) gives 0; reading it as the 6th value (18) shifts the sign to +; 15 is just the mean. The expression equals −2.

**46. (D)** Sorted: 14, 14, 14, 18, 22, 22, 26. Mode = 14 (three times). Median = 4th value = 18. Mean = (14+14+14+18+22+22+26) ÷ 7 = 130 ÷ 7 ≈ 18.6. So 14 (mode) < 18 (median) < 18.6 (mean): mode < median < mean. The cluster of low modal 14s puts the mode lowest, while the high values 22, 22, 26 lift the mean just above the median. The other orderings misplace the mean or wrongly equate the three.

**47. (B)** The transform new = (old ÷ 2) + 12 applies to the mean: new mean = (40 ÷ 2) + 12 = 20 + 12 = 32. Halving alone gives 20 (forgets the +12); adding 12 to the original mean before halving, or other mis-sequencing, gives 52 or 26. The correct new mean is 32.

**48. (A)** Forest M = 3 × 25 = 75 trees; Forest N = 4 × 20 = 80 trees. So N has more, by 80 − 75 = 5. Even though the scales differ, converting first shows N edges ahead. Comparing symbol counts alone (4 vs 3) wrongly favours N by 1; M does not lead; they are not equal. Forest N is greater by 5 trees.

**49. (B)** Recorded total = 14 × 50 = 700. The entry was 96 − 18 = 78 too HIGH, so the true total = 700 − 78 = 622, mean = 622 ÷ 14 ≈ 44.4. The over-entry by 78 spread over 14 values lowers the mean by about 5.6. Leaving it at 50 ignores the correction; 55.6 adds instead of subtracts; 47 corrects only partly. The corrected mean is about 44.4.

**50. (D)** For nine sorted values the median is the 5th value. The changes touch only positions 1–4 and 6–9; position 5 is never altered and the order is preserved (the gaps only widen), so the median stays exactly 50. The symmetric ±30 changes spread the data out far more, but the centre value does not move. Adding 30 (giving 80) or subtracting 30 (giving 20) wrongly assumes the 5th value was among those changed; 65 has no basis. The median is unchanged at 50.

**51. (C)** After 12 innings his total is 12 × 38 = 456. To have a mean of 42 over 14 innings, his total must be 14 × 42 = 588. So the next two innings together must add 588 − 456 = 132 runs. Scoring 84 (= 2 × 42, the target mean per innings) gives a total of 540 over 14 = 38.6, not 42. 120 and 66 mis-handle the totals. He needs 132 runs across the two innings.

**52. (D)** Total of all eight = 8 × 25 = 200. Four numbers each equal to the mean contribute 4 × 25 = 100. So the remaining four sum to 200 − 100 = 100. The whole total 200 is for all eight, not four; 25 is one value; 50 forgets half of the mean-valued numbers. The other four sum to 100.

**53. (B)** Total = 5 × 40 = 200. Removing the smallest and largest: 200 − 12 − 84 = 104 is shared equally by the three middle numbers, so each = 104 ÷ 3 ≈ 34.7. The value 104 is their combined total, not each one; 40 copies the overall mean; 52 wrongly divides 104 by 2. Each middle number is about 34.7.

**54. (C)** The angles must add to 140 + 100 + 80 + 40 = 360° ✓. Football's share = (100 ÷ 360) × 720 = 720 × (5 ÷ 18) = 200 students. (Each degree is 720 ÷ 360 = 2 students, so 100° → 200.) The value 100 is Football's angle, not its count; 280 is Cricket's count (140 × 2); 160 mis-multiplies. Football was chosen by 200 students.

**55. (A)** Both shops total ₹120 thousand, so seasonal totals match — but equal totals do not mean equal quarters: P's values are 40, 70, 10 while Q's are 30, 30, 60, a clearly different period-by-period pattern. So 'identical' is wrong even though totals agree. The totals do NOT differ (both 120); equal totals do not make the data identical; and a single largest quarter (Q's 60) does not mean Q sold more overall since the totals tie.

**56. (C)** Original total = 9 × 22 = 198. New mean 20 over 9 numbers needs a total of 9 × 20 = 180, a drop of 18. Replacing 46 by v changes the total by (v − 46), so v − 46 = −18, giving v = 28. The drop of 18 is the change in total, not the value; 18 is that change; 46 is the original value; 20 is the new mean. The replacement is 28.

**57. (C)** Adding 130 (well above 50) raises the total, so the mean rises above 50. The mode is the most frequent value; one new 130 cannot outnumber the many 50s, so the mode stays 50. The median, being position-based, shifts only slightly toward the upper-middle (it cannot leap to 130, an extreme). So the mean is most affected, the mode is unmoved, and the median barely moves — the classic outlier pattern. The mode is defined by frequency, not size; the three do not move together; and adding an extreme value certainly changes the mean.

**58. (D)** List with y = 13: sorted 5, 9, 13, 13, 13, 17. Mode = 13 (three times) ✓. Median = average of 3rd and 4th = (13 + 13) ÷ 2 = 13 ✓. So y = 13 keeps both. For y = 11: sorted 5, 9, 11, 13, 13, 17, median = (11 + 13) ÷ 2 = 12, not 13, so the median fails. For y = 5: sorted 5, 5, 9, 13, 13, 17, median = (9 + 13) ÷ 2 = 11, not 13. y = 18: sorted 5, 9, 13, 13, 17, 18, median = (13 + 13) ÷ 2 = 13 holds but it need not be exactly 18 — y = 13 also works, and the claim 'must be exactly 18' is false. Only y = 13 is guaranteed to keep both.

**59. (A)** With the axis starting at 1000, the visible parts are 40 and 10 units, so X's bar looks about four times Y's. But the true values are 1040 and 1010, differing by just 30 — about 3% — so the cities are nearly the same size. The truncated axis manufactured the illusion. X is not four times Y, Y is plainly 1010 (not zero), and the graph does not prove a big difference once the axis start is read honestly.

**60. (C)** The six equally likely outcomes are 1, 2, 3, 4, 5, 6. Even numbers: 2, 4, 6. Numbers greater than 4: 5, 6. The outcomes in A OR B (listing each once, since 6 is shared) are 2, 4, 5, 6 — four favourable outcomes. So P = 4/6 (which simplifies to 2/3). Counting only the evens gives 3/6; double-counting the shared 6 inflates it to 5/6; 2/6 counts only 'greater than 4'. The probability is 4/6.
