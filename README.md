# desktopAhaan

**A calm, offline study app for Class 7 — Science, Maths, and Sanskrit, all in
one window on your Mac.**

## What is desktopAhaan?

desktopAhaan is a single-window Mac app that helps a Class 7 student learn three
subjects at their own pace. Every idea comes with a plain-language explanation,
something interactive to poke at, and just enough practice to make it stick. It
runs entirely on your Mac — no internet, no accounts, no sign-up.

## Who's it for?

Ahaan, age 12. And kids like him — anyone in Class 7 (or nearby) who learns
better by exploring than by memorising. A parent can sit alongside and follow a
weekly progress report; the child can use it alone without ever creating an
account or touching a setting.

## What's inside?

- **Three subjects** — Science, Maths, and Sanskrit, each picked from a simple
  sidebar.
- **50 chapters** of NCERT / NEP Class 7 content — Science (19), Maths (15),
  Sanskrit (16, including a vocabulary deck).
- **Discover Mode** — interactive, illustrated scenes in every Science chapter:
  drag things, move sliders, run a little experiment, then take a boss quiz.
- **Articles** — "Beyond the Book" reading with **Read Aloud** that highlights
  each paragraph as it's spoken.
- **Daily Practice** — the app quietly remembers what's been learned and brings
  each idea back right before it would be forgotten (spaced repetition). A few
  minutes a day, not a cram session.
- **Achievements & streaks** — gentle encouragement to keep showing up.
- **Sanskrit translator** — an on-device dictionary, speech, and OCR for scanned
  text.
- **Weekly Progress** — a one-page parent dashboard (Help → Weekly Progress,
  ⌘⇧W) you can read or export to PDF.

## How to install

You don't need to be a developer. Full step-by-step (with the one macOS
security prompt explained) is in **[INSTALL.md](INSTALL.md)**.

Short version: open the `.dmg`, drag **desktopAhaan** into **Applications**, and
the first time you open it, right-click → **Open** → **Open Anyway**. A short
welcome tour appears the first time you launch.

## Privacy

Single user. Offline-first. **No telemetry, no accounts, no tracking.** Your
data stays on this Mac, under `~/Library/Application Support/desktopAhaan/`. The
only thing that ever reaches the internet is an *optional* online translator,
and you can turn it off in Settings (it's off the critical path either way).

## For developers

- Architecture, platform rules (Big Sur 11.5 deploy target, Swift 5.5), naming
  and commit conventions: **[CLAUDE.md](CLAUDE.md)**.
- How to cut and ship a release build / DMG: **[DISTRIBUTION.md](DISTRIBUTION.md)**.
- The full audit taxonomy (what's done, what's pending):
  `docs/ISSUE_CATEGORIES.md`.
- Security model + entitlements rationale: `docs/SECURITY.md`.

Build & test from a checkout:

```
bash scripts/ci-build-test.sh        # Release build + Debug test suite
```

The app is a universal binary (Apple Silicon + Intel) and is daily-driven on a
Late-2014 iMac running Big Sur 11.7.11 — see CLAUDE.md for the hardware
constraints that shape the codebase.

### Multi-agent overnight runs

Large overnight work is split across several Claude agents running in parallel
on the same checkout. Launch a fleet with:

```
bash scripts/run_overnight_v3_3agents.sh            # launch
bash scripts/run_overnight_v3_3agents.sh --dry-run  # validate setup only
```

The launcher enforces the **per-agent DerivedData policy**: every agent builds
into its own `/tmp/dd-agent-<LETTER>-<PID>` path (never a shared one), and the
pre-push gate's `xcodebuild` is serialized behind `scripts/hooks/build-mutex.sh`.
Together these stop the parallel gates from corrupting each other's module
caches or OOM-killing the 8 GB iMac's Swift compiler — the failure mode that
deferred the v2 run's push. A pre-flight `scripts/clean_overnight_artifacts.sh`
clears stale DerivedData first. See **[DISTRIBUTION.md](DISTRIBUTION.md)** for
the policy details.

## License

Personal project — not for redistribution.
