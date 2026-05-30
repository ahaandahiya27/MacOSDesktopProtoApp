# Installing desktopAhaan

This is for anyone — no developer tools needed. It takes about a minute.

> _Screenshots referenced below are placeholders; the steps work without them._

## 1. Download the app

Get the latest `desktopAhaan-v<version>-<id>.dmg` file (a disk image). Save it
to your **Downloads** folder.

## 2. Open the disk image

Double-click the `.dmg` file. A window opens showing the **desktopAhaan** app
next to a shortcut to your **Applications** folder.

![Placeholder: the opened DMG window with the app and the Applications shortcut](docs/images/install-dmg-window.png)

## 3. Install it

**Drag the desktopAhaan icon onto the Applications folder** in that same
window. macOS copies it in. You can now close the disk-image window and eject
it (drag the desktopAhaan disk on your desktop to the Trash, or click the ⏏
eject button next to it in a Finder window).

## 4. Open it the first time

Open your **Applications** folder and **double-click desktopAhaan**.

The first time only, macOS may stop you with a message like:

> _"desktopAhaan" cannot be opened because Apple cannot check it for malicious
> software._

This is normal for an app installed outside the App Store — it does **not** mean
anything is wrong. To open it anyway:

1. **Right-click** (or Control-click) the desktopAhaan icon in Applications.
2. Choose **Open** from the menu.
3. In the dialog that appears, click **Open** (sometimes labelled **Open
   Anyway**).

![Placeholder: right-click → Open → Open Anyway](docs/images/install-open-anyway.png)

You only have to do this once. After that, it opens with a normal double-click.

> On newer macOS, if there's no **Open** button in the right-click menu, go to
> **System Settings → Privacy & Security**, scroll to the bottom, and click
> **Open Anyway** next to the desktopAhaan message.

## 5. The welcome tour

The first time it opens, a short **4-page welcome tour** introduces the three
subjects and Daily Practice, then offers to open Science Chapter 1. You can tap
**Skip** any time — you can replay it later from **Help → Show Welcome Tour**.

## 6. Enjoy

That's it. Everything works offline. Pick a subject from the sidebar and start
exploring. Progress saves automatically.

---

## Permissions you might see

The app is sandboxed and asks for as little as possible:

- **Microphone** — only if you use dictation in the translator or speak an
  answer in practice. Decline it and everything else still works.
- **Files** — only when *you* pick an image for the Sanskrit OCR translator.

It never asks for contacts, location, photos, or network access on its own.

## Where your data lives

Everything stays on this Mac under:

```
~/Library/Application Support/desktopAhaan/
```

To back up your progress, use **Settings → Data → Export backup** inside the
app. To see every path the app touches (for support or uninstall), run
`bash scripts/install-receipt.sh` from a developer checkout.

## Uninstalling

Drag **desktopAhaan** from Applications to the Trash. To also remove saved
progress and settings, run `bash scripts/install-receipt.sh --uninstall-hint`
(it only *prints* the commands — it never deletes anything itself).

## Troubleshooting

### If the DMG won't open

If double-clicking `desktopAhaan.app` is blocked, work through these in order —
the first one almost always works:

1. **Right-click → Open → Open Anyway.** Right-click (or Control-click) the app
   in **Applications**, choose **Open**, then click **Open** (or **Open
   Anyway**) in the dialog. You only do this once.
2. **System Settings → Privacy & Security.** On newer macOS, open
   **System Settings → Privacy & Security**, scroll to the bottom, and click
   **Open Anyway** next to the desktopAhaan message.
3. **Power users — clear the quarantine flag from Terminal:**
   ```
   xattr -dr com.apple.quarantine /Applications/desktopAhaan.app
   ```
   This removes the "downloaded from the internet" flag that triggers the
   Gatekeeper prompt. Safe for this app; then double-click normally.

- **"The app is damaged and can't be opened."** This usually means the download
  was incomplete or the quarantine flag got set oddly. Re-download the `.dmg`
  and try Step 4 again. On a developer checkout you can also clear quarantine
  with `xattr -dr com.apple.quarantine /Applications/desktopAhaan.app`.
- **It won't open at all.** Make sure you're on macOS 11 (Big Sur) or newer.
- **Nothing happens / it's slow on an old Mac.** Quit Safari and Mail first;
  the app is tuned for a Late-2014 iMac but a busy machine can still feel
  sluggish on the very first launch while content loads once.
