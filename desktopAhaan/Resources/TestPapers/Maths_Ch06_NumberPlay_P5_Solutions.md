# Solutions — Mathematics (Class 7), Chapter 6: Number Play — Paper 5

**Paper 5 — (progressively harder)**

Marking: **+4** correct, **−1** wrong, **0** unattempted. Maximum marks **240**.

<!--
Coverage matrix (Paper 5 — hardest tier, multi-concept):
- Parity / divisibility chains (9, 3, 11 combined, reversal invariance) ... Q1-Q11
- Virahanka-Fibonacci deep identities, periods, mixed-start tracing ...... Q12-Q23
- Taller-in-front game: inversion counting, bounds, reconstruction ...... Q24-Q33
- 3x3 grids: supercells, magic-square structure, corner/edge algebra ..... Q34-Q44
- Collatz / Kaprekar / iterative number-machines (long traces) .......... Q45-Q52
- Palindromes & digit-rearrangement puzzles (divisibility-constrained) .. Q53-Q60
Every item requires multi-step, multi-concept reasoning; distractors encode the classic single-step misconceptions.
-->

## Answer Key

| Q | Ans | Q | Ans | Q | Ans | Q | Ans | Q | Ans | Q | Ans |
|---|-----|---|-----|---|-----|---|-----|---|-----|---|-----|
| 1 | C | 11 | C | 21 | C | 31 | B | 41 | B | 51 | D |
| 2 | D | 12 | B | 22 | A | 32 | D | 42 | A | 52 | A |
| 3 | A | 13 | B | 23 | B | 33 | C | 43 | D | 53 | C |
| 4 | C | 14 | A | 24 | A | 34 | D | 44 | D | 54 | A |
| 5 | D | 15 | B | 25 | C | 35 | A | 45 | D | 55 | A |
| 6 | C | 16 | A | 26 | A | 36 | B | 46 | A | 56 | C |
| 7 | D | 17 | B | 27 | C | 37 | D | 47 | B | 57 | D |
| 8 | B | 18 | D | 28 | A | 38 | B | 48 | C | 58 | B |
| 9 | A | 19 | D | 29 | C | 39 | D | 49 | A | 59 | B |
| 10 | C | 20 | C | 30 | C | 40 | B | 50 | D | 60 | B |

Answer-key distribution: A = 15, B = 15, C = 15, D = 15.

---

## Worked Solutions

**1. (C)** A number is congruent to its digit-sum for both 9 and 3. 23 divided by 9 leaves remainder 5 (since 9 x 2 = 18, 23 - 18 = 5), so N also leaves 5. Then 23 divided by 3 leaves remainder 2 (3 x 7 = 21, 23 - 21 = 2), so N leaves 2. Taking the digit-sum of 23 again to get 5 and using that for the mod-3 answer is wrong because 5 mod 3 is also 2 by luck but the reasoning differs; claiming the mod-3 remainder is 0 forgets 23 is not a multiple of 3; using remainder 2 for mod 9 confuses the two divisors.

**2. (D)** The digit-sum is 8 + A + 3 + 5 + B = 16 + A + B, which must be a multiple of 9. With B = A + 2 the sum becomes 16 + A + (A + 2) = 18 + 2A. For this to be a multiple of 9, 2A must be a multiple of 9; the only single-digit possibility keeping B = A + 2 a valid digit is A = 0 (sum 18, B = 2, giving 80352). A = 9 would need B = 11, impossible. So A = 0. The decoys 3, 1, 5 give digit-sums 24, 20, 28 — none divisible by 9, so each fails the divisibility-by-9 test.

**3. (A)** For a number with digits d3 d2 d1 d0, the value mod 11 equals the alternating sum d0 - d1 + d2 - d3. Reversing to d0 d1 d2 d3 gives alternating sum d3 - d2 + d1 - d0, the exact negative of the original. So M is congruent to -7 mod 11, and -7 + 11 = 4. Claiming reversal preserves the remainder is true only for palindromes or odd digit-counts; claiming the difference is always a multiple of 11 holds for the DIFFERENCE N - M, not for M itself; the remainder is fully determined as 4.

**4. (C)** An even product needs at least one even factor. An odd sum of three numbers needs an ODD count of odd numbers, so the number of odds is one or three. Three odds would make the product odd, contradicting the even product, so there is exactly one odd — and therefore exactly two even. Check: even + even + odd has one odd (odd count) giving an odd sum, and the two evens make the product even — valid. 'Exactly one even (two odds)' has two odds, an even count, giving an even sum — rejected. All even gives an even sum; all odd gives an odd product. Only exactly two even works.

**5. (D)** A number's digit-sum is a multiple of 3 exactly when the number itself is a multiple of 3 (the divisibility rule). From 1 to 60 the multiples of 3 are 3, 6, ..., 60, which number 60 / 3 = 20. Answering 18 forgets to count both endpoints or miscounts the last term; 21 wrongly includes a non-multiple; 24 confuses the count with multiples of a smaller divisor. The digit-sum rule makes 'digit-sum divisible by 3' identical to 'number divisible by 3'.

**6. (C)** For a 3-digit number with hundreds digit a, tens b, units c, value 100a + 10b + c; its reverse is 100c + 10b + a. The difference is 99(a - c) in absolute value. Setting 99 |a - c| = 297 gives |a - c| = 3. Answering 9 confuses the multiplier 99 with the digit gap; 33 divides 297 by 9 instead of 99; 2 misreads the factor. The tens digit cancels entirely.

**7. (D)** An odd product forces every one of the seven factors to be odd (a single even factor would make the product even). Seven odd numbers form an odd COUNT of odds, so their sum is odd; this holds regardless of the specific odd values. Saying it depends on values ignores that all seven are forced odd; restricting to all-ones is unnecessary since any seven odds work; an even sum is impossible because 7 is odd.

**8. (B)** Write the number with tens digit b and units c. Divisible by 9: 5 + 7 + b + c = 12 + b + c is a multiple of 9, so b + c = 6 or 15. Divisible by 11: the alternating sum (units + hundreds) - (tens + thousands) = (c + 7) - (b + 5) = c - b + 2 must be a multiple of 11, so c - b = -2 (taking 0) or 9. Combine b + c = 6 with c - b = -2: add to get 2c = 4, c = 2, b = 4, giving 5742. Check: 5+7+4+2 = 18 (÷9) and (2+7)-(4+5) = 0 (÷11). The branch b + c = 15 with c - b = -2 gives non-integers, and c - b = 9 forces c > 9. So 5742 is the unique answer. 5715 fails the 11-test, 5760 is not divisible by 11, and 5709 fails divisibility by 9.

**9. (A)** The multiples of 9 in this range run from 108 (= 9 x 12) to 198 (= 9 x 22). That is 22 - 12 + 1 = 11 numbers. Answering 12 forgets that 100/9 rounds up to 12 but 9 x 11 = 99 is below 100; 10 drops an endpoint; 9 miscounts the span. Listing 108, 117, ..., 198 confirms 11 terms.

**10. (C)** Let the number be 10t + u = 6(t + u), so 10t + u = 6t + 6u, giving 4t = 5u, i.e. t/u = 5/4. The single-digit solution is t = 5, u = 4, the number 54. Check: 6 x (5 + 4) = 54. It is even. The decoys 24, 42, 18 do not satisfy 10t + u = 6(t + u): 6 x 6 = 36 not 24; 6 x 6 = 36 not 42; 6 x 9 = 54 not 18. Only 54 fits both conditions.

**11. (C)** A six-digit repdigit equals d x 111111, and 111111 = 111 x 1001 = 111 x 7 x 11 x 13, so 111111 is divisible by 7. Therefore d x 111111 is divisible by 7 for every digit d. Restricting to d = 7 confuses the digit with the divisor; requiring even digits invents an irrelevant parity condition; claiming none work ignores the factorisation 1001 = 7 x 11 x 13.

**12. (B)** Let the first two terms be a and b. Then term3 = a + b = 11, term4 = a + 2b, term5 = 2a + 3b, term6 = 3a + 5b = 47. From a + b = 11 we get a = 11 - b; substitute: 3(11 - b) + 5b = 47, so 33 + 2b = 47, b = 7, and a = 4. Check term6: 3(4) + 5(7) = 12 + 35 = 47, and a + b = 11 — both hold. So the 1st term is 4. A first term of 3 would give term6 = 49; 5 gives 45; 2 gives 51.

**13. (B)** Because the units digits cycle with period 60, term 67 has the same units digit as term 67 - 60 = 7. The 7th term is 13, units digit 3, so the 67th term also ends in 3. Answering 8 takes the 6th term; 1 takes the wrong offset; 6 is unrelated. Reducing the index modulo the period is the key step.

**14. (A)** In each block of 3 consecutive terms exactly one is even (the pattern is Odd, Odd, Even). 100 = 3 x 33 + 1, so there are 33 complete blocks contributing 33 evens, and the leftover 1 term is the first of the next block, which is Odd. Hence 33 evens. Answering 34 wrongly counts the leftover as even; 50 treats parity as alternating; the count is fixed by the period-3 pattern, not the start, so 'depends on start' is false for the standard 1,1,2 sequence.

**15. (B)** Work backwards using prev = current - previous-of-current. Before 72 (with 117 after it) the earlier term is 117 - 72 = 45, so the run going back is ..., 45, 72, 117. Step back: before 45 is 72 - 45 = 27; before 27 is 45 - 27 = 18; before 18 is 27 - 18 = 9. Counting four places before 72: that gives 45 (1 before), 27 (2 before), 18 (3 before), 9 (4 before). So the answer is 9. Answering 18 stops one step short; 27 stops two short; 12 mis-subtracts.

**16. (A)** The sum of the first n terms equals term(n+2) - 1. Here n = 12 terms are listed (ending at 144 = term12), so the sum = term14 - 1. Extend the sequence: term13 = 89 + 144 = 233, term14 = 144 + 233 = 377. Thus the sum = 377 - 1 = 376. The value 375 is one short, 232 mistakes it for term13 - 1, and 377 forgets to subtract 1.

**17. (B)** The terms are a, b, a+b, a+2b, 2a+3b, so the 5th term gives 2a + 3b = 30. Then 2a = 30 - 3b must be positive and even, so b is even and b <= 9: b in {2,4,6,8}. b = 2 gives a = 12 (a > b, rejected); b = 4 gives a = 9 (a > b, rejected); b = 6 gives a = 6 (a = b, valid); b = 8 gives a = 3 (a < b, valid). So the valid pairs are (6,6) and (3,8) — exactly 2. Answering 3 or 4 counts the rejected a > b pairs; 1 misses one valid pair.

**18. (D)** Tilings of length n follow the rule t(n) = t(n-1) + t(n-2): t(7) = 21, t(8) = 34, t(9) = 55, t(10) = 89. Exactly one tiling uses no 2-tile at all (all ten 1-tiles). So tilings with at least one 2-tile = 89 - 1 = 88. Answering 89 forgets to remove the all-singles tiling; 55 gives t(9); 87 subtracts two by mistake. Only one all-1-tile arrangement exists, hence subtract exactly one.

**19. (D)** Going from the 9th to the 15th term is 6 steps, so the growth factor is about 1.618 to the 6th power. 1.618 squared is about 2.618, cubed about 4.24, to the 4th about 6.85, 5th about 11.1, 6th about 17.9 — close to 18. Answering 6 times counts only 4 steps; 1.6 times counts a single step; 11 times uses 5 steps instead of 6. Each step multiplies by roughly 1.618, and there are six of them.

**20. (C)** If two consecutive terms are both multiples of 3, their sum is also a multiple of 3, so by induction every term stays a multiple of 3 once the first two (both 3) are. The sequence 3,3,6,9,15,24,39,... is entirely divisible by 3. Picking the 4th, 6th or 7th term assumes the multiple-of-3 property eventually breaks, but addition preserves a common factor of the seeds forever.

**21. (C)** By the sum identity, the sum of the first 17 terms = term19 - 1. Parity of term19: the pattern O,O,E has period 3, and 19 = 3 x 6 + 1, so term19 is the first in a block, which is Odd. Then term19 - 1 is even. So the sum is even. Answering odd forgets the -1 flips parity; the parity is fully determined by the period-3 pattern, so 'cannot be determined' is wrong.

**22. (A)** The next term is 105 + 170 = 275. Its units digit 5 makes it odd. Answering 275 even ignores the actual digit; 265 mis-adds; 65 subtracts instead of adds (170 - 105). The forward rule adds the two previous terms, giving 275, an odd number.

**23. (B)** The sum of all calls counts exactly the 'taller-ahead' pairs (each call at a position tallies how many earlier children exceed that child's height). The sum 0 + 1 + 2 + 3 + 4 + 5 = 15. This is the maximum, occurring when heights strictly decrease front to back. Answering 21 uses 6 x 7 / 2; 5 takes only the last call; 10 halves the count. The total of the calls IS the inversion count, namely 15.

**24. (A)** Calls 0,1,2,3,4 mean each child has more taller children ahead than the one before, so heights strictly decrease from front to back; the front child is tallest and the back child is shortest. Hence the shortest stands 5th (back). Saying front confuses tallest with shortest; middle ignores the strict ordering; the configuration is forced, so it is determinable.

**25. (C)** A call of k - 1 at the last position means every one of the k - 1 children ahead is taller, so the back child is shorter than all of them — the shortest in the line. Calling it tallest reverses the meaning; median is unsupported; the conclusion is certain because k - 1 is the maximum possible call and saturates it.

**26. (A)** Every call is 0, meaning no child has a taller child ahead, so heights strictly INCREASE front to back and there are no taller-ahead pairs at all. The sum of calls 0+0+...+0 = 0 equals the pair count. Answering 7 or 6 invents pairs; 21 gives the maximum for the reversed order. All-zero calls mean a fully sorted-ascending line, zero inversions.

**27. (C)** The bound at position k is k - 1: position 1 max 0, position 2 max 1, position 3 max 2, position 4 max 3, position 5 max 4. The calls 0,1,1,2,0 satisfy 0<=0, 1<=1, 1<=2, 2<=3, 0<=4 — all within bounds. So none is impossible. Flagging the 2nd, 4th or 5th child mistakes a valid call for a violation; the sequence is realisable.

**28. (A)** The sum of all calls equals the number of taller-ahead pairs. Sum = 0 + 1 + 2 + 0 + 1 + 2 + 3 = 9. Answering 6 drops some terms; 12 over-adds; 21 gives the maximum for a fully reversed line of 7. Simply totalling the calls yields the inversion count, 9.

**29. (C)** Calls 0,1,...,8 for n = 9 mean heights strictly decrease front to back. The middle position is the 5th, whose call is 4 — meaning 4 taller children stand ahead. Since heights strictly decrease, no child behind the 5th is taller, so exactly 4 children in total are taller than the middle child. Answering 5 off-by-ones the position; 8 gives the back child's count; 0 gives the front child's. The call at the middle position directly states the answer, 4.

**30. (C)** Process front to back assigning ranks (1 = shortest among placed so far). Call 0 for child1: no taller ahead. Child2 call 1: one taller ahead (child1 taller than child2). Child3 call 0: no taller ahead, so child3 is taller than both child1 and child2 placed before it. Child4 call 2: exactly two of the three ahead are taller. Since child3 is tallest so far and child1 > child2, the two taller-than-child4 are child3 and child1, so child4 sits below child1 but above child2; final order tallest-to-shortest: child3 > child1 > child4 > child2. The tallest is child3, at the 3rd position. Answering 1st, 4th or 2nd mis-tracks the running comparisons.

**31. (B)** The sum of calls is the inversion count, maximised when every earlier child is taller than every later one — heights strictly decreasing. Then position k contributes k - 1, totalling 0 + 1 + ... + (n - 1) = n(n-1)/2. The formula n(n+1)/2 over-counts by including a phantom pair; n - 1 is just the single largest call; n squared exceeds the maximum possible pair count. The decreasing arrangement saturates every pair as an inversion.

**32. (D)** For 6 children the call-sum (inversion count) ranges from 0 (sorted ascending) to 6 x 5 / 2 = 15 (sorted descending), and every integer in between is achievable by a suitable permutation. 14 is in [0, 15], so it is possible. The total need not be a multiple of 6; the maximum is 15 not 10; distinct heights are required by the game, so 'sharing a height' is irrelevant and false.

**33. (C)** Corners have 2 edge-neighbours, edge-middles have 3, the centre has 4 — fewest is a corner with 2. But a supercell must EXCEED all neighbours, and 1 is the smallest of 1-9, so it can never exceed any neighbour, regardless of position. The centre has the MOST neighbours, not fewest; an edge-middle has 3; and no placement makes 1 a supercell. Fewest neighbours = corner (2), and 1 is never a supercell.

**34. (D)** In the standard 3x3 magic square the centre is always 15 / 3 = 5 (the average of 1-9), and the even numbers 2,4,6,8 sit at the edge-middles while odd 1,3,7,9 sit at the corners. So the centre is 5. Answering 1 or 9 violates the centre-equals-5 theorem (any line through the centre forces it to the mean); the centre is fixed, so 'it varies' is false.

**35. (A)** The whole grid uses 1-9, total 45, so the three row sums add to 45. Given 7 and 23, the middle row is 45 - 7 - 23 = 15. A top row summing to 7 (e.g. 1+2+4) and a bottom summing to 23 (e.g. 9+8+6) leave middle digits 3,5,7 summing to 15 — possible. Answering 14 or 16 mis-subtracts; claiming 15 impossible ignores that the leftover three digits genuinely sum to 15.

**36. (B)** Corners have the fewest neighbours (2 each), so placing the largest values there lets four cells each exceed both their neighbours simultaneously, giving the maximum of 4 supercells (e.g. 9,7,8,6 in corners with smaller numbers on edges/centre). Edge-middles have 3 neighbours and the centre has 4, harder to dominate, and adjacent supercells in one row would conflict (neighbours). The four corners is the optimal configuration.

**37. (D)** Every rotation and every reflection of a magic square is again a magic square (the eight such symmetries are exactly the dihedral group of the square); each one sends the set of lines summing to 15 to itself. Doing two of them in a row still yields a magic square. The diagonals are preserved (they map to diagonals or to each other); the centre stays central under any symmetry; the magic sum 15 is unchanged regardless of its parity.

**38. (B)** Each diagonal is (corner) + 5 + (opposite corner). Diagonal one = 15 means its two corners sum to 15 - 5 = 10; diagonal two = 19 means its two corners sum to 19 - 5 = 14. The four corners are exactly these two diagonal pairs, summing to 10 + 14 = 24. Answering 20 forgets one diagonal's excess; 26 double-counts the centre; 21 mis-adds. Subtract the shared centre once per diagonal, then add.

**39. (D)** The four largest digits are 6,7,8,9 summing to 30, the maximum any four cells (hence the corners) can reach. 28 is below 30 and achievable, e.g. corners 9,8,7,4 or 9,8,6,5. Claiming the max is 24, 26 or 28 understates it; the four-largest bound is 6+7+8+9 = 30, so 28 fits.

**40. (B)** The three row sums total 45 (sum of 1-9). If all three could be 15 the largest would be 15; the standard magic square 8-1-6 / 3-5-7 / 4-9-2 achieves all rows = 15, so the largest row is 15. You cannot do better: three rows summing to 45 must have a largest of at least 45 / 3 = 15. Answering 14 is below the forced average; 16 is achievable but not minimal; 24 is the maximum row, not the minimised largest.

**41. (B)** The left column = (top-left) + (centre) + (bottom-left) = 4 + 5 + (bottom-left) = 18, so bottom-left = 9. The remaining two left-column cells are the centre 5 and the bottom-left 9, summing to 5 + 9 = 14. Answering 11 forgets the corner is excluded from 'remaining'; 13 mis-adds; 9 gives only the bottom-left. Subtract the corner from the column total to confirm, then add the two non-corner cells.

**42. (A)** 9 is the largest, so it is a supercell wherever it goes; 8 is a supercell only if 9 is not one of its neighbours (since 9 > 8). So 9 and 8 must not share an edge — two opposite corners work, each dominating its own two neighbours. Putting 9 in the centre makes it adjacent to potentially 8 and bars 8 nearby; placing them side by side makes 8 lose to its neighbour 9; centre-8 is dominated by an adjacent larger cell. Non-adjacent placement is required.

**43. (D)** Replacing each value v by 16 - v sends 1-9 to 15,14,...,7 — still nine distinct values, and each line of three now sums to 3 x 16 - 15 = 48 - 15 = 33. Since every original line summed to 15, every new line sums to 33, so it remains a magic square (this is the complement map). The sum is not unchanged (each cell changed); the diagonals survive because the transformation is linear and uniform; 48 forgets to subtract the old sum.

**44. (D)** From 7: 7->22->11->34->17->52->26->13->40->20->10->5->16->8->4->2->1. Counting the arrows: 7->22 (1), ->11 (2), ->34 (3), ->17 (4), ->52 (5), ->26 (6), ->13 (7), ->40 (8), ->20 (9), ->10 (10), ->5 (11), ->16 (12), ->8 (13), ->4 (14), ->2 (15), ->1 (16). So 16 steps. Answering 17 over-counts; 11 stops at 5; 15 stops at 2.

**45. (D)** The Collatz trajectory from 27 is famously long (111 steps) and peaks at 9232 before descending to 1. This is a well-known landmark value. 4616 is half of the peak (one halving past it); 6174 is the unrelated Kaprekar constant; 3077 is not on the trajectory. The maximum reached is 9232.

**46. (A)** Step 1 on 3524: descending 5432, ascending 2345, difference 5432 - 2345 = 3087. Step 2 on 3087: descending 8730, ascending 0378, difference 8730 - 378 = 8352. So after two steps the value is 8352. (A third step, 8532 - 2358, would give the famous 6174.) Thus 3087 is the one-step result, 6174 the three-step fixed point, and 2475 is unrelated.

**47. (B)** From 23: 2^2 + 3^2 = 4 + 9 = 13 (step 1); 1^2 + 3^2 = 1 + 9 = 10 (step 2); 1^2 + 0^2 = 1 (step 3). So 23 reaches 1 in exactly 3 steps — it is a 'happy number'. Numbers that are NOT happy fall into the cycle 4,16,37,58,89,145,42,20,4..., but 23 escapes to 1, so the 'never reaches 1' option is wrong here; 5 and 8 steps over-count.

**48. (C)** Trace: 50 (even) ->25 (step1); 25 (odd) ->22 (step2); 22 (even) ->11 (step3); 11 (odd) ->8 (step4); 8 (even) ->4 (step5); 4 (even) ->2 (step6). After exactly 6 steps the value is 2. Answering 1 over-runs by a step; 4 stops at step 5; 0 is never reached.

**49. (A)** 12->6->3->10->5->16->8->4->2->1. Steps: 12->6 (halve), 6->3 (halve), 3->10 (3n+1, odd step), 10->5 (halve), 5->16 (3n+1, odd step), 16->8 (halve), 8->4 (halve), 4->2 (halve), 2->1 (halve). That is 9 steps total; the two odd (3n+1) steps are 3->10 and 5->16, so 9 - 2 = 7 halving steps. Answering all 9 halving forgets the two tripling steps; 10 steps over-counts; 8 steps stops early.

**50. (D)** Step 1 on 297: descending 972, ascending 279, 972 - 279 = 693. Step 2 on 693: 963 - 369 = 594. Step 3 on 594: 954 - 459 = 495, the fixed point. So it takes 3 steps. Stopping at 693 (2 steps) or 594 (which would be the 2-step value) under-counts; 4 over-counts since 495 is reached and stays put at step 3; 1 step gives only 693.

**51. (D)** The digital root equals the number mod 9 (using 9 for multiples of 9). 4004's digit-sum is 4 + 0 + 0 + 4 = 8, already a single digit, so the digital root is 8. Equivalently 4004 mod 9: 4004 = 9 x 444 + 8. Answering 9 would require a multiple of 9; 2 and 4 mis-add the digits. The digital root is 8.

**52. (A)** A palindrome abba has alternating digit-sum a - b + b - a = 0, which is a multiple of 11, so EVERY 4-digit palindrome is divisible by 11. The 4-digit palindromes have a from 1-9 (9 choices) and b from 0-9 (10 choices), giving 9 x 10 = 90. Answering 9 counts only one b; 18 counts two; 45 halves wrongly. All 90 are divisible by 11.

**53. (C)** A palindrome abba is divisible by 9 when 2a + 2b is a multiple of 9, i.e. a + b is a multiple of 9 (since 2(a+b) multiple of 9 needs a+b multiple of 9 as gcd(2,9)=1). Divisible by 4 needs the last two digits 'ba' (10b + a) divisible by 4. We want the largest, so maximise a. a + b multiple of 9 with a as large as possible: a = 9 needs b = 0 or 9. a=9,b=0 -> 9009; last two digits 09 -> 9 not divisible by 4. a=9,b=9 -> 9999; last two 99 not divisible by 4. a=8 needs b=1 (sum 9) or b=10(no): 8118; last two 18 -> not divisible by 4. a=7,b=2 -> 7227, last two 27 no. a=6,b=3 -> 6336, last two 36 -> 36/4 = 9, divisible! Check 9: 6+3+3+6 = 18, divisible by 9. So 6336 works. Larger candidates (9009, 8118, 7227) all fail the divisible-by-4 test, and 9999/8888 are not divisible by 9 and 4 respectively. The largest qualifying palindrome is 6336.

**54. (A)** A two-digit number 10t + u plus its reverse 10u + t equals 11(t + u). Setting 11(t + u) = 121 gives t + u = 11. The digits differ by 3, so combining t + u = 11 with t - u = 3 gives t = 7, u = 4. The number is 74 (or its reverse 47); the larger is 74, and 74 + 47 = 121 with digit gap 3. The decoy 85 gives 85 + 58 = 143; 63 gives 63 + 36 = 99; and a valid pair clearly exists, so 'no such number' is false.

**55. (A)** Largest arrangement 8642, smallest 2468; difference 8642 - 2468 = 6174. Its digit-sum 6 + 1 + 7 + 4 = 18, a multiple of 9, so 6174 is divisible by 9 (indeed any number minus its digit-rearrangement is divisible by 9 since rearranging preserves the digit-sum). 6084 and 5994 are arithmetic slips; the difference IS divisible by 9, so the 'not divisible' option is false. The answer is 6174, divisible by 9.

**56. (C)** Divisibility by 4 depends on the last two digits, which for aba are 'ba' = 10b + a. We need 10b + a divisible by 4 for a in 1-9, b in 0-9. For each fixed a, 10b + a mod 4 = (2b + a) mod 4 (since 10 = 8 + 2, 10b ≡ 2b mod 4). We need 2b + a ≡ 0 mod 4. For a even (a = 2,4,6,8): a mod 4 is 2,0,2,0; we need 2b ≡ -a mod 4. 2b mod 4 is 0 (b even) or 2 (b odd). a=2 needs 2b≡2 -> b odd: 5 values; a=4 needs 2b≡0 -> b even: 5 values; a=6 needs 2b≡2 -> b odd: 5; a=8 needs 2b≡0 -> b even: 5. Odd a (1,3,5,7,9): a is odd so 2b + a is odd, never divisible by 4: 0 values. Total = 5 x 4 = 20. Answering 18 or 25 miscounts the b-parity cases; 10 counts only half the even-a values. The answer is 20.

**57. (D)** The original minus its reverse is 99(a - c) where a > c, giving one of 99,198,...,891 — all 3-digit (after the middle becomes 9) of the form where the result is X. The classic result: original - reverse always yields a number whose reverse added back gives 1089 (e.g. 853 - 358 = 495; 495 + 594 = 1089). This is the famous '1089 trick'. Answering 99 or 198 stops at the subtraction stage; 1000 is a near-miss. Adding the reversal of the difference always lands on 1089.

**58. (B)** A 4-digit palindrome in (1000, 2000) has form 1bb1 (first and last digit 1, since the number is between 1000 and 2000), with the middle two digits equal: 1001, 1111, 1221, ..., 1991. The middle digit b runs 0-9, giving 10 palindromes. But 1001 is greater than 1000 (strictly between holds) and 1991 < 2000. So 10 of them. Answering 9 drops an endpoint value; 11 over-counts; 100 ignores the palindrome constraint. There are 10.

**59. (B)** abcba is divisible by 5 when its last digit a is 0 or 5. But a is also the first digit, which cannot be 0 (or it would not be a 5-digit number), so a must be 5. With a = 5 fixed, b ranges over 0-9 (10 choices) and c over 0-9 (10 choices), giving 10 x 10 = 100 palindromes. Answering 200 wrongly allows a = 0 as well; 180 mixes the counts; 90 drops one value of b.

**60. (B)** There are 5! = 120 arrangements of five distinct digits. A number's parity depends only on its units digit; since every digit 1,3,5,7,9 is odd, the units digit is always odd, so every one of the 120 numbers is odd. Answering 60 assumes half are even (impossible with only odd digits); 24 fixes one position needlessly; 'none guaranteed' contradicts that all digits are odd. All 120 are odd.
