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

        // Class 7 Social Science (socialscience_class7) — strand-coded so the
        // Discover chrome + dashboard tint give each chapter a recognisable
        // identity. Geography = earth blues/greens; History = warm bronze/sepia;
        // Civics = authority indigo/slate; Economics = prosperity green/gold;
        // Culture/Society = saffron/magenta.
        case "ssch01": return Color(red: 0.16, green: 0.42, blue: 0.45)   // Geographical Diversity — deep teal-green
        case "ssch02": return Color(red: 0.26, green: 0.50, blue: 0.74)   // Weather — sky blue
        case "ssch03": return Color(red: 0.20, green: 0.46, blue: 0.62)   // Climates — ocean blue
        case "ssch04": return Color(red: 0.55, green: 0.40, blue: 0.22)   // Cities & States — clay bronze
        case "ssch05": return Color(red: 0.62, green: 0.34, blue: 0.16)   // Rise of Empires — burnt amber
        case "ssch06": return Color(red: 0.50, green: 0.30, blue: 0.20)   // Reorganisation — sepia
        case "ssch07": return Color(red: 0.58, green: 0.42, blue: 0.12)   // Gupta Era — gold
        case "ssch08": return Color(red: 0.72, green: 0.38, blue: 0.16)   // Land Becomes Sacred — saffron
        case "ssch09": return Color(red: 0.24, green: 0.30, blue: 0.55)   // Types of Governments — indigo
        case "ssch10": return Color(red: 0.20, green: 0.28, blue: 0.50)   // Constitution — deep blue
        case "ssch11": return Color(red: 0.20, green: 0.45, blue: 0.32)   // Barter to Money — green
        case "ssch12": return Color(red: 0.24, green: 0.48, blue: 0.30)   // Markets — market green
        case "ssch13": return Color(red: 0.30, green: 0.46, blue: 0.18)   // Indian Farming — field green
        case "ssch14": return Color(red: 0.18, green: 0.40, blue: 0.50)   // India & Her Neighbours — teal
        case "ssch15": return Color(red: 0.56, green: 0.32, blue: 0.24)   // Empires & Kingdoms 6th–10th — terracotta
        case "ssch16": return Color(red: 0.48, green: 0.28, blue: 0.28)   // Turning Tides 11th–12th — maroon
        case "ssch17": return Color(red: 0.55, green: 0.24, blue: 0.42)   // India, a Home to Many — magenta
        case "ssch18": return Color(red: 0.26, green: 0.32, blue: 0.46)   // State, Government & You — slate blue
        case "ssch19": return Color(red: 0.30, green: 0.44, blue: 0.40)   // Infrastructure — slate green
        case "ssch20": return Color(red: 0.22, green: 0.44, blue: 0.34)   // Banks & Finance — emerald

        // Class 7 Sanskrit (sanskrit_class7) — 15 NEP chapters (`sch01`–`sch15`).
        // Saffron / maroon / gold family, the traditional palette of Sanskrit
        // texts, so the Discover chrome gives each chapter its own warm identity
        // while reading unmistakably as the Sanskrit subject.
        case "sch01": return Color(red: 0.72, green: 0.38, blue: 0.12)   // वन्दे भारतमातरम् — saffron
        case "sch02": return Color(red: 0.58, green: 0.42, blue: 0.12)   // सुभाषितानि — gold
        case "sch03": return Color(red: 0.62, green: 0.34, blue: 0.16)   // burnt amber
        case "sch04": return Color(red: 0.56, green: 0.32, blue: 0.24)   // terracotta
        case "sch05": return Color(red: 0.50, green: 0.30, blue: 0.20)   // sepia
        case "sch06": return Color(red: 0.68, green: 0.36, blue: 0.14)   // marigold
        case "sch07": return Color(red: 0.48, green: 0.28, blue: 0.28)   // maroon
        case "sch08": return Color(red: 0.60, green: 0.40, blue: 0.10)   // turmeric gold
        case "sch09": return Color(red: 0.64, green: 0.32, blue: 0.18)   // copper
        case "sch10": return Color(red: 0.54, green: 0.36, blue: 0.16)   // ochre
        case "sch11": return Color(red: 0.55, green: 0.24, blue: 0.30)   // deep rose-maroon
        case "sch12": return Color(red: 0.70, green: 0.40, blue: 0.16)   // saffron-orange
        case "sch13": return Color(red: 0.52, green: 0.30, blue: 0.22)   // clay
        case "sch14": return Color(red: 0.58, green: 0.38, blue: 0.14)   // honey gold
        case "sch15": return Color(red: 0.66, green: 0.34, blue: 0.20)   // sienna

        default: return Color.compatIndigo
        }
    }
}
