# Solutions — Mathematics (Class 7), Chapter 6: Number Play — Paper 3

**Paper 3 — (progressively harder)**

Marking: **+4** correct, **−1** wrong, **0** unattempted. Maximum marks **240**.

<!--
Taller children in front (sequence feasibility): Q1, Q9, Q17, Q33, Q45.
Parity of sums of odd/even numbers: Q2, Q10, Q21, Q29, Q41, Q53.
Virahanka-Fibonacci sequence and beat rhythms: Q3, Q12, Q24, Q35, Q44, Q56.
Cryptarithms / digit puzzles: Q4, Q14, Q26, Q38, Q49, Q58.
Supercells and grid filling: Q5, Q15, Q27, Q39, Q51.
Magic squares and row/column/diagonal logic: Q6, Q16, Q28, Q40, Q50, Q60.
Collatz (3n+1) process: Q7, Q18, Q30, Q42, Q54.
Kaprekar's 6174 routine: Q8, Q19, Q31, Q43, Q55.
Palindromes: Q11, Q22, Q34, Q46, Q57.
Digit-sum and divisibility reasoning: Q13, Q23, Q32, Q47, Q52, Q59.
Place-value and smallest/largest number puzzles: Q20, Q25, Q36, Q37, Q48.
Mixed parity / number-property synthesis: Q40 (also magic), Q48, Q60.
-->

## Answer Key

| Q | Ans | Q | Ans | Q | Ans | Q | Ans | Q | Ans | Q | Ans |
|---|-----|---|-----|---|-----|---|-----|---|-----|---|-----|
| 1 | A | 11 | B | 21 | C | 31 | A | 41 | D | 51 | B |
| 2 | B | 12 | A | 22 | A | 32 | C | 42 | B | 52 | A |
| 3 | A | 13 | C | 23 | B | 33 | B | 43 | A | 53 | D |
| 4 | D | 14 | C | 24 | D | 34 | A | 44 | D | 54 | D |
| 5 | C | 15 | D | 25 | B | 35 | D | 45 | A | 55 | D |
| 6 | B | 16 | C | 26 | D | 36 | D | 46 | C | 56 | C |
| 7 | B | 17 | B | 27 | A | 37 | D | 47 | C | 57 | A |
| 8 | D | 18 | B | 28 | A | 38 | C | 48 | C | 58 | A |
| 9 | B | 19 | A | 29 | A | 39 | C | 49 | B | 59 | D |
| 10 | B | 20 | D | 30 | C | 40 | B | 50 | C | 60 | C |

Answer-key distribution: A = 15, B = 15, C = 15, D = 15.

---

## Worked Solutions

**1. (A)** A child can only count taller children standing AHEAD, so the call at position p (counting from the front, the first child being position 1) can be at most p - 1. Check each call against this bound: the 1st child (0 ahead) can say at most 0, and says 0 - fine; the 2nd (1 ahead) can say at most 1, says 1 - fine; the 3rd child has only 2 people ahead, so the most it could ever say is 2, yet it says 3 - impossible; the 4th (3 ahead) says 0 - fine; the 5th (4 ahead) says 2 - fine; the 6th (5 ahead) says 1 - fine. Only the 3rd child's call of 3 breaks the bound, so that call is the impossible one. The first child's 0 is always correct, and the 5th and 6th calls are well within their limits.

**2. (B)** Even numbers contribute nothing to parity - any count of them sums to an even amount. So the total's parity equals the parity of the sum of the 5 odd numbers. An odd COUNT of odd numbers gives an odd sum (each odd is 1 more than an even, and 5 such 'extra ones' add to an odd surplus). Hence the total is odd, regardless of the actual sizes. The 'even' answer wrongly assumes any mix balances out; the 'depends on the even/odd values' answers ignore that parity is fixed purely by the COUNT of odds, not their magnitudes.

**3. (A)** Call the first two terms a and b. Then the 3rd term is a+b, the 4th is a+2b, the 5th is 2a+3b and the 6th is 3a+5b. We are told a+2b = 13 and 3a+5b = 34. From the first, a = 13 - 2b. Substitute into the second: 3(13 - 2b) + 5b = 39 - 6b + 5b = 39 - b = 34, so b = 5 and a = 13 - 2(5) = 3. Check the 6th term: 3(3) + 5(5) = 9 + 25 = 34 ✓. So the 1st term is 3. The value 2 comes from misreading which term equals 13; 5 confuses the first term with b; 1 is the default Fibonacci start that does not fit the data.

**4. (D)** Adding AB three times gives 3 x AB. We need 3 x AB to be a three-digit number whose last two digits are AB itself, i.e. 3 x AB = 100C + AB, so 2 x AB = 100C, AB = 50C. For AB to be two digits, C = 1 gives AB = 50 and 3 x 50 = 150 = C A B with C=1, A=5, B=0 ✓. C = 2 would give AB = 100, too big. So AB = 50. The value 25 gives 75 (not ending in 25); 75 gives 225 (ends in 25, not 75); 10 gives 30 (not three digits).

**5. (C)** Two edge-adjacent cells can never both be supercells, since each would have to exceed the other. So the supercells form an 'independent set': no two share an edge. On the 3x3 grid the four corners and the centre are pairwise non-edge-adjacent (each corner touches only edge-midpoints, and the centre also touches only edge-midpoints), so these 5 cells form a checkerboard pattern. Place the four SMALLEST values 1,2,3,4 on the four edge-midpoints and the five largest 5,6,7,8,9 on the corners and centre: then every corner (>=6) beats its two edge-midpoint neighbours (all <=4), and the centre (5) beats its four edge-midpoint neighbours (1,2,3,4). All 5 chosen cells are supercells at once. No arrangement beats 5, because a 6th supercell would have to be an edge-midpoint, which is edge-adjacent to two corners that are already larger. So the maximum is 5. Answering 4 stops one short (it forgets the centre joins the four corners as a non-adjacent fifth); 3 undercounts; 9 is impossible since edge-adjacent cells block each other.

**6. (B)** The total 1+2+...+9 = 45 splits into 3 equal rows, so the magic sum is 45/3 = 15. The centre cell lies on 4 lines (one row, one column, two diagonals). Summing those 4 lines counts the centre 4 times and every other cell once; that total is 4 x 15 = 60, while the eight non-centre cells sum to 45 - centre. So 60 = (45 - centre) + 4 x centre = 45 + 3 x centre, giving 3 x centre = 15, centre = 5. A centre of 4 is therefore impossible. The 'centre must be 9' answer confuses largest with central; the 'must be odd' answer states a true fact (centre is 5, odd) but for the wrong reason; the 'any digit' answer is simply false.

**7. (B)** Apply the rule from 6: 6 is even -> 3; 3 is odd -> 3(3)+1 = 10; 10 -> 5; 5 is odd -> 16; 16 -> 8; 8 -> 4; 4 -> 2; 2 -> 1. Counting the arrows: 6->3->10->5->16->8->4->2->1 is 8 steps. The answer 7 forgets to count the final 2->1; 9 double-counts a step; 6 stops early at 4 or 2.

**8. (D)** Kaprekar's constant for four-digit numbers is 6174: from 7641 - 1467 = 6174, the routine reproduces 6174 forever, and every starting four-digit number (not all-equal digits) reaches it within at most 7 steps. 1089 is the famous three-digit-reverse-product curiosity, not the Kaprekar fixed point; 9999 has all equal digits and gives 0, which is the degenerate case the rule excludes; 0 is only reached when all four digits are equal, which is barred. So the universal landing value is 6174.

**9. (B)** A child's call counts taller children standing AHEAD, so the call at position p (front child = position 1) can be at most p - 1. The 2nd child has only 1 person ahead, so the largest number it could possibly say is 1, yet it says 2 - more taller children than there are people in front of it. That is impossible regardless of heights, so the sequence fails right there. The first child saying 0 is always correct (nobody is ahead); calls can certainly exceed 1 further back (e.g. a 4th child could say 3); and calls need not increase - patterns like 0,1,0 are perfectly valid.

**10. (B)** The count of beat-patterns of length n follows the Virahanka-Fibonacci rule: a pattern either starts with a short (leaving n-1 beats) or a long (leaving n-2 beats), so C(n) = C(n-1) + C(n-2). With C(1)=1, C(2)=2, we get C(3)=3, C(4)=5, C(5)=8, C(6)=13, C(7)=21, C(8)=34. So 34 rhythms. The value 21 is C(7) (off by one beat); 55 is C(9) (one too many); 32 = 2^5 wrongly treats every beat as a free binary choice, ignoring that longs use two beats.

**11. (B)** A three-digit palindrome has the form aba with a from 1-9 and b from 0-9; there are 9 x 10 = 90 of them. Its digit sum is 2a + b, and it is divisible by 3 exactly when 2a + b is a multiple of 3. For each fixed a (9 choices), b ranges over 0-9 (10 values); among any 10 consecutive integers the residues mod 3 are not perfectly even, but 2a+b runs through 10 consecutive values as b goes 0-9, of which either 3 or 4 are multiples of 3. Counting precisely: b in {0..9} gives multiples of 3 at b values making 2a+b divisible by 3 - exactly 3 or 4 per a. Summing over all a, the multiples of 3 among palindromes total 90/3 = 30, since the map is uniform across the full set (the palindromes aba in order 101,111,...,999 hit every residue class equally often: exactly one third). Hence 30. The value 90 is the count of ALL palindromes; 33 and 27 come from miscounting b-values per a.

**12. (A)** List terms (term 1 = 1): 1,1,2,3,5,8,13,21,34,55,89,144,233,377,610. The 15th term is 610, whose units digit is 0. Tracking only units digits also works: 1,1,2,3,5,8,3,1,4,5,9,4,3,7,0 - the 15th units digit is 0. The value 7 is the units digit of the 14th term (377); 5 is the 10th term's units digit (55); 1 is the units digit of several early terms but not the 15th.

**13. (C)** A 4-digit palindrome has the form abba with digit sum 2a + 2b = 2(a+b). It is divisible by 9 when 2(a+b) is a multiple of 9, i.e. a+b is a multiple of 9 (since 2 and 9 share no factor). To be smallest, take a = 1 (smallest leading digit), so b must make a+b a multiple of 9: a+b = 9 gives b = 8. The number is 1 8 8 1 = 1881, and 1+8+8+1 = 18 is divisible by 9. The value 1001 has digit sum 2 (not divisible by 9); 1111 has digit sum 4; 1818 is not a palindrome (reversed it is 8181).

**14. (C)** Writing the two-digit numbers in place value, AB + BA = (10A + B) + (10B + A) = 11(A + B) = 99, so A + B = 9. Both AB and BA must be real two-digit numbers, so A >= 1 and B >= 1 (no leading zero); thus B cannot be 0. With A > B and A + B = 9 and B >= 1, the pairs are (8,1), (7,2), (6,3) and (5,4) -- exactly 4. Counting (9,0) as well gives 5, but BA would be '09', not a two-digit number, so it is excluded. Answering 9 confuses the digit count with the sum; 8 double-counts by allowing B > A as well.

**15. (D)** In any 3x3 magic square of 1-9 the centre is forced to 5 (the magic sum is 45/3 = 15, and the centre, lying on 4 lines, must equal 15/3 = 5 by the line-counting argument). The corners must be the four even numbers 2,4,6,8 and the edge-midpoints the remaining odds 1,3,7,9 - this is exactly the structure of the standard magic square. So whatever placement of the even corners, the centre is 5. The values 4, 6 are corner numbers (even), not the centre; 9 is an edge number here, never the centre.

**16. (C)** From 7: 7 is odd -> 22; 22 -> 11; 11 -> 34; 34 -> 17; 17 -> 52; 52 -> 26; 26 -> 13; 13 -> 40; 40 -> 20 -> 10 -> 5 -> 16 -> 8 -> 4 -> 2 -> 1. The peak values along the way are 22, 34, 52, 40 - the maximum is 52. The value 40 is a later local high but smaller than 52; 26 and 22 are intermediate values, not the maximum.

**17. (B)** The first child always says 0, meaning no taller child stands ahead - trivially true since nobody is ahead. But the question asks how many taller children there are anywhere relative to the first child. With calls 0,1,2,3,4,5 strictly increasing, each successive child has one more taller person ahead, which is the pattern when the line is arranged from tallest at front to shortest at back: the front child is the TALLEST of all, so zero children are taller than the first child. The value 5 confuses the back child's call with the first child; 1 misreads the second child's call; it is fully determined, so 'cannot be determined' is wrong.

**18. (B)** For three-digit numbers Kaprekar's constant is 495: e.g. from 954 - 459 = 495, and 954-459 reproduces 495. Every three-digit number with at least two distinct digits reaches 495 within a few steps. 6174 is the FOUR-digit Kaprekar constant - the classic trap of using the wrong width; 999 is a repdigit which gives 0; 0 only occurs for repdigits, which the rule excludes.

**19. (A)** There must always be at least one supercell: the cell holding 9, the largest number, exceeds all of its neighbours (nothing is bigger), so 9's cell is always a supercell. Hence 0 is impossible. Can we hold the count to exactly 1? Place 9 in the centre so it neighbours 4 cells; arrange the rest so that no other cell beats all its neighbours - e.g. make the grid increase toward the centre along every path so only the centre is a local maximum. This is achievable, giving exactly 1 supercell. The value 0 ignores that 9 is always a supercell; 2 and 4 overstate the forced minimum.

**20. (D)** There are 9 terms here (up to 34, the 9th term). By the identity, the sum of the first 9 terms equals the 11th term minus 1. The sequence is 1,1,2,3,5,8,13,21,34,55,89, so the 11th term is 89, and the sum is 89 - 1 = 88. Direct addition confirms: 1+1+2+3+5+8+13+21+34 = 88. The value 89 forgets to subtract 1 (it is the 11th term itself); 87 over-subtracts; 143 mistakenly adds the 10th term 55 as well.

**21. (C)** We need three different non-zero digits adding to 6; the only such set is {1, 2, 3} (since 1+2+3 = 6 and any other distinct non-zero triple exceeds 6). To make the largest number, place the digits in descending order: 3, 2, 1 -> 321. The value 411 repeats the digit 1 and uses a zero-free but non-distinct set; 312 is a valid arrangement of 3,1,2 but smaller than 321; 123 is the smallest arrangement.

**22. (A)** Parity of a sum depends only on the count of odd addends. Here 4 odds are present; an even count of odd numbers sums to an even amount, and the remaining 5 even numbers add nothing to parity. So the total is even - consistent. The claim that 9 numbers always sum odd is false (parity depends on how many are odd, not the total count); the equality condition is irrelevant to parity; and 4 odds give an EVEN, not odd, sum - that distractor inverts the rule.

**23. (B)** A 4-digit palindrome has the form abba with leading digit a from 1-9 and inner digit b from 0-9. The smallest takes the smallest leading digit and smallest inner digit: a = 1, b = 0 gives 1001. The largest takes a = 9, b = 9 giving 9999. Their sum is 1001 + 9999 = 11000. The value 10890 mistakenly treats 0990 as the smallest (which is not a 4-digit number); 10989 is an addition slip; 9999 forgets to add the smallest palindrome at all.

**24. (D)** Top row sums to 8 and includes the corner cell (1), so its other two cells sum to 8 - 1 = 7. Left column sums to 11 and includes the same corner cell (1), so its other two cells sum to 11 - 1 = 10. The 'other' cells of the row and the 'other' cells of the column are four distinct cells (none is the shared corner), so together they sum to 7 + 10 = 17. The value 19 forgets to remove the corner from BOTH lines; 18 removes it once; 16 subtracts an extra 1.

**25. (B)** At 1 (odd) the rule 3n+1 gives 4; 4 -> 2; 2 -> 1; and the loop repeats: 1 -> 4 -> 2 -> 1. So once you reach 1, the process enters the cycle 1,4,2 indefinitely. It does not freeze at 1 (the rule still applies to 1), it does not grow forever, and it never reaches 0 (the rule keeps numbers positive). This 1-4-2 loop is exactly why 1 is treated as the stopping point in the puzzle.

**26. (D)** Let the number be 10t + u; its reverse is 10u + t, and their sum is 11(t + u) = 143, so t + u = 13. The extra condition that the digits differ by 1 means t - u = 1 (taking t larger). Solving t + u = 13 and t - u = 1 gives t = 7, u = 6, so the larger number is 76 (and 76 + 67 = 143 ✓). The pair (9,4) gives 94 but the digits differ by 5, not 1; (8,5) gives 85 with a difference of 3; 67 is the reverse (smaller) number, not the original larger one.

**27. (A)** The result must end in B, the units digit of AB, so 3 x B must end in B, meaning 2B is a multiple of 10, giving B = 0 or B = 5. Try B = 5 with various tens digits: 35 x 3 = 105 (digits 1,0,5 - not CCB), 45 x 3 = 135 (no), 65 x 3 = 195 (no), 75 x 3 = 225 (digits 2,2,5 - that IS CCB with C = 2 and B = 5, and units 5 matches the units of 75 ✓). Check 85 x 3 = 255: digits 2,5,5 - the first two differ, so 85 fails. So the unique answer is 75. The value 85 gives 255 (leading digits unequal); 45 gives 135 (not CCB); 37 gives 111 whose units 1 does not match the units of 37.

**28. (A)** Check each: 1(odd),1(odd),2(even),3(odd),5(odd),8(even),13(odd),21(odd),34(even),55(odd). The even terms are 2, 8, 34 - that is 3 of them. The pattern of parity is O,O,E repeating, so every third term is even; among 10 terms positions 3, 6, 9 are even, giving 3. The value 4 over-counts; 2 misses one; 5 confuses odds with evens (there are 7 odds).

**29. (A)** A 3-digit palindrome aba is a multiple of 11 when its alternating digit sum a - b + a = 2a - b is a multiple of 11. With a from 1-9 and b from 0-9, 2a - b ranges from -9 to 18, so the only multiples of 11 in range are 0 and 11. For 2a - b = 0: b = 2a, valid for a=1 (121), a=2 (242), a=3 (363), a=4 (484) - 4 numbers (a=5 needs b=10, invalid). For 2a - b = 11: b = 2a - 11, valid for a=6 (616), a=7 (737), a=8 (858), a=9 (979) - 4 numbers (a=5 gives b=-1, invalid). Total 4 + 4 = 8. The value 9 over-counts by one near-miss; 10 over-counts further; 90 is the count of ALL 3-digit palindromes, not just the multiples of 11.

**30. (C)** From 11: 11->34->17->52->26->13->40->20->10->5->16->8->4->2->1. Count the arrows: 11->34 (1), ->17 (2), ->52 (3), ->26 (4), ->13 (5), ->40 (6), ->20 (7), ->10 (8), ->5 (9), ->16 (10), ->8 (11), ->4 (12), ->2 (13), ->1 (14). So 14 steps. The value 13 forgets the final 2->1; 15 adds a phantom step; 12 miscounts the descent.

**31. (A)** The centre lies on the middle row, the middle column, and BOTH main diagonals - that is 1 + 1 + 2 = 4 lines. This is exactly why the centre is so constrained in a magic square. A corner lies on 3 lines (its row, column, one diagonal); an edge-midpoint lies on only 2. The value 2 is the edge-cell count; 3 is the corner count; 8 is the total number of lines, not how many touch the centre.

**32. (C)** Five odd numbers - an odd count of odds - always sum to an ODD total. So any even total is impossible. Among the choices, 40 is even, hence unreachable; 35, 49 and 63 are all odd and achievable (e.g. 1+3+5+7+19 = 35, etc.). The trap is to check sizes rather than parity: an even target like 40 is ruled out instantly by the odd-count-of-odds rule.

**33. (B)** Count steps for the smallest two-digit numbers. From 10: 10->5->16->8->4->2->1 is 6 steps - not enough. From 11: 11->34->17->52->26->13->40->20->10->5->16->8->4->2->1 is 14 steps - more than 10, and 11 is the smallest two-digit value, so it qualifies first. For comparison 12->6->3->10->5->16->8->4->2->1 is only 9 steps (fails the >10 test), and 14->7->... takes 17 steps but 14 is larger than 11. So the smallest qualifying two-digit number is 11. The value 12 actually falls short at 9 steps; 10 takes only 6; 14 qualifies but is not the smallest.

**34. (A)** The other two corners are the ends of the anti-diagonal, which also passes through the centre 5. Since every line (including that diagonal) sums to 15, we have top-right + 5 + bottom-left = 15, so the two corners sum to 15 - 5 = 10. (Concretely they are the remaining even numbers 4 and 6, which indeed add to 10.) The value 12 wrongly adds 4 and 8; 15 forgets to remove the centre; 8 picks the wrong pair.

**35. (D)** A call of 0 means no taller child stands ahead. For every child to say 0, each child must be at least as tall as all those in front - with distinct heights this means each child is taller than everyone ahead, so heights strictly increase front to back (shortest at front, tallest at back). It does NOT mean equal heights (that is one degenerate way but the game assumes a clear order); 'tallest at front' would give increasing calls 0,1,2,3, not all zeros; and the all-zero pattern is perfectly possible, so it is not impossible.

**36. (D)** Arrange the digits 1, 7, 2, 9 in descending order: 9721. Arrange them in ascending order: 1279. Subtract: 9721 - 1279 = 8442. So the first step gives 8442. The value 6174 is Kaprekar's eventual fixed point, reached only after several more steps, not on the first; 8262 and 7443 are arithmetic slips in the subtraction.

**37. (D)** A 3-digit palindrome aba has digit sum 2a + b = 18 with a in 1-9 and b in 0-9. Solve b = 18 - 2a, requiring 0 <= b <= 9: 18 - 2a >= 0 means a <= 9, and 18 - 2a <= 9 means 2a >= 9, a >= 4.5, so a >= 5. Thus a in {5,6,7,8,9}: a=5,b=8 (585); a=6,b=6 (666); a=7,b=4 (747); a=8,b=2 (828); a=9,b=0 (909). That is 5 numbers. The value 4 misses one endpoint; 6 includes an out-of-range b; 9 ignores the b<=9 constraint.

**38. (C)** If two consecutive terms are P and Q with P before Q, the term just before P is Q - P (since P + (the one before P) would not help - rather, the term before P equals (the term after) minus P only forward). Work backward using term = next - previous: the term before 50 is 81 - 50 = 31. The term before that 31 is 50 - 31 = 19. So two places before 50 is 19. The value 31 is only ONE place before 50; 12 and 13 come from subtracting in the wrong order or one step too few.

**39. (C)** The nine numbers 1-9 sum to 45. The four corners (20) plus the four edges (20) plus the centre = 45, so centre = 45 - 20 - 20 = 5. This matches the magic-square fact that 5 sits centre. The values 4, 6, 9 each fail the total 45 = 20 + 20 + centre.

**40. (B)** Divisible by 9 needs the digit sum to be a multiple of 9; divisible by 11 needs the alternating digit sum to be a multiple of 11. Check 8910: digit sum 8+9+1+0 = 18 (multiple of 9 ✓); alternating sum 8 - 9 + 1 - 0 = 0 (multiple of 11 ✓). So 8910 works (8910 = 99 x 90). Check 8901: digit sum 18 ✓ for 9, but alternating 8 - 9 + 0 - 1 = -2, not a multiple of 11. Check 8190: digit sum 18 ✓ for 9, but alternating 8 - 1 + 9 - 0 = 16, not a multiple of 11. Check 9810: digit sum 18 ✓ for 9, but alternating 9 - 8 + 1 - 0 = 2, not a multiple of 11. Only 8910 passes both tests.

**41. (D)** A child can only see children AHEAD, so the most taller children possible is everyone in front. The back (7th) child has 6 people ahead, so the largest call any child can make is 6 (only the back child can reach it, by being the shortest with all 6 ahead taller). No child can say 7 (there are not 7 people ahead of anyone in a 7-line); 5 understates the maximum; 0 is the minimum (the front child's call).

**42. (B)** By the identity, sum of first n terms = F(n+2) - 1. If that sum is 142, then F(n+2) - 1 = 142, so F(n+2) = 143. The value 144 forgets to add only 1 (it would need the sum to be 143); 142 omits the +1 entirely; 141 subtracts instead of adding.

**43. (A)** AB - BA = (10A + B) - (10B + A) = 9A - 9B = 9(A - B). Set 9(A - B) = 27, so A - B = 3. The value 2 comes from dividing 27 by a wrong factor; 9 confuses the multiplier with the answer; 27 ignores the factor of 9 entirely. (For instance A=5,B=2 gives 52-25 = 27 with A-B = 3.)

**44. (D)** Kaprekar's 3-digit routine has exactly one non-trivial fixed point: 495 (since 954 - 459 = 495 repeats). No number from 1 to 100 equals 495, so none of them is a true Kaprekar fixed point. Repdigits like 11 (011) give descending 110 minus ascending 011 = 099, not themselves - so they are not fixed. 100 gives 100 - 001 = 099, changing. Multiples of 9 are not generally fixed (the routine's outputs are multiples of 9, but being a multiple of 9 does not make a number fixed). Only 495 is fixed, and it exceeds 100.

**45. (A)** Reflecting left-to-right reverses each row: every row keeps the same three numbers, so its sum is unchanged (still 15). The three columns are simply relabelled in reverse order, so each column sum still equals one of the original column sums (15). The two diagonals swap with each other under the reflection, and since both originally summed to 15, both still do. Hence the reflected grid is again magic. The diagonals are not destroyed - they exchange; the centre stays put (it maps to itself under a horizontal flip); and the property holds for any magic square, not only the 1-9 one, though here it does use 1-9.

**46. (C)** The Collatz conjecture - verified for all numbers far beyond 27 - states that the process always reaches 1, and 27 is a well-known case that climbs very high (peaking over 9000) but still descends to 1 after 111 steps. So we can be certain it ends at 1. It does not grow forever (it is known to terminate at 1 for 27); 6174 is Kaprekar's constant, a different process; and the process does not 'end' at its peak - the peak is just the highest value along the way before it falls to 1.

**47. (C)** Let the number be 10t + u. We need 10t + u = 7(t + u), so 10t + u = 7t + 7u, giving 3t = 6u, hence t = 2u. The digit pairs with t = 2u are u=1,t=2 (21); u=2,t=4 (42); u=3,t=6 (63); u=4,t=8 (84). All four satisfy the equation (for example 21 = 7 x 3 ✓ and 42 = 7 x 6 ✓), so the smallest of them is 21. The values 42 and 63 are larger valid solutions, not the smallest; 14 fails the rule (7 x (1+4) = 35, not 14).

**48. (C)** The largest a single row can sum to is 7 + 8 + 9 = 24, using the three biggest numbers in one row. The extra rule only requires 1 to sit somewhere on the main diagonal; we can place 1 on the diagonal in a DIFFERENT row from the 7-8-9 row, leaving 7,8,9 free to share a row. For example, put 7,8,9 in the top row and 1 on the diagonal in the middle or bottom position - fully compatible. So the maximum row sum remains 24. The value 23 wrongly assumes 1 must displace a big number; 22 assumes two displacements; 15 confuses this with the magic-square row sum.

**49. (B)** Each step multiplies by roughly 1.618, so three steps (from 7th to 10th) multiply by about 1.618^3. Compute 1.618^2 ≈ 2.618, then x 1.618 ≈ 4.24. So the 10th term is about 4.2 times the 7th. Checking exactly: 7th = 13, 10th = 55, and 55/13 ≈ 4.23 ✓. The value 1.6 is just one step; 3 underestimates 1.618^3; 8 confuses it with 2^3 (treating the ratio as 2).

**50. (C)** A 4-digit palindrome in 2000-2999 has the form 2 b b 2 (first digit 2 forces last digit 2; the middle two must match). The middle digit b runs 0 through 9, giving 2002, 2112, 2222, 2332, 2442, 2552, 2662, 2772, 2882, 2992 - that is 10 years. The value 9 forgets b=0; 11 adds an extra; 100 wrongly treats both middle digits as free.

**51. (B)** A call at position p must satisfy 0 <= call <= p - 1. Positions 1-6 allow maxima 0,1,2,3,4,5. The calls 0,1,1,2,3,5 give: position1=0 (<=0 ✓), position2=1 (<=1 ✓), position3=1 (<=2 ✓), position4=2 (<=3 ✓), position5=3 (<=4 ✓), position6=5 (<=5 ✓). Every call is within its bound, and one can construct heights realising them, so the sequence is valid. Repeated values like two 1's are allowed (two different children can each have one taller person ahead); the last call 5 is exactly the maximum for position 6, hence fine; the heights need not follow any Fibonacci pattern - that the CALLS resemble Fibonacci is a coincidence.

**52. (A)** Palindromes of the form a0a with a from 1-9 are 101, 202, 303, ..., 909. Each equals 100a + a = 101a. Their sum is 101 x (1 + 2 + ... + 9) = 101 x 45 = 4545. The value 4995 mistakenly uses 111 x 45 (treating the number as a repdigit aaa rather than a0a); 5050 and 4950 are arithmetic slips.

**53. (D)** Each row has 3 cells. Adding 10 to every cell adds 3 x 10 = 30 to each row's total. The new magic sum is 15 + 30 = 45. It is still a magic square (every line gains the same 30), with magic sum 45. The value 25 adds only 10 (one cell's worth); 15 forgets the shift entirely; 150 multiplies instead of adds.

**54. (D)** From 16: 16->8->4->2->1, which is 4 halving steps. Because 16 = 2^4 is a power of 2, the process never needs the 3n+1 branch - it just halves four times. The count 5 over-counts; 'multiple of 4' is true but does not capture why it is so short (8 and 4 are also multiples of 4 with fewer steps - the key is being a pure power of 2); '16 steps' has no basis.

**55. (D)** If a 3-digit number equals its own reversal, then reversing leaves it unchanged, which is precisely the definition of a palindrome - its first and last digits match (the middle stays put). It need not be a multiple of 11 (e.g. 121 = 11^2 is, but 232 = 8x29 is a palindrome not divisible by 11); it cannot end in 0 (then it could not start with 0 after reversal and stay 3-digit); and it is 3-digit by assumption, not single-digit.

**56. (C)** Only the front child has nobody ahead, so its call is forced to 0. Every later child has at least one person ahead and COULD have a taller person there, so could call a positive number (e.g. the second child calls 1 if the front child is taller). Thus exactly one child - the first - is guaranteed unable to exceed 0. 'All of them' is false (later children often call positive numbers); the second child is not forced to 0; and the first child certainly cannot exceed 0 since nobody stands ahead.

**57. (A)** Two supercells cannot share an edge (each would need to beat the other). So the cell with 8 must not be edge-adjacent to the cell with 9. The opposite corner shares no edge with 9's corner, so 8 there can exceed its two (smaller) neighbours and be a genuine supercell while 9 stays one too. Placing 8 directly beside 9 makes them edge-adjacent, so 8 would lose to 9 and fail. The centre touches the maximal number of cells (4), making it hardest to isolate and likely adjacent to 9. And 8 certainly CAN be a supercell when its neighbours are all smaller, so 'nowhere' is false.

**58. (A)** Halving an even number gives a 3-digit result when the half is at least 100, i.e. the even number is at least 200, and we want the LARGEST 3-digit even number, since odd numbers do not halve. The largest even 3-digit number is 998 (999 is odd, so it would go to 3x999+1 = 2998, a 4-digit jump, not a halving). Halving 998 gives 499, still 3 digits. So 998 is the answer. 999 is odd and does not halve; 500 is even and halves to 250 but is not the largest; the last option restates 999 incorrectly.

**59. (D)** In such a sequence each term is the sum of the two before, so the 10th term = 9th + 8th. Thus 55 = 9th + 21, giving 9th = 55 - 21 = 34. Check: 21, 34, 55 - indeed 21+34 = 55 ✓. The value 33 mis-subtracts; 38 adds wrongly; 29 averages instead of subtracting.

**60. (C)** A 3-digit palindrome aba is even when its last digit (which equals a) is even, so a is even. The even choices for a (the leading digit, 1-9) are 2, 4, 6, 8 - that is 4 values. The middle digit b is free over 0-9 - 10 values. So there are 4 x 10 = 40 even 3-digit palindromes. The value 45 wrongly uses 9 choices for a (all leading digits) x ... ; 50 uses 5 even digits including 0 as a leading digit (not allowed); 20 halves incorrectly.
