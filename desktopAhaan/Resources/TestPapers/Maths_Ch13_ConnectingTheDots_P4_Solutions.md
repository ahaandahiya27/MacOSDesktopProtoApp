# Solutions — Maths (Class 7), Chapter 13: Connecting the Dots — Paper 4

**Paper 4 — (progressively harder)**

Marking: **+4** correct, **−1** wrong, **0** unattempted. Maximum marks **240**.

<!--
Sub-topic coverage matrix (60 questions):
- Working backwards to a missing value from a given mean (multi-constraint): Q1, Q9, Q21, Q31, Q41, Q51 (6)
- Mean under adding / removing / replacing a value (and reconstructing counts): Q2, Q11, Q23, Q33, Q42 (5)
- Mean under transforming every value (linear shift, scaling, combined): Q3, Q14, Q27, Q43, Q52 (5)
- Correcting a wrong entry / error propagation into the mean: Q12, Q34, Q53 (3)
- Combining data sets (weighted vs naive average, reverse-engineering a group size): Q4, Q16, Q26, Q37, Q47, Q56 (6)
- Median by sorting / two-middle values / structural reasoning: Q5, Q18, Q28, Q44, Q54 (5)
- Median with a missing value or after editing extremes (robustness): Q6, Q19, Q35, Q45 (4)
- Mode, multimodal data, ties and frequency reasoning: Q7, Q20, Q30, Q46, Q59 (5)
- Range, spread and consistency comparisons: Q8, Q24, Q36, Q48 (4)
- Outlier effect: mean vs median sensitivity: Q10, Q25, Q40, Q58 (4)
- Bar graph and double-bar graph interpretation (growth, gaps, totals): Q13, Q22, Q38, Q57 (4)
- Scale conversion (bar / pictograph) and unequal / switched scales: Q15, Q29, Q39, Q49, Q55 (5)
- Truncated-axis and misleading-graph reasoning: Q17, Q32, Q60 (3)
- Ordering / relating mean, median, mode; conclusion logic: Q50, Q51 (1 — combined into Q50)
- Combined-summary expression and ordering: Q50 (1)
-->

## Answer Key

| Q | Ans | Q | Ans | Q | Ans | Q | Ans | Q | Ans | Q | Ans |
|---|-----|---|-----|---|-----|---|-----|---|-----|---|-----|
| 1 | D | 11 | B | 21 | D | 31 | D | 41 | C | 51 | D |
| 2 | C | 12 | B | 22 | A | 32 | B | 42 | B | 52 | D |
| 3 | B | 13 | D | 23 | A | 33 | B | 43 | D | 53 | A |
| 4 | B | 14 | A | 24 | B | 34 | A | 44 | C | 54 | B |
| 5 | C | 15 | B | 25 | C | 35 | B | 45 | C | 55 | D |
| 6 | C | 16 | A | 26 | B | 36 | A | 46 | D | 56 | D |
| 7 | D | 17 | A | 27 | C | 37 | C | 47 | A | 57 | C |
| 8 | D | 18 | C | 28 | B | 38 | A | 48 | C | 58 | D |
| 9 | D | 19 | A | 29 | B | 39 | D | 49 | A | 59 | C |
| 10 | A | 20 | B | 30 | A | 40 | C | 50 | A | 60 | C |

Answer-key distribution: A = 15, B = 15, C = 15, D = 15.

---

## Worked Solutions

**1. (D)** Total of all six = 6 × 40 = 240. The two removed numbers sum to 30 + 50 = 80, so the remaining four total 240 − 80 = 160, and their mean is 160 ÷ 4 = 40. The two removed values average 40 (the same as the overall mean), so removing them leaves the mean unchanged at 40. Dividing the remaining total by 6 or 5 instead of 4 gives the off-values near 38 or 42; 55 wrongly works with the removed sum 80 instead of the remaining total.

**2. (C)** Eight numbers total 8 × 15 = 120. After the 9th, the total is 9 × 16 = 144, so the 9th number = 144 − 120 = 24. After the 10th, the total must be 10 × 15 = 150, so the 10th number = 150 − 144 = 6. The value 24 is the 9th number, not the 10th; 15 just copies the final mean; 16 copies the intermediate mean. Only 6 brings the average back to 15.

**3. (B)** A transform of the form new = 2 × old − 3 applies the same way to the mean: new mean = 2 × 10 − 3 = 20 − 3 = 17. Stopping after doubling gives 20; leaving the mean unchanged ignores the transform; doubling then ADDING 3 (mishandling the sign) gives 23.

**4. (B)** Let A have a students and B have b. Then (60a + 80b) ÷ (a + b) = 68, so 60a + 80b = 68a + 68b, giving 12b = 8a, i.e. a : b = 12 : 8 = 3 : 2. Because 68 is closer to 60 than to 80, the lower-mean class A must be larger — consistent with 3 : 2. A 1 : 1 split gives mean 70; 2 : 3 leans toward 80 (mean 72); 3 : 1 gives mean 65.

**5. (C)** With seven sorted values the median is the 4th value, which is x, so x must satisfy 13 ≤ x ≤ 22. The range = 31 − 6 = 25, so range ÷ 4 = 6.25. The condition median = range ÷ 4 would force x = 6.25, but 6.25 lies far below 13 and cannot occupy the 4th sorted slot. Hence no valid x exists. Writing x = 6.25 ignores the ordering constraint; 25 mistakes the range for x; 18 is an unjustified guess that does not equal 6.25.

**6. (C)** For five sorted values the median is the 3rd. Only the two largest (positions 4, 5) and the smallest (position 1) were changed, leaving the 3rd value untouched, so the median stays 12. The median resists changes in the extremes. Adding 10 (giving 22) or subtracting 4 (giving 8) wrongly assumes an edited value reaches the middle; 14 invents a shift that never touches position 3.

**7. (D)** Currently 7 appears three times and 3 appears twice, so 7 is the unique mode — NOT already bimodal. To tie 3 with 7, make 3 appear three times: change the single 9 into a 3, giving 3, 3, 3, 5, 7, 7, 7, where both 3 and 7 appear three times. That is one edit. Believing it is already bimodal ignores that 3 has only two copies; two or three edits exceed what is needed.

**8. (D)** Mean 40 over 5 innings gives each a total of 200, so totals match. Range measures spread: Bina's range 12 keeps her scores in a tight band, while Asha's range 30 swings much wider. Smaller spread about the same mean signals greater consistency, so Bina is steadier. Equal means do not imply identical data; a large range is not a 'higher skill ceiling'; and a small range describes tight clustering, not low values.

**9. (D)** Five numbers total 5 × 18 = 90; four numbers total 4 × 15 = 60. The removed (largest) number = 90 − 60 = 30. Since removing it lowered the mean, it was above average, and 30 > 18 confirms this. 18 copies the original mean; 15 copies the reduced mean; 3 is merely the change in mean (18 − 15).

**10. (A)** New total = 70 − 16 + 100 = 154, so the new mean = 154 ÷ 7 = 22 (up by 12). The sorted list 4, 6, 8, 10, 12, 14, 100 still has 10 as its 4th (middle) value, so the median is unchanged at 10. This is the outlier signature: the mean is dragged by an extreme value while the median resists. Claiming both reach 22 ignores the median's robustness; saying the mean stays 10 ignores the changed total; replacing a value certainly changes the mean.

**11. (B)** Original total = 10 × 12 = 120. Removing 5 and 9 (sum 14) and adding 22 gives a new total of 120 − 14 + 22 = 128 over 9 numbers, so the mean = 128 ÷ 9 ≈ 14.2. The count dropped from 10 to 9 because two values became one. Dividing 128 by 10 gives 12.8 (wrong count); 12 copies the old mean; 22 mistakes the inserted value for the mean.

**12. (B)** Recorded total = 12 × 30 = 360. First error: 8 should be 18, so add 10. Second error: 52 should be 25, so subtract 27. Net correction = +10 − 27 = −17. True total = 360 − 17 = 343, mean = 343 ÷ 12 ≈ 28.6. The two errors pull oppositely and the negative one dominates, so the mean falls slightly. Leaving it at 30 ignores both corrections; 31.4 applies them with the wrong sign; 32.5 accounts for only one error.

**13. (D)** Tea: 80 → 110, a rise of 30. Coffee: 140 → 119, a fall of 21. So Tea grew and Coffee declined. Comparing 2024 values, Coffee 119 > Tea 110, so Coffee still leads despite shrinking. Tall bars do not mean growth (Coffee fell); Tea did not overtake Coffee (110 < 119); and Coffee did not grow at all, so it cannot have grown faster.

**14. (A)** Adding 7 to each value raises the mean by 7, so the original mean = 19 − 7 = 12. Since original mean × n = original total, 12 × n = 96, giving n = 8. The key step is undoing the shift before using the total. Using 19 directly gives 96 ÷ 19 ≈ 5; 12 is the recovered old mean mistaken for the count; 7 is the shift, not the count.

**15. (B)** Shelf P = 3.75 × 12 = 45 books; Shelf Q = 2.25 × 12 = 27 books; difference = 45 − 27 = 18. Equivalently (3.75 − 2.25) × 12 = 1.5 × 12 = 18. Subtracting symbol counts alone (1.5) forgets each symbol is 12 books; 12 is the value of one symbol; 72 is the combined total (45 + 27), not the difference.

**16. (A)** Let the second group have k numbers. Totals: group1 = 2 × 10 = 20; group2 = 20k; group3 = 3 × 30 = 90. Overall: (20 + 20k + 90) ÷ (2 + k + 3) = 21, i.e. (110 + 20k) ÷ (k + 5) = 21, so 110 + 20k = 21k + 105, giving k = 5. Check: total 210 over 10 numbers = 21 ✓. Choosing 1 or 3 fails the equation; 10 mistakes the total count for the group size.

**17. (A)** The axis starts at 200, so visible bar lengths measure only the parts above 200: X shows 12 units, Y shows 3 units, hence the 4-to-1 look. But the true values are 212 and 203, whose ratio is 212 ÷ 203 ≈ 1.04 — nearly equal, differing by just 9. The fourfold appearance is an artefact of the cut axis. X is not four times Y, Y is clearly 203 (not zero), and the graph is readable once the axis start is noted.

**18. (C)** For eight values the median is the average of the 4th and 5th values, a and b, so (a + b) ÷ 2 = 16, i.e. a + b = 32. The pairs (14, 18), (15, 17) and (13, 19) all sum to 32 and respect a < b and 11 < a, b < 20. The pair (17, 15) sums to 32 but violates a < b (17 > 15), so it cannot occupy positions 4 and 5 in increasing order. The trap is checking only the sum and ignoring the ordering.

**19. (A)** With seven numbers, total = 7 × 14 = 98. The six known values sum to 5 + 8 + 14 + 18 + 18 + 25 = 88, so x = 98 − 88 = 10. Check the constraints: the list becomes 5, 8, 10, 14, 18, 18, 25, which is still increasing (8 < 10 < 14) ✓; 18 appears twice and every other value once, so 18 is the unique mode ✓; and the mean is 98 ÷ 7 = 14 ✓. The value 14 mistakes the mean for x; 12 averages the neighbours 8 and 14 instead of using the total; 9 is an unjustified guess that makes the sum only 97, so the mean would not be 14.

**20. (B)** Originally v appears three times (the unique mode) and every other value once. Adding two copies of w makes w appear 0 + 2 = 2 times, still fewer than v's three. So v remains the single most frequent value: the set stays unimodal. To tie, w would need a third copy. Claiming w becomes the mode, that both tie, or that the mode vanishes all overstate what two copies achieve.

**21. (D)** Need: five numbers, total 5 × 8 = 40; the 3rd sorted value = 7; the value 5 the unique most frequent. Test 5, 5, 7, 8, 15: sum = 40 ✓, 3rd value 7 ✓, 5 appears twice and is the only repeat ✓. The set 5, 5, 8, 8, 14 has two values each appearing twice (5 and 8) → bimodal, so 5 is not the unique mode. The set 4, 5, 5, 7, 19 has 3rd value 5, so its median is 5, not 7. The set 5, 5, 7, 9, 13 sums to 39, not 40, so its mean is not 8. Only 5, 5, 7, 8, 15 meets every condition.

**22. (A)** Bar heights in cm are 5, 7, 6, 6; their mean height = (5 + 7 + 6 + 6) ÷ 4 = 24 ÷ 4 = 6 cm. Because the scale is linear, the bar for the mean mark also has the mean height, 6 cm. (Check: marks 30, 42, 36, 36, mean 36, and 36 ÷ 6 = 6 cm.) The value 36 is the mean in marks, not cm; 24 is the total height; 1 confuses dividing height by the scale. The bar is 6 cm tall.

**23. (A)** Total of nine = 9 × 20 = 180. Removing three values each equal to 20 removes 60, leaving 120 over six numbers, mean = 120 ÷ 6 = 20. Removing values equal to the current mean leaves the mean unchanged. 13.3 = 120 ÷ 9 keeps the wrong count; 30 wrongly raises the mean; 60 is the removed total.

**24. (B)** Range = largest − smallest = 20. After the changes, the smallest drops by 5 and the largest rises by 5, so the new range = (largest + 5) − (smallest − 5) = (largest − smallest) + 10 = 20 + 10 = 30. Both ends move outward, widening the spread by 10. Keeping 20 ignores both moves; 25 adds only one 5; 15 subtracts instead of adding.

**25. (C)** Six numbers total 6 × 50 = 300. Adding 50 keeps the total at 350 (mean 50 over 7). Adding 90 gives total 440 over 8 numbers, mean = 440 ÷ 8 = 55. The 50 leaves the mean alone, but the 90 (above the mean) pulls it up to 55. Staying at 50 ignores the 90; 63.3 uses a wrong count; 70 naively averages 50 and 90, ignoring the six existing values.

**26. (B)** Let Class B have b students. (30 × 78 + 66b) ÷ (30 + b) = 72, i.e. (2340 + 66b) ÷ (30 + b) = 72, so 2340 + 66b = 2160 + 72b, giving 180 = 6b, b = 30. Since 72 is exactly midway between 78 and 66, the groups must be equal in size, confirming 30. Values 20 and 36 break the balance; 60 over-weights B and would pull the mean below the midpoint.

**27. (C)** A linear transform new = 3 × old − 8 applies to the mean directly: new mean = 3 × 16 − 8 = 48 − 8 = 40. The multiplier scales the mean and the constant shifts it. Stopping after multiplying gives 48; leaving the mean unchanged ignores the transform; 24 mishandles the constant (e.g. 16 + 8) instead of 3 × 16 − 8.

**28. (B)** In seven sorted values the median is the 4th value, 25. Removing it leaves the original 1st, 2nd, 3rd, 5th, 6th, 7th. The new median of six values is the average of the new 3rd and 4th, which are the original 3rd and 5th — the immediate neighbours of 25. So the new median is their average, not 25 (that value is gone) and not just one neighbour.

**29. (B)** Initially 6 appears 4 times and 9 once. Adding three 9s makes 9 appear 1 + 3 = 4 times. Adding one more 6 makes 6 appear 4 + 1 = 5 times. So 6 (5 times) beats 9 (4 times) and stays the unique mode. The extra 6 is decisive — without it there would be a tie at 4. Choosing 9 ignores the added 6; the tie claim ignores 6 reaching 5; 'no mode' is false.

**30. (A)** Original total = 6 × 21 = 126; new total = 6 × 24 = 144, an increase of 18. Replacing 9 by w changes the total by (w − 9), so w − 9 = 18, giving w = 27. The mean rose by 3 over 6 numbers, i.e. a total rise of 18 carried entirely by this swap. 24 copies the new mean; 18 is the total change, not w; 33 = 24 + 9 adds the old value instead of solving w − 9 = 18.

**31. (D)** With the axis starting at 480, the visible heights are 490 − 480 = 10 and 500 − 480 = 20, so the second looks twice the first. But the real values are 490 and 500: a rise of just 10, about 2% — nowhere near doubling. The truncated axis created the illusion. Sales did not double, did not fall, and the values are clearly readable as 490 and 500.

**32. (B)** Original total = 8 × 30 = 240. Removing a 30 leaves 210 over 7. Adding 10 and 50 (sum 60, averaging 30 — the same as the mean) gives total 270 over 9 numbers, mean = 270 ÷ 9 = 30. Removing a value equal to the mean and adding two values whose average equals the mean both leave the mean unchanged. 33.3 and 37.5 use wrong counts; 28 wrongly assumes the additions drag the mean down.

**33. (B)** Recorded total = 10 × 50 = 500. First error: 48 should be 84, add 36. Second error: 32 should be 23, subtract 9. Net correction = +36 − 9 = +27. True total = 500 + 27 = 527, mean = 527 ÷ 10 = 52.7. The corrections oppose but the positive one dominates, so the mean rises slightly. Leaving it at 50 ignores the corrections; 54.5 mishandles a sign; 47.3 applies the net correction in the wrong direction.

**34. (A)** Median first: only positions 1 (smallest) and 7 (largest) changed, so the 4th (middle) value is untouched → median stays 24. Mean: smallest 10 → 2 (a fall of 8) and largest 40 → 60 (a rise of 20), net change +12 to the total, so the mean rises by 12 ÷ 7 ≈ 1.7 to about 25.7. So the median is fixed while the mean rises. 'Both rise' ignores the median's robustness; 'both stay 24' ignores the unbalanced net change; 'median rises' is false since the middle value never moved.

**35. (B)** First seven numbers total = 3 × 14 + 4 × 21 = 42 + 84 = 126. Including x makes eight numbers with mean 20, so total = 8 × 20 = 160, giving x = 160 − 126 = 34. The grand total of the seven (126) is the key intermediate. 20 copies the final mean; 18 is the seven-number mean (126 ÷ 7); 126 is the seven-number total, not x.

**36. (A)** Increasing the largest value by 30 − 18 = 12 raises the total by 12, so the mean rises by 12 ÷ 6 = 2, to 12. The median of six numbers is the average of the 3rd and 4th sorted values; the largest sits at position 6, so moving it further out does not touch positions 3 or 4 — the median stays 9. The point is the median's robustness to a single extreme: 'both increase' ignores it, 'mean stays 10' ignores the changed total, and 'neither changes' ignores both effects.

**37. (C)** Totals: Music 15 + 9 = 24; Art 6 + 22 = 28, so Art is more popular. Gaps: Music |15 − 9| = 6; Art |6 − 22| = 16, so Art also has the larger gap. Both halves are correct. Saying Music is more popular reverses the totals; pairing Art-popular with Music-bigger-gap mixes up comparisons; the totals are not equal (24 ≠ 28).

**38. (A)** Village P = 2.5 × 20 = 50 trees; Village Q = 9 × 8 = 72 trees. Q − P = 72 − 50 = 22, so Q planted more by 22. The two displays use different scales, so symbol counts and cm cannot be compared directly. 'P is larger' reverses the result; 'same' ignores the conversion; 6.5 wrongly compares 9 against 2.5 without applying either scale.

**39. (D)** Mean: the total changes by +6 +6 −6 −6 = 0, so the mean stays 20. Median: only the two largest (positions 4, 5) and two smallest (positions 1, 2) changed, leaving the 3rd (middle) value untouched, so the median stays 20. Both are unchanged. The balanced ±6 changes cancel for the mean, and the median is unaffected because the centre never moved; the options claiming a rise or fall ignore one of these facts.

**40. (C)** The total increase is 1 + 2 + 3 + 4 + 5 = 15. The original total was 5 × 12 = 60, so the new total is 60 + 15 = 75 over 5 numbers, mean = 75 ÷ 5 = 15 (a rise of 3). Leaving the mean at 12 ignores the additions; 17 adds 5 (the last position) to the mean; 13 adds only 1 to the mean. The clean result is 15.

**41. (C)** Range = largest − smallest = 50. The largest drops by 12 → (largest − 12); the smallest rises by 8 → (smallest + 8). New range = (largest − 12) − (smallest + 8) = (largest − smallest) − 20 = 50 − 20 = 30. Both ends move inward, shrinking the spread by 12 + 8 = 20. Keeping 50 ignores the changes; 70 adds 20 instead of subtracting; 20 subtracts only one shift.

**42. (B)** Correctly, 30 units need a bar of 30 ÷ 6 = 5 cm. The printing error stretches the drawn height by 1.5, so it now measures 5 × 1.5 = 7.5 cm, though it still 'means' 30 units. 5 cm is the correct (unstretched) height; 45 cm multiplies units by 1.5 instead of the height; 30 cm confuses units with cm.

**43. (D)** Total change = (2 − 6) + (2 − 8) = −4 − 6 = −10, so the new total drops by 10; the mean falls by 10 ÷ 6 ≈ 1.67, from 15 to about 13.33 (≈13.3) — not exactly 13. For the median of six values (the average of the 3rd and 4th sorted values): the two smallest occupy positions 1 and 2, so lowering them does not touch positions 3 and 4 — the median stays 14. So the mean falls while the median holds at 14. 'Mean stays 15' ignores the lowered total; 'both fall by 2' wrongly moves the median; 'median also falls to 12' is false because positions 3 and 4 never changed.

**44. (C)** Initially 7 appears 5 times and 4 appears 3 times. Adding two 4s makes 4 appear 3 + 2 = 5 times, tying 7's 5. So both 7 and 4 are most frequent — the data is bimodal. Choosing 7 alone ignores that 4 caught up; choosing 4 alone ignores that 7 still has 5; a tie still means there are modes, so 'no mode' is wrong.

**45. (C)** Let Q have q numbers and P have 2q. Total = 2q × 30 + q × 60 = 60q + 60q = 120q over 3q numbers, mean = 120q ÷ 3q = 40. Because the lower-mean group P is twice as large, the combined mean leans toward 30, landing at 40. The naive average of 30 and 60 is 45 (ignores the sizes); 50 over-weights Q; 90 adds the means.

**46. (D)** The range 28 − 4 = 24 describes only the distance between the smallest and largest values. The other three numbers (which sum to 5 × 14 − 4 − 28 = 70 − 32 = 38) could be tightly bunched near 14, e.g. 12, 13, 13. So a large range does not force the middle values away from the mean, nor does it pin the median. The range is not the mean, and it makes no claim about every value's distance from 14.

**47. (A)** Graph distances: 4 × 5 = 20, 6 × 5 = 30, 8 × 5 = 40 km; graph total = 90 km. The odometer reads 95 km, so the graph falls short by 95 − 90 = 5 km. Adding the units (4 + 6 + 8 = 18) without the scale gives 18; 0 assumes agreement; 90 is the graph total, not the shortfall.

**48. (C)** Sort (already sorted). Mode = 14 (three times). Median = 5th value = 14. Mean = (8+12+12+14+14+14+16+16+20) ÷ 9 = 126 ÷ 9 = 14. So mean + mode − 2 × median = 14 + 14 − 28 = 0. Here mean, median and mode all equal 14, making the expression zero. Taking the median as the 4th or 6th value (mis-locating it) gives ±2; 14 is just the common value, not the combined expression.

**49. (A)** Sorted: 12, 15, 15, 18, 21, 21, 21. Mode = 21 (three times). Median = 4th value = 18. Mean = (12+15+15+18+21+21+21) ÷ 7 = 123 ÷ 7 ≈ 17.6. So 17.6 (mean) < 18 (median) < 21 (mode): mean < median < mode. The single low 12 pulls the mean just below the median, while the cluster of high modal 21s lifts the mode highest. The other orderings misplace the mean relative to the median or wrongly equate the three.

**50. (A)** The transform new = (old ÷ 2) + 10 applies to the mean: new mean = (25 ÷ 2) + 10 = 12.5 + 10 = 22.5. Halving alone gives 12.5 (forgets the +10); adding 10 to the original mean before halving, or adding 10 then halving wrong, gives 35; 17.5 mis-halves. The correct new mean is 22.5.

**51. (D)** Recorded total = 12 × 40 = 480. The entry was 91 − 19 = 72 too low, so the true total = 480 + 72 = 552, mean = 552 ÷ 12 = 46. The error of 72 spread over 12 values raises the mean by 6, to 46. Leaving it at 40 ignores the correction; 43 spreads only half the error; 52 adds 12 (the count) wrongly instead of 6.

**52. (D)** For nine sorted values the median is the 5th value. The changes touch only positions 1–4 and 6–9; position 5 is never altered and the order is preserved, so the median stays exactly 40. The symmetric ±100 changes spread the data out far more, but the centre value does not move. Adding 100 to the median (giving 140) or subtracting 100 (giving −60) wrongly assumes the 5th value was among those changed; halving to 20 has no basis. The median's resistance to changes in the tails is the whole point.

**53. (A)** After 10 innings his total is 10 × 45 = 450. To have a mean of 50 over 11 innings, his total must be 11 × 50 = 550. So the 11th innings must add 550 − 450 = 100 runs. Scoring just 50 (the target mean) would give a total of 500 over 11 = 45.5, not 50. The value 55 confuses the score with mean + half the rise; 5 is merely the desired change in the mean.

**54. (B)** Total of all six = 6 × 20 = 120. Three numbers each equal to the mean contribute 3 × 20 = 60. So the remaining three sum to 120 − 60 = 60. The whole total 120 is for all six, not three; 20 is one value; 40 forgets one of the three mean-valued numbers. The other three sum to 60.

**55. (D)** Basket A = 4 × 15 = 60 apples; Basket B = 5 × 10 = 50 apples. So A has more, by 60 − 50 = 10. Even though B shows more SYMBOLS (5 vs 4), the larger scale on graph 1 makes A bigger — symbol counts cannot be compared across different scales. Comparing symbols directly (5 vs 4) wrongly favours B by 1 or claims A by 1; they are not equal.

**56. (D)** Total = 5 × 30 = 150. Subtracting the smallest and largest: 150 − 10 − 60 = 80 is shared equally by the three middle numbers, so each = 80 ÷ 3 ≈ 26.7. The value 80 is their combined total, not each one; 30 just copies the overall mean; 40 wrongly divides 80 by 2. Each middle number is about 26.7.

**57. (C)** Both cities total 180 mm, so seasonal totals match — but matching totals do not mean matching months: P's values are 60, 90, 30 while Q's are 50, 50, 80, a clearly different month-by-month pattern. So 'identical' is wrong even though totals agree. The totals do NOT differ (both 180); equal totals do not make the data identical; and a single largest month (Q's 80) does not mean Q had more rain overall since totals tie.

**58. (D)** Original total = 7 × 18 = 126. New mean 16 over 7 numbers needs a total of 7 × 16 = 112, a drop of 14. Replacing 30 by v changes the total by (v − 30), so v − 30 = −14, giving v = 16. The drop of 14 is the change in total, not the value; 2 is the change in the mean (18 − 16); 30 is the original value. The replacement is 16.

**59. (C)** Adding 100 (well above 40) raises the total, so the mean rises above 40. The mode is the most frequent value; one new 100 cannot outnumber the many 40s, so the mode stays 40. The median, being position-based, shifts only slightly toward the upper-middle (it cannot leap to 100, an extreme). So the mean is most affected, the mode is unmoved, and the median barely moves — the classic outlier pattern. The mode does not become 100 (frequency, not size, defines it); the three do not move together; and adding an extreme value certainly changes the mean.

**60. (C)** Six numbers total 6 × 12 = 72. Eight numbers total 8 × 15 = 120, so the 7th and 8th together = 120 − 72 = 48. Let the 8th be x; the 7th is 2x, so 2x + x = 48, giving 3x = 48, x = 16. The 8th number is 16 (and the 7th is 32). The value 48 is their combined total, not the 8th alone; 24 halves 48 (ignoring that the parts are 2:1, not 1:1); 8 mistakenly splits 48 by 6.
