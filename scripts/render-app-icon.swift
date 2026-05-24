#!/usr/bin/env swift
// render-app-icon.swift — generate the 10 PNGs the AppIcon catalog
// declares but doesn't ship. Standalone macOS Swift script; run from
// the repo root with:
//
//     swift scripts/render-app-icon.swift
//
// Produces icon-{16,32,128,256,512}-{1x,2x}.png in
// desktopAhaan/Assets.xcassets/AppIcon.appiconset/ and updates the
// catalog's Contents.json to point at them.
//
// Design — kid-friendly, recognisable at 16×16, license-free because
// it's rendered from code:
//
//   * Soft rounded-rect background, indigo-to-purple gradient (matches
//     the Color.compatIndigo / Color.compatPurple brand tokens used
//     throughout the app's chrome).
//   * Bold white "A" monogram for "Ahaan", centred. Heavy weight so
//     it survives 16×16 downsampling without becoming a smudge.
//   * Subtle inner highlight ring so the icon reads as glassy/round
//     rather than flat — adds depth at 128pt+ without muddying the
//     small sizes.

import AppKit
import SwiftUI

// MARK: - Artwork

private struct AppIconArtwork: View {
    /// Edge length of the rendered image in points. Caller supplies
    /// the per-target size so the corner radius + stroke width scale
    /// proportionally instead of looking chunky at 16px and thin at
    /// 1024px.
    let size: CGFloat

    var body: some View {
        ZStack {
            // Brand gradient background.
            RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.30, green: 0.34, blue: 0.78),   // indigo
                            Color(red: 0.46, green: 0.30, blue: 0.74)    // purple
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            // Inner highlight ring — gives depth at large sizes without
            // muddying the 16×16 silhouette (it disappears under the
            // edge antialias at small scales).
            RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.45),
                            Color.white.opacity(0.05)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: max(1, size * 0.012)
                )
                .padding(size * 0.04)

            // Monogram "A". Bold + custom font size so the letterform
            // survives 16px downscaling.
            Text("A")
                .font(.system(size: size * 0.62, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.18),
                        radius: size * 0.02,
                        x: 0, y: size * 0.01)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Rendering

private func renderToPNG(view: some View, pixelSize: CGFloat) -> Data? {
    // Pixel-exact render via an explicit 1:1 NSBitmapImageRep. The
    // simpler `bitmapImageRepForCachingDisplay` path picks up the
    // window's backing-store scale (2× on Retina), which produced
    // double-sized PNGs the asset catalog rejected ("32x32 but should
    // be 16x16"). Allocating the rep manually with `pixelsWide` =
    // `pixelSize` guarantees the on-disk PNG is exactly `pixelSize` ×
    // `pixelSize` regardless of where the script runs.
    let intSize = Int(pixelSize)
    guard let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: intSize,
        pixelsHigh: intSize,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    ) else { return nil }
    // Point size on the rep matches pixel size so the SwiftUI layout
    // computes with the same coordinates the bitmap captures.
    rep.size = NSSize(width: pixelSize, height: pixelSize)

    let hosting = NSHostingView(rootView: view)
    hosting.frame = CGRect(x: 0, y: 0, width: pixelSize, height: pixelSize)
    hosting.layoutSubtreeIfNeeded()

    NSGraphicsContext.saveGraphicsState()
    guard let ctx = NSGraphicsContext(bitmapImageRep: rep) else {
        NSGraphicsContext.restoreGraphicsState()
        return nil
    }
    NSGraphicsContext.current = ctx
    hosting.layer?.render(in: ctx.cgContext)
    // SwiftUI views typically don't have a CALayer immediately; fall
    // back to displayIgnoringOpacity which draws the AppKit-bridged
    // hierarchy into the current context.
    hosting.displayIgnoringOpacity(hosting.bounds, in: ctx)
    NSGraphicsContext.restoreGraphicsState()

    return rep.representation(using: .png, properties: [:])
}

// MARK: - Driver

private struct IconSlot {
    /// The declared "size" in the asset catalog (always equals the 1×
    /// pixel width).
    let pointSize: Int
    /// 1 or 2 — the @1x or @2x scale.
    let scale: Int

    var pixelSize: Int { pointSize * scale }
    var filename: String { "icon-\(pointSize)-\(scale)x.png" }
    var catalogSize: String { "\(pointSize)x\(pointSize)" }
    var catalogScale: String { "\(scale)x" }
}

private let slots: [IconSlot] = [
    IconSlot(pointSize: 16,  scale: 1),
    IconSlot(pointSize: 16,  scale: 2),
    IconSlot(pointSize: 32,  scale: 1),
    IconSlot(pointSize: 32,  scale: 2),
    IconSlot(pointSize: 128, scale: 1),
    IconSlot(pointSize: 128, scale: 2),
    IconSlot(pointSize: 256, scale: 1),
    IconSlot(pointSize: 256, scale: 2),
    IconSlot(pointSize: 512, scale: 1),
    IconSlot(pointSize: 512, scale: 2)
]

private func contentsJSON(slots: [IconSlot]) -> String {
    var images: [String] = []
    for slot in slots {
        images.append("""
            {
              "filename" : "\(slot.filename)",
              "idiom" : "mac",
              "scale" : "\(slot.catalogScale)",
              "size" : "\(slot.catalogSize)"
            }
        """)
    }
    return """
    {
      "images" : [
    \(images.joined(separator: ",\n"))
      ],
      "info" : {
        "author" : "xcode",
        "version" : 1
      }
    }

    """
}

// Locate the asset catalog relative to the script. Works whether the
// script is run with `swift scripts/...` from the repo root or via an
// absolute path.
let scriptURL = URL(fileURLWithPath: CommandLine.arguments[0])
let repoRoot = scriptURL
    .deletingLastPathComponent()        // scripts/
    .deletingLastPathComponent()        // <repo root>
let appIconDir = repoRoot
    .appendingPathComponent("desktopAhaan/Assets.xcassets/AppIcon.appiconset",
                            isDirectory: true)

guard FileManager.default.fileExists(atPath: appIconDir.path) else {
    FileHandle.standardError.write(
        "AppIcon.appiconset not found at \(appIconDir.path)\n"
            .data(using: .utf8) ?? Data()
    )
    exit(1)
}

print("Rendering \(slots.count) icons into \(appIconDir.path)")

for slot in slots {
    let view = AppIconArtwork(size: CGFloat(slot.pixelSize))
    let pixel = CGFloat(slot.pixelSize)
    guard let png = renderToPNG(view: view, pixelSize: pixel) else {
        FileHandle.standardError.write(
            "  failed to render \(slot.filename)\n".data(using: .utf8) ?? Data()
        )
        exit(2)
    }
    let url = appIconDir.appendingPathComponent(slot.filename)
    do {
        try png.write(to: url, options: .atomic)
        print("  wrote \(slot.filename) (\(slot.pixelSize)×\(slot.pixelSize))")
    } catch {
        FileHandle.standardError.write(
            "  write failed: \(slot.filename) — \(error)\n"
                .data(using: .utf8) ?? Data()
        )
        exit(3)
    }
}

let contents = contentsJSON(slots: slots)
let contentsURL = appIconDir.appendingPathComponent("Contents.json")
try contents.write(to: contentsURL, atomically: true, encoding: .utf8)
print("Updated Contents.json")
print("Done.")
