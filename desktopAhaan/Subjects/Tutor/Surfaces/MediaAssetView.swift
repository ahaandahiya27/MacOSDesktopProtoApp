import SwiftUI
import AppKit
import AVKit

// MARK: - MediaAssetView
//
// Single dispatcher view that renders any `MediaAsset` by its `kind`.
// Five backends (only 3 are currently populated in
// `science_class7.json`: shapeDiagram, animatedSceneRef,
// narratedWalkthrough; illustration + bundledVideo wiring is in place
// for future JSON authoring).
//
// Big Sur compat:
//   - `AVPlayerView` via NSViewRepresentable (AVKit shipping since
//     macOS 10.9 ✅).
//   - Reduce Motion gates the auto-play behavior (videos start paused).
//   - All colors via `Color.compat*`.

struct MediaAssetView: View {
    let asset: MediaAsset
    let chapter: Chapter
    /// Callback invoked when an animatedSceneRef card is tapped — the
    /// host wires this up to navigate to Discover Mode for the chapter.
    /// nil disables the CTA.
    var onOpenDiscover: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            renderBackend
            Text(asset.caption)
                .font(.caption)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.secondary.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.secondary.opacity(0.20), lineWidth: 1)
        )
        // Asset's altText is a HARD lint contract (≥ 10 chars) — perfect
        // VoiceOver label without needing additional copy.
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(asset.altText)
    }

    @ViewBuilder
    private var renderBackend: some View {
        switch asset.kind {
        case .illustration:
            illustrationBackend
        case .shapeDiagram:
            shapeDiagramBackend
        case .animatedSceneRef:
            animatedSceneBackend
        case .bundledVideo:
            bundledVideoBackend
        case .narratedWalkthrough:
            narratedWalkthroughBackend
        }
    }

    // MARK: - Illustration

    @ViewBuilder
    private var illustrationBackend: some View {
        if let resource = asset.resource,
           let nsImage = NSImage(named: NSImage.Name(resource)) {
            Image(nsImage: nsImage)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 220)
        } else {
            placeholderCard(systemImage: "photo", label: "Illustration (asset missing)")
        }
    }

    // MARK: - Shape diagram

    @ViewBuilder
    private var shapeDiagramBackend: some View {
        if let resource = asset.resource,
           let factory = ShapeDiagramRegistry.factory(for: resource) {
            factory()
                .frame(maxWidth: .infinity, maxHeight: 220)
        } else {
            placeholderCard(systemImage: "scribble.variable", label: "Shape diagram (not yet illustrated)")
        }
    }

    // MARK: - Animated scene ref

    @ViewBuilder
    private var animatedSceneBackend: some View {
        HStack(spacing: 12) {
            Image(systemName: SFSymbolCompat.name("play.rectangle.fill"))
                .font(.title)
                .foregroundColor(Color.compatIndigo)
            VStack(alignment: .leading, spacing: 4) {
                Text("See it animated")
                    .font(.callout.weight(.semibold))
                Text("Open the Discover Mode scene that brings this idea to life.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            if let action = onOpenDiscover {
                Button("Open scene") { action() }
                    .buttonStyle(.bordered)
                    .accentColor(Color.compatIndigo)
                    .accessibilityHint("Switches to Discover Mode for this chapter.")
            }
        }
        .padding(.vertical, 6)
    }

    // MARK: - Bundled video

    @ViewBuilder
    private var bundledVideoBackend: some View {
        if let resource = asset.resource,
           let url = Bundle.main.url(forResource: resource, withExtension: nil) {
            // AVPlayerView in an NSViewRepresentable. The video starts
            // paused (Reduce Motion + Discover-Mode policy — no
            // surprise motion in the chapter detail page).
            AVPlayerHost(url: url)
                .frame(maxWidth: .infinity, idealHeight: 220, maxHeight: 280)
        } else {
            placeholderCard(systemImage: "film", label: "Video (file missing)")
        }
    }

    // MARK: - Narrated walkthrough

    @ViewBuilder
    private var narratedWalkthroughBackend: some View {
        NarratedWalkthroughRow(text: asset.caption)
    }

    // MARK: - Placeholder

    @ViewBuilder
    private func placeholderCard(systemImage: String, label: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: SFSymbolCompat.name(systemImage))
                .font(.title)
                .foregroundColor(.secondary)
            Text(label)
                .font(.callout)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding(.vertical, 14)
    }
}

// MARK: - AVPlayerHost

/// Tiny `NSViewRepresentable` wrapping AVKit's `AVPlayerView`. Starts
/// paused; the user controls playback through the player's transport
/// bar. Pause on disappear so navigating away doesn't leak audio.
private struct AVPlayerHost: NSViewRepresentable {
    let url: URL

    func makeNSView(context: Context) -> AVPlayerView {
        let view = AVPlayerView()
        let player = AVPlayer(url: url)
        player.actionAtItemEnd = .pause
        view.player = player
        view.controlsStyle = .inline
        view.showsFullScreenToggleButton = false
        return view
    }

    func updateNSView(_ nsView: AVPlayerView, context: Context) {
        // Static URL — nothing to update.
    }

    static func dismantleNSView(_ nsView: AVPlayerView, coordinator: ()) {
        // Stop and release the player explicitly. Failing to do so on
        // Big Sur can leave audio playing for a beat after the view
        // tears down. Same belt-and-suspenders policy as the article
        // surface's dismantleNSView fix from 2026-05-22.
        nsView.player?.pause()
        nsView.player = nil
    }
}

// MARK: - NarratedWalkthroughRow

/// A "Read aloud" button that hands the parent text to the existing
/// TextToSpeechManager. Lives separately because the button's pressed/
/// playing state needs @StateObject scoping.
private struct NarratedWalkthroughRow: View {
    let text: String
    @ObservedObject private var speech = SpeechReader.shared
    /// Owner string scopes start/stop calls so this row only stops
    /// narration it started — `SpeechReader.stop(owner:)` no-ops if
    /// some other surface (e.g. the article reader) owns the queue.
    private let owner = "mediaAsset.narratedWalkthrough"
    @State private var isMine = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: SFSymbolCompat.name("speaker.wave.2.fill"))
                .font(.title)
                .foregroundColor(Color.compatCyan)
            VStack(alignment: .leading, spacing: 4) {
                Text("Listen to the walkthrough")
                    .font(.callout.weight(.semibold))
                Text("Tap to hear this caption read aloud.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            Button(action: toggleTTS) {
                Image(systemName: SFSymbolCompat.name(isMine && speech.isSpeaking ? "pause.fill" : "play.fill"))
                    .font(.body)
            }
            .buttonStyle(.bordered)
            .accentColor(Color.compatCyan)
            .accessibilityLabel(isMine && speech.isSpeaking ? "Pause narration" : "Start narration")
            .accessibilityHint("Reads the walkthrough caption aloud through the system text-to-speech voice.")
        }
        .padding(.vertical, 6)
        .onDisappear {
            if isMine { speech.stop(owner: owner) }
        }
    }

    private func toggleTTS() {
        if isMine && speech.isSpeaking {
            speech.stop(owner: owner)
            isMine = false
        } else {
            speech.speak(text, owner: owner)
            isMine = true
        }
    }
}
