# Solutions — Mathematics (Class 7), Chapter 6: Number Play — Paper 4

**Paper 4 — (progressively harder)**

Marking: **+4** correct, **−1** wrong, **0** unattempted. Maximum marks **240**.

<!--
Parity & divisibility deductions ............ Q1-Q11
Virahanka-Fibonacci (deep tracing/identities) Q12-Q22
Taller-in-front game (bounds & counting) ... Q23-Q31
Grids: supercells, magic squares, sums ..... Q32-Q43
Collatz / number-machine tracing ........... Q44-Q50
Palindromes & digit-manipulation puzzles ... Q51-Q60
-->

## Answer Key

| Q | Ans | Q | Ans | Q | Ans | Q | Ans | Q | Ans | Q | Ans |
|---|-----|---|-----|---|-----|---|-----|---|-----|---|-----|
| 1 | B | 11 | C | 21 | A | 31 | B | 41 | D | 51 | C |
| 2 | A | 12 | A | 22 | A | 32 | A | 42 | B | 52 | D |
| 3 | D | 13 | B | 23 | B | 33 | B | 43 | D | 53 | C |
| 4 | B | 14 | B | 24 | D | 34 | A | 44 | C | 54 | D |
| 5 | D | 15 | D | 25 | A | 35 | C | 45 | B | 55 | B |
| 6 | C | 16 | C | 26 | D | 36 | C | 46 | D | 56 | A |
| 7 | A | 17 | B | 27 | D | 37 | A | 47 | A | 57 | D |
| 8 | D | 18 | B | 28 | C | 38 | C | 48 | A | 58 | A |
| 9 | C | 19 | A | 29 | C | 39 | B | 49 | C | 59 | C |
| 10 | B | 20 | D | 30 | B | 40 | A | 50 | D | 60 | C |

Answer-key distribution: A = 15, B = 15, C = 15, D = 15.

---

## Worked Solutions

**1. (B)** An even count of evens contributes an even subtotal, so the parity of the whole total is decided by the odd numbers. An odd total requires an odd COUNT of odd numbers. Since 7 numbers are used and the even count is even (0, 2, 4 or 6), the odd count is 7, 5, 3 or 1 respectively — all odd, consistent. The smallest of these odd counts is 1 (six evens plus one odd). Thinking the count of odds could be 0 forgets that zero odds gives an even total; thinking it must be 2 confuses 'even count of evens' with 'even count of odds'.

**2. (A)** Four odd numbers sum to an even subtotal (even count of odds), and three even numbers add an even subtotal, so the grand total must be even. 40, 28 and 50 are even and reachable. 37 is odd, so it can never be the total of four odds plus three evens. Choosing an even-looking decoy fails; the parity is fixed even regardless of the actual values.

**3. (D)** List by tens. 1-9: even digit-sums are 2,4,6,8 -> 4 numbers. 10-19: digit-sum = 1+units; even when units is odd (1,3,5,7,9) -> 5 numbers (11,13,15,17,19). 20-29: 2+units even when units even (0,2,4,6,8) -> 5. 30-39: like the tens-1 case -> 5 (31,33,35,37,39). 40-49: like tens-2 -> 5 (40,42,44,46,48). 50: 5+0=5 odd -> 0. Total = 4+5+5+5+5 = 24. Forgetting that 10 itself (sum 1) is odd, or miscounting the 1-9 block, gives 25 or 26.

**4. (B)** A number and its digit-reversal have exactly the same digits, hence the same digit-sum, so they leave the same remainder on division by 9. Since N gives remainder 2, the reversal also gives remainder 2. Answering 7 assumes 9 minus the remainder (a divisibility-by-11 style mistake); 'cannot be determined' overlooks that the digit set is unchanged.

**5. (D)** The five smallest distinct odd numbers are 1, 3, 5, 7, 9, summing to 25. Five odds (an odd count) always give an odd total, and 25 is odd as required. Using 1+3+5 = 9 only counts three numbers; using the first five whole numbers 1+2+3+4+5 = 15 wrongly includes evens.

**6. (C)** For divisibility by 9 the digit-sum must be a multiple of 9. So far 7+3+1 = 11; adding the units digit d must reach the next multiple of 9, which is 18, giving d = 7 (sum 18). The next multiple, 27, would need d = 16, impossible. Choosing 0 (keeping sum 11) or 9 (sum 20) fails the rule; 8 gives sum 19, not a multiple of 9.

**7. (A)** A product is odd only when every factor is odd; a single even factor introduces a factor of 2 and makes the product even. So all three must be odd. 'Exactly one is odd' or 'exactly two are odd' would each include at least one even number, forcing an even product.

**8. (D)** A number is divisible by 3 exactly when its digit-sum is a multiple of 3 — that is the divisibility rule for 3. So 'digit-sum is a multiple of 3' and 'the number is a multiple of 3' are the SAME condition. There can be no number satisfying one but not the other, giving 0. Counting the multiples of 3 (33 of them) or some subset is the trap; the two conditions are identical.

**9. (C)** Alternating sum (units − tens + hundreds − thousands) for 8195: 5 − 9 + 1 − 8 = −11, a multiple of 11, so divisible. For 8196: 6 − 9 + 1 − 8 = −10. For 8159: 9 − 5 + 1 − 8 = −3. For 8519: 9 − 1 + 5 − 8 = 5. Only 8195 gives a multiple of 11. Adding the digits straight (which tests for 9, not 11) is the trap.

**10. (B)** An odd product forces both factors odd. Two odd numbers also sum to an even total (odd + odd = even), so both conditions hold simultaneously. Both even would give an even product; one odd and one even gives an odd sum and an even product — neither matches. The pair certainly exists (e.g. 3 and 5).

**11. (C)** The sum 1+2+...+n equals n(n+1)/2. Its parity is odd exactly when n is 1 or 2 less than a multiple of 4, i.e. n ≡ 1 or 2 (mod 4). Check: n=5 -> 15 odd (ok); n=6 -> 21 odd (ok); n=9 -> 45 odd (ok); n=8 -> 36 even. So n = 8 cannot give an odd total. Picking 5, 6 or 9 ignores that those all DO give odd sums.

**12. (A)** Call the terms a, b, a+b, a+2b, 2a+3b (this is the 5th term) = 30, and the 7th term is 5a+8b = 78. From 2a+3b = 30 and 5a+8b = 78: multiply the first by 8 and the second by 3 -> 16a+24b = 240 and 15a+24b = 234; subtract -> a = 6. The 1st term is 6. Mis-tracking which combination is the 5th vs 7th term yields 3, 9 or 12.

**13. (B)** Listing units digits term by term: T1..T24 give 1,1,2,3,5,8,3,1,4,5,9,4,3,7,0,7,7,4,1,5,6,1,7,8. The 24th entry is 8. Stopping one early lands on 7 (the 23rd) or reading the 22nd gives 1; 6 is the 21st. Careful index counting confirms 8.

**14. (B)** The 8th term equals the 6th plus the 7th: 84 = 32 + (7th), so the 7th term is 52. Halving 84 to get 42, or halving the difference, are the traps; the rule is strictly term7 = term8 − term6.

**15. (D)** This is the sum of the first 10 terms, so it equals the 12th term minus 1. The 12th term is 144, so the sum is 143. Forgetting the '−1' gives 144; using the 11th term (89) path mis-shifts the index.

**16. (C)** Work backwards with earlier = later − the term after it. The term before 89 is 144 − 89 = 55. The term before 55 is 89 − 55 = 34. The term before 34 is 55 − 34 = 21. So three places before 89 is 21. Stopping one step early lands on 34, and going one too far reaches 13.

**17. (B)** Parity repeats every 3 terms as O,O,E. Term 50: 50 = 3×16 + 2, so it is the 2nd in a block, which is O (odd). Positions that are multiples of 3 are the even ones; 50 is not a multiple of 3, so it is odd. Assuming a simple O,E alternation is the trap.

**18. (B)** Even terms occur exactly at positions that are multiples of 3 (the parity pattern is O,O,E repeating). Among positions 1 to 30, the multiples of 3 are 3,6,9,...,30 — that is 30/3 = 10 of them. So 10 terms are even. Halving 30 to get 15 forgets that only one in three is even; off-by-one counting gives 9 or 11.

**19. (A)** The terms are a, b, a+b, a+2b, so the 4th term is a + 2b = 19. With a, b positive whole numbers and a < b: b can be 1..9 but a = 19 − 2b must be positive and less than b. Try b=7 -> a=5 (5<7 ok); b=8 -> a=3 (ok); b=9 -> a=1 (ok); b=6 -> a=7 (7<6 false); b=10 -> a=−1 (invalid). So 3 pairs: (5,7),(3,8),(1,9). Missing the a<b condition or the positivity bound gives 2 or 4.

**20. (D)** The number of tilings of length n follows the rule (length n) = (length n−1) + (length n−2), because the last tile is either a 1-beat (leaving n−1) or a 2-beat (leaving n−2). So length 11 = 89 + 55 = 144. Adding incorrectly or doubling 89 to 178 are the traps.

**21. (A)** Each step multiplies by about 1.618. From the 8th to the 12th term is 4 steps, so the factor is about 1.618^4 ≈ 6.85, i.e. roughly 6.9. (Check with actual terms: 8th = 21, 12th = 144; 144/21 ≈ 6.86.) Using one factor of 1.618 ignores that there are 4 steps; multiplying 1.6 by 4 to get '4 times' confuses adding and multiplying.

**22. (A)** If two consecutive terms are both multiples of 4, their sum is also a multiple of 4, so the property never breaks. Starting 4, 4 keeps every later term divisible by 4 (4,4,8,12,20,32,...). Hence no term escapes. Guessing the 3rd, 5th or 8th term ignores that divisibility by 4 is inherited through the addition rule.

**23. (B)** A call of k means k taller children stand ahead. The kth child (position k, counting from 1) calls k−1, meaning EVERY one of the k−1 children ahead is taller. For this to hold for all positions, each child must be taller than the one behind, i.e. heights decrease from front to back (tallest at front). Reversing this reasoning gives the 'increase' trap; equal heights would make every call 0.

**24. (D)** The back child has 7 children ahead, so at most 7 of them can be taller; the maximum call is 7. Saying 8 forgets that the child does not count itself; saying 6 or 5 undercounts the children ahead.

**25. (A)** Position k allows a maximum call of k−1 (only the k−1 children ahead can be taller). Position 3 may call at most 2, but it called 3 — impossible. Position 2 (max 1) called 1: fine. Position 4 (max 3) called 2: fine. Position 5 (max 4) called 1: fine. Only the 3rd child exceeds its bound.

**26. (D)** The 2nd child calls 1, meaning exactly one child AHEAD (the 1st) is taller. But could children behind also be taller? In the pattern 0,1,2,...,n−1 heights strictly decrease front to back, so everyone behind the 2nd child is shorter. Hence only the 1st child is taller than the 2nd — exactly 1. The call only counts those ahead, but the decreasing arrangement settles the rest. Answering 0 forgets the child ahead; 'n−2' counts those behind as taller.

**27. (D)** Each child at position k calls a value from 0 to k−1, so the possible values overall are 0..5. Six distinct calls drawn from {0,1,2,3,4,5} must use every one of these six values exactly once, giving the set {0,1,2,3,4,5}. Including 6 exceeds the maximum (a child can call at most 5); repeating 0 breaks distinctness.

**28. (C)** A call of 0 means zero taller children stand AHEAD, i.e. that child is at least as tall as everyone in front of it. It need not be the overall tallest (someone behind could be taller) nor at the front (the 4th child can also call 0). Statements about children BEHIND are not constrained by the call.

**29. (C)** The tallest child has no one taller anywhere, so wherever it stands it must call 0 and every child behind that is taller-than-its-predecessors pattern must accommodate it. The 1st child always calls 0. For the tallest to be elsewhere, every child ahead of it would have to be shorter, yet positions 2,4,6 call 1 (one taller child ahead) — so the tallest sits ahead of those, at the front. Position 1 calling 0 with all later odd positions seeing exactly one taller child ahead is consistent only if the tallest is at the front. Assuming back or middle contradicts the calls.

**30. (B)** Each child's call counts exactly the taller children standing ahead of it, so the TOTAL number of (ahead taller, this child) pairs is the sum of all calls: 0 + 1 + 2 + 1 = 4. This counts every inversion where a taller child precedes a shorter one. Summing only the nonzero distinct values (1+2 = 3) or the maximum (6 = all possible pairs) misses the correct tally.

**31. (B)** The total of all calls equals the number of pairs (front child taller than back child). The maximum occurs when heights decrease front to back, making EVERY pair count: the number of pairs among n children is n(n−1)/2. This equals 0+1+2+...+(n−1). Using n(n+1)/2 over-counts by including a child with itself; n−1 is just the back child's maximum, not the total.

**32. (A)** The four edge-middle cells (top, bottom, left, right) are pairwise non-adjacent: no two of them share an edge — any two meet at most at a corner, which is a diagonal touch, not a shared edge. Each edge-middle has as its edge-neighbours only two corners and the centre. Put the four largest numbers 6, 7, 8, 9 in the four edge-middle cells and the five smallest numbers 1-5 in the four corners and the centre. Every edge-middle is then strictly greater than each of its neighbours (all of which are at most 5), so all four edge-middle cells are supercells at once, giving 4. The belief that the shared centre blocks more than two is mistaken — the centre need only be smaller than the surrounding edge-middles, which is easily arranged; answers 3 and 2 undercount for the same reason.

**33. (B)** To maximize the corner sum, place the four largest numbers 9, 8, 7, 6 in the corners: 9+8+7+6 = 30. The remaining 1–5 fill the edges and centre. Nothing forbids the four largest from all being corners. Using 9+8+7+5 = 29 or 9+8+6+5 = 28 fails to pick the top four; 24 picks 9+8+7 only.

**34. (A)** In any 3×3 magic square of 1–9 the centre is 5 and each main-diagonal pair of opposite corners sums to 2×5 = 10 (so the line through them with the centre totals 15). With the top-left = 2, the bottom-right = 10 − 2 = 8. Choosing 6 assumes corners pair to 8; choosing 4 or 9 ignores the fixed centre-5 relationship.

**35. (C)** Multiplying every cell by 3 multiplies each row's sum by 3 as well, so the magic sum becomes 15 × 3 = 45. The square stays magic (all lines scale equally). Adding 3 to the sum gives 18 (confuses adding with multiplying); 135 multiplies by 9; 15 forgets the scaling entirely.

**36. (C)** The top row totals 18 and includes the corner 3, so the other two top-row cells sum to 18 − 3 = 15. (The left column and centre are extra context.) Subtracting from the wrong total (8 − 3 = 5, then 13) confuses row with column; 17 forgets to remove the corner.

**37. (A)** Each diagonal = (its two corners) + centre. Diagonal sums 15 and 21 include the centre 5 once each, so the four corners total (15 − 5) + (21 − 5) = 10 + 16 = 26. Adding the diagonals and subtracting 5 only once (15+21−5 = 31) or twice incorrectly gives 30 or other values.

**38. (C)** The nine numbers 1–9 total 45, and the three row sums add to 45. With two rows at 6 and 24, the third is 45 − 6 − 24 = 15. (6 = 1+2+3 and 24 = 7+8+9 are the only ways to hit those extremes, leaving 4+5+6 = 15.) Forgetting the total-45 constraint or mis-subtracting gives 14, 16 or 12.

**39. (B)** The three row sums add to 45, so their average is 15. The largest row sum is at least the average, i.e. at least 15, and 15 is achievable when all three rows equal 15 (as in a magic square). So the smallest the largest row can be is 15. Believing the rows must differ (forcing 16) ignores that equal rows are allowed; 14 is below the unavoidable average.

**40. (A)** The cell with the most edge-neighbours is the centre, which touches 4 cells. The value 1 is the smallest number, so every neighbour is larger; a supercell must be STRICTLY GREATER than all its neighbours, which 1 can never be. So 4 neighbours and never a supercell. Saying 1 can be a supercell contradicts its being the minimum; the centre has 4, not 2 or 3, neighbours.

**41. (D)** 9 is automatically a supercell wherever it sits (nothing is larger). For 8 to also be a supercell, none of 8's neighbours may exceed it; the only number larger than 8 is 9, so 9 must not be a neighbour of 8 — they cannot share an edge (place them so they are non-adjacent, e.g. opposite corners). Putting 8 in the centre touches all cells including 9's, killing its supercell status; same row often makes them adjacent.

**42. (B)** A 90° rotation turns each row into a column and each column into a row, so every line that summed to 15 still does; the two diagonals swap with each other and each still totals 15; the centre stays in the centre. Hence it remains magic. Rotation preserves all line-sums, so claims that diagonals break or the centre moves are false.

**43. (D)** The nine cells total 45 = (4 corners) + (4 edge-middles) + (centre). With edge-middles = 24 and centre = 5, the corners sum to 45 − 24 − 5 = 16. Forgetting to subtract the centre gives 45 − 24 = 21; subtracting the centre but not the edge-middles, or other slips, give 20 or 29.

**44. (C)** 9 -> 28 -> 14 -> 7 -> 22 -> 11 -> 34 -> 17 -> 52 -> 26 -> 13 -> 40 -> 20 -> 10 -> 5 -> 16 -> 8 -> 4 -> 2 -> 1. Counting the arrows: that is 19 steps. Miscounting by including or excluding the final 1 gives 18 or 20.

**45. (B)** 15 -> 46 -> 23 -> 70 -> 35 -> 106 -> 53 -> 160 -> 80 -> 40 -> 20 -> 10 -> 5 -> 16 -> 8 -> 4 -> 2 -> 1. The peak value is 160. Stopping at an earlier high point (106) or a later one gives the distractors; 160 is the true maximum.

**46. (D)** Step 1: 24 even, largest digit 4 -> 20. Step 2: 20 even, largest digit 2 -> 18. Step 3: 18 even, largest digit 8 -> 10. Step 4: 10 even, largest digit 1 -> 9. After 4 steps the value is 9. Stopping at step 3 (10) or miscounting digits gives 10 or 8.

**47. (A)** From 1 (odd): 3×1+1 = 4. From 4 (even): 2. From 2 (even): 1. So it loops 1 -> 4 -> 2 -> 1 endlessly. It does not freeze at 1 (the 3n+1 rule still fires), never reaches 0 (you cannot halve down past 1), and does not grow unboundedly.

**48. (A)** 19 -> 1²+9² = 1+81 = 82 -> 8²+2² = 64+4 = 68 -> 6²+8² = 36+64 = 100 -> 1²+0²+0² = 1. Counting the arrows: 19->82->68->100->1 is 4 steps. Stopping at 100 (step 3) or overcounting gives the distractors.

**49. (C)** 6 is even, so halve: 6 -> 3 -> 10 -> 5 -> 16 -> 8 -> 4 -> 2 -> 1. Counting arrows gives 8 steps, and the first action on the even 6 is halving to 3. Tripling 6 would mean treating it as odd (wrong); miscounting the chain gives 7 or 9 steps.

**50. (D)** A 4-digit palindrome abba has last two digits 'ba', and divisibility by 4 depends on those last two digits being a multiple of 4. The number is 1001a + 110b. For divisibility by 4, consider the last two digits forming 10b + a (the value 'ba'): need 10b + a ≡ 0 (mod 4), i.e. 2b + a ≡ 0 (mod 4). For each a (1..9) count valid b (0..9). a even: a=2,4,6,8 need 2b ≡ −a ≡ ... let's count by 2b mod4 which is 0 if b even, 2 if b odd. Need 2b ≡ (−a) mod4. For a ≡0 mod4 (a=4,8): need 2b≡0 -> b even (5 values each) = 10. For a ≡2 mod4 (a=2,6): need 2b≡2 -> b odd (5 each) = 10. For a odd, a is odd so a mod4 is 1 or 3, but 2b is always even, so 2b+a is odd, never divisible by 4 — 0 solutions. Total = 10 + 10 = 20. Forgetting a cannot be 0 (it is the leading digit) or miscounting b parity gives 18 or 24.

**51. (C)** For abba, the digit-sum is 2a + 2b = 2(a+b); divisibility by 9 needs 2(a+b) a multiple of 9, so (a+b) must be a multiple of 9 (since 2 shares no factor 9), i.e. a+b = 9 or 18. To maximize, take a = 9; then b = 0 (sum 9) or b = 9 (sum 18). b = 9 gives 9999 (digit-sum 36, divisible by 9) — larger than 9909. So 9999. Stopping at a+b = 9 yields 9909; 9779 and 9889 fail the digit-sum-multiple-of-9 test.

**52. (D)** Let the number be 10t + u with digit-sum t + u; the condition 10t + u = 4(t + u) gives 6t = 3u, so u = 2t. Valid pairs: (t=1,u=2)->12, (t=2,u=4)->24, (t=3,u=6)->36, (t=4,u=8)->48; t=5 needs u=10 (impossible). The largest is 48 (check: 4×(4+8) = 48). Choosing 84 reverses the digits (84 = 4×12 is true but 84's digit-sum is also 12, so 4×12 = 48 ≠ 84 — fails); 36 and 24 are valid but smaller.

**53. (C)** We need b = 2a with a from 1 to 9 (leading digit, nonzero) and b a single digit 0–9. a=1 -> b=2 (121); a=2 -> b=4 (242); a=3 -> b=6 (363); a=4 -> b=8 (484); a=5 -> b=10 invalid. So 4 palindromes. Including a=0 (not allowed as leading digit) or a=5 over-counts to 5; missing one gives 3.

**54. (D)** Let the number be 10t + u; (10t+u) + (10u+t) = 11(t+u) = 88, so t+u = 8. Also |t − u| = 4. Solving t+u = 8 and t−u = 4 gives t = 6, u = 2 (or t = 2, u = 6). The two originals are 62 and 26; the larger is 62. Using a digit-difference of the wrong sign or sum gives 48, 53 or 71.

**55. (B)** A 4-digit palindrome in the 1000s has the form 1bb1 (first digit 1 forces last digit 1, and the two middle digits must match). The middle digit b runs 0 to 9, giving 1001, 1111, 1221, ..., 1991 — that is 10 years. Forgetting 1001 or 1991 as an endpoint gives 9 or 11.

**56. (A)** AB + BA = 11(A + B) = 110, so A + B = 10. With A and B each from 1 to 9: (1,9),(2,8),(3,7),(4,6),(6,4),(7,3),(8,2),(9,1) and (5,5). The distinctness rule removes (5,5), leaving 8 ordered pairs. Forgetting to drop (5,5) gives 9; counting only unordered pairs halves it to 4.

**57. (D)** A 3-digit palindrome aba has digit-sum 2a + b, whose parity equals the parity of b (since 2a is even). An even digit-sum needs b even: b in {0,2,4,6,8} = 5 choices, and a in {1,...,9} = 9 choices (leading digit nonzero). Total = 9 × 5 = 45. Using 10 choices for a (allowing 0) gives 50; using b odd gives the other 45 grouped wrongly.

**58. (A)** A 3-digit number is 100a + 10b + c; its reverse is 100c + 10b + a. The difference is 99a − 99c = 99(a − c), always a multiple of 99 (and hence of both 9 and 11). The single strongest correct statement is 'a multiple of 99'. Saying only 9 or only 11 understates the guaranteed factor; 100 is not a factor.

**59. (C)** A 4-digit palindrome abba is always divisible by 11 (its alternating digit-sum a − b + b − a = 0). For divisibility by 9 the digit-sum 2(a+b) must be a multiple of 9, so a + b must be a multiple of 9. The smallest leading digit a = 1 needs b = 8 (a+b = 9), giving 1881. The smaller palindromes 1001 (a+b=1) and 1221 (a+b=3) fail the 9-rule; 9999 works but is far larger.

**60. (C)** Largest is 4321, smallest is 1234; difference 4321 − 1234 = 3087. Subtracting in the wrong column order (e.g. 4321 − 1243) gives the off-by distractors; careful subtraction confirms 3087.
