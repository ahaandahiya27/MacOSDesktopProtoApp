import Foundation

/// Grade-level tag for stretch ("Deep Dive") content shown to fast learners.
/// The string-backed raw values keep JSON authoring stable when new values
/// are added later — old packs without a value just decode as nil at the
/// call site.
enum GradeLevel: String, Codable, CaseIterable, Identifiable {
    case class8     = "class_8"
    case class9     = "class_9"
    case class10    = "class_10"
    case class11    = "class_11"
    case class12    = "class_12"
    case neetJee    = "neet_jee"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .class8:  return "Class 8"
        case .class9:  return "Class 9"
        case .class10: return "Class 10"
        case .class11: return "Class 11"
        case .class12: return "Class 12"
        case .neetJee: return "NEET / JEE"
        }
    }

    /// Maps to existing `Color.compat*` tokens so DeepDiveDisclosure badges
    /// stay coherent with the rest of the UI palette.
    var badgeTint: String {
        switch self {
        case .class8:            return "compatBlue"
        case .class9:            return "compatTeal"
        case .class10:           return "compatCyan"
        case .class11, .class12: return "compatIndigo"
        case .neetJee:           return "compatPurple"
        }
    }
}
