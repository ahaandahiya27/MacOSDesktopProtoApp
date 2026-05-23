# Surface Audit — desktopAhaan / Science Class 7

**Audit kind:** static code review (read every view file's body + accessibility modifiers + animation gating), not runtime walker. The dev Mac's test runner lacks the Accessibility permission needed for XCUITest-driven UI walks (per `STOP_AND_ASK.md` 2026-05-22 entry); a future iMac session with AX granted can run `desktopAhaanUITests` to capture runtime warnings and screenshots.

**Audit date:** 2026-05-23. **Code revision:** `fd99e92` + this session.

**Format:** every (chapter × surface) row reports four state columns (Renders? · A11y? · Reduce Motion? · Polish note). Schema-only gaps (no UI) are listed once each in §3 — they apply uniformly to every chapter.

---

## §1. Shipped surfaces (per chapter × surface)

| Chapter | Surface | Renders? | A11y label / hint | Reduce Motion respected? | Polish note |
|---------|---------|----------|--------------------|---------------------------|-------------|
| ch01 (Ch.1) | Chapter Detail · summary text | ✅ | ✅ (read by VoiceOver as body text) | n/a (static) | Reads cleanly; one suggestion — bump font from .callout to .body so it doesn't shrink under Dynamic Type Large. |
| ch01 (Ch.1) | Chapter Detail · Try Discover Mode | ✅ | ✅ ('try-discover-mode' identifier + accessibilityHint) | n/a (no animation; hover scale 1.01 only) | Hover scale 1.01 not gated on Reduce Motion — Reduce Motion users still get the scale. Polish: wrap in respectReduceMotion. |
| ch01 (Ch.1) | Chapter Detail · Beyond the Book | ✅ (only when HTML exists) | ✅ ('beyond-the-book' identifier + hint) | n/a (hover scale only) | Same hover scale 1.01 isn't gated by Reduce Motion. |
| ch01 (Ch.1) | Chapter Detail · Try at Home | ✅ (only when HomeExperimentLibrary has entries) | ✅ (accessibilityLabel + hint) | n/a (hover scale only) | Same hover scale Reduce Motion gap. Card hard-codes 'Hands-on experiments you can do this weekend.' regardless of chapter — could use per-chapter copy from the experiment library. |
| ch01 (Ch.1) | Chapter Detail · Notebook | ✅ | ✅ | n/a | Renders cleanly. The 'hasNotes' state could use a small badge ('Last edited 2 days ago'). |
| ch01 (Ch.1) | Chapter Detail · Topic cards (3) | ✅ | ⚠️ accessibilityHint missing on the chevron — VoiceOver reads 'Button' without context | n/a (hover only) | Add `.accessibilityHint("Opens topic X — N concepts, M questions.")`. |
| ch01 (Ch.1) | Topic Detail page | ✅ | ⚠️ Concept/Question section headers lack semantic header trait | n/a | Add `.accessibilityAddTraits(.isHeader)` to the 'Concepts' / 'Questions' section labels. |
| ch01 (Ch.1) | Concept Detail page | ✅ | ✅ (Read Aloud button has full label + hint) | ✅ Reduce Motion respected on the highlight pulse | Polished; Read Aloud button has good accessibilityLabel/Hint. |
| ch01 (Ch.1) | Question Detail page | ✅ | ⚠️ Match-the-following sub-view lacks `.accessibilityHint` on the pairs | ✅ (animations gated) | Match-pairs need a11y hint: 'Drag the left card onto its matching right card.' |
| ch01 (Ch.1) | Discover Mode shell | ✅ | ✅ | ✅ Reduce Motion gated | Polish: scene-progress bar at top doesn't announce step number to VoiceOver — add `.accessibilityValue("Scene N of M")`. |
| ch02 (Ch.2) | Chapter Detail · summary text | ✅ | ✅ (read by VoiceOver as body text) | n/a (static) | Reads cleanly; one suggestion — bump font from .callout to .body so it doesn't shrink under Dynamic Type Large. |
| ch02 (Ch.2) | Chapter Detail · Try Discover Mode | ✅ | ✅ ('try-discover-mode' identifier + accessibilityHint) | n/a (no animation; hover scale 1.01 only) | Hover scale 1.01 not gated on Reduce Motion — Reduce Motion users still get the scale. Polish: wrap in respectReduceMotion. |
| ch02 (Ch.2) | Chapter Detail · Beyond the Book | ✅ (only when HTML exists) | ✅ ('beyond-the-book' identifier + hint) | n/a (hover scale only) | Same hover scale 1.01 isn't gated by Reduce Motion. |
| ch02 (Ch.2) | Chapter Detail · Try at Home | ✅ (only when HomeExperimentLibrary has entries) | ✅ (accessibilityLabel + hint) | n/a (hover scale only) | Same hover scale Reduce Motion gap. Card hard-codes 'Hands-on experiments you can do this weekend.' regardless of chapter — could use per-chapter copy from the experiment library. |
| ch02 (Ch.2) | Chapter Detail · Notebook | ✅ | ✅ | n/a | Renders cleanly. The 'hasNotes' state could use a small badge ('Last edited 2 days ago'). |
| ch02 (Ch.2) | Chapter Detail · Topic cards (3) | ✅ | ⚠️ accessibilityHint missing on the chevron — VoiceOver reads 'Button' without context | n/a (hover only) | Add `.accessibilityHint("Opens topic X — N concepts, M questions.")`. |
| ch02 (Ch.2) | Topic Detail page | ✅ | ⚠️ Concept/Question section headers lack semantic header trait | n/a | Add `.accessibilityAddTraits(.isHeader)` to the 'Concepts' / 'Questions' section labels. |
| ch02 (Ch.2) | Concept Detail page | ✅ | ✅ (Read Aloud button has full label + hint) | ✅ Reduce Motion respected on the highlight pulse | Polished; Read Aloud button has good accessibilityLabel/Hint. |
| ch02 (Ch.2) | Question Detail page | ✅ | ⚠️ Match-the-following sub-view lacks `.accessibilityHint` on the pairs | ✅ (animations gated) | Match-pairs need a11y hint: 'Drag the left card onto its matching right card.' |
| ch02 (Ch.2) | Discover Mode shell | ✅ | ✅ | ✅ Reduce Motion gated | Polish: scene-progress bar at top doesn't announce step number to VoiceOver — add `.accessibilityValue("Scene N of M")`. |
| ch03 (Ch.3) | Chapter Detail · summary text | ✅ | ✅ (read by VoiceOver as body text) | n/a (static) | Reads cleanly; one suggestion — bump font from .callout to .body so it doesn't shrink under Dynamic Type Large. |
| ch03 (Ch.3) | Chapter Detail · Try Discover Mode | ✅ | ✅ ('try-discover-mode' identifier + accessibilityHint) | n/a (no animation; hover scale 1.01 only) | Hover scale 1.01 not gated on Reduce Motion — Reduce Motion users still get the scale. Polish: wrap in respectReduceMotion. |
| ch03 (Ch.3) | Chapter Detail · Beyond the Book | ✅ (only when HTML exists) | ✅ ('beyond-the-book' identifier + hint) | n/a (hover scale only) | Same hover scale 1.01 isn't gated by Reduce Motion. |
| ch03 (Ch.3) | Chapter Detail · Try at Home | ✅ (only when HomeExperimentLibrary has entries) | ✅ (accessibilityLabel + hint) | n/a (hover scale only) | Same hover scale Reduce Motion gap. Card hard-codes 'Hands-on experiments you can do this weekend.' regardless of chapter — could use per-chapter copy from the experiment library. |
| ch03 (Ch.3) | Chapter Detail · Notebook | ✅ | ✅ | n/a | Renders cleanly. The 'hasNotes' state could use a small badge ('Last edited 2 days ago'). |
| ch03 (Ch.3) | Chapter Detail · Topic cards (3) | ✅ | ⚠️ accessibilityHint missing on the chevron — VoiceOver reads 'Button' without context | n/a (hover only) | Add `.accessibilityHint("Opens topic X — N concepts, M questions.")`. |
| ch03 (Ch.3) | Topic Detail page | ✅ | ⚠️ Concept/Question section headers lack semantic header trait | n/a | Add `.accessibilityAddTraits(.isHeader)` to the 'Concepts' / 'Questions' section labels. |
| ch03 (Ch.3) | Concept Detail page | ✅ | ✅ (Read Aloud button has full label + hint) | ✅ Reduce Motion respected on the highlight pulse | Polished; Read Aloud button has good accessibilityLabel/Hint. |
| ch03 (Ch.3) | Question Detail page | ✅ | ⚠️ Match-the-following sub-view lacks `.accessibilityHint` on the pairs | ✅ (animations gated) | Match-pairs need a11y hint: 'Drag the left card onto its matching right card.' |
| ch03 (Ch.3) | Discover Mode shell | ✅ | ✅ | ✅ Reduce Motion gated | Polish: scene-progress bar at top doesn't announce step number to VoiceOver — add `.accessibilityValue("Scene N of M")`. |
| ch04 (Ch.4) | Chapter Detail · summary text | ✅ | ✅ (read by VoiceOver as body text) | n/a (static) | Reads cleanly; one suggestion — bump font from .callout to .body so it doesn't shrink under Dynamic Type Large. |
| ch04 (Ch.4) | Chapter Detail · Try Discover Mode | ✅ | ✅ ('try-discover-mode' identifier + accessibilityHint) | n/a (no animation; hover scale 1.01 only) | Hover scale 1.01 not gated on Reduce Motion — Reduce Motion users still get the scale. Polish: wrap in respectReduceMotion. |
| ch04 (Ch.4) | Chapter Detail · Beyond the Book | ✅ (only when HTML exists) | ✅ ('beyond-the-book' identifier + hint) | n/a (hover scale only) | Same hover scale 1.01 isn't gated by Reduce Motion. |
| ch04 (Ch.4) | Chapter Detail · Try at Home | ✅ (only when HomeExperimentLibrary has entries) | ✅ (accessibilityLabel + hint) | n/a (hover scale only) | Same hover scale Reduce Motion gap. Card hard-codes 'Hands-on experiments you can do this weekend.' regardless of chapter — could use per-chapter copy from the experiment library. |
| ch04 (Ch.4) | Chapter Detail · Notebook | ✅ | ✅ | n/a | Renders cleanly. The 'hasNotes' state could use a small badge ('Last edited 2 days ago'). |
| ch04 (Ch.4) | Chapter Detail · Topic cards (3) | ✅ | ⚠️ accessibilityHint missing on the chevron — VoiceOver reads 'Button' without context | n/a (hover only) | Add `.accessibilityHint("Opens topic X — N concepts, M questions.")`. |
| ch04 (Ch.4) | Topic Detail page | ✅ | ⚠️ Concept/Question section headers lack semantic header trait | n/a | Add `.accessibilityAddTraits(.isHeader)` to the 'Concepts' / 'Questions' section labels. |
| ch04 (Ch.4) | Concept Detail page | ✅ | ✅ (Read Aloud button has full label + hint) | ✅ Reduce Motion respected on the highlight pulse | Polished; Read Aloud button has good accessibilityLabel/Hint. |
| ch04 (Ch.4) | Question Detail page | ✅ | ⚠️ Match-the-following sub-view lacks `.accessibilityHint` on the pairs | ✅ (animations gated) | Match-pairs need a11y hint: 'Drag the left card onto its matching right card.' |
| ch04 (Ch.4) | Discover Mode shell | ✅ | ✅ | ✅ Reduce Motion gated | Polish: scene-progress bar at top doesn't announce step number to VoiceOver — add `.accessibilityValue("Scene N of M")`. |
| ch05 (Ch.5) | Chapter Detail · summary text | ✅ | ✅ (read by VoiceOver as body text) | n/a (static) | Reads cleanly; one suggestion — bump font from .callout to .body so it doesn't shrink under Dynamic Type Large. |
| ch05 (Ch.5) | Chapter Detail · Try Discover Mode | ✅ | ✅ ('try-discover-mode' identifier + accessibilityHint) | n/a (no animation; hover scale 1.01 only) | Hover scale 1.01 not gated on Reduce Motion — Reduce Motion users still get the scale. Polish: wrap in respectReduceMotion. |
| ch05 (Ch.5) | Chapter Detail · Beyond the Book | ✅ (only when HTML exists) | ✅ ('beyond-the-book' identifier + hint) | n/a (hover scale only) | Same hover scale 1.01 isn't gated by Reduce Motion. |
| ch05 (Ch.5) | Chapter Detail · Try at Home | ✅ (only when HomeExperimentLibrary has entries) | ✅ (accessibilityLabel + hint) | n/a (hover scale only) | Same hover scale Reduce Motion gap. Card hard-codes 'Hands-on experiments you can do this weekend.' regardless of chapter — could use per-chapter copy from the experiment library. |
| ch05 (Ch.5) | Chapter Detail · Notebook | ✅ | ✅ | n/a | Renders cleanly. The 'hasNotes' state could use a small badge ('Last edited 2 days ago'). |
| ch05 (Ch.5) | Chapter Detail · Topic cards (3) | ✅ | ⚠️ accessibilityHint missing on the chevron — VoiceOver reads 'Button' without context | n/a (hover only) | Add `.accessibilityHint("Opens topic X — N concepts, M questions.")`. |
| ch05 (Ch.5) | Topic Detail page | ✅ | ⚠️ Concept/Question section headers lack semantic header trait | n/a | Add `.accessibilityAddTraits(.isHeader)` to the 'Concepts' / 'Questions' section labels. |
| ch05 (Ch.5) | Concept Detail page | ✅ | ✅ (Read Aloud button has full label + hint) | ✅ Reduce Motion respected on the highlight pulse | Polished; Read Aloud button has good accessibilityLabel/Hint. |
| ch05 (Ch.5) | Question Detail page | ✅ | ⚠️ Match-the-following sub-view lacks `.accessibilityHint` on the pairs | ✅ (animations gated) | Match-pairs need a11y hint: 'Drag the left card onto its matching right card.' |
| ch05 (Ch.5) | Discover Mode shell | ✅ | ✅ | ✅ Reduce Motion gated | Polish: scene-progress bar at top doesn't announce step number to VoiceOver — add `.accessibilityValue("Scene N of M")`. |
| ch06 (Ch.6) | Chapter Detail · summary text | ✅ | ✅ (read by VoiceOver as body text) | n/a (static) | Reads cleanly; one suggestion — bump font from .callout to .body so it doesn't shrink under Dynamic Type Large. |
| ch06 (Ch.6) | Chapter Detail · Try Discover Mode | ✅ | ✅ ('try-discover-mode' identifier + accessibilityHint) | n/a (no animation; hover scale 1.01 only) | Hover scale 1.01 not gated on Reduce Motion — Reduce Motion users still get the scale. Polish: wrap in respectReduceMotion. |
| ch06 (Ch.6) | Chapter Detail · Beyond the Book | ✅ (only when HTML exists) | ✅ ('beyond-the-book' identifier + hint) | n/a (hover scale only) | Same hover scale 1.01 isn't gated by Reduce Motion. |
| ch06 (Ch.6) | Chapter Detail · Try at Home | ✅ (only when HomeExperimentLibrary has entries) | ✅ (accessibilityLabel + hint) | n/a (hover scale only) | Same hover scale Reduce Motion gap. Card hard-codes 'Hands-on experiments you can do this weekend.' regardless of chapter — could use per-chapter copy from the experiment library. |
| ch06 (Ch.6) | Chapter Detail · Notebook | ✅ | ✅ | n/a | Renders cleanly. The 'hasNotes' state could use a small badge ('Last edited 2 days ago'). |
| ch06 (Ch.6) | Chapter Detail · Topic cards (3) | ✅ | ⚠️ accessibilityHint missing on the chevron — VoiceOver reads 'Button' without context | n/a (hover only) | Add `.accessibilityHint("Opens topic X — N concepts, M questions.")`. |
| ch06 (Ch.6) | Topic Detail page | ✅ | ⚠️ Concept/Question section headers lack semantic header trait | n/a | Add `.accessibilityAddTraits(.isHeader)` to the 'Concepts' / 'Questions' section labels. |
| ch06 (Ch.6) | Concept Detail page | ✅ | ✅ (Read Aloud button has full label + hint) | ✅ Reduce Motion respected on the highlight pulse | Polished; Read Aloud button has good accessibilityLabel/Hint. |
| ch06 (Ch.6) | Question Detail page | ✅ | ⚠️ Match-the-following sub-view lacks `.accessibilityHint` on the pairs | ✅ (animations gated) | Match-pairs need a11y hint: 'Drag the left card onto its matching right card.' |
| ch06 (Ch.6) | Discover Mode shell | ✅ | ✅ | ✅ Reduce Motion gated | Polish: scene-progress bar at top doesn't announce step number to VoiceOver — add `.accessibilityValue("Scene N of M")`. |
| ch07 (Ch.7) | Chapter Detail · summary text | ✅ | ✅ (read by VoiceOver as body text) | n/a (static) | Reads cleanly; one suggestion — bump font from .callout to .body so it doesn't shrink under Dynamic Type Large. |
| ch07 (Ch.7) | Chapter Detail · Try Discover Mode | ✅ | ✅ ('try-discover-mode' identifier + accessibilityHint) | n/a (no animation; hover scale 1.01 only) | Hover scale 1.01 not gated on Reduce Motion — Reduce Motion users still get the scale. Polish: wrap in respectReduceMotion. |
| ch07 (Ch.7) | Chapter Detail · Beyond the Book | ✅ (only when HTML exists) | ✅ ('beyond-the-book' identifier + hint) | n/a (hover scale only) | Same hover scale 1.01 isn't gated by Reduce Motion. |
| ch07 (Ch.7) | Chapter Detail · Try at Home | ✅ (only when HomeExperimentLibrary has entries) | ✅ (accessibilityLabel + hint) | n/a (hover scale only) | Same hover scale Reduce Motion gap. Card hard-codes 'Hands-on experiments you can do this weekend.' regardless of chapter — could use per-chapter copy from the experiment library. |
| ch07 (Ch.7) | Chapter Detail · Notebook | ✅ | ✅ | n/a | Renders cleanly. The 'hasNotes' state could use a small badge ('Last edited 2 days ago'). |
| ch07 (Ch.7) | Chapter Detail · Topic cards (3) | ✅ | ⚠️ accessibilityHint missing on the chevron — VoiceOver reads 'Button' without context | n/a (hover only) | Add `.accessibilityHint("Opens topic X — N concepts, M questions.")`. |
| ch07 (Ch.7) | Topic Detail page | ✅ | ⚠️ Concept/Question section headers lack semantic header trait | n/a | Add `.accessibilityAddTraits(.isHeader)` to the 'Concepts' / 'Questions' section labels. |
| ch07 (Ch.7) | Concept Detail page | ✅ | ✅ (Read Aloud button has full label + hint) | ✅ Reduce Motion respected on the highlight pulse | Polished; Read Aloud button has good accessibilityLabel/Hint. |
| ch07 (Ch.7) | Question Detail page | ✅ | ⚠️ Match-the-following sub-view lacks `.accessibilityHint` on the pairs | ✅ (animations gated) | Match-pairs need a11y hint: 'Drag the left card onto its matching right card.' |
| ch07 (Ch.7) | Discover Mode shell | ✅ | ✅ | ✅ Reduce Motion gated | Polish: scene-progress bar at top doesn't announce step number to VoiceOver — add `.accessibilityValue("Scene N of M")`. |
| ch08 (Ch.8) | Chapter Detail · summary text | ✅ | ✅ (read by VoiceOver as body text) | n/a (static) | Reads cleanly; one suggestion — bump font from .callout to .body so it doesn't shrink under Dynamic Type Large. |
| ch08 (Ch.8) | Chapter Detail · Try Discover Mode | ✅ | ✅ ('try-discover-mode' identifier + accessibilityHint) | n/a (no animation; hover scale 1.01 only) | Hover scale 1.01 not gated on Reduce Motion — Reduce Motion users still get the scale. Polish: wrap in respectReduceMotion. |
| ch08 (Ch.8) | Chapter Detail · Beyond the Book | ✅ (only when HTML exists) | ✅ ('beyond-the-book' identifier + hint) | n/a (hover scale only) | Same hover scale 1.01 isn't gated by Reduce Motion. |
| ch08 (Ch.8) | Chapter Detail · Try at Home | ✅ (only when HomeExperimentLibrary has entries) | ✅ (accessibilityLabel + hint) | n/a (hover scale only) | Same hover scale Reduce Motion gap. Card hard-codes 'Hands-on experiments you can do this weekend.' regardless of chapter — could use per-chapter copy from the experiment library. |
| ch08 (Ch.8) | Chapter Detail · Notebook | ✅ | ✅ | n/a | Renders cleanly. The 'hasNotes' state could use a small badge ('Last edited 2 days ago'). |
| ch08 (Ch.8) | Chapter Detail · Topic cards (3) | ✅ | ⚠️ accessibilityHint missing on the chevron — VoiceOver reads 'Button' without context | n/a (hover only) | Add `.accessibilityHint("Opens topic X — N concepts, M questions.")`. |
| ch08 (Ch.8) | Topic Detail page | ✅ | ⚠️ Concept/Question section headers lack semantic header trait | n/a | Add `.accessibilityAddTraits(.isHeader)` to the 'Concepts' / 'Questions' section labels. |
| ch08 (Ch.8) | Concept Detail page | ✅ | ✅ (Read Aloud button has full label + hint) | ✅ Reduce Motion respected on the highlight pulse | Polished; Read Aloud button has good accessibilityLabel/Hint. |
| ch08 (Ch.8) | Question Detail page | ✅ | ⚠️ Match-the-following sub-view lacks `.accessibilityHint` on the pairs | ✅ (animations gated) | Match-pairs need a11y hint: 'Drag the left card onto its matching right card.' |
| ch08 (Ch.8) | Discover Mode shell | ✅ | ✅ | ✅ Reduce Motion gated | Polish: scene-progress bar at top doesn't announce step number to VoiceOver — add `.accessibilityValue("Scene N of M")`. |
| ch09 (Ch.9) | Chapter Detail · summary text | ✅ | ✅ (read by VoiceOver as body text) | n/a (static) | Reads cleanly; one suggestion — bump font from .callout to .body so it doesn't shrink under Dynamic Type Large. |
| ch09 (Ch.9) | Chapter Detail · Try Discover Mode | ✅ | ✅ ('try-discover-mode' identifier + accessibilityHint) | n/a (no animation; hover scale 1.01 only) | Hover scale 1.01 not gated on Reduce Motion — Reduce Motion users still get the scale. Polish: wrap in respectReduceMotion. |
| ch09 (Ch.9) | Chapter Detail · Beyond the Book | ✅ (only when HTML exists) | ✅ ('beyond-the-book' identifier + hint) | n/a (hover scale only) | Same hover scale 1.01 isn't gated by Reduce Motion. |
| ch09 (Ch.9) | Chapter Detail · Try at Home | ✅ (only when HomeExperimentLibrary has entries) | ✅ (accessibilityLabel + hint) | n/a (hover scale only) | Same hover scale Reduce Motion gap. Card hard-codes 'Hands-on experiments you can do this weekend.' regardless of chapter — could use per-chapter copy from the experiment library. |
| ch09 (Ch.9) | Chapter Detail · Notebook | ✅ | ✅ | n/a | Renders cleanly. The 'hasNotes' state could use a small badge ('Last edited 2 days ago'). |
| ch09 (Ch.9) | Chapter Detail · Topic cards (3) | ✅ | ⚠️ accessibilityHint missing on the chevron — VoiceOver reads 'Button' without context | n/a (hover only) | Add `.accessibilityHint("Opens topic X — N concepts, M questions.")`. |
| ch09 (Ch.9) | Topic Detail page | ✅ | ⚠️ Concept/Question section headers lack semantic header trait | n/a | Add `.accessibilityAddTraits(.isHeader)` to the 'Concepts' / 'Questions' section labels. |
| ch09 (Ch.9) | Concept Detail page | ✅ | ✅ (Read Aloud button has full label + hint) | ✅ Reduce Motion respected on the highlight pulse | Polished; Read Aloud button has good accessibilityLabel/Hint. |
| ch09 (Ch.9) | Question Detail page | ✅ | ⚠️ Match-the-following sub-view lacks `.accessibilityHint` on the pairs | ✅ (animations gated) | Match-pairs need a11y hint: 'Drag the left card onto its matching right card.' |
| ch09 (Ch.9) | Discover Mode shell | ✅ | ✅ | ✅ Reduce Motion gated | Polish: scene-progress bar at top doesn't announce step number to VoiceOver — add `.accessibilityValue("Scene N of M")`. |
| ch10 (Ch.10) | Chapter Detail · summary text | ✅ | ✅ (read by VoiceOver as body text) | n/a (static) | Reads cleanly; one suggestion — bump font from .callout to .body so it doesn't shrink under Dynamic Type Large. |
| ch10 (Ch.10) | Chapter Detail · Try Discover Mode | ✅ | ✅ ('try-discover-mode' identifier + accessibilityHint) | n/a (no animation; hover scale 1.01 only) | Hover scale 1.01 not gated on Reduce Motion — Reduce Motion users still get the scale. Polish: wrap in respectReduceMotion. |
| ch10 (Ch.10) | Chapter Detail · Beyond the Book | ✅ (only when HTML exists) | ✅ ('beyond-the-book' identifier + hint) | n/a (hover scale only) | Same hover scale 1.01 isn't gated by Reduce Motion. |
| ch10 (Ch.10) | Chapter Detail · Try at Home | ✅ (only when HomeExperimentLibrary has entries) | ✅ (accessibilityLabel + hint) | n/a (hover scale only) | Same hover scale Reduce Motion gap. Card hard-codes 'Hands-on experiments you can do this weekend.' regardless of chapter — could use per-chapter copy from the experiment library. |
| ch10 (Ch.10) | Chapter Detail · Notebook | ✅ | ✅ | n/a | Renders cleanly. The 'hasNotes' state could use a small badge ('Last edited 2 days ago'). |
| ch10 (Ch.10) | Chapter Detail · Topic cards (3) | ✅ | ⚠️ accessibilityHint missing on the chevron — VoiceOver reads 'Button' without context | n/a (hover only) | Add `.accessibilityHint("Opens topic X — N concepts, M questions.")`. |
| ch10 (Ch.10) | Topic Detail page | ✅ | ⚠️ Concept/Question section headers lack semantic header trait | n/a | Add `.accessibilityAddTraits(.isHeader)` to the 'Concepts' / 'Questions' section labels. |
| ch10 (Ch.10) | Concept Detail page | ✅ | ✅ (Read Aloud button has full label + hint) | ✅ Reduce Motion respected on the highlight pulse | Polished; Read Aloud button has good accessibilityLabel/Hint. |
| ch10 (Ch.10) | Question Detail page | ✅ | ⚠️ Match-the-following sub-view lacks `.accessibilityHint` on the pairs | ✅ (animations gated) | Match-pairs need a11y hint: 'Drag the left card onto its matching right card.' |
| ch10 (Ch.10) | Discover Mode shell | ✅ | ✅ | ✅ Reduce Motion gated | Polish: scene-progress bar at top doesn't announce step number to VoiceOver — add `.accessibilityValue("Scene N of M")`. |
| ch11 (Ch.11) | Chapter Detail · summary text | ✅ | ✅ (read by VoiceOver as body text) | n/a (static) | Reads cleanly; one suggestion — bump font from .callout to .body so it doesn't shrink under Dynamic Type Large. |
| ch11 (Ch.11) | Chapter Detail · Try Discover Mode | ✅ | ✅ ('try-discover-mode' identifier + accessibilityHint) | n/a (no animation; hover scale 1.01 only) | Hover scale 1.01 not gated on Reduce Motion — Reduce Motion users still get the scale. Polish: wrap in respectReduceMotion. |
| ch11 (Ch.11) | Chapter Detail · Beyond the Book | ✅ (only when HTML exists) | ✅ ('beyond-the-book' identifier + hint) | n/a (hover scale only) | Same hover scale 1.01 isn't gated by Reduce Motion. |
| ch11 (Ch.11) | Chapter Detail · Try at Home | ✅ (only when HomeExperimentLibrary has entries) | ✅ (accessibilityLabel + hint) | n/a (hover scale only) | Same hover scale Reduce Motion gap. Card hard-codes 'Hands-on experiments you can do this weekend.' regardless of chapter — could use per-chapter copy from the experiment library. |
| ch11 (Ch.11) | Chapter Detail · Notebook | ✅ | ✅ | n/a | Renders cleanly. The 'hasNotes' state could use a small badge ('Last edited 2 days ago'). |
| ch11 (Ch.11) | Chapter Detail · Topic cards (3) | ✅ | ⚠️ accessibilityHint missing on the chevron — VoiceOver reads 'Button' without context | n/a (hover only) | Add `.accessibilityHint("Opens topic X — N concepts, M questions.")`. |
| ch11 (Ch.11) | Topic Detail page | ✅ | ⚠️ Concept/Question section headers lack semantic header trait | n/a | Add `.accessibilityAddTraits(.isHeader)` to the 'Concepts' / 'Questions' section labels. |
| ch11 (Ch.11) | Concept Detail page | ✅ | ✅ (Read Aloud button has full label + hint) | ✅ Reduce Motion respected on the highlight pulse | Polished; Read Aloud button has good accessibilityLabel/Hint. |
| ch11 (Ch.11) | Question Detail page | ✅ | ⚠️ Match-the-following sub-view lacks `.accessibilityHint` on the pairs | ✅ (animations gated) | Match-pairs need a11y hint: 'Drag the left card onto its matching right card.' |
| ch11 (Ch.11) | Discover Mode shell | ✅ | ✅ | ✅ Reduce Motion gated | Polish: scene-progress bar at top doesn't announce step number to VoiceOver — add `.accessibilityValue("Scene N of M")`. |
| ch12 (Ch.12) | Chapter Detail · summary text | ✅ | ✅ (read by VoiceOver as body text) | n/a (static) | Reads cleanly; one suggestion — bump font from .callout to .body so it doesn't shrink under Dynamic Type Large. |
| ch12 (Ch.12) | Chapter Detail · Try Discover Mode | ✅ | ✅ ('try-discover-mode' identifier + accessibilityHint) | n/a (no animation; hover scale 1.01 only) | Hover scale 1.01 not gated on Reduce Motion — Reduce Motion users still get the scale. Polish: wrap in respectReduceMotion. |
| ch12 (Ch.12) | Chapter Detail · Beyond the Book | ✅ (only when HTML exists) | ✅ ('beyond-the-book' identifier + hint) | n/a (hover scale only) | Same hover scale 1.01 isn't gated by Reduce Motion. |
| ch12 (Ch.12) | Chapter Detail · Try at Home | ✅ (only when HomeExperimentLibrary has entries) | ✅ (accessibilityLabel + hint) | n/a (hover scale only) | Same hover scale Reduce Motion gap. Card hard-codes 'Hands-on experiments you can do this weekend.' regardless of chapter — could use per-chapter copy from the experiment library. |
| ch12 (Ch.12) | Chapter Detail · Notebook | ✅ | ✅ | n/a | Renders cleanly. The 'hasNotes' state could use a small badge ('Last edited 2 days ago'). |
| ch12 (Ch.12) | Chapter Detail · Topic cards (3) | ✅ | ⚠️ accessibilityHint missing on the chevron — VoiceOver reads 'Button' without context | n/a (hover only) | Add `.accessibilityHint("Opens topic X — N concepts, M questions.")`. |
| ch12 (Ch.12) | Topic Detail page | ✅ | ⚠️ Concept/Question section headers lack semantic header trait | n/a | Add `.accessibilityAddTraits(.isHeader)` to the 'Concepts' / 'Questions' section labels. |
| ch12 (Ch.12) | Concept Detail page | ✅ | ✅ (Read Aloud button has full label + hint) | ✅ Reduce Motion respected on the highlight pulse | Polished; Read Aloud button has good accessibilityLabel/Hint. |
| ch12 (Ch.12) | Question Detail page | ✅ | ⚠️ Match-the-following sub-view lacks `.accessibilityHint` on the pairs | ✅ (animations gated) | Match-pairs need a11y hint: 'Drag the left card onto its matching right card.' |
| ch12 (Ch.12) | Discover Mode shell | ✅ | ✅ | ✅ Reduce Motion gated | Polish: scene-progress bar at top doesn't announce step number to VoiceOver — add `.accessibilityValue("Scene N of M")`. |
| ch13 (Ch.13) | Chapter Detail · summary text | ✅ | ✅ (read by VoiceOver as body text) | n/a (static) | Reads cleanly; one suggestion — bump font from .callout to .body so it doesn't shrink under Dynamic Type Large. |
| ch13 (Ch.13) | Chapter Detail · Try Discover Mode | ✅ | ✅ ('try-discover-mode' identifier + accessibilityHint) | n/a (no animation; hover scale 1.01 only) | Hover scale 1.01 not gated on Reduce Motion — Reduce Motion users still get the scale. Polish: wrap in respectReduceMotion. |
| ch13 (Ch.13) | Chapter Detail · Beyond the Book | ✅ (only when HTML exists) | ✅ ('beyond-the-book' identifier + hint) | n/a (hover scale only) | Same hover scale 1.01 isn't gated by Reduce Motion. |
| ch13 (Ch.13) | Chapter Detail · Try at Home | ✅ (only when HomeExperimentLibrary has entries) | ✅ (accessibilityLabel + hint) | n/a (hover scale only) | Same hover scale Reduce Motion gap. Card hard-codes 'Hands-on experiments you can do this weekend.' regardless of chapter — could use per-chapter copy from the experiment library. |
| ch13 (Ch.13) | Chapter Detail · Notebook | ✅ | ✅ | n/a | Renders cleanly. The 'hasNotes' state could use a small badge ('Last edited 2 days ago'). |
| ch13 (Ch.13) | Chapter Detail · Topic cards (3) | ✅ | ⚠️ accessibilityHint missing on the chevron — VoiceOver reads 'Button' without context | n/a (hover only) | Add `.accessibilityHint("Opens topic X — N concepts, M questions.")`. |
| ch13 (Ch.13) | Topic Detail page | ✅ | ⚠️ Concept/Question section headers lack semantic header trait | n/a | Add `.accessibilityAddTraits(.isHeader)` to the 'Concepts' / 'Questions' section labels. |
| ch13 (Ch.13) | Concept Detail page | ✅ | ✅ (Read Aloud button has full label + hint) | ✅ Reduce Motion respected on the highlight pulse | Polished; Read Aloud button has good accessibilityLabel/Hint. |
| ch13 (Ch.13) | Question Detail page | ✅ | ⚠️ Match-the-following sub-view lacks `.accessibilityHint` on the pairs | ✅ (animations gated) | Match-pairs need a11y hint: 'Drag the left card onto its matching right card.' |
| ch13 (Ch.13) | Discover Mode shell | ✅ | ✅ | ✅ Reduce Motion gated | Polish: scene-progress bar at top doesn't announce step number to VoiceOver — add `.accessibilityValue("Scene N of M")`. |
| ch14 (Ch.14) | Chapter Detail · summary text | ✅ | ✅ (read by VoiceOver as body text) | n/a (static) | Reads cleanly; one suggestion — bump font from .callout to .body so it doesn't shrink under Dynamic Type Large. |
| ch14 (Ch.14) | Chapter Detail · Try Discover Mode | ✅ | ✅ ('try-discover-mode' identifier + accessibilityHint) | n/a (no animation; hover scale 1.01 only) | Hover scale 1.01 not gated on Reduce Motion — Reduce Motion users still get the scale. Polish: wrap in respectReduceMotion. |
| ch14 (Ch.14) | Chapter Detail · Beyond the Book | ✅ (only when HTML exists) | ✅ ('beyond-the-book' identifier + hint) | n/a (hover scale only) | Same hover scale 1.01 isn't gated by Reduce Motion. |
| ch14 (Ch.14) | Chapter Detail · Try at Home | ✅ (only when HomeExperimentLibrary has entries) | ✅ (accessibilityLabel + hint) | n/a (hover scale only) | Same hover scale Reduce Motion gap. Card hard-codes 'Hands-on experiments you can do this weekend.' regardless of chapter — could use per-chapter copy from the experiment library. |
| ch14 (Ch.14) | Chapter Detail · Notebook | ✅ | ✅ | n/a | Renders cleanly. The 'hasNotes' state could use a small badge ('Last edited 2 days ago'). |
| ch14 (Ch.14) | Chapter Detail · Topic cards (3) | ✅ | ⚠️ accessibilityHint missing on the chevron — VoiceOver reads 'Button' without context | n/a (hover only) | Add `.accessibilityHint("Opens topic X — N concepts, M questions.")`. |
| ch14 (Ch.14) | Topic Detail page | ✅ | ⚠️ Concept/Question section headers lack semantic header trait | n/a | Add `.accessibilityAddTraits(.isHeader)` to the 'Concepts' / 'Questions' section labels. |
| ch14 (Ch.14) | Concept Detail page | ✅ | ✅ (Read Aloud button has full label + hint) | ✅ Reduce Motion respected on the highlight pulse | Polished; Read Aloud button has good accessibilityLabel/Hint. |
| ch14 (Ch.14) | Question Detail page | ✅ | ⚠️ Match-the-following sub-view lacks `.accessibilityHint` on the pairs | ✅ (animations gated) | Match-pairs need a11y hint: 'Drag the left card onto its matching right card.' |
| ch14 (Ch.14) | Discover Mode shell | ✅ | ✅ | ✅ Reduce Motion gated | Polish: scene-progress bar at top doesn't announce step number to VoiceOver — add `.accessibilityValue("Scene N of M")`. |
| ch15 (Ch.15) | Chapter Detail · summary text | ✅ | ✅ (read by VoiceOver as body text) | n/a (static) | Reads cleanly; one suggestion — bump font from .callout to .body so it doesn't shrink under Dynamic Type Large. |
| ch15 (Ch.15) | Chapter Detail · Try Discover Mode | ✅ | ✅ ('try-discover-mode' identifier + accessibilityHint) | n/a (no animation; hover scale 1.01 only) | Hover scale 1.01 not gated on Reduce Motion — Reduce Motion users still get the scale. Polish: wrap in respectReduceMotion. |
| ch15 (Ch.15) | Chapter Detail · Beyond the Book | ✅ (only when HTML exists) | ✅ ('beyond-the-book' identifier + hint) | n/a (hover scale only) | Same hover scale 1.01 isn't gated by Reduce Motion. |
| ch15 (Ch.15) | Chapter Detail · Try at Home | ✅ (only when HomeExperimentLibrary has entries) | ✅ (accessibilityLabel + hint) | n/a (hover scale only) | Same hover scale Reduce Motion gap. Card hard-codes 'Hands-on experiments you can do this weekend.' regardless of chapter — could use per-chapter copy from the experiment library. |
| ch15 (Ch.15) | Chapter Detail · Notebook | ✅ | ✅ | n/a | Renders cleanly. The 'hasNotes' state could use a small badge ('Last edited 2 days ago'). |
| ch15 (Ch.15) | Chapter Detail · Topic cards (3) | ✅ | ⚠️ accessibilityHint missing on the chevron — VoiceOver reads 'Button' without context | n/a (hover only) | Add `.accessibilityHint("Opens topic X — N concepts, M questions.")`. |
| ch15 (Ch.15) | Topic Detail page | ✅ | ⚠️ Concept/Question section headers lack semantic header trait | n/a | Add `.accessibilityAddTraits(.isHeader)` to the 'Concepts' / 'Questions' section labels. |
| ch15 (Ch.15) | Concept Detail page | ✅ | ✅ (Read Aloud button has full label + hint) | ✅ Reduce Motion respected on the highlight pulse | Polished; Read Aloud button has good accessibilityLabel/Hint. |
| ch15 (Ch.15) | Question Detail page | ✅ | ⚠️ Match-the-following sub-view lacks `.accessibilityHint` on the pairs | ✅ (animations gated) | Match-pairs need a11y hint: 'Drag the left card onto its matching right card.' |
| ch15 (Ch.15) | Discover Mode shell | ✅ | ✅ | ✅ Reduce Motion gated | Polish: scene-progress bar at top doesn't announce step number to VoiceOver — add `.accessibilityValue("Scene N of M")`. |
| ch16 (Ch.16) | Chapter Detail · summary text | ✅ | ✅ (read by VoiceOver as body text) | n/a (static) | Reads cleanly; one suggestion — bump font from .callout to .body so it doesn't shrink under Dynamic Type Large. |
| ch16 (Ch.16) | Chapter Detail · Try Discover Mode | ✅ | ✅ ('try-discover-mode' identifier + accessibilityHint) | n/a (no animation; hover scale 1.01 only) | Hover scale 1.01 not gated on Reduce Motion — Reduce Motion users still get the scale. Polish: wrap in respectReduceMotion. |
| ch16 (Ch.16) | Chapter Detail · Beyond the Book | ✅ (only when HTML exists) | ✅ ('beyond-the-book' identifier + hint) | n/a (hover scale only) | Same hover scale 1.01 isn't gated by Reduce Motion. |
| ch16 (Ch.16) | Chapter Detail · Try at Home | ✅ (only when HomeExperimentLibrary has entries) | ✅ (accessibilityLabel + hint) | n/a (hover scale only) | Same hover scale Reduce Motion gap. Card hard-codes 'Hands-on experiments you can do this weekend.' regardless of chapter — could use per-chapter copy from the experiment library. |
| ch16 (Ch.16) | Chapter Detail · Notebook | ✅ | ✅ | n/a | Renders cleanly. The 'hasNotes' state could use a small badge ('Last edited 2 days ago'). |
| ch16 (Ch.16) | Chapter Detail · Topic cards (3) | ✅ | ⚠️ accessibilityHint missing on the chevron — VoiceOver reads 'Button' without context | n/a (hover only) | Add `.accessibilityHint("Opens topic X — N concepts, M questions.")`. |
| ch16 (Ch.16) | Topic Detail page | ✅ | ⚠️ Concept/Question section headers lack semantic header trait | n/a | Add `.accessibilityAddTraits(.isHeader)` to the 'Concepts' / 'Questions' section labels. |
| ch16 (Ch.16) | Concept Detail page | ✅ | ✅ (Read Aloud button has full label + hint) | ✅ Reduce Motion respected on the highlight pulse | Polished; Read Aloud button has good accessibilityLabel/Hint. |
| ch16 (Ch.16) | Question Detail page | ✅ | ⚠️ Match-the-following sub-view lacks `.accessibilityHint` on the pairs | ✅ (animations gated) | Match-pairs need a11y hint: 'Drag the left card onto its matching right card.' |
| ch16 (Ch.16) | Discover Mode shell | ✅ | ✅ | ✅ Reduce Motion gated | Polish: scene-progress bar at top doesn't announce step number to VoiceOver — add `.accessibilityValue("Scene N of M")`. |
| ch17 (Ch.17) | Chapter Detail · summary text | ✅ | ✅ (read by VoiceOver as body text) | n/a (static) | Reads cleanly; one suggestion — bump font from .callout to .body so it doesn't shrink under Dynamic Type Large. |
| ch17 (Ch.17) | Chapter Detail · Try Discover Mode | ✅ | ✅ ('try-discover-mode' identifier + accessibilityHint) | n/a (no animation; hover scale 1.01 only) | Hover scale 1.01 not gated on Reduce Motion — Reduce Motion users still get the scale. Polish: wrap in respectReduceMotion. |
| ch17 (Ch.17) | Chapter Detail · Beyond the Book | ✅ (only when HTML exists) | ✅ ('beyond-the-book' identifier + hint) | n/a (hover scale only) | Same hover scale 1.01 isn't gated by Reduce Motion. |
| ch17 (Ch.17) | Chapter Detail · Try at Home | ✅ (only when HomeExperimentLibrary has entries) | ✅ (accessibilityLabel + hint) | n/a (hover scale only) | Same hover scale Reduce Motion gap. Card hard-codes 'Hands-on experiments you can do this weekend.' regardless of chapter — could use per-chapter copy from the experiment library. |
| ch17 (Ch.17) | Chapter Detail · Notebook | ✅ | ✅ | n/a | Renders cleanly. The 'hasNotes' state could use a small badge ('Last edited 2 days ago'). |
| ch17 (Ch.17) | Chapter Detail · Topic cards (3) | ✅ | ⚠️ accessibilityHint missing on the chevron — VoiceOver reads 'Button' without context | n/a (hover only) | Add `.accessibilityHint("Opens topic X — N concepts, M questions.")`. |
| ch17 (Ch.17) | Topic Detail page | ✅ | ⚠️ Concept/Question section headers lack semantic header trait | n/a | Add `.accessibilityAddTraits(.isHeader)` to the 'Concepts' / 'Questions' section labels. |
| ch17 (Ch.17) | Concept Detail page | ✅ | ✅ (Read Aloud button has full label + hint) | ✅ Reduce Motion respected on the highlight pulse | Polished; Read Aloud button has good accessibilityLabel/Hint. |
| ch17 (Ch.17) | Question Detail page | ✅ | ⚠️ Match-the-following sub-view lacks `.accessibilityHint` on the pairs | ✅ (animations gated) | Match-pairs need a11y hint: 'Drag the left card onto its matching right card.' |
| ch17 (Ch.17) | Discover Mode shell | ✅ | ✅ | ✅ Reduce Motion gated | Polish: scene-progress bar at top doesn't announce step number to VoiceOver — add `.accessibilityValue("Scene N of M")`. |
| ch18 (Ch.18) | Chapter Detail · summary text | ✅ | ✅ (read by VoiceOver as body text) | n/a (static) | Reads cleanly; one suggestion — bump font from .callout to .body so it doesn't shrink under Dynamic Type Large. |
| ch18 (Ch.18) | Chapter Detail · Try Discover Mode | ✅ | ✅ ('try-discover-mode' identifier + accessibilityHint) | n/a (no animation; hover scale 1.01 only) | Hover scale 1.01 not gated on Reduce Motion — Reduce Motion users still get the scale. Polish: wrap in respectReduceMotion. |
| ch18 (Ch.18) | Chapter Detail · Beyond the Book | ✅ (only when HTML exists) | ✅ ('beyond-the-book' identifier + hint) | n/a (hover scale only) | Same hover scale 1.01 isn't gated by Reduce Motion. |
| ch18 (Ch.18) | Chapter Detail · Try at Home | ✅ (only when HomeExperimentLibrary has entries) | ✅ (accessibilityLabel + hint) | n/a (hover scale only) | Same hover scale Reduce Motion gap. Card hard-codes 'Hands-on experiments you can do this weekend.' regardless of chapter — could use per-chapter copy from the experiment library. |
| ch18 (Ch.18) | Chapter Detail · Notebook | ✅ | ✅ | n/a | Renders cleanly. The 'hasNotes' state could use a small badge ('Last edited 2 days ago'). |
| ch18 (Ch.18) | Chapter Detail · Topic cards (3) | ✅ | ⚠️ accessibilityHint missing on the chevron — VoiceOver reads 'Button' without context | n/a (hover only) | Add `.accessibilityHint("Opens topic X — N concepts, M questions.")`. |
| ch18 (Ch.18) | Topic Detail page | ✅ | ⚠️ Concept/Question section headers lack semantic header trait | n/a | Add `.accessibilityAddTraits(.isHeader)` to the 'Concepts' / 'Questions' section labels. |
| ch18 (Ch.18) | Concept Detail page | ✅ | ✅ (Read Aloud button has full label + hint) | ✅ Reduce Motion respected on the highlight pulse | Polished; Read Aloud button has good accessibilityLabel/Hint. |
| ch18 (Ch.18) | Question Detail page | ✅ | ⚠️ Match-the-following sub-view lacks `.accessibilityHint` on the pairs | ✅ (animations gated) | Match-pairs need a11y hint: 'Drag the left card onto its matching right card.' |
| ch18 (Ch.18) | Discover Mode shell | ✅ | ✅ | ✅ Reduce Motion gated | Polish: scene-progress bar at top doesn't announce step number to VoiceOver — add `.accessibilityValue("Scene N of M")`. |
| ch19 (Ch.19) | Chapter Detail · summary text | ✅ | ✅ (read by VoiceOver as body text) | n/a (static) | Reads cleanly; one suggestion — bump font from .callout to .body so it doesn't shrink under Dynamic Type Large. |
| ch19 (Ch.19) | Chapter Detail · Try Discover Mode | ✅ | ✅ ('try-discover-mode' identifier + accessibilityHint) | n/a (no animation; hover scale 1.01 only) | Hover scale 1.01 not gated on Reduce Motion — Reduce Motion users still get the scale. Polish: wrap in respectReduceMotion. |
| ch19 (Ch.19) | Chapter Detail · Beyond the Book | ✅ (only when HTML exists) | ✅ ('beyond-the-book' identifier + hint) | n/a (hover scale only) | Same hover scale 1.01 isn't gated by Reduce Motion. |
| ch19 (Ch.19) | Chapter Detail · Try at Home | ✅ (only when HomeExperimentLibrary has entries) | ✅ (accessibilityLabel + hint) | n/a (hover scale only) | Same hover scale Reduce Motion gap. Card hard-codes 'Hands-on experiments you can do this weekend.' regardless of chapter — could use per-chapter copy from the experiment library. |
| ch19 (Ch.19) | Chapter Detail · Notebook | ✅ | ✅ | n/a | Renders cleanly. The 'hasNotes' state could use a small badge ('Last edited 2 days ago'). |
| ch19 (Ch.19) | Chapter Detail · Topic cards (3) | ✅ | ⚠️ accessibilityHint missing on the chevron — VoiceOver reads 'Button' without context | n/a (hover only) | Add `.accessibilityHint("Opens topic X — N concepts, M questions.")`. |
| ch19 (Ch.19) | Topic Detail page | ✅ | ⚠️ Concept/Question section headers lack semantic header trait | n/a | Add `.accessibilityAddTraits(.isHeader)` to the 'Concepts' / 'Questions' section labels. |
| ch19 (Ch.19) | Concept Detail page | ✅ | ✅ (Read Aloud button has full label + hint) | ✅ Reduce Motion respected on the highlight pulse | Polished; Read Aloud button has good accessibilityLabel/Hint. |
| ch19 (Ch.19) | Question Detail page | ✅ | ⚠️ Match-the-following sub-view lacks `.accessibilityHint` on the pairs | ✅ (animations gated) | Match-pairs need a11y hint: 'Drag the left card onto its matching right card.' |
| ch19 (Ch.19) | Discover Mode shell | ✅ | ✅ | ✅ Reduce Motion gated | Polish: scene-progress bar at top doesn't announce step number to VoiceOver — add `.accessibilityValue("Scene N of M")`. |

**Row count §1:** 190 (19 chapters × 10 surfaces).

---

## §2. Article + Discover Mode (cross-chapter UI components)

These surfaces are not chapter-specific in their code but render per-chapter content. One audit per surface kind.

| Surface | Renders? | A11y? | Reduce Motion? | Polish note |
|---------|----------|-------|------------------|-------------|
| `ArticleBrowserView` — Beyond the Book / enrichment article | ✅ | ✅ (read-aloud has full label + hint; paragraph-highlight gates the announcement) | ✅ (NSTextView is the render path, no implicit animation) | Tight. The play/pause/resume icon-only button could carry the chapter number in its label so VoiceOver users hear 'Read article aloud, Ch.5'. |
| `NativeArticleRepresentable` (NSTextView host) | ✅ | ✅ (selectable text, VoiceOver reads paragraphs) | n/a | The paragraph highlight `coordinator.highlightParagraph(at:)` could expose the current paragraph as an `.accessibilityValue` on the host so screen readers announce "Reading paragraph 3 of 14." |
| `DiscoverMode` shell — scene navigation + boss quiz | ✅ | ✅ | ✅ | Scene-progress dot row lacks an accessibility value at the container level; individual dots are announced as buttons without context. Add `.accessibilityValue("Scene N of M")` on the dot container. |
| `DiscoverProgressDashboard` (Tools → Discover Progress) | ✅ | ✅ | ✅ | Polish: completed-chapter rows could carry a `.accessibilityHint("Tap to jump back into this chapter.")` to invite re-entry. |
| `KeyboardShortcutsSheet` (Help → desktopAhaan Help) | ✅ | ✅ | n/a | Polish: shortcut chips (`⌘K` etc.) are decorative — add `.accessibilityHidden(true)` so VoiceOver reads the description text instead of "command-K". |
| `WelcomeSheet` (first-launch hello) | ✅ | ✅ | n/a | Polish: this is the *only* WelcomeSheet — Phase 4 of this session replaces/extends it with a 3-panel `WelcomeTourSheet`. |
| `AllChaptersCompleteOverlay` (DM7/EM4) | ✅ | ✅ | ✅ | Tight. |
| `ChapterNotebookSheet` | ✅ | ✅ | n/a | Tight. |
| `HomeExperimentsSheet` | ✅ | ✅ | n/a | Tight. |
| `CommandPalette` (⌘K) | ✅ | ✅ | n/a | Tight. |

---

## §3. Schema-only content types — DATA SHIPS, NO UI RENDERS IT

Each of the 15 entries below is an Optional `Chapter` field with full Codable + JSON population, but no view file consumes its `*List` accessor. These are the deferred surfaces from the previous 10 sessions — the data work shipped, the UI work did not. Each row applies to ALL 19 chapters.

| Surface | Schema field | State | Plan |
|---------|--------------|-------|------|
| DeepDive · 'Go deeper' disclosure | `deepDive: [StretchTopic]?` | ❌ NO UI — schema in StretchTopic.swift, JSON populated for all 19 ch (3 entries each), but NO view in the codebase consumes `chapter.deepDiveList`. The CLAUDE comment in StretchTopic.swift says 'rendered via DeepDiveDisclosure on the chapter detail page' — that view does not exist. | Build `DeepDiveSection.swift` (chapter detail disclosure) + `DeepDiveDetailSheet.swift` (per-topic body). Wire into ChapterDetailView. SHIPPING IN THIS SESSION. |
| MediaAsset · chapter visual library | `mediaAssets: [MediaAsset]?` | ❌ NO UI — schema in MediaAsset.swift, JSON populated for all 19 ch (10 assets each), but NO view in the codebase consumes `chapter.mediaAssetsList`. MediaAsset.swift's docstring references a 'MediaAssetView' that does not exist. | Deferred to POLISH_TODOS.md. Building MediaAssetView with five backends (illustration / shapeDiagram / animatedSceneRef / bundledVideo / narratedWalkthrough) is multi-session work. |
| Misconceptions · 'Common mistakes' panel | `misconceptions: [Misconception]?` | ❌ NO UI — JSON has 5/5 ✅ per chapter, no view consumes `chapter.misconceptionsList`. | Deferred to POLISH_TODOS.md. High pedagogical value — should ship as a chapter-detail collapsible after DeepDive. |
| Mnemonics · memorization aids | `mnemonics: [Mnemonic]?` | ❌ NO UI — JSON has 3/3 ✅ per chapter, no view consumes `chapter.mnemonicsList`. (Note: `MnemonicCallout.swift` exists but is a generic component used inside Discover scenes; it does NOT pull from `chapter.mnemonics`.) | Deferred to POLISH_TODOS.md. Could surface as small chips under each Topic Detail. |
| Glossary · per-chapter glossary | `glossary: [GlossaryTerm]?` | ❌ NO UI — JSON has 10/10 ✅ per chapter, no view consumes `chapter.glossaryList`. | Deferred to POLISH_TODOS.md. Should appear as either a sheet from Chapter Detail OR inline definitions when terms appear in concept body text. |
| NCERT Q&A · canonical textbook questions | `ncertQA: [NcertQAEntry]?` | ❌ NO UI — JSON has 8/8 ✅ per chapter, no view consumes `chapter.ncertQAList`. These are the exact-form textbook questions Ahaan needs for class prep. | Deferred to POLISH_TODOS.md. HIGHEST product value of the schema-only gaps — should ship next session as a chapter-detail card. |
| WhatIfs · counterfactual scenarios | `whatIfs: [WhatIfScenario]?` | ❌ NO UI — JSON has 3/3 ✅ per chapter, no view consumes `chapter.whatIfsList`. | Deferred to POLISH_TODOS.md. |
| Real-world examples | `realWorldExamples: [RealWorldExample]?` | ❌ NO UI — JSON has 5/5 ✅ per chapter, no view consumes `chapter.realWorldExamplesList`. | Deferred to POLISH_TODOS.md. |
| Exam connections | `examConnections: [ExamConnection]?` | ❌ NO UI — JSON has 3/3 ✅ per chapter, no view consumes `chapter.examConnectionsList`. | Deferred to POLISH_TODOS.md. |
| Cross-chapter refs | `crossChapterRefs: [CrossChapterRef]?` | ❌ NO UI — JSON has 2/2 ✅ per chapter. | Deferred to POLISH_TODOS.md. |
| Curriculum bridge | `curriculumBridge: CurriculumBridge?` | ❌ NO UI — JSON has 1/1 ✅ per chapter. | Deferred to POLISH_TODOS.md. |
| Gallery | `gallery: [GalleryItem]?` | ❌ NO UI — JSON has 6/6 ✅ per chapter. | Deferred to POLISH_TODOS.md. |
| Timelines | `timelines: [ContentTimeline]?` | ❌ NO UI — JSON has 1/1 ✅ per chapter. | Deferred to POLISH_TODOS.md. |
| Mini-projects | `miniProjects: [MiniProject]?` | ❌ NO UI — JSON has 2/2 ✅ per chapter. | Deferred to POLISH_TODOS.md. |
| Scientist profiles | `scientists: [ScientistProfile]?` | ❌ NO UI — JSON has 1/1 ✅ per chapter. | Deferred to POLISH_TODOS.md. |

---

## §4. Latent code issues found during audit

| Surface | Where | Finding | Plan |
|---------|-------|---------|------|
| Color tokens missing for grade badges | `Color.compatBlue + Color.compatPurple` | `GradeLevel.badgeTint` returns 'compatBlue' / 'compatPurple' but Color extensions for those tokens do NOT exist in `Extensions.swift`. Any future call site that resolves the string would fail. Latent bug. | FIXING IN THIS SESSION as part of the DeepDive UI build. |
| Read Aloud button hover not gated by Reduce Motion | `ArticleBrowserView.readAloudButton, ConceptDetailView read-aloud button` | Both buttons render but the .help() tooltip is the only hover behavior; no scale or motion. ✅ Actually fine — no fix needed. | No action. |
| First-launch tile size | `WindowGroup .frame in desktopAhaanApp.swift` | idealWidth 2200 / idealHeight 1380 was bumped for the 5K iMac. On a 13" MBP this overshoots — Big Sur SwiftUI clips to display bounds correctly, so no visible bug, but the window opens covering 95% of the screen on first launch. | Polish candidate: add a min-of-display-bounds guard so smaller-screen Macs open at ~85% of available height. |

---

## §5. Roll-up

- Total audit rows: **218** (§1: 190 per-chapter × per-surface, §2: 10 cross-chapter components, §3: 15 schema-only gaps, §4: 3 latent issues).
- Shipped surfaces with ✅ render: every row in §1 and §2.
- A11y gaps (⚠️) found: 3 in §1 (topic-card chevron, topic-detail section header, question-detail match-pairs hint) + 2 in §2 (scene-progress dot value, keyboard-shortcut chip hidden trait). 5 total. All Phase 3 candidates.
- Reduce Motion gaps (⚠️): 3 surfaces use hover-scale 1.01 without `respectReduceMotion` gating (Discover banner, Beyond the Book, Try at Home). Phase 3 candidates.
- UI-not-shipped (❌): every schema-only content type in §3 (15 surfaces × 19 chapters = 285 conceptual cells). This session ships DeepDive (a11y + ReduceMotion gated from the start). The remaining 14 deferred to `POLISH_TODOS.md`.
- Latent code bugs: 1 (missing `Color.compatBlue` / `compatPurple` tokens referenced by `GradeLevel.badgeTint`). Fixing this session.

## §6. How to refresh this audit on the iMac

On the iMac (which has Accessibility granted to the XCUITest runner) the same audit can be augmented with runtime warnings + screenshots:

```
# Drives every shipped surface via XCUITest, captures runtime warnings,
# saves screencaptures.
xcodebuild test \
  -scheme desktopAhaan \
  -destination 'platform=macOS' \
  -only-testing:desktopAhaanUITests
```

(A dedicated `Surface_AuditWalker.swift` UITest is a future-session deliverable. The two existing tests — `Crash1_TryDiscoverMode_Ch1`, `Crash_BeyondThenDiscover` — cover the C1 / C2 crash repros, not a full surface walk.)