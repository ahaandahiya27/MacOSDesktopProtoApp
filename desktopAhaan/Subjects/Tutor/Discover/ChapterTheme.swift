import SwiftUI

/// Per-chapter accent colour, used to tint Discover Mode chrome (current-scene
/// dot, footer scene title, progress-arc) and the dashboard so each chapter
/// has a recognisable visual identity. Palette is hand-tuned to roughly
/// match the colour swatch used in each chapter's article CSS, so the
/// Discover Mode chapter and the "Read the full article" surface feel like
/// the same chapter.
///
/// macOS 11 (Big Sur) compatible — uses only `Color(red:green:blue:)` and
/// has no `@available` requirements. Falls back to `compatIndigo` for any
/// unknown chapter id so the rest of the UI can ship before this table is
/// updated.
enum ChapterTheme {

    /// Returns the accent colour to use for the chapter with the given id.
    /// Pass `chapter.id` (e.g. "ch08") directly.
    static func accent(for chapterId: String) -> Color {
        switch chapterId {
        // Class 7 Science — biology
        case "ch01": return Color(red: 0.22, green: 0.55, blue: 0.30)   // Nutrition in Plants — leaf green
        case "ch02": return Color(red: 0.78, green: 0.42, blue: 0.18)   // Nutrition in Animals — warm digestion orange
        case "ch10": return Color(red: 0.54, green: 0.16, blue: 0.24)   // Respiration — lung pink-red
        case "ch11": return Color(red: 0.60, green: 0.14, blue: 0.10)   // Transportation — heart red
        case "ch12": return Color(red: 0.50, green: 0.16, blue: 0.42)   // Reproduction in Plants — flower magenta

        // Materials / chemistry
        case "ch03": return Color(red: 0.55, green: 0.40, blue: 0.30)   // Fibre to Fabric — wool brown
        case "ch05": return Color(red: 0.65, green: 0.30, blue: 0.70)   // Acids & Bases — pH purple
        case "ch06": return Color(red: 0.30, green: 0.50, blue: 0.75)   // Physical & Chemical Changes — blue

        // Physics
        case "ch04": return Color(red: 0.85, green: 0.40, blue: 0.20)   // Heat — hot red
        case "ch13": return Color(red: 0.12, green: 0.35, blue: 0.29)   // Motion & Time — track green
        case "ch14": return Color(red: 0.53, green: 0.35, blue: 0.06)   // Electric Current — amber
        case "ch15": return Color(red: 0.16, green: 0.25, blue: 0.48)   // Light — indigo

        // Weather / Earth / environment
        case "ch07": return Color(red: 0.30, green: 0.55, blue: 0.78)   // Weather, Climate — sky blue
        case "ch08": return Color(red: 0.29, green: 0.47, blue: 0.76)   // Winds, Storms — storm blue
        case "ch09": return Color(red: 0.42, green: 0.29, blue: 0.12)   // Soil — earth brown
        case "ch16": return Color(red: 0.11, green: 0.34, blue: 0.44)   // Water — deep teal
        case "ch17": return Color(red: 0.18, green: 0.38, blue: 0.16)   // Forests — deep green
        case "ch18": return Color(red: 0.21, green: 0.32, blue: 0.44)   // Wastewater — slate

        // Space
        case "ch19": return Color(red: 0.20, green: 0.18, blue: 0.40)   // Earth, Moon, Sun — midnight indigo

        default: return Color.compatIndigo
        }
    }
}
