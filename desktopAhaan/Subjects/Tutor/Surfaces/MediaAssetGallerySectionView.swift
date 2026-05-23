import SwiftUI
import AppKit

// MARK: - MediaAssetGallerySectionView
//
// Surfaces `chapter.mediaAssets: [MediaAsset]?` on the chapter detail
// page as a "Visual library" disclosure. Each entry renders through
// the `MediaAssetView` dispatcher.
//
// Auto-hides when `chapter.mediaAssets` is nil/empty. Uses
// `CollapsibleContentSection` for the disclosure shell.
//
// Tap-to-open-Discover for animatedSceneRef cards routes through the
// navigation state injected by the parent.

struct MediaAssetGallerySectionView: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var nav: TutorNavigationState

    private var assets: [MediaAsset] { chapter.mediaAssetsList }

    var body: some View {
        if !assets.isEmpty {
            CollapsibleContentSection(
                title: "Visual library",
                icon: "photo.on.rectangle.angled",
                badgeCount: assets.count,
                tint: .compatTeal,
                storageKey: "\(chapter.id).visualLibrary"
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(assets) { asset in
                        MediaAssetView(
                            asset: asset,
                            chapter: chapter,
                            onOpenDiscover: {
                                // Defer the navigation push to the next
                                // runloop tick — same pattern as the
                                // ChapterDetail Try Discover Mode CTA,
                                // which the 2026-05-22 dismantle-order
                                // crash class taught us to use.
                                let packId = pack.id
                                let chapterId = chapter.id
                                DispatchQueue.main.async {
                                    nav.push(.discover(packId: packId, chapterId: chapterId))
                                }
                            }
                        )
                    }
                }
            }
        }
    }
}
