# Lint fixtures

Each `<rule>_violation.swift` is intentionally broken in a way that the
named lint rule should catch. Each `<rule>_clean.swift` exercises the
same pattern in a way the lint should NOT flag. The harness in
`scripts/test_lints.py` runs each scan function against both and
asserts the expected outcome.

These files are **not** part of the app target — they live under
`scripts/test_fixtures/`, which the lints' `SOURCE_DIR = repo / "desktopAhaan"`
glob never sees. They're only loaded explicitly by the harness.

If you add a new lint rule, add matching fixtures here and a test case
in `scripts/test_lints.py`.
