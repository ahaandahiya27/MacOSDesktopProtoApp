# desktopAhaan — Security & Sandbox Model

Audit-and-fix checklist for categories **K** (Offline & sandbox) and **V**
(Security) from `docs/ISSUE_CATEGORIES.md`. Last audit: 2026-05-17.

## Threat model in one paragraph

This is a **single-user, offline-first** education app shipped to a
child's home Mac. There is no server. There are no accounts. There is
no telemetry. The only "untrusted input" the app handles is the
content pack JSON (which we ship) and image files the user explicitly
picks via NSOpenPanel for OCR. The main risks worth defending against
are: accidental data loss (writes not atomic), accidental privacy
violation (extra entitlements granting more than feature needs), and
crashes from malformed data (covered separately under category B and
the CrashReporter).

## Entitlements — `desktopAhaan/desktopAhaan.entitlements`

| Key | Status | Why it exists | What disabling would break |
|-----|--------|----------------|-----------------------------|
| `com.apple.security.app-sandbox` | ✅ ON | Required for App Store / Gatekeeper compliance and to confine writes to the app container. | The whole app can't run on macOS with mandatory sandboxing. |
| `com.apple.security.network.client` | ✅ ON | `FreeOnlineTranslationProvider` makes outbound `URLSession.shared.data(for:)` calls when the user hasn't enabled "Dictionary Only (Offline Mode)". `NWPathMonitor` does NOT need this entitlement (just reads network state). | The optional online translation fallback would fail silently. Local dictionary translation, all subject content, all quizzes, and OCR keep working. |
| `com.apple.security.files.user-selected.read-only` | ✅ ON | `OCRTranslationScreen` calls `NSOpenPanel()` so the user can pick an image to scan + translate. Read-only because the app never writes back to the user-picked file. | The "Open Image…" command + drag-drop OCR would fail. |
| `com.apple.security.device.audio-input` | ✅ ON | `SpeechRecognitionManager` uses the microphone for dictation in the translator and practice screens. Paired with `NSMicrophoneUsageDescription` + `NSSpeechRecognitionUsageDescription` privacy strings (via `INFOPLIST_KEY_*` build settings). | Microphone dictation breaks; typing still works. |

**No other entitlements** — no `read-write` file access, no `temporary-exception`s, no network server, no app groups, no keychain, no calendar, no contacts, no photo library, no camera (NSOpenPanel ≠ camera).

## Info.plist privacy strings

Configured via `INFOPLIST_KEY_*` build settings inside `project.pbxproj`:

- `NSMicrophoneUsageDescription` — "DesktopAhaan uses your microphone to transcribe what you say into the answer box and translator. All audio is processed on this Mac — nothing is uploaded."
- `NSSpeechRecognitionUsageDescription` — "Speech recognition turns your spoken words into typed text so you can answer questions without typing. Runs on-device on this Mac."

Both are child-friendly and accurate. The "nothing is uploaded" claim is honest because Apple's SFSpeechRecognizer with `requiresOnDeviceRecognition = true` is configured in `SpeechRecognitionManager`.

## File-system writes — atomicity & location

All file writes go through `.atomic` so a crash mid-write can't corrupt the destination:

- `~/Library/Application Support/desktopAhaan/progress.json` — `DataStore.swift:251` uses `try data.write(to: url, options: .atomic)`.
- `~/Library/Application Support/desktopAhaan/crashlogs/crashlog-YYYY-MM-DD.txt` — `CrashReporter.swift:189` and `199` use `try data.write(to: url, options: .atomic)` for the create path, with append-via-FileHandle for subsequent entries.
- `UserDefaults` writes for sidebar selection, recent items, and settings.

The Application Support directory is the canonical sandbox-friendly location and is automatically per-user. No file is ever written to `/tmp`, `~/Desktop`, the bundle directory, or any user-visible folder.

## Network surface

The ONLY outbound network call in the entire codebase:

```
Services/Translation/FreeOnlineTranslationProvider.swift:44
    URLSession.shared.data(for: request)
```

This provider is invoked **only when**:
1. The user has not toggled "Dictionary Only (Offline Mode)" in Settings (default: off).
2. `NWPathMonitor` reports the network is reachable.
3. The user runs a translation request.

When `preferOffline = true` (one click in Settings), the app behaves as fully offline — no calls are attempted. All subject content, quizzes, OCR, and dictation work without the network ever.

There are NO:
- Analytics / telemetry endpoints.
- Crash-reporting back-ends (CrashReporter writes locally only).
- Push notification servers.
- Update check endpoints (the app does not call home for updates).
- API keys / bearer tokens / OAuth flows.

## URL scheme attack surface

The app registers no custom URL schemes (no `CFBundleURLTypes` in pbxproj, no `onOpenURL` handlers in any view). External processes cannot open the app with a crafted URL to trigger a code path.

## Input sanitization

Search query strings are passed to `String.range(of:options:)` for substring matching with `.caseInsensitive, .diacriticInsensitive`. No `eval`, no shell-out, no JavaScript injection surface (HTML articles are rendered with `WKWebView` loading bundled file:// URLs — no remote content, no JS evaluation).

The `WKWebView` configuration in the article renderer should additionally:
- Disable JavaScript by default (verify — currently 🟡 unverified).
- Restrict `WKContentRuleList` to block any inline scripts that slip in.
- Use `loadFileURL(_:allowingReadAccessTo:)` with the chapter's specific Articles folder, not a parent.

This is documented as **V5b** in the issue taxonomy as a future-pass item; the current bundled HTML is hand-authored so the risk is theoretical for now.

## Hardcoded secrets

`grep` audit shows zero hardcoded API keys, bearer tokens, OAuth secrets, or credentials. The `TranslationProvider` protocol has a `requiresAPIKey: Bool` property, but every concrete provider (`LocalTranslationProvider`, `FreeOnlineTranslationProvider`, `MockTranslationProvider`) returns `false` and uses public, key-less endpoints.

## Crash report content

Crash logs (`~/Library/Application Support/desktopAhaan/crashlogs/`) contain:
- Timestamp (UTC).
- Crash kind (exception / signal / data-issue).
- Origin (function name or signal handler).
- Message (NSException.reason or signal description).
- Full call stack symbols.

They do NOT contain:
- User content (no question prompts, no answers, no dictation transcripts).
- Network requests / responses.
- Filesystem paths beyond the executable path that the OS produces.
- Personally identifiable information.

The user can `cat` or delete the logs at any time. Help → "Reveal Crash Logs in Finder" and "Clear Crash Logs" expose this in the UI.

## What I would NOT add without re-evaluating the threat model

- **Network server entitlement** — there's no reason for the app to listen on a port.
- **Read-write file access** — every file the app needs to write goes to Application Support.
- **Photo library / camera entitlements** — OCR uses NSOpenPanel, not camera capture.
- **Keychain access** — there are no credentials to store.
- **App groups** — single-target app.
- **Apple events** — no AppleScript surface needed.

## Going forward

If a new feature needs a new entitlement, the convention is:
1. Add it to `desktopAhaan.entitlements` with an XML comment explaining why.
2. Add a row to the table in this file.
3. Update `docs/ISSUE_CATEGORIES.md` rows K/V to flip back to 🟡 if the change widens the attack surface, until re-audited.
4. Add an `INFOPLIST_KEY_*` privacy string if the entitlement touches the user (camera, location, contacts, etc.).
