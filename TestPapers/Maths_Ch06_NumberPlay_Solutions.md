# Solutions — Mathematics (Class 7), Chapter 6: Number Play

Marking: **+4** correct, **−1** wrong, **0** unattempted. Maximum marks **240**.

<!--
COVERAGE MATRIX (fine-grained; no single sub-topic exceeds ~6 of the 60)
  Taller-children-in-front (encoded info):       Q1, Q2, Q18, Q24, Q32, Q39, Q53, Q58   = 8 (split below)
    - first-child-says-0 / always-true facts:    Q1, Q24, Q32                       = 3
    - possible/impossible sequences & bounds:    Q2, Q39, Q53, Q58                  = 4
    - meaning of a single called number:         Q18                                = 1
  Parity — sums & rules:                         Q3, Q4, Q9, Q12, Q15, Q26, Q36, Q45, Q55, Q60   = 10 (split)
    - parity of a sum / impossible totals:       Q3, Q4, Q12, Q60                   = 4
    - odd-count-of-odds reasoning:               Q9, Q36, Q45, Q55                  = 4
    - parity as proof / true-false rules:        Q15, Q26                           = 2
  Parity of a product:                           Q37                                = 1
  3×3 grid (bounds / 45-invariant):              Q7, Q8, Q14, Q23, Q28, Q38, Q46, Q48   = 8 (split)
    - bounds (min 6 / max 24):                   Q7, Q14, Q28, Q48                  = 4
    - 45-invariant / find missing sum:           Q8, Q23, Q38, Q46                  = 4
  Virahāṅka–Fibonacci sequence:                  Q5, Q10, Q13, Q17, Q19, Q22, Q27, Q30, Q35, Q41, Q43, Q47, Q54, Q59  = 14 (split)
    - next term / recurrence (incl. variants):   Q5, Q17, Q27, Q30, Q41, Q43, Q54   = 7
    - rhythms-from-poetry count:                 Q10, Q35                           = 2
    - nth term:                                  Q13                                = 1
    - golden ratio:                              Q19                                = 1
    - sum identity Fₙ₊₂ − 1:                      Q22, Q59                           = 2
    - parity within the sequence:                Q47                                = 1
  Cryptarithms (letters = digits):               Q6, Q16, Q20, Q34, Q44, Q50, Q56   = 7 (split)
    - T+T+T = UT family:                         Q6, Q16                            = 2
    - AB+BA / other addition puzzles:            Q20, Q34, Q44, Q50                 = 4
    - palindrome cryptarithm:                    Q56                                = 1
  Palindromes / digit reversal:                  Q25, Q29, Q52, Q57                 = 4
  Counting / digit facts (mult of 9, evens):     Q11, Q31, Q33, Q40, Q49, Q51       = 6
  TOTAL = 60. Olympiad-heavy: ~52 of the 60 require multi-step reasoning,
  parity/invariant arguments, recurrence application, or misconception traps;
  only a small anchor set (e.g. Q5, Q19, Q40) is near-recall. At most 5 pure-recall.
-->

## Answer Key

| Q | Ans | Q | Ans | Q | Ans | Q | Ans | Q | Ans | Q | Ans |
|---|-----|---|-----|---|-----|---|-----|---|-----|---|-----|
| 1 | D | 11 | A | 21 | A | 31 | D | 41 | A | 51 | D |
| 2 | B | 12 | C | 22 | B | 32 | A | 42 | D | 52 | B |
| 3 | A | 13 | D | 23 | D | 33 | D | 43 | C | 53 | C |
| 4 | C | 14 | B | 24 | C | 34 | B | 44 | B | 54 | D |
| 5 | C | 15 | C | 25 | C | 35 | C | 45 | A | 55 | B |
| 6 | D | 16 | A | 26 | D | 36 | A | 46 | C | 56 | A |
| 7 | B | 17 | A | 27 | A | 37 | A | 47 | B | 57 | C |
| 8 | A | 18 | D | 28 | B | 38 | C | 48 | D | 58 | D |
| 9 | B | 19 | C | 29 | C | 39 | B | 49 | A | 59 | A |
| 10 | D | 20 | B | 30 | B | 40 | D | 50 | C | 60 | B |

Answer-key distribution: A = 15, B = 15, C = 15, D = 15.

---

## Worked Solutions

**1. (D)** The first child in the line has nobody standing ahead of them, so the number of taller children in front is exactly 0 — always. (Being the "tallest" is option-A's trap: saying 0 only means no one taller is ahead, which is automatic for the front position regardless of height.)

**2. (B)** A child can name at most as many taller children as there are people ahead. In a line of 5, the back child has only 4 ahead, so the largest possible call is 4. "0, 1, 2, 3, 5" ends in 5 — impossible. The others obey the bound (every value ≤ number ahead).

**3. (A)** Five odd numbers always add to an ODD total (odd count of odds → odd). 30 is even, so it can never be the sum. 41, 25 and 15 are all odd and are achievable. So the impossible total is 30.

**4. (C)** Six odd numbers is an EVEN count of odds, so the sum is even. (Actual sum 7+9+11+13+15+17 = 72, even.) Parity is fixed by the count, not the values — so "it depends" is the trap.

**5. (C)** Each term is the sum of the two before: after …, 13, 21 the next is 13 + 21 = 34. (Adding a constant like +12 to get 33 is the "fixed gap" misconception.)

**6. (D)** T + T + T = 3T must be a two-digit number ending in T. Try T = 5: 3×5 = 15, ends in 5 = T, with U = 1. ✓ T = 2 gives 6 (one digit, no U); larger T overshoots the ending-in-T condition. So T = 5.

**7. (B)** The smallest a row can be is the three smallest distinct digits: 1 + 2 + 3 = 6. (1 would need a single cell, not a row sum — that's the trap.)

**8. (A)** The three row sums always total 1+2+…+9 = 45 (the 45-invariant). So the third = 45 − 13 − 17 = 15.

**9. (B)** Exactly 3 odd numbers is an ODD count of odds, which forces an ODD total. An odd total can never be even, so it is impossible — no matter how large the even numbers are. Answer: No.

**10. (D)** Rhythm counts follow 1, 2, 3, 5, … (each the sum of the previous two). For 1 beat: 1 way; 2 beats: 2; 3 beats: 3; 4 beats: 3 + 2 = 5. So 5 rhythms.

**11. (A)** Three distinct digits from 1–9 summing to 24 must be the three largest, 7 + 8 + 9 = 24 (the maximum). 8+9+6 = 23 and 6+8+7 = 21 fall short; 9,9,6 repeats a digit. So 7, 8, 9.

**12. (C)** Parity of each: four odds → even; first 10 evens → even; three evens + two odds → even (two odds make even); seven odds → ODD (odd count of odds). So the odd one is "the sum of seven odd numbers."

**13. (D)** 1, 1, 2, 3, 5, 8, 13, 21, 34 — the 9th term is 34. (21 is the 8th — an off-by-one trap.)

**14. (B)** The largest a row of three distinct digits from 1–9 can reach is 7 + 8 + 9 = 24. Since 26 > 24, no row can sum to 26. (Divisibility by 3 is irrelevant here.)

**15. (C)** (2m+1) + (2n+1) = 2m + 2n + 2 = 2(m + n + 1), a multiple of 2 — hence even — for ALL whole m, n. This is a general proof that odd + odd is ALWAYS even (not just in examples).

**16. (A)** From Q6, 5 + 5 + 5 = 15, so UT = 15: the tens digit U = 1.

**17. (A)** Apply "add the previous two" from 4, 7: 4+7 = 11, 7+11 = 18, 11+18 = 29 → 4, 7, 11, 18, 29. (Option B adds a constant 3; D mis-adds 11+8.)

**18. (D)** The number a child calls is, by the rule of the game, exactly how many TALLER children stand ahead of them — here, 3. It says nothing certain about their rank, position in line, or how many are behind.

**19. (C)** Ratios of consecutive terms (2/1, 3/2, 5/3, 8/5, 13/8, …) close in on the golden ratio φ ≈ 1.618. (Not 2, 1.5, or π ≈ 3.14.)

**20. (B)** AB + BA = (10A + B) + (10B + A) = 11A + 11B = 11(A + B) = 132 → A + B = 132 ÷ 11 = 12.

**21. (A)** An EVEN count of odd cards gives an even sum; an odd count gives odd. 30 is even, so the count must be even — among the options only 4 is even. (4 odds, e.g. 3+5+9+13 = 30. ✓)

**22. (B)** Add directly: 1+1 = 2, +2 = 4, +3 = 7, +5 = 12, +8 = 20, +13 = 33, +21 = 54. (The identity gives F₁₀ − 1 = 55 − 1 = 54 too — choosing 55 forgets the "−1".)

**23. (D)** The nine entries are 1–9 once each, totalling 45; the three row sums partition all nine cells, so they add to 45 (the 45-invariant) regardless of arrangement.

**24. (C)** The front child has no one ahead, so they always call 0 — always true. The numbers need not increase, need not all differ, and no one is forced to exceed 0 (e.g. everyone in increasing-height order calls 0).

**25. (C)** Two-digit palindromes have equal digits: 11, 22, 33, 44, 55, 66, 77, 88, 99 — that's 9. (10 wrongly counts 00; 11/18 over-count.)

**26. (D)** even+even = even ✓, odd+odd = even ✓, even+odd = odd ✓ are all true. "odd + odd = odd" is FALSE (two odds give an even). So the false one is (D).

**27. (A)** Sequence 1, 2, 3, 5, 8, 13, 21: 6th term = 13, 7th term = 21, sum = 13 + 21 = 34. (This sum is also the 8th term.)

**28. (B)** The smallest possible sum of three distinct digits from 1–9 is 1 + 2 + 3 = 6, so a row can never sum to 4. (Being even or not a multiple of 3 is not the reason.)

**29. (C)** Palindromes just above 121: 122 isn't a palindrome (221 reversed), but 131 reads the same both ways and is the next one larger than 121. (211 reverses to 112; 212 is larger than 131.)

**30. (B)** Consecutive terms satisfy x + y = (next term) = 21. With y = 13, x = 21 − 13 = 8. (Indeed …, 8, 13, 21, … is the Fibonacci run.)

**31. (D)** 2T must be a two-digit number with tens digit 1, i.e. 10 ≤ 2T ≤ 19. The smallest T with 2T ≥ 10 is T = 5 (2×5 = 10). (T = 4 gives 8, only one digit.)

**32. (A)** Calling "0" always means no taller child stands ahead — that is its exact meaning for any position, including the back. It does NOT force the line to have one child or make that child the shortest (others ahead could be shorter).

**33. (D)** Five consecutive whole numbers n, …, n+4 sum to 5n + 10 = 5(n + 2), a multiple of 5. Among the options only 30 is a multiple of 5 (30 = 4+5+6+7+8). 32, 36, 38 are impossible.

**34. (B)** 1A + A1 = (10 + A) + (10A + 1) = 11 + 11A = 33 → 11A = 22 → A = 2. Check: 12 + 21 = 33. ✓

**35. (C)** Rhythm counts: 1, 2, 3, 5, 8 for 1, 2, 3, 4, 5 beats. So 5 beats give 8 rhythms (5 + 3 from the recurrence). (13 is for 6 beats.)

**36. (A)** A sum of odds is even only when the COUNT of odds is even. Among the options only 6 is even, so 6 odd numbers can sum to even. (5, 3, 1 are odd counts → odd total.)

**37. (A)** Odd × odd = odd: writing them 2m+1 and 2n+1, the product is 4mn + 2m + 2n + 1 = 2(2mn + m + n) + 1, which is one more than an even number — odd. (Multiple of 4 fails, e.g. 3×5 = 15.)

**38. (C)** The three column sums also total 45 (every cell counted once). So the third column = 45 − 15 − 18 = 12.

**39. (B)** In a line of 4, the back child has 3 people ahead, so at most 3 of them can be taller — the greatest value c can call is 3. (4 would need 4 children ahead, but only 3 exist.)

**40. (D)** A number is divisible by 9 when its digit sum is. 2+3+4 = 9 ✓ (234). 3+4+3 = 10, 5+1+2 = 8, 7+0+0 = 7 — none divisible by 9. So 234.

**41. (A)** In an "add the previous two" sequence, the term before 19 plus 19 gives the next term 31, so it is 31 − 19 = 12. Check: 12, 19, 31 (12 + 19 = 31). ✓

**42. (D)** Checking three examples cannot PROVE a universal claim — examples can only suggest a pattern or disprove it with a counterexample. The conclusion happens to be true (provable by 2m+1 + 2n+1 = even), but her reasoning by examples is not a proof.

**43. (C)** Continue 2, 5, 7, 12, 19 by adding the last two: 12 + 19 = 31. (Same recurrence, different start.)

**44. (B)** In a cryptarithm, different LETTERS must stand for different digits; A and B are different letters, so they cannot both be 6. (Also 66 + 66 = 132 numerically, but the rule, not the arithmetic, forbids it.)

**45. (A)** Odd numbers from 1 to 20: 1, 3, 5, …, 19 — that's 10 of them. Ten is an EVEN count of odds, so their sum is even (in fact 100). So: 10 odd numbers, sum even.

**46. (C)** Row sums total 45. With top = 6 and bottom = 24, the middle = 45 − 6 − 24 = 15.

**47. (B)** Terms 1, 2, 3, 5, 8, 13, 21, 34: the 8th term is 34, which is even. (The parity pattern O, E, O, O, E, O, O, E confirms the 8th slot is E.)

**48. (D)** A valid row uses three DISTINCT digits. "1, 2, 2" repeats 2, so it cannot be a row of a 1–9 grid (every digit appears once). 1+2+3 = 6, 7+8+9 = 24, 4+5+6 = 15 are all legal sums; 1,2,2 is the impossible set.

**49. (A)** Doubling any whole number gives an even result, so 2N always ends in an even digit (0, 2, 4, 6 or 8). 7 is odd, so it can NEVER be the units digit of 2N. (4, 0, 8 are all even and possible.)

**50. (C)** AA + A = 11A + A = 12A. For the answer to end in A we need 12A ≡ A (mod 10), i.e. 2A ≡ 0 (mod 10), so A = 0 or 5; A is non-zero, so A = 5 → 12×5 = 60, which ends in 0, not 5. No non-zero digit works, so it is impossible.

**51. (D)** 2 + 4 + … + 20 = 2(1 + 2 + … + 10) = 2 × 55 = 110. (90 forgets the doubling; 100 is the count-of-odds sum from Q45.)

**52. (B)** A palindrome reads the same reversed. 252 reversed is 252 ✓. 120→021, 102→201, 210→012 — none match. So 252.

**53. (C)** In the sequence 0, 1, 1, 3 the FIRST child calls 0 (nobody ahead), so "the 1st child says a number larger than 0" MUST be false. The other statements correctly read off the sequence (2nd→1, 4th→3, 3rd→1), all of which are possible.

**54. (D)** 12th term = 10th + 11th = 55 + 89 = 144. (Adding wrong pairs gives the traps 134/110/121.)

**55. (B)** An EVEN count of odd numbers always sums to an even number (the odds pair up). It need not be a multiple of 4 (e.g. 3 + 3 = 6). So the total is guaranteed even.

**56. (A)** ABC × 1 = ABC, and the puzzle sets this equal to CBA. ABC = CBA means the number reads the same reversed — it must be a palindrome. (It need not be even, a multiple of 9, or a multiple of 11.)

**57. (C)** A number between 100 and 200 reading the same reversed has the form 1X1 (first and last digit 1). X can be 0–9: 101, 111, …, 191 — that's 10 numbers.

**58. (D)** Each value must not exceed the number of children ahead: positions 1–6 have 0,1,2,3,4,5 ahead. The calls 0,1,2,1,4,0 satisfy 0≤0, 1≤1, 2≤2, 1≤3, 4≤4, 0≤5 — every value is individually possible. So none is definitely impossible.

**59. (A)** Add directly: 1 + 1 + 2 + 3 + 5 = 12. (The identity gives F₇ − 1 = 13 − 1 = 12 too — choosing 13 forgets the "−1".)

**60. (B)** Five distinct odd numbers form an ODD count of odds, so their sum is always ODD. 100 is even, so the total can never be 100. (35, 49, 63 are all odd and achievable.)

---
*Solutions complete: 60 / 60.*
