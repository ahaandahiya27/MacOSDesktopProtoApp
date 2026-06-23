import Foundation

// MARK: - Variant practice papers (P3 / P4 / P5)
//
// Built programmatically off the 69 base foundation papers. Each chapter's
// base paper has three extra practice variants on disk:
//
//   <chapter>_P3.pdf  +  _P3.html  +  _P3_QuestionPaper.md  +  _P3_Solutions.md
//   <chapter>_P4.pdf  +  …
//   <chapter>_P5.pdf  +  …
//
// per the `TestPapers/` authoring pipeline. They were produced by the
// QA-sweep tooling (commit prefix `qa:`) — each variant is a harder
// ramp over the base (`ramp P3>P1 holds`, `P5≈P4`). Same +4/-1/0 marking,
// same 60-MCQ / 90-min envelope; the marking surface, timer, autosave,
// and Score Report don't need per-variant branches.
//
// Why programmatic and not hand-typed: 207 entries × ~13 lines each =
// ~2,700 lines that don't carry any per-chapter information — every
// field is derivable from the base paper's filenames. A `_P3` suffix
// gets sliced into the same string-mutating function for every chapter,
// so the catalog stays in sync as the QA-sweep tool adds further
// variants without anyone touching this file.
//
// The variants are appended at the end of `allPapers` so the existing
// 138 base/advanced entries keep their stable order. `papersBySubject()`
// reads insertion order to bucket — variants land alongside their
// subject's base + advanced entries (the bucket builder doesn't reorder).
//
// Big Sur safety: pure Foundation string ops; no macOS 12+ APIs; no
// new actor isolation; no view-tree changes.

extension OlympiadPaperRegistry {

    /// The 207 P3/P4/P5 variant papers, generated from the 138 base/
    /// advanced papers' filenames. Computed eagerly at module init —
    /// the 207-element array is a few KB of structs, far below the
    /// budget where lazy init would matter.
    static let variantPapers: [OlympiadPaper] = makeVariantPapers()

    /// Three variant tags, applied in display order so the hub shows
    /// each chapter as `Base → P3 → P4 → P5`.
    static let variantTags: [String] = ["P3", "P4", "P5"]

    private static func makeVariantPapers() -> [OlympiadPaper] {
        // Only expand the FOUNDATION (base) tier — Advanced is its own
        // separate paper with hand-authored MD, not a P3/P4/P5 ramp.
        // Filtering on tier keeps us at exactly 69 × 3 = 207 variants.
        let bases = (sciencePapers + mathsPapers
                     + sanskritPapers + socialSciencePapers)
            .filter { $0.tier == .foundation }
        var out: [OlympiadPaper] = []
        out.reserveCapacity(bases.count * variantTags.count)
        for base in bases {
            for tag in variantTags {
                out.append(makeVariant(base: base, tag: tag))
            }
        }
        return out
    }

    /// Build one variant `OlympiadPaper` from a base by splicing `_<tag>`
    /// into each of the four bundled-filename fields. Falls back to a
    /// best-effort string mutation if a field doesn't match the expected
    /// shape — the test suite pins every emitted filename against the
    /// real bundle, so a silent mismatch would surface there.
    private static func makeVariant(base: OlympiadPaper,
                                    tag: String) -> OlympiadPaper {
        let pdf = injectVariant(into: base.questionPaperPDF, tag: tag,
                                beforeExtension: true)
        let html = injectVariant(into: base.questionPaperHTML, tag: tag,
                                 beforeExtension: true)
        let qpMD = injectVariant(into: base.questionPaperMD, tag: tag,
                                 beforeSuffix: "_QuestionPaper.md")
        let solMD = injectVariant(into: base.solutionsMD, tag: tag,
                                  beforeSuffix: "_Solutions.md")
        let displaySuffix = " — Practice Paper \(paperNumber(forTag: tag))"
        return OlympiadPaper(
            id: "\(base.id)_\(tag.lowercased())",
            subjectId: base.subjectId,
            subjectName: base.subjectName,
            chapterNumber: base.chapterNumber,
            chapterTitle: base.chapterTitle,
            displayTitle: "\(base.chapterTitle)\(displaySuffix)",
            questionPaperMD: qpMD,
            solutionsMD: solMD,
            questionPaperHTML: html,
            questionPaperPDF: pdf,
            suggestedTimeMinutes: base.suggestedTimeMinutes,
            // Variants don't ship a Solved Guide HTML — the QA-sweep
            // tooling produces the QuestionPaper / Solutions / HTML /
            // PDF quad and stops there. The hub already gates the
            // "Solved Guide" CTA on `solvedGuideHTML != nil`, so a nil
            // here just hides the CTA on the variant cards.
            solvedGuideHTML: nil
        )
    }

    /// Insert `_<tag>` immediately before the file extension.
    /// Example: `Maths_Ch01_Foo.pdf` + `P3` → `Maths_Ch01_Foo_P3.pdf`.
    private static func injectVariant(into name: String,
                                      tag: String,
                                      beforeExtension: Bool) -> String {
        guard beforeExtension else { return name }
        let ns = name as NSString
        let ext = ns.pathExtension
        guard !ext.isEmpty else { return "\(name)_\(tag)" }
        let stem = ns.deletingPathExtension
        return "\(stem)_\(tag).\(ext)"
    }

    /// Insert `_<tag>` immediately before a known multi-token suffix
    /// such as `_QuestionPaper.md` or `_Solutions.md`. Example:
    /// `Maths_Ch01_Foo_QuestionPaper.md` + `P3` →
    /// `Maths_Ch01_Foo_P3_QuestionPaper.md`. Falls back to the
    /// extension-only splice if the expected suffix isn't present.
    private static func injectVariant(into name: String,
                                      tag: String,
                                      beforeSuffix suffix: String) -> String {
        if name.hasSuffix(suffix) {
            let head = String(name.dropLast(suffix.count))
            return "\(head)_\(tag)\(suffix)"
        }
        return injectVariant(into: name, tag: tag, beforeExtension: true)
    }

    /// Map the on-disk tag (`"P3"`, `"P4"`, `"P5"`) to the display
    /// number (`"3"`, `"4"`, `"5"`). The base paper is conceptually
    /// "Paper 1" and the Advanced track is "Paper 2"; P3/P4/P5 continue
    /// the numbering so the kid sees a coherent progression in the hub.
    private static func paperNumber(forTag tag: String) -> String {
        switch tag {
        case "P3": return "3"
        case "P4": return "4"
        case "P5": return "5"
        default:   return tag
        }
    }
}
