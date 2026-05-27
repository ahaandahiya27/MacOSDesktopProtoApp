import Foundation

struct ArticleEntry: Hashable, Identifiable {
    let id: String
    let filename: String
    let title: String
    let chapterFolder: String
    let estimatedMinutes: Int
}

enum ArticleIndex {
    /// Namespaces an article base key (e.g. `"ch05_glossary"`) to the owning
    /// subject pack. Maths article keys carry an `m` prefix
    /// (`mch05_glossary`); Science reuses the bare key. Returns nil for packs
    /// that ship no articles (e.g. Sanskrit) so callers gate the surface off
    /// entirely.
    ///
    /// Pure + testable single source of truth so a cross-subject article leak
    /// (a Maths chapter resolving to a Science `chNN_` article because the key
    /// was built from the shared `chapter.id` alone) can't recur silently.
    static func packScopedKey(forPackId packId: String, baseKey: String) -> String? {
        switch packId {
        case "science_class7": return baseKey
        case "maths_class7":   return "m" + baseKey
        default:               return nil
        }
    }

    static let chapter1Folder = "Articles/Chapter1"
    static let chapter2Folder = "Articles/Chapter2"
    static let chapter3Folder = "Articles/Chapter3"
    static let chapter4Folder = "Articles/Chapter4"
    static let chapter5Folder = "Articles/Chapter5"
    static let chapter6Folder = "Articles/Chapter6"
    static let chapter7Folder = "Articles/Chapter7"
    static let chapter8Folder = "Articles/Chapter8"
    static let chapter9Folder = "Articles/Chapter9"
    static let chapter10Folder = "Articles/Chapter10"
    static let chapter11Folder = "Articles/Chapter11"
    static let chapter12Folder = "Articles/Chapter12"
    static let chapter13Folder = "Articles/Chapter13"
    static let chapter14Folder = "Articles/Chapter14"
    static let chapter15Folder = "Articles/Chapter15"
    static let chapter16Folder = "Articles/Chapter16"
    static let chapter17Folder = "Articles/Chapter17"
    static let chapter18Folder = "Articles/Chapter18"
    static let chapter19Folder = "Articles/Chapter19"

    static let entries: [String: ArticleEntry] = [
        // Chapter overview
        "ch01": ArticleEntry(
            id: "ch01",
            filename: "ch01_overview.html",
            title: "Nutrition in Plants — Chapter Overview",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 6
        ),

        // Topic 1: How Plants Make Their Own Food
        "ch01_t01": ArticleEntry(
            id: "ch01_t01",
            filename: "ch01_t01_overview.html",
            title: "How Plants Make Their Own Food — Topic Overview",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 5
        ),
        "ch01_t01_c01": ArticleEntry(
            id: "ch01_t01_c01",
            filename: "ch01_t01_c01.html",
            title: "Autotrophs and Heterotrophs",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 5
        ),
        "ch01_t01_c02": ArticleEntry(
            id: "ch01_t01_c02",
            filename: "ch01_t01_c02.html",
            title: "Photosynthesis: The Food-Making Process",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 6
        ),
        "ch01_t01_c03": ArticleEntry(
            id: "ch01_t01_c03",
            filename: "ch01_t01_c03.html",
            title: "Chlorophyll: Why Leaves Are Green",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 5
        ),
        "ch01_t01_c04": ArticleEntry(
            id: "ch01_t01_c04",
            filename: "ch01_t01_c04.html",
            title: "Stomata, Xylem and the Plumbing of a Leaf",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 6
        ),
        "ch01_t01_c05": ArticleEntry(
            id: "ch01_t01_c05",
            filename: "ch01_t01_c05.html",
            title: "Modes of Nutrition",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 5
        ),
        "ch01_t01_c06": ArticleEntry(
            id: "ch01_t01_c06",
            filename: "ch01_t01_c06.html",
            title: "Why Plants Need Food",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 4
        ),
        "ch01_t01_c07": ArticleEntry(
            id: "ch01_t01_c07",
            filename: "ch01_t01_c07.html",
            title: "The Four Conditions for Photosynthesis",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 5
        ),
        "ch01_t01_c08": ArticleEntry(
            id: "ch01_t01_c08",
            filename: "ch01_t01_c08.html",
            title: "The Iodine Test for Starch",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 4
        ),
        "ch01_t01_c09": ArticleEntry(
            id: "ch01_t01_c09",
            filename: "ch01_t01_c09.html",
            title: "Why Leaves Are Broad and Thin",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 5
        ),
        "ch01_t01_c10": ArticleEntry(
            id: "ch01_t01_c10",
            filename: "ch01_t01_c10.html",
            title: "Photosynthesis Beyond Leaves",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 6
        ),

        // Topic 2: Plants That Don't Make Their Own Food
        "ch01_t02": ArticleEntry(
            id: "ch01_t02",
            filename: "ch01_t02_overview.html",
            title: "Plants That Don't Make Their Own Food — Topic Overview",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 4
        ),
        "ch01_t02_c01": ArticleEntry(
            id: "ch01_t02_c01",
            filename: "ch01_t02_c01.html",
            title: "Parasitic Plants",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 5
        ),
        "ch01_t02_c02": ArticleEntry(
            id: "ch01_t02_c02",
            filename: "ch01_t02_c02.html",
            title: "Insectivorous Plants — The Bug Eaters",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 6
        ),
        "ch01_t02_c03": ArticleEntry(
            id: "ch01_t02_c03",
            filename: "ch01_t02_c03.html",
            title: "Saprophytic Nutrition — Feeding on the Dead",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 5
        ),
        "ch01_t02_c04": ArticleEntry(
            id: "ch01_t02_c04",
            filename: "ch01_t02_c04.html",
            title: "Symbiotic Nutrition — Partners Helping Each Other",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 6
        ),
        "ch01_t02_c05": ArticleEntry(
            id: "ch01_t02_c05",
            filename: "ch01_t02_c05.html",
            title: "The Family of Relationships — Symbiosis vs Parasitism",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 5
        ),
        "ch01_t02_c06": ArticleEntry(
            id: "ch01_t02_c06",
            filename: "ch01_t02_c06.html",
            title: "Insectivorous Plant Diversity",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 5
        ),
        "ch01_t02_c07": ArticleEntry(
            id: "ch01_t02_c07",
            filename: "ch01_t02_c07.html",
            title: "Saprotrophs and the Recycling of Death",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 6
        ),

        // Topic 3: Soil, Nitrogen and the Food Chain
        "ch01_t03": ArticleEntry(
            id: "ch01_t03",
            filename: "ch01_t03_overview.html",
            title: "Soil, Nitrogen and the Food Chain — Topic Overview",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 4
        ),
        "ch01_t03_c01": ArticleEntry(
            id: "ch01_t03_c01",
            filename: "ch01_t03_c01.html",
            title: "Why Plants Need Nitrogen",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 5
        ),
        "ch01_t03_c02": ArticleEntry(
            id: "ch01_t03_c02",
            filename: "ch01_t03_c02.html",
            title: "Replenishing Soil Nutrients",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 6
        ),
        "ch01_t03_c03": ArticleEntry(
            id: "ch01_t03_c03",
            filename: "ch01_t03_c03.html",
            title: "Plants as the First Link in the Food Chain",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 5
        ),
        "ch01_t03_c04": ArticleEntry(
            id: "ch01_t03_c04",
            filename: "ch01_t03_c04.html",
            title: "Plants Talk to Each Other",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 6
        ),

        // Beyond the Book — chapter-level enrichment
        "ch01_beyond": ArticleEntry(
            id: "ch01_beyond",
            filename: "ch01_beyond.html",
            title: "Beyond the Book — Ten Mind-Stretchers",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 12
        ),

        // "Ways of Learning" — alternative content surfaces for Ch.1.
        // Linked from a hub block at the bottom of ch01_beyond.html.
        "ch01_scientists": ArticleEntry(
            id: "ch01_scientists",
            filename: "ch01_scientists.html",
            title: "Famous Plant Scientists — A 400-Year Timeline",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 8
        ),
        "ch01_storymode": ArticleEntry(
            id: "ch01_storymode",
            filename: "ch01_storymode.html",
            title: "A Day in the Life of a Leaf",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 7
        ),
        "ch01_whatif": ArticleEntry(
            id: "ch01_whatif",
            filename: "ch01_whatif.html",
            title: "What If? — Five Plant Thought Experiments",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 8
        ),
        "ch01_glossary": ArticleEntry(
            id: "ch01_glossary",
            filename: "ch01_glossary.html",
            title: "Kid's Plant Biology Dictionary (English · Hindi · Sanskrit)",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 6
        ),
        "ch01_plantoftheday": ArticleEntry(
            id: "ch01_plantoftheday",
            filename: "ch01_plantoftheday.html",
            title: "Seven Plants You Should Know About",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 8
        ),
        "ch01_miniproject": ArticleEntry(
            id: "ch01_miniproject",
            filename: "ch01_miniproject.html",
            title: "Mini Project — Grow a Chickpea, Build a Plant Diary",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 14
        ),
        "ch01_selfcheck": ArticleEntry(
            id: "ch01_selfcheck",
            filename: "ch01_selfcheck.html",
            title: "Self-Check — Are You Ready for the Boss Quiz?",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 5
        ),
        "ch01_bridge": ArticleEntry(
            id: "ch01_bridge",
            filename: "ch01_bridge.html",
            title: "What's Next — Where Chapter 1 Leads (Class 8 → NEET)",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 6
        ),
        "ch01_mistakes": ArticleEntry(
            id: "ch01_mistakes",
            filename: "ch01_mistakes.html",
            title: "Ten Wrong Answers Class 7 Students Give",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 10
        ),
        "ch01_ncert_qa": ArticleEntry(
            id: "ch01_ncert_qa",
            filename: "ch01_ncert_qa.html",
            title: "NCERT Exercise Q&A — Chapter 1",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 14
        ),
        "ch01_infographic": ArticleEntry(
            id: "ch01_infographic",
            filename: "ch01_infographic.html",
            title: "Chapter 1 Infographic — The Whole Chapter on One Page",
            chapterFolder: chapter1Folder,
            estimatedMinutes: 5
        ),

        // ================================================================
        // CHAPTER 2 — Nutrition in Animals
        // ================================================================
        "ch02": ArticleEntry(id: "ch02", filename: "ch02_overview.html",
            title: "Nutrition in Animals — Chapter Overview",
            chapterFolder: chapter2Folder, estimatedMinutes: 6),

        "ch02_t01": ArticleEntry(id: "ch02_t01", filename: "ch02_t01_overview.html",
            title: "How the Human Body Turns Food into Fuel — Topic Overview",
            chapterFolder: chapter2Folder, estimatedMinutes: 5),
        "ch02_t01_c01": ArticleEntry(id: "ch02_t01_c01", filename: "ch02_t01_c01.html",
            title: "The Five Steps of Nutrition",
            chapterFolder: chapter2Folder, estimatedMinutes: 5),
        "ch02_t01_c02": ArticleEntry(id: "ch02_t01_c02", filename: "ch02_t01_c02.html",
            title: "Different Ways Animals Take Food In",
            chapterFolder: chapter2Folder, estimatedMinutes: 5),
        "ch02_t01_c03": ArticleEntry(id: "ch02_t01_c03", filename: "ch02_t01_c03.html",
            title: "The Mouth and Your 32 Teeth",
            chapterFolder: chapter2Folder, estimatedMinutes: 5),
        "ch02_t01_c04": ArticleEntry(id: "ch02_t01_c04", filename: "ch02_t01_c04.html",
            title: "The Stomach: A Churning Chemical Bag",
            chapterFolder: chapter2Folder, estimatedMinutes: 6),
        "ch02_t01_c05": ArticleEntry(id: "ch02_t01_c05", filename: "ch02_t01_c05.html",
            title: "Small Intestine — Where Digestion Finishes",
            chapterFolder: chapter2Folder, estimatedMinutes: 6),
        "ch02_t01_c06": ArticleEntry(id: "ch02_t01_c06", filename: "ch02_t01_c06.html",
            title: "Large Intestine — Water, Waste, Goodbye",
            chapterFolder: chapter2Folder, estimatedMinutes: 5),
        "ch02_t01_c07": ArticleEntry(id: "ch02_t01_c07", filename: "ch02_t01_c07.html",
            title: "The Oesophagus and Swallowing",
            chapterFolder: chapter2Folder, estimatedMinutes: 4),
        "ch02_t01_c08": ArticleEntry(id: "ch02_t01_c08", filename: "ch02_t01_c08.html",
            title: "The Liver and Bile — Breaking Down Fats",
            chapterFolder: chapter2Folder, estimatedMinutes: 5),
        "ch02_t01_c09": ArticleEntry(id: "ch02_t01_c09", filename: "ch02_t01_c09.html",
            title: "The Pancreas and Digestive Enzymes",
            chapterFolder: chapter2Folder, estimatedMinutes: 5),
        "ch02_t01_c10": ArticleEntry(id: "ch02_t01_c10", filename: "ch02_t01_c10.html",
            title: "Saliva and the First Taste of Digestion",
            chapterFolder: chapter2Folder, estimatedMinutes: 4),
        "ch02_t01_c11": ArticleEntry(id: "ch02_t01_c11", filename: "ch02_t01_c11.html",
            title: "Villi and Microvilli — Maximum Surface for Absorption",
            chapterFolder: chapter2Folder, estimatedMinutes: 5),
        "ch02_t01_c12": ArticleEntry(id: "ch02_t01_c12", filename: "ch02_t01_c12.html",
            title: "Peristalsis — How Food Moves Along",
            chapterFolder: chapter2Folder, estimatedMinutes: 4),

        "ch02_t02": ArticleEntry(id: "ch02_t02", filename: "ch02_t02_overview.html",
            title: "Special Diets — Ruminants and Amoeba — Topic Overview",
            chapterFolder: chapter2Folder, estimatedMinutes: 4),
        "ch02_t02_c01": ArticleEntry(id: "ch02_t02_c01", filename: "ch02_t02_c01.html",
            title: "Rumination — How a Cow Digests Grass",
            chapterFolder: chapter2Folder, estimatedMinutes: 6),
        "ch02_t02_c02": ArticleEntry(id: "ch02_t02_c02", filename: "ch02_t02_c02.html",
            title: "Amoeba — Digestion Inside a Single Cell",
            chapterFolder: chapter2Folder, estimatedMinutes: 5),
        "ch02_t02_c03": ArticleEntry(id: "ch02_t02_c03", filename: "ch02_t02_c03.html",
            title: "Herbivores vs Omnivores vs Carnivores",
            chapterFolder: chapter2Folder, estimatedMinutes: 5),
        "ch02_t02_c04": ArticleEntry(id: "ch02_t02_c04", filename: "ch02_t02_c04.html",
            title: "Symbiosis in Digestion — The Rumen Microbiome",
            chapterFolder: chapter2Folder, estimatedMinutes: 5),
        "ch02_t02_c05": ArticleEntry(id: "ch02_t02_c05", filename: "ch02_t02_c05.html",
            title: "Single-Celled Feeders — Paramecium and Euglena",
            chapterFolder: chapter2Folder, estimatedMinutes: 5),

        "ch02_t03": ArticleEntry(id: "ch02_t03", filename: "ch02_t03_overview.html",
            title: "The Journey of Nutrition — Topic Overview",
            chapterFolder: chapter2Folder, estimatedMinutes: 4),
        "ch02_t03_c01": ArticleEntry(id: "ch02_t03_c01", filename: "ch02_t03_c01.html",
            title: "How Cells Use Absorbed Nutrients — Energy Factory",
            chapterFolder: chapter2Folder, estimatedMinutes: 6),
        "ch02_t03_c02": ArticleEntry(id: "ch02_t03_c02", filename: "ch02_t03_c02.html",
            title: "Assimilation — Growth, Repair, and Building Tissue",
            chapterFolder: chapter2Folder, estimatedMinutes: 5),
        "ch02_t03_c03": ArticleEntry(id: "ch02_t03_c03", filename: "ch02_t03_c03.html",
            title: "Smell, Taste and the Science of Flavour",
            chapterFolder: chapter2Folder, estimatedMinutes: 5),

        // Beyond the Book — chapter-level enrichment
        "ch02_beyond": ArticleEntry(id: "ch02_beyond", filename: "ch02_beyond.html",
            title: "Beyond the Book — Ten Mind-Stretchers About How Animals Eat",
            chapterFolder: chapter2Folder, estimatedMinutes: 12),

        // Beyond the Book Ch.3-19 — generated 2026-05-26 from
        // chapter.deepDive (3 entries each) via
        // scripts/generate_beyond_articles.py. Ch.1 + Ch.2 keep their
        // bespoke hand-authored anchor articles (the 10-section and
        // 5-section narratives above). Brings the Beyond surface to
        // 19/19 coverage.
        "ch03_beyond": ArticleEntry(id: "ch03_beyond", filename: "ch03_beyond.html",
            title: "Beyond the Book — Three Mind-Stretchers About Fibre to Fabric",
            chapterFolder: chapter3Folder, estimatedMinutes: 9),
        "ch04_beyond": ArticleEntry(id: "ch04_beyond", filename: "ch04_beyond.html",
            title: "Beyond the Book — Three Mind-Stretchers About Heat",
            chapterFolder: chapter4Folder, estimatedMinutes: 9),
        "ch05_beyond": ArticleEntry(id: "ch05_beyond", filename: "ch05_beyond.html",
            title: "Beyond the Book — Three Mind-Stretchers About Acids, Bases and Salts",
            chapterFolder: chapter5Folder, estimatedMinutes: 9),
        "ch06_beyond": ArticleEntry(id: "ch06_beyond", filename: "ch06_beyond.html",
            title: "Beyond the Book — Three Mind-Stretchers About Physical and Chemical Changes",
            chapterFolder: chapter6Folder, estimatedMinutes: 9),
        "ch07_beyond": ArticleEntry(id: "ch07_beyond", filename: "ch07_beyond.html",
            title: "Beyond the Book — Three Mind-Stretchers About Weather, Climate and Adaptations",
            chapterFolder: chapter7Folder, estimatedMinutes: 9),
        "ch08_beyond": ArticleEntry(id: "ch08_beyond", filename: "ch08_beyond.html",
            title: "Beyond the Book — Three Mind-Stretchers About Winds, Storms and Cyclones",
            chapterFolder: chapter8Folder, estimatedMinutes: 9),
        "ch09_beyond": ArticleEntry(id: "ch09_beyond", filename: "ch09_beyond.html",
            title: "Beyond the Book — Three Mind-Stretchers About Soil",
            chapterFolder: chapter9Folder, estimatedMinutes: 9),
        "ch10_beyond": ArticleEntry(id: "ch10_beyond", filename: "ch10_beyond.html",
            title: "Beyond the Book — Three Mind-Stretchers About Respiration",
            chapterFolder: chapter10Folder, estimatedMinutes: 9),
        "ch11_beyond": ArticleEntry(id: "ch11_beyond", filename: "ch11_beyond.html",
            title: "Beyond the Book — Three Mind-Stretchers About Transportation",
            chapterFolder: chapter11Folder, estimatedMinutes: 9),
        "ch12_beyond": ArticleEntry(id: "ch12_beyond", filename: "ch12_beyond.html",
            title: "Beyond the Book — Three Mind-Stretchers About Reproduction in Plants",
            chapterFolder: chapter12Folder, estimatedMinutes: 9),
        "ch13_beyond": ArticleEntry(id: "ch13_beyond", filename: "ch13_beyond.html",
            title: "Beyond the Book — Three Mind-Stretchers About Motion and Time",
            chapterFolder: chapter13Folder, estimatedMinutes: 9),
        "ch14_beyond": ArticleEntry(id: "ch14_beyond", filename: "ch14_beyond.html",
            title: "Beyond the Book — Three Mind-Stretchers About Electric Current",
            chapterFolder: chapter14Folder, estimatedMinutes: 9),
        "ch15_beyond": ArticleEntry(id: "ch15_beyond", filename: "ch15_beyond.html",
            title: "Beyond the Book — Three Mind-Stretchers About Light",
            chapterFolder: chapter15Folder, estimatedMinutes: 9),
        "ch16_beyond": ArticleEntry(id: "ch16_beyond", filename: "ch16_beyond.html",
            title: "Beyond the Book — Three Mind-Stretchers About Water",
            chapterFolder: chapter16Folder, estimatedMinutes: 9),
        "ch17_beyond": ArticleEntry(id: "ch17_beyond", filename: "ch17_beyond.html",
            title: "Beyond the Book — Three Mind-Stretchers About Forests",
            chapterFolder: chapter17Folder, estimatedMinutes: 9),
        "ch18_beyond": ArticleEntry(id: "ch18_beyond", filename: "ch18_beyond.html",
            title: "Beyond the Book — Three Mind-Stretchers About Wastewater",
            chapterFolder: chapter18Folder, estimatedMinutes: 9),
        "ch19_beyond": ArticleEntry(id: "ch19_beyond", filename: "ch19_beyond.html",
            title: "Beyond the Book — Three Mind-Stretchers About Earth, Moon and Sun",
            chapterFolder: chapter19Folder, estimatedMinutes: 9),

        // ================================================================
        // CHAPTER 3 — Fibre to Fabric
        // ================================================================
        "ch03": ArticleEntry(id: "ch03", filename: "ch03_overview.html",
            title: "Fibre to Fabric — Chapter Overview",
            chapterFolder: chapter3Folder, estimatedMinutes: 6),

        "ch03_t01": ArticleEntry(id: "ch03_t01", filename: "ch03_t01_overview.html",
            title: "Wool — From Sheep to Sweater — Topic Overview",
            chapterFolder: chapter3Folder, estimatedMinutes: 5),
        "ch03_t01_c01": ArticleEntry(id: "ch03_t01_c01", filename: "ch03_t01_c01.html",
            title: "Animal Fibres vs Plant Fibres",
            chapterFolder: chapter3Folder, estimatedMinutes: 6),
        "ch03_t01_c02": ArticleEntry(id: "ch03_t01_c02", filename: "ch03_t01_c02.html",
            title: "Wool-Yielding Animals",
            chapterFolder: chapter3Folder, estimatedMinutes: 6),
        "ch03_t01_c03": ArticleEntry(id: "ch03_t01_c03", filename: "ch03_t01_c03.html",
            title: "From Fleece to Fabric — The Wool Pipeline",
            chapterFolder: chapter3Folder, estimatedMinutes: 5),
        "ch03_t01_c04": ArticleEntry(id: "ch03_t01_c04", filename: "ch03_t01_c04.html",
            title: "Sorter's Disease — The Hidden Cost of Wool",
            chapterFolder: chapter3Folder, estimatedMinutes: 5),
        "ch03_t01_c05": ArticleEntry(id: "ch03_t01_c05", filename: "ch03_t01_c05.html",
            title: "Types and Classifications of Wool",
            chapterFolder: chapter3Folder, estimatedMinutes: 5),
        "ch03_t01_c06": ArticleEntry(id: "ch03_t01_c06", filename: "ch03_t01_c06.html",
            title: "Hair Types in Sheep — Guard Hair and Undercoat",
            chapterFolder: chapter3Folder, estimatedMinutes: 5),
        "ch03_t01_c07": ArticleEntry(id: "ch03_t01_c07", filename: "ch03_t01_c07.html",
            title: "Fabric Care and Wool Washing Science",
            chapterFolder: chapter3Folder, estimatedMinutes: 5),
        "ch03_t01_c08": ArticleEntry(id: "ch03_t01_c08", filename: "ch03_t01_c08.html",
            title: "Plant Fibres vs Animal Fibres Compared",
            chapterFolder: chapter3Folder, estimatedMinutes: 6),

        "ch03_t02": ArticleEntry(id: "ch03_t02", filename: "ch03_t02_overview.html",
            title: "Silk — The Cocoon-Spun Fabric — Topic Overview",
            chapterFolder: chapter3Folder, estimatedMinutes: 5),
        "ch03_t02_c01": ArticleEntry(id: "ch03_t02_c01", filename: "ch03_t02_c01.html",
            title: "Sericulture and the Silkworm Life Cycle",
            chapterFolder: chapter3Folder, estimatedMinutes: 6),
        "ch03_t02_c02": ArticleEntry(id: "ch03_t02_c02", filename: "ch03_t02_c02.html",
            title: "Reeling Cocoons into Silk Fibre",
            chapterFolder: chapter3Folder, estimatedMinutes: 6),
        "ch03_t02_c03": ArticleEntry(id: "ch03_t02_c03", filename: "ch03_t02_c03.html",
            title: "Types of Silk Around the World",
            chapterFolder: chapter3Folder, estimatedMinutes: 6),
        "ch03_t02_c04": ArticleEntry(id: "ch03_t02_c04", filename: "ch03_t02_c04.html",
            title: "Ethical Concerns in Silk Production",
            chapterFolder: chapter3Folder, estimatedMinutes: 6),

        "ch03_t03": ArticleEntry(id: "ch03_t03", filename: "ch03_t03_overview.html",
            title: "Synthetic vs Natural Fibres — Topic Overview",
            chapterFolder: chapter3Folder, estimatedMinutes: 4),
        "ch03_t03_c01": ArticleEntry(id: "ch03_t03_c01", filename: "ch03_t03_c01.html",
            title: "Synthetic vs Natural Fibres",
            chapterFolder: chapter3Folder, estimatedMinutes: 6),
        "ch03_t03_c02": ArticleEntry(id: "ch03_t03_c02", filename: "ch03_t03_c02.html",
            title: "The Global Textile Industry",
            chapterFolder: chapter3Folder, estimatedMinutes: 6),
        "ch03_t03_c03": ArticleEntry(id: "ch03_t03_c03", filename: "ch03_t03_c03.html",
            title: "Spider Silk — Nature's Engineering Marvel",
            chapterFolder: chapter3Folder, estimatedMinutes: 6),

        // ================================================================
        // CHAPTER 4 — Heat
        // ================================================================
        "ch04": ArticleEntry(id: "ch04", filename: "ch04_overview.html",
            title: "Heat — Chapter Overview",
            chapterFolder: chapter4Folder, estimatedMinutes: 6),

        // Topic 1: Heat, Temperature, and Thermometers
        "ch04_t01": ArticleEntry(id: "ch04_t01", filename: "ch04_t01_overview.html",
            title: "Heat, Temperature, and Thermometers — Topic Overview",
            chapterFolder: chapter4Folder, estimatedMinutes: 5),
        "ch04_t01_c01": ArticleEntry(id: "ch04_t01_c01", filename: "ch04_t01_c01.html",
            title: "Heat vs Temperature — What's the Difference?",
            chapterFolder: chapter4Folder, estimatedMinutes: 6),
        "ch04_t01_c02": ArticleEntry(id: "ch04_t01_c02", filename: "ch04_t01_c02.html",
            title: "How a Thermometer Works",
            chapterFolder: chapter4Folder, estimatedMinutes: 5),
        "ch04_t01_c03": ArticleEntry(id: "ch04_t01_c03", filename: "ch04_t01_c03.html",
            title: "Celsius and Kelvin — Converting Between Scales",
            chapterFolder: chapter4Folder, estimatedMinutes: 5),
        "ch04_t01_c04": ArticleEntry(id: "ch04_t01_c04", filename: "ch04_t01_c04.html",
            title: "Why Hot Things Cool Down (Newton's Law of Cooling)",
            chapterFolder: chapter4Folder, estimatedMinutes: 6),
        "ch04_t01_c05": ArticleEntry(id: "ch04_t01_c05", filename: "ch04_t01_c05.html",
            title: "Temperature vs Heat — the Surprise Difference",
            chapterFolder: chapter4Folder, estimatedMinutes: 5),
        "ch04_t01_c06": ArticleEntry(id: "ch04_t01_c06", filename: "ch04_t01_c06.html",
            title: "Why Mercury Was Used in Thermometers",
            chapterFolder: chapter4Folder, estimatedMinutes: 5),
        "ch04_t01_c07": ArticleEntry(id: "ch04_t01_c07", filename: "ch04_t01_c07.html",
            title: "Specific Heat Capacity — Why Water is Special",
            chapterFolder: chapter4Folder, estimatedMinutes: 7),

        // Topic 2: How Heat Travels
        "ch04_t02": ArticleEntry(id: "ch04_t02", filename: "ch04_t02_overview.html",
            title: "How Heat Travels — Conduction, Convection, Radiation — Topic Overview",
            chapterFolder: chapter4Folder, estimatedMinutes: 5),
        "ch04_t02_c01": ArticleEntry(id: "ch04_t02_c01", filename: "ch04_t02_c01.html",
            title: "Conduction — Heat Travelling Through Solids",
            chapterFolder: chapter4Folder, estimatedMinutes: 6),
        "ch04_t02_c02": ArticleEntry(id: "ch04_t02_c02", filename: "ch04_t02_c02.html",
            title: "Convection — Heat Travelling Through Fluids",
            chapterFolder: chapter4Folder, estimatedMinutes: 6),
        "ch04_t02_c03": ArticleEntry(id: "ch04_t02_c03", filename: "ch04_t02_c03.html",
            title: "Radiation — Heat Travelling Without Any Material",
            chapterFolder: chapter4Folder, estimatedMinutes: 5),
        "ch04_t02_c04": ArticleEntry(id: "ch04_t02_c04", filename: "ch04_t02_c04.html",
            title: "Thermos Flask — Beating All Three Heat Modes",
            chapterFolder: chapter4Folder, estimatedMinutes: 6),
        "ch04_t02_c05": ArticleEntry(id: "ch04_t02_c05", filename: "ch04_t02_c05.html",
            title: "Cooking Vessels — Why Copper Bottoms, Wooden Handles",
            chapterFolder: chapter4Folder, estimatedMinutes: 5),
        "ch04_t02_c06": ArticleEntry(id: "ch04_t02_c06", filename: "ch04_t02_c06.html",
            title: "Sea Breeze and Land Breeze — Convection at Coastal Scale",
            chapterFolder: chapter4Folder, estimatedMinutes: 6),

        // Topic 3: Heat in Bodies, Climates, and the Future
        "ch04_t03": ArticleEntry(id: "ch04_t03", filename: "ch04_t03_overview.html",
            title: "Heat in Bodies, Climates, and the Future — Topic Overview",
            chapterFolder: chapter4Folder, estimatedMinutes: 5),
        "ch04_t03_c01": ArticleEntry(id: "ch04_t03_c01", filename: "ch04_t03_c01.html",
            title: "Heat in the Human Body — Why 37 C, Why You Sweat",
            chapterFolder: chapter4Folder, estimatedMinutes: 6),
        "ch04_t03_c02": ArticleEntry(id: "ch04_t03_c02", filename: "ch04_t03_c02.html",
            title: "Heat and Climate Change — A Planet With a Fever",
            chapterFolder: chapter4Folder, estimatedMinutes: 7),
        "ch04_t03_c03": ArticleEntry(id: "ch04_t03_c03", filename: "ch04_t03_c03.html",
            title: "The Strange World of Cryogenics",
            chapterFolder: chapter4Folder, estimatedMinutes: 6),

        // ================================================================
        // CHAPTER 5 — Acids, Bases and Salts
        // ================================================================
        "ch05": ArticleEntry(id: "ch05", filename: "ch05_overview.html",
            title: "Acids, Bases and Salts — Chapter Overview",
            chapterFolder: chapter5Folder, estimatedMinutes: 6),

        // Topic 1: Acids and bases — the two opposite families
        "ch05_t01": ArticleEntry(id: "ch05_t01", filename: "ch05_t01_overview.html",
            title: "Acids and Bases — The Two Opposite Families — Topic Overview",
            chapterFolder: chapter5Folder, estimatedMinutes: 5),
        "ch05_t01_c01": ArticleEntry(id: "ch05_t01_c01", filename: "ch05_t01_c01.html",
            title: "Acids — The Sour Family",
            chapterFolder: chapter5Folder, estimatedMinutes: 6),
        "ch05_t01_c02": ArticleEntry(id: "ch05_t01_c02", filename: "ch05_t01_c02.html",
            title: "Bases — The Bitter, Soapy Family",
            chapterFolder: chapter5Folder, estimatedMinutes: 6),
        "ch05_t01_c03": ArticleEntry(id: "ch05_t01_c03", filename: "ch05_t01_c03.html",
            title: "Indicators — How We Tell Acids from Bases",
            chapterFolder: chapter5Folder, estimatedMinutes: 5),
        "ch05_t01_c04": ArticleEntry(id: "ch05_t01_c04", filename: "ch05_t01_c04.html",
            title: "The pH Scale — Measuring Acidity and Alkalinity",
            chapterFolder: chapter5Folder, estimatedMinutes: 6),
        "ch05_t01_c05": ArticleEntry(id: "ch05_t01_c05", filename: "ch05_t01_c05.html",
            title: "Strong vs Weak Acids and Bases",
            chapterFolder: chapter5Folder, estimatedMinutes: 5),
        "ch05_t01_c06": ArticleEntry(id: "ch05_t01_c06", filename: "ch05_t01_c06.html",
            title: "Natural Indicators — Turmeric, Litmus, and More",
            chapterFolder: chapter5Folder, estimatedMinutes: 5),
        "ch05_t01_c07": ArticleEntry(id: "ch05_t01_c07", filename: "ch05_t01_c07.html",
            title: "Acids and Bases in the Kitchen",
            chapterFolder: chapter5Folder, estimatedMinutes: 5),

        // Topic 2: Neutralization and salts
        "ch05_t02": ArticleEntry(id: "ch05_t02", filename: "ch05_t02_overview.html",
            title: "Neutralisation and Salts — Topic Overview",
            chapterFolder: chapter5Folder, estimatedMinutes: 5),
        "ch05_t02_c01": ArticleEntry(id: "ch05_t02_c01", filename: "ch05_t02_c01.html",
            title: "Neutralisation — When Acid Meets Base",
            chapterFolder: chapter5Folder, estimatedMinutes: 6),
        "ch05_t02_c02": ArticleEntry(id: "ch05_t02_c02", filename: "ch05_t02_c02.html",
            title: "Salts in Everyday Life",
            chapterFolder: chapter5Folder, estimatedMinutes: 5),
        // ch05_t02_c03..c05 — entries removed 2026-05-21: HTML files were
        // never authored, so the kid was seeing "Article not found".
        // Concept content still lives in the pack JSON; restore entries
        // here once the HTML files are written and added to Xcode.

        // Topic 3: Acids and Bases in Industry and Nature
        "ch05_t03": ArticleEntry(id: "ch05_t03", filename: "ch05_t03_overview.html",
            title: "Acids and Bases in Industry and Nature — Topic Overview",
            chapterFolder: chapter5Folder, estimatedMinutes: 4),
        "ch05_t03_c01": ArticleEntry(id: "ch05_t03_c01", filename: "ch05_t03_c01.html",
            title: "Acids in Industry — From Batteries to Fertilisers",
            chapterFolder: chapter5Folder, estimatedMinutes: 6),
        "ch05_t03_c02": ArticleEntry(id: "ch05_t03_c02", filename: "ch05_t03_c02.html",
            title: "The Chemistry of Tooth Decay",
            chapterFolder: chapter5Folder, estimatedMinutes: 5),
        "ch05_t03_c03": ArticleEntry(id: "ch05_t03_c03", filename: "ch05_t03_c03.html",
            title: "Ocean Acidification — Acids in the Sea",
            chapterFolder: chapter5Folder, estimatedMinutes: 6),

        // ================================================================
        // CHAPTER 6 — Physical and Chemical Changes
        // ================================================================
        "ch06": ArticleEntry(id: "ch06", filename: "ch06_overview.html",
            title: "Physical and Chemical Changes — Chapter Overview",
            chapterFolder: chapter6Folder, estimatedMinutes: 6),

        // Topic 1: Two kinds of change — physical and chemical
        "ch06_t01": ArticleEntry(id: "ch06_t01", filename: "ch06_t01_overview.html",
            title: "Two Kinds of Change — Physical and Chemical — Topic Overview",
            chapterFolder: chapter6Folder, estimatedMinutes: 5),
        "ch06_t01_c01": ArticleEntry(id: "ch06_t01_c01", filename: "ch06_t01_c01.html",
            title: "Physical Change — Same Stuff, Different Shape",
            chapterFolder: chapter6Folder, estimatedMinutes: 6),
        "ch06_t01_c02": ArticleEntry(id: "ch06_t01_c02", filename: "ch06_t01_c02.html",
            title: "Chemical Change — New Substance, New Properties",
            chapterFolder: chapter6Folder, estimatedMinutes: 6),
        "ch06_t01_c03": ArticleEntry(id: "ch06_t01_c03", filename: "ch06_t01_c03.html",
            title: "Rusting of Iron — The Famous Chemical Change",
            chapterFolder: chapter6Folder, estimatedMinutes: 5),
        "ch06_t01_c04": ArticleEntry(id: "ch06_t01_c04", filename: "ch06_t01_c04.html",
            title: "Signs of a Chemical Reaction",
            chapterFolder: chapter6Folder, estimatedMinutes: 5),
        "ch06_t01_c05": ArticleEntry(id: "ch06_t01_c05", filename: "ch06_t01_c05.html",
            title: "Burning, Cooking, and Digestion as Chemical Changes",
            chapterFolder: chapter6Folder, estimatedMinutes: 6),
        "ch06_t01_c06": ArticleEntry(id: "ch06_t01_c06", filename: "ch06_t01_c06.html",
            title: "Reversible vs Irreversible Changes",
            chapterFolder: chapter6Folder, estimatedMinutes: 5),
        "ch06_t01_c07": ArticleEntry(id: "ch06_t01_c07", filename: "ch06_t01_c07.html",
            title: "Galvanisation and Preventing Rust",
            chapterFolder: chapter6Folder, estimatedMinutes: 6),
        "ch06_t01_c08": ArticleEntry(id: "ch06_t01_c08", filename: "ch06_t01_c08.html",
            title: "Physical vs Chemical — Tricky Cases",
            chapterFolder: chapter6Folder, estimatedMinutes: 5),

        // Topic 2: Crystallisation
        "ch06_t02": ArticleEntry(id: "ch06_t02", filename: "ch06_t02_overview.html",
            title: "Crystallisation — Pure Substances from Solution — Topic Overview",
            chapterFolder: chapter6Folder, estimatedMinutes: 4),
        "ch06_t02_c01": ArticleEntry(id: "ch06_t02_c01", filename: "ch06_t02_c01.html",
            title: "How Crystallisation Works",
            chapterFolder: chapter6Folder, estimatedMinutes: 6),
        "ch06_t02_c02": ArticleEntry(id: "ch06_t02_c02", filename: "ch06_t02_c02.html",
            title: "Growing Crystals at Home — A Fun Experiment",
            chapterFolder: chapter6Folder, estimatedMinutes: 5),
        // ch06_t02_c03 entry removed 2026-05-21: HTML file was never
        // authored — restore once the file is written and added to Xcode.

        // Topic 3: Chemical Changes in Everyday Life
        "ch06_t03": ArticleEntry(id: "ch06_t03", filename: "ch06_t03_overview.html",
            title: "Chemical Changes in Everyday Life — Topic Overview",
            chapterFolder: chapter6Folder, estimatedMinutes: 4),
        "ch06_t03_c01": ArticleEntry(id: "ch06_t03_c01", filename: "ch06_t03_c01.html",
            title: "Baking Soda and Vinegar — Chemistry in Your Kitchen",
            chapterFolder: chapter6Folder, estimatedMinutes: 5),
        "ch06_t03_c02": ArticleEntry(id: "ch06_t03_c02", filename: "ch06_t03_c02.html",
            title: "Fireworks and Sparklers — Spectacular Chemical Reactions",
            chapterFolder: chapter6Folder, estimatedMinutes: 6),
        "ch06_t03_c03": ArticleEntry(id: "ch06_t03_c03", filename: "ch06_t03_c03.html",
            title: "Photosynthesis and Respiration — Life's Chemical Engines",
            chapterFolder: chapter6Folder, estimatedMinutes: 6),

        // ================================================================
        // CHAPTER 7 — Weather, Climate and Adaptations
        // ================================================================
        "ch07": ArticleEntry(id: "ch07", filename: "ch07_overview.html",
            title: "Weather, Climate and Adaptations — Chapter Overview",
            chapterFolder: chapter7Folder, estimatedMinutes: 6),

        // Topic 1: Weather, climate, and what shapes them
        "ch07_t01": ArticleEntry(id: "ch07_t01", filename: "ch07_t01_overview.html",
            title: "Weather, Climate, and What Shapes Them — Topic Overview",
            chapterFolder: chapter7Folder, estimatedMinutes: 5),
        "ch07_t01_c01": ArticleEntry(id: "ch07_t01_c01", filename: "ch07_t01_c01.html",
            title: "Weather vs Climate — What's the Difference?",
            chapterFolder: chapter7Folder, estimatedMinutes: 6),
        "ch07_t01_c02": ArticleEntry(id: "ch07_t01_c02", filename: "ch07_t01_c02.html",
            title: "What Shapes a Region's Climate",
            chapterFolder: chapter7Folder, estimatedMinutes: 6),
        "ch07_t01_c03": ArticleEntry(id: "ch07_t01_c03", filename: "ch07_t01_c03.html",
            title: "Measuring Weather — Instruments and Stations",
            chapterFolder: chapter7Folder, estimatedMinutes: 5),
        "ch07_t01_c04": ArticleEntry(id: "ch07_t01_c04", filename: "ch07_t01_c04.html",
            title: "The Water Cycle and Weather Patterns",
            chapterFolder: chapter7Folder, estimatedMinutes: 6),
        "ch07_t01_c05": ArticleEntry(id: "ch07_t01_c05", filename: "ch07_t01_c05.html",
            title: "Seasons — Why They Happen",
            chapterFolder: chapter7Folder, estimatedMinutes: 5),
        "ch07_t01_c06": ArticleEntry(id: "ch07_t01_c06", filename: "ch07_t01_c06.html",
            title: "Climate Zones of India",
            chapterFolder: chapter7Folder, estimatedMinutes: 6),
        "ch07_t01_c07": ArticleEntry(id: "ch07_t01_c07", filename: "ch07_t01_c07.html",
            title: "Extreme Weather Events — Cyclones, Droughts, Floods",
            chapterFolder: chapter7Folder, estimatedMinutes: 6),

        // Topic 2: How animals adapt to their climate
        "ch07_t02": ArticleEntry(id: "ch07_t02", filename: "ch07_t02_overview.html",
            title: "How Animals Adapt to Their Climate — Topic Overview",
            chapterFolder: chapter7Folder, estimatedMinutes: 5),
        "ch07_t02_c01": ArticleEntry(id: "ch07_t02_c01", filename: "ch07_t02_c01.html",
            title: "Polar Adaptations — Surviving Extreme Cold",
            chapterFolder: chapter7Folder, estimatedMinutes: 6),
        "ch07_t02_c02": ArticleEntry(id: "ch07_t02_c02", filename: "ch07_t02_c02.html",
            title: "Tropical Adaptations — Life in Hot, Wet Forests",
            chapterFolder: chapter7Folder, estimatedMinutes: 6),
        "ch07_t02_c03": ArticleEntry(id: "ch07_t02_c03", filename: "ch07_t02_c03.html",
            title: "Migration — The Long-Distance Solution",
            chapterFolder: chapter7Folder, estimatedMinutes: 6),
        // ch07_t02_c04..c05 — entries removed 2026-05-21: HTML files
        // were never authored. Restore once the files are written and
        // added to Xcode.

        // Topic 3: Climate Change and Animal Survival
        "ch07_t03": ArticleEntry(id: "ch07_t03", filename: "ch07_t03_overview.html",
            title: "Climate Change and Animal Survival — Topic Overview",
            chapterFolder: chapter7Folder, estimatedMinutes: 4),
        "ch07_t03_c01": ArticleEntry(id: "ch07_t03_c01", filename: "ch07_t03_c01.html",
            title: "Climate Change and Wildlife — Shifting Habitats",
            chapterFolder: chapter7Folder, estimatedMinutes: 6),
        "ch07_t03_c02": ArticleEntry(id: "ch07_t03_c02", filename: "ch07_t03_c02.html",
            title: "Coral Bleaching — When Oceans Get Too Warm",
            chapterFolder: chapter7Folder, estimatedMinutes: 6),
        "ch07_t03_c03": ArticleEntry(id: "ch07_t03_c03", filename: "ch07_t03_c03.html",
            title: "Conservation — Helping Animals Survive a Changing World",
            chapterFolder: chapter7Folder, estimatedMinutes: 6),

        // ================================================================
        // CHAPTER 8 — Winds, Storms and Cyclones
        // ================================================================
        "ch08": ArticleEntry(id: "ch08", filename: "ch08_overview.html",
            title: "Winds, Storms and Cyclones — Chapter Overview",
            chapterFolder: chapter8Folder, estimatedMinutes: 6),

        // Topic overviews for Ch 8 (Winds, Storms and Cyclones)
        "ch08_t01": ArticleEntry(id: "ch08_t01", filename: "ch08_t01_overview.html",
            title: "Why Wind Exists — Topic Overview",
            chapterFolder: chapter8Folder, estimatedMinutes: 5),
        "ch08_t01_c01": ArticleEntry(id: "ch08_t01_c01", filename: "ch08_t01_c01.html",
            title: "Why Air Rises When Heated",
            chapterFolder: chapter8Folder, estimatedMinutes: 6),
        "ch08_t01_c02": ArticleEntry(id: "ch08_t01_c02", filename: "ch08_t01_c02.html",
            title: "Air Pressure and How We Measure It",
            chapterFolder: chapter8Folder, estimatedMinutes: 6),


        "ch08_t02": ArticleEntry(id: "ch08_t02", filename: "ch08_t02_overview.html",
            title: "Sea Breeze and Land Breeze — Topic Overview",
            chapterFolder: chapter8Folder, estimatedMinutes: 5),
        "ch08_t02_c01": ArticleEntry(id: "ch08_t02_c01", filename: "ch08_t02_c01.html",
            title: "Why Sea Breeze Blows During the Day",
            chapterFolder: chapter8Folder, estimatedMinutes: 6),
        "ch08_t02_c02": ArticleEntry(id: "ch08_t02_c02", filename: "ch08_t02_c02.html",
            title: "How Coastal Cities Use the Breeze",
            chapterFolder: chapter8Folder, estimatedMinutes: 6),

        "ch08_t03": ArticleEntry(id: "ch08_t03", filename: "ch08_t03_overview.html",
            title: "Cyclones, Storms and Safety — Topic Overview",
            chapterFolder: chapter8Folder, estimatedMinutes: 5),
        "ch08_t03_c01": ArticleEntry(id: "ch08_t03_c01", filename: "ch08_t03_c01.html",
            title: "Inside a Cyclone",
            chapterFolder: chapter8Folder, estimatedMinutes: 7),
        "ch08_t03_c02": ArticleEntry(id: "ch08_t03_c02", filename: "ch08_t03_c02.html",
            title: "Inside a Cyclone — Eye, Wall, and Wind Bands",
            chapterFolder: chapter8Folder, estimatedMinutes: 7),


        // ================================================================
        // CHAPTER 9 — Soil
        // ================================================================
        "ch09": ArticleEntry(id: "ch09", filename: "ch09_overview.html",
            title: "Soil — Chapter Overview",
            chapterFolder: chapter9Folder, estimatedMinutes: 6),

        // Topic overviews for Ch 9 (Soil)
        "ch09_t01": ArticleEntry(id: "ch09_t01", filename: "ch09_t01_overview.html",
            title: "The Soil Profile and Types — Topic Overview",
            chapterFolder: chapter9Folder, estimatedMinutes: 5),
        "ch09_t01_c01": ArticleEntry(id: "ch09_t01_c01", filename: "ch09_t01_c01.html",
            title: "The Four Soil Horizons",
            chapterFolder: chapter9Folder, estimatedMinutes: 6),
        "ch09_t01_c02": ArticleEntry(id: "ch09_t01_c02", filename: "ch09_t01_c02.html",
            title: "Sand, Clay and Loam — Why Particle Size Matters",
            chapterFolder: chapter9Folder, estimatedMinutes: 6),


        "ch09_t02": ArticleEntry(id: "ch09_t02", filename: "ch09_t02_overview.html",
            title: "Soil for Life — Topic Overview",
            chapterFolder: chapter9Folder, estimatedMinutes: 5),
        "ch09_t02_c01": ArticleEntry(id: "ch09_t02_c01", filename: "ch09_t02_c01.html",
            title: "How Water Moves Through Soil",
            chapterFolder: chapter9Folder, estimatedMinutes: 6),
        "ch09_t02_c02": ArticleEntry(id: "ch09_t02_c02", filename: "ch09_t02_c02.html",
            title: "Why Healthy Soil Is Alive",
            chapterFolder: chapter9Folder, estimatedMinutes: 7),

        "ch09_t03": ArticleEntry(id: "ch09_t03", filename: "ch09_t03_overview.html",
            title: "Soil Conservation — Topic Overview",
            chapterFolder: chapter9Folder, estimatedMinutes: 5),
        "ch09_t03_c01": ArticleEntry(id: "ch09_t03_c01", filename: "ch09_t03_c01.html",
            title: "Earthworms — Nature's Plough",
            chapterFolder: chapter9Folder, estimatedMinutes: 6),
        "ch09_t03_c02": ArticleEntry(id: "ch09_t03_c02", filename: "ch09_t03_c02.html",
            title: "Indian Soil-Loss Hotspots and What's Being Done",
            chapterFolder: chapter9Folder, estimatedMinutes: 7),


        // ================================================================
        // CHAPTER 10 — Respiration in Organisms
        // ================================================================
        "ch10": ArticleEntry(id: "ch10", filename: "ch10_overview.html",
            title: "Respiration in Organisms — Chapter Overview",
            chapterFolder: chapter10Folder, estimatedMinutes: 6),

        // Topic overviews for Ch 10 (Respiration in Organisms)
        "ch10_t01": ArticleEntry(id: "ch10_t01", filename: "ch10_t01_overview.html",
            title: "How Humans Breathe — Topic Overview",
            chapterFolder: chapter10Folder, estimatedMinutes: 5),
        "ch10_t01_c01": ArticleEntry(id: "ch10_t01_c01", filename: "ch10_t01_c01.html",
            title: "Inhalation and Exhalation",
            chapterFolder: chapter10Folder, estimatedMinutes: 6),
        "ch10_t01_c02": ArticleEntry(id: "ch10_t01_c02", filename: "ch10_t01_c02.html",
            title: "Gas Exchange in the Alveoli",
            chapterFolder: chapter10Folder, estimatedMinutes: 7),


        "ch10_t02": ArticleEntry(id: "ch10_t02", filename: "ch10_t02_overview.html",
            title: "Aerobic vs Anaerobic Respiration — Topic Overview",
            chapterFolder: chapter10Folder, estimatedMinutes: 5),
        "ch10_t02_c01": ArticleEntry(id: "ch10_t02_c01", filename: "ch10_t02_c01.html",
            title: "Aerobic Respiration in Detail",
            chapterFolder: chapter10Folder, estimatedMinutes: 7),
        "ch10_t02_c02": ArticleEntry(id: "ch10_t02_c02", filename: "ch10_t02_c02.html",
            title: "Glucose to ATP — The Energy Coin of Life",
            chapterFolder: chapter10Folder, estimatedMinutes: 7),

        "ch10_t03": ArticleEntry(id: "ch10_t03", filename: "ch10_t03_overview.html",
            title: "Respiration Across Species — Topic Overview",
            chapterFolder: chapter10Folder, estimatedMinutes: 5),
        "ch10_t03_c01": ArticleEntry(id: "ch10_t03_c01", filename: "ch10_t03_c01.html",
            title: "How Fish Use Their Gills",
            chapterFolder: chapter10Folder, estimatedMinutes: 6),
        "ch10_t03_c02": ArticleEntry(id: "ch10_t03_c02", filename: "ch10_t03_c02.html",
            title: "Plants Breathe Too — Just Differently",
            chapterFolder: chapter10Folder, estimatedMinutes: 7),


        // ================================================================
        // CHAPTER 11 — Transportation in Animals and Plants
        // ================================================================
        "ch11": ArticleEntry(id: "ch11", filename: "ch11_overview.html",
            title: "Transportation in Animals and Plants — Chapter Overview",
            chapterFolder: chapter11Folder, estimatedMinutes: 7),

        // Topic overviews for Ch 11 (Transportation in Animals and Plants)
        "ch11_t01": ArticleEntry(id: "ch11_t01", filename: "ch11_t01_overview.html",
            title: "The Human Circulatory System — Topic Overview",
            chapterFolder: chapter11Folder, estimatedMinutes: 5),
        "ch11_t01_c01": ArticleEntry(id: "ch11_t01_c01", filename: "ch11_t01_c01.html",
            title: "The Four-Chambered Heart",
            chapterFolder: chapter11Folder, estimatedMinutes: 7),
        "ch11_t01_c02": ArticleEntry(id: "ch11_t01_c02", filename: "ch11_t01_c02.html",
            title: "Blood Components",
            chapterFolder: chapter11Folder, estimatedMinutes: 7),


        "ch11_t02": ArticleEntry(id: "ch11_t02", filename: "ch11_t02_overview.html",
            title: "Excretion and the Kidneys — Topic Overview",
            chapterFolder: chapter11Folder, estimatedMinutes: 5),
        "ch11_t02_c01": ArticleEntry(id: "ch11_t02_c01", filename: "ch11_t02_c01.html",
            title: "How Kidneys Filter Blood",
            chapterFolder: chapter11Folder, estimatedMinutes: 7),
        "ch11_t02_c02": ArticleEntry(id: "ch11_t02_c02", filename: "ch11_t02_c02.html",
            title: "Inside a Kidney — Nephrons, Filtration and Reabsorption",
            chapterFolder: chapter11Folder, estimatedMinutes: 7),

        "ch11_t03": ArticleEntry(id: "ch11_t03", filename: "ch11_t03_overview.html",
            title: "Transport in Plants — Topic Overview",
            chapterFolder: chapter11Folder, estimatedMinutes: 5),
        "ch11_t03_c01": ArticleEntry(id: "ch11_t03_c01", filename: "ch11_t03_c01.html",
            title: "Xylem — The Water Pipeline",
            chapterFolder: chapter11Folder, estimatedMinutes: 6),
        "ch11_t03_c02": ArticleEntry(id: "ch11_t03_c02", filename: "ch11_t03_c02.html",
            title: "Xylem, Phloem and How Plants Move Water 100 m Up",
            chapterFolder: chapter11Folder, estimatedMinutes: 7),


        // ================================================================
        // CHAPTER 12 — Reproduction in Plants
        // ================================================================
        "ch12": ArticleEntry(id: "ch12", filename: "ch12_overview.html",
            title: "Reproduction in Plants — Chapter Overview",
            chapterFolder: chapter12Folder, estimatedMinutes: 7),

        // Topic overviews for Ch 12 (Reproduction in Plants)
        "ch12_t01": ArticleEntry(id: "ch12_t01", filename: "ch12_t01_overview.html",
            title: "Flowers and Pollination — Topic Overview",
            chapterFolder: chapter12Folder, estimatedMinutes: 5),
        "ch12_t01_c01": ArticleEntry(id: "ch12_t01_c01", filename: "ch12_t01_c01.html",
            title: "Flower Anatomy in Detail",
            chapterFolder: chapter12Folder, estimatedMinutes: 7),
        "ch12_t01_c02": ArticleEntry(id: "ch12_t01_c02", filename: "ch12_t01_c02.html",
            title: "Pollinators and Their Strategies",
            chapterFolder: chapter12Folder, estimatedMinutes: 7),


        "ch12_t02": ArticleEntry(id: "ch12_t02", filename: "ch12_t02_overview.html",
            title: "Fertilisation and Seed Formation — Topic Overview",
            chapterFolder: chapter12Folder, estimatedMinutes: 5),
        "ch12_t02_c01": ArticleEntry(id: "ch12_t02_c01", filename: "ch12_t02_c01.html",
            title: "Pollination to Fertilisation",
            chapterFolder: chapter12Folder, estimatedMinutes: 7),
        "ch12_t02_c02": ArticleEntry(id: "ch12_t02_c02", filename: "ch12_t02_c02.html",
            title: "From Pollination to Fruit — The Full Plant Life Cycle",
            chapterFolder: chapter12Folder, estimatedMinutes: 7),

        "ch12_t03": ArticleEntry(id: "ch12_t03", filename: "ch12_t03_overview.html",
            title: "Asexual Reproduction — Topic Overview",
            chapterFolder: chapter12Folder, estimatedMinutes: 5),
        "ch12_t03_c01": ArticleEntry(id: "ch12_t03_c01", filename: "ch12_t03_c01.html",
            title: "Vegetative Propagation",
            chapterFolder: chapter12Folder, estimatedMinutes: 6),
        "ch12_t03_c02": ArticleEntry(id: "ch12_t03_c02", filename: "ch12_t03_c02.html",
            title: "Cloning Plants in the Lab — Tissue Culture",
            chapterFolder: chapter12Folder, estimatedMinutes: 7),


        // ================================================================
        // CHAPTER 13 — Motion and Time
        // ================================================================
        "ch13": ArticleEntry(id: "ch13", filename: "ch13_overview.html",
            title: "Motion and Time — Chapter Overview",
            chapterFolder: chapter13Folder, estimatedMinutes: 7),

        // Topic overviews for Ch 13 (Motion and Time)
        "ch13_t01": ArticleEntry(id: "ch13_t01", filename: "ch13_t01_overview.html",
            title: "Speed and Motion — Topic Overview",
            chapterFolder: chapter13Folder, estimatedMinutes: 5),
        "ch13_t01_c01": ArticleEntry(id: "ch13_t01_c01", filename: "ch13_t01_c01.html",
            title: "What is Speed?",
            chapterFolder: chapter13Folder, estimatedMinutes: 6),
        "ch13_t01_c02": ArticleEntry(id: "ch13_t01_c02", filename: "ch13_t01_c02.html",
            title: "Uniform vs Non-Uniform Motion",
            chapterFolder: chapter13Folder, estimatedMinutes: 6),


        "ch13_t02": ArticleEntry(id: "ch13_t02", filename: "ch13_t02_overview.html",
            title: "The Pendulum and Measuring Time — Topic Overview",
            chapterFolder: chapter13Folder, estimatedMinutes: 5),
        "ch13_t02_c01": ArticleEntry(id: "ch13_t02_c01", filename: "ch13_t02_c01.html",
            title: "Galileo and the Pendulum",
            chapterFolder: chapter13Folder, estimatedMinutes: 6),
        "ch13_t02_c02": ArticleEntry(id: "ch13_t02_c02", filename: "ch13_t02_c02.html",
            title: "Why a Pendulum Always Takes the Same Time",
            chapterFolder: chapter13Folder, estimatedMinutes: 7),

        "ch13_t03": ArticleEntry(id: "ch13_t03", filename: "ch13_t03_overview.html",
            title: "Instruments and the History of Time — Topic Overview",
            chapterFolder: chapter13Folder, estimatedMinutes: 5),
        "ch13_t03_c01": ArticleEntry(id: "ch13_t03_c01", filename: "ch13_t03_c01.html",
            title: "Atomic Clocks and Modern Time",
            chapterFolder: chapter13Folder, estimatedMinutes: 7),
        "ch13_t03_c02": ArticleEntry(id: "ch13_t03_c02", filename: "ch13_t03_c02.html",
            title: "From Sundials to Atomic Clocks — 4000 Years of Timekeeping",
            chapterFolder: chapter13Folder, estimatedMinutes: 7),


        // ================================================================
        // CHAPTER 14 — Electric Current and its Effects
        // ================================================================
        "ch14": ArticleEntry(id: "ch14", filename: "ch14_overview.html",
            title: "Electric Current and its Effects — Chapter Overview",
            chapterFolder: chapter14Folder, estimatedMinutes: 6),

        // Topic 1: Circuits & Current
        "ch14_t01": ArticleEntry(id: "ch14_t01", filename: "ch14_t01_overview.html",
            title: "Circuits & Current — Topic Overview",
            chapterFolder: chapter14Folder, estimatedMinutes: 5),
        "ch14_t01_c01": ArticleEntry(id: "ch14_t01_c01", filename: "ch14_t01_c01.html",
            title: "What is an Electric Current?",
            chapterFolder: chapter14Folder, estimatedMinutes: 7),
        "ch14_t01_c02": ArticleEntry(id: "ch14_t01_c02", filename: "ch14_t01_c02.html",
            title: "The Cell and the Closed Loop",
            chapterFolder: chapter14Folder, estimatedMinutes: 7),
        "ch14_t01_c03": ArticleEntry(id: "ch14_t01_c03", filename: "ch14_t01_c03.html",
            title: "Series vs Parallel",
            chapterFolder: chapter14Folder, estimatedMinutes: 7),
        "ch14_t01_c04": ArticleEntry(id: "ch14_t01_c04", filename: "ch14_t01_c04.html",
            title: "Conductors and Insulators",
            chapterFolder: chapter14Folder, estimatedMinutes: 7),

        "ch14_t02": ArticleEntry(id: "ch14_t02", filename: "ch14_t02_overview.html",
            title: "Heating Effect — Topic Overview",
            chapterFolder: chapter14Folder, estimatedMinutes: 5),

        "ch14_t02_c01": ArticleEntry(id: "ch14_t02_c01", filename: "ch14_t02_c01.html",
            title: "The Filament Bulb and Joule\'s Law",
            chapterFolder: chapter14Folder, estimatedMinutes: 7),
        "ch14_t02_c02": ArticleEntry(id: "ch14_t02_c02", filename: "ch14_t02_c02.html",
            title: "Joule's Law — Why Wires Get Hot",
            chapterFolder: chapter14Folder, estimatedMinutes: 7),

        "ch14_t03": ArticleEntry(id: "ch14_t03", filename: "ch14_t03_overview.html",
            title: "Magnetic Effect — Topic Overview",
            chapterFolder: chapter14Folder, estimatedMinutes: 5),

        "ch14_t03_c01": ArticleEntry(id: "ch14_t03_c01", filename: "ch14_t03_c01.html",
            title: "Electromagnets — Ørsted to Modern Cranes",
            chapterFolder: chapter14Folder, estimatedMinutes: 8),
        "ch14_t03_c02": ArticleEntry(id: "ch14_t03_c02", filename: "ch14_t03_c02.html",
            title: "The Magnetic Effect — From Doorbells to MagLev Trains",
            chapterFolder: chapter14Folder, estimatedMinutes: 7),

        // ================================================================
        // CHAPTER 15 — Light
        // ================================================================
        "ch15": ArticleEntry(id: "ch15", filename: "ch15_overview.html",
            title: "Light — Chapter Overview",
            chapterFolder: chapter15Folder, estimatedMinutes: 7),

        // Topic 1: Reflection & Mirrors
        "ch15_t01": ArticleEntry(id: "ch15_t01", filename: "ch15_t01_overview.html",
            title: "Reflection & Mirrors — Topic Overview",
            chapterFolder: chapter15Folder, estimatedMinutes: 5),
        "ch15_t01_c01": ArticleEntry(id: "ch15_t01_c01", filename: "ch15_t01_c01.html",
            title: "The Law of Reflection",
            chapterFolder: chapter15Folder, estimatedMinutes: 5),
        "ch15_t01_c02": ArticleEntry(id: "ch15_t01_c02", filename: "ch15_t01_c02.html",
            title: "The Plane Mirror",
            chapterFolder: chapter15Folder, estimatedMinutes: 6),
        "ch15_t01_c03": ArticleEntry(id: "ch15_t01_c03", filename: "ch15_t01_c03.html",
            title: "The Concave Mirror",
            chapterFolder: chapter15Folder, estimatedMinutes: 6),
        "ch15_t01_c04": ArticleEntry(id: "ch15_t01_c04", filename: "ch15_t01_c04.html",
            title: "The Convex Mirror",
            chapterFolder: chapter15Folder, estimatedMinutes: 6),

        // Topic 2: Refraction, Prism & Rainbow
        "ch15_t02": ArticleEntry(id: "ch15_t02", filename: "ch15_t02_overview.html",
            title: "Refraction, Prism & Rainbow — Topic Overview",
            chapterFolder: chapter15Folder, estimatedMinutes: 5),
        "ch15_t02_c01": ArticleEntry(id: "ch15_t02_c01", filename: "ch15_t02_c01.html",
            title: "Refraction",
            chapterFolder: chapter15Folder, estimatedMinutes: 7),
        "ch15_t02_c02": ArticleEntry(id: "ch15_t02_c02", filename: "ch15_t02_c02.html",
            title: "The Prism & Dispersion",
            chapterFolder: chapter15Folder, estimatedMinutes: 7),
        "ch15_t02_c03": ArticleEntry(id: "ch15_t02_c03", filename: "ch15_t02_c03.html",
            title: "The Rainbow",
            chapterFolder: chapter15Folder, estimatedMinutes: 7),

        // Topic 3: Lenses & Optical Instruments
        "ch15_t03": ArticleEntry(id: "ch15_t03", filename: "ch15_t03_overview.html",
            title: "Lenses & Optical Instruments — Topic Overview",
            chapterFolder: chapter15Folder, estimatedMinutes: 5),
        "ch15_t03_c01": ArticleEntry(id: "ch15_t03_c01", filename: "ch15_t03_c01.html",
            title: "Lenses",
            chapterFolder: chapter15Folder, estimatedMinutes: 8),
        "ch15_t03_c02": ArticleEntry(id: "ch15_t03_c02", filename: "ch15_t03_c02.html",
            title: "The Periscope",
            chapterFolder: chapter15Folder, estimatedMinutes: 6),
        "ch15_t03_c03": ArticleEntry(id: "ch15_t03_c03", filename: "ch15_t03_c03.html",
            title: "The Kaleidoscope",
            chapterFolder: chapter15Folder, estimatedMinutes: 7),

        // ================================================================
        // CHAPTER 16 — Water: A Precious Resource
        // ================================================================
        "ch16": ArticleEntry(id: "ch16", filename: "ch16_overview.html",
            title: "Water: A Precious Resource — Chapter Overview",
            chapterFolder: chapter16Folder, estimatedMinutes: 7),

        // Topic overviews for Ch 16 (Water: A Precious Resource)
        "ch16_t01": ArticleEntry(id: "ch16_t01", filename: "ch16_t01_overview.html",
            title: "Earth's Water and the Water Table — Topic Overview",
            chapterFolder: chapter16Folder, estimatedMinutes: 5),
        "ch16_t01_c01": ArticleEntry(id: "ch16_t01_c01", filename: "ch16_t01_c01.html",
            title: "How Much Drinkable Water Earth Actually Has",
            chapterFolder: chapter16Folder, estimatedMinutes: 6),
        "ch16_t01_c02": ArticleEntry(id: "ch16_t01_c02", filename: "ch16_t01_c02.html",
            title: "The Water Table and Aquifers",
            chapterFolder: chapter16Folder, estimatedMinutes: 7),


        "ch16_t02": ArticleEntry(id: "ch16_t02", filename: "ch16_t02_overview.html",
            title: "Irrigation and Rainwater Harvesting — Topic Overview",
            chapterFolder: chapter16Folder, estimatedMinutes: 5),
        "ch16_t02_c01": ArticleEntry(id: "ch16_t02_c01", filename: "ch16_t02_c01.html",
            title: "Drip Irrigation — Water at the Roots",
            chapterFolder: chapter16Folder, estimatedMinutes: 7),
        "ch16_t02_c02": ArticleEntry(id: "ch16_t02_c02", filename: "ch16_t02_c02.html",
            title: "Drip and Sprinkler — Modern Irrigation Methods",
            chapterFolder: chapter16Folder, estimatedMinutes: 7),

        "ch16_t03": ArticleEntry(id: "ch16_t03", filename: "ch16_t03_overview.html",
            title: "Water Conservation — Topic Overview",
            chapterFolder: chapter16Folder, estimatedMinutes: 5),
        "ch16_t03_c01": ArticleEntry(id: "ch16_t03_c01", filename: "ch16_t03_c01.html",
            title: "Rainwater Harvesting Systems",
            chapterFolder: chapter16Folder, estimatedMinutes: 7),
        "ch16_t03_c02": ArticleEntry(id: "ch16_t03_c02", filename: "ch16_t03_c02.html",
            title: "Why World Water Day Matters — Global and Indian Water Stress",
            chapterFolder: chapter16Folder, estimatedMinutes: 7),


        // ================================================================
        // CHAPTER 17 — Forests: Our Lifeline
        // ================================================================
        "ch17": ArticleEntry(id: "ch17", filename: "ch17_overview.html",
            title: "Forests: Our Lifeline — Chapter Overview",
            chapterFolder: chapter17Folder, estimatedMinutes: 6),

        // Topic overviews for Ch 17 (Forests: Our Lifeline)
        "ch17_t01": ArticleEntry(id: "ch17_t01", filename: "ch17_t01_overview.html",
            title: "Forest Layers and Food Webs — Topic Overview",
            chapterFolder: chapter17Folder, estimatedMinutes: 5),
        "ch17_t01_c01": ArticleEntry(id: "ch17_t01_c01", filename: "ch17_t01_c01.html",
            title: "Forest Strata",
            chapterFolder: chapter17Folder, estimatedMinutes: 6),
        "ch17_t01_c02": ArticleEntry(id: "ch17_t01_c02", filename: "ch17_t01_c02.html",
            title: "Food Webs and Energy Flow",
            chapterFolder: chapter17Folder, estimatedMinutes: 7),


        "ch17_t02": ArticleEntry(id: "ch17_t02", filename: "ch17_t02_overview.html",
            title: "Decomposers and the Soil-Forest Cycle — Topic Overview",
            chapterFolder: chapter17Folder, estimatedMinutes: 5),
        "ch17_t02_c01": ArticleEntry(id: "ch17_t02_c01", filename: "ch17_t02_c01.html",
            title: "Decomposers — Recycling Death",
            chapterFolder: chapter17Folder, estimatedMinutes: 6),
        "ch17_t02_c02": ArticleEntry(id: "ch17_t02_c02", filename: "ch17_t02_c02.html",
            title: "The Forest Floor — Where Death Becomes Soil",
            chapterFolder: chapter17Folder, estimatedMinutes: 7),

        "ch17_t03": ArticleEntry(id: "ch17_t03", filename: "ch17_t03_overview.html",
            title: "Deforestation and Conservation — Topic Overview",
            chapterFolder: chapter17Folder, estimatedMinutes: 5),
        "ch17_t03_c01": ArticleEntry(id: "ch17_t03_c01", filename: "ch17_t03_c01.html",
            title: "Why Deforestation Hurts Everyone",
            chapterFolder: chapter17Folder, estimatedMinutes: 7),
        "ch17_t03_c02": ArticleEntry(id: "ch17_t03_c02", filename: "ch17_t03_c02.html",
            title: "Why India Cuts Forests — And What It Costs",
            chapterFolder: chapter17Folder, estimatedMinutes: 7),


        // ================================================================
        // CHAPTER 18 — Wastewater Story
        // ================================================================
        "ch18": ArticleEntry(id: "ch18", filename: "ch18_overview.html",
            title: "Wastewater Story — Chapter Overview",
            chapterFolder: chapter18Folder, estimatedMinutes: 7),

        // Topic overviews for Ch 18 (Wastewater Story)
        "ch18_t01": ArticleEntry(id: "ch18_t01", filename: "ch18_t01_overview.html",
            title: "Where Wastewater Goes — Topic Overview",
            chapterFolder: chapter18Folder, estimatedMinutes: 5),
        "ch18_t01_c01": ArticleEntry(id: "ch18_t01_c01", filename: "ch18_t01_c01.html",
            title: "What Is Sewage?",
            chapterFolder: chapter18Folder, estimatedMinutes: 7),
        "ch18_t01_c02": ArticleEntry(id: "ch18_t01_c02", filename: "ch18_t01_c02.html",
            title: "Sources of Wastewater",
            chapterFolder: chapter18Folder, estimatedMinutes: 7),


        "ch18_t02": ArticleEntry(id: "ch18_t02", filename: "ch18_t02_overview.html",
            title: "Treatment Plant Stages — Topic Overview",
            chapterFolder: chapter18Folder, estimatedMinutes: 5),
        "ch18_t02_c01": ArticleEntry(id: "ch18_t02_c01", filename: "ch18_t02_c01.html",
            title: "Inside a Sewage Treatment Plant",
            chapterFolder: chapter18Folder, estimatedMinutes: 7),
        "ch18_t02_c02": ArticleEntry(id: "ch18_t02_c02", filename: "ch18_t02_c02.html",
            title: "Bacteria as Water Cleaners — Aeration Tanks and Activated Sludge",
            chapterFolder: chapter18Folder, estimatedMinutes: 7),

        "ch18_t03": ArticleEntry(id: "ch18_t03", filename: "ch18_t03_overview.html",
            title: "Sanitation at Home — Topic Overview",
            chapterFolder: chapter18Folder, estimatedMinutes: 5),
        "ch18_t03_c01": ArticleEntry(id: "ch18_t03_c01", filename: "ch18_t03_c01.html",
            title: "Compost Pits and Soak Pits",
            chapterFolder: chapter18Folder, estimatedMinutes: 6),
        "ch18_t03_c02": ArticleEntry(id: "ch18_t03_c02", filename: "ch18_t03_c02.html",
            title: "From Open Drains to Modern Sanitation — How Cities Changed",
            chapterFolder: chapter18Folder, estimatedMinutes: 7),


        // ================================================================
        // CHAPTER 19 — Earth, Moon and the Sun
        // ================================================================
        "ch19": ArticleEntry(id: "ch19", filename: "ch19_overview.html",
            title: "Earth, Moon and the Sun — Chapter Overview",
            chapterFolder: chapter19Folder, estimatedMinutes: 6),

        "ch19_t01": ArticleEntry(id: "ch19_t01", filename: "ch19_t01_overview.html",
            title: "Earth's rotation, revolution, and seasons — Topic Overview",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t01_c01": ArticleEntry(id: "ch19_t01_c01", filename: "ch19_t01_c01.html",
            title: "Earth's shape and the tilted axis",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t01_c02": ArticleEntry(id: "ch19_t01_c02", filename: "ch19_t01_c02.html",
            title: "Rotation — what causes day and night",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t01_c03": ArticleEntry(id: "ch19_t01_c03", filename: "ch19_t01_c03.html",
            title: "Revolution — Earth's orbit around the Sun",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t01_c04": ArticleEntry(id: "ch19_t01_c04", filename: "ch19_t01_c04.html",
            title: "Seasons — why tilt plus revolution creates summer and winter",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t01_c05": ArticleEntry(id: "ch19_t01_c05", filename: "ch19_t01_c05.html",
            title: "Leap year — why we add a day every four years",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t01_c06": ArticleEntry(id: "ch19_t01_c06", filename: "ch19_t01_c06.html",
            title: "Time zones — why different places have different times",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t01_c07": ArticleEntry(id: "ch19_t01_c07", filename: "ch19_t01_c07.html",
            title: "The Coriolis effect — why winds and cyclones curve",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t01_c08": ArticleEntry(id: "ch19_t01_c08", filename: "ch19_t01_c08.html",
            title: "Polaris — the North Star that appears fixed",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),

        "ch19_t02": ArticleEntry(id: "ch19_t02", filename: "ch19_t02_overview.html",
            title: "The Moon — phases, eclipses, and tides — Topic Overview",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t02_c01": ArticleEntry(id: "ch19_t02_c01", filename: "ch19_t02_c01.html",
            title: "The Moon — Earth's natural satellite",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t02_c02": ArticleEntry(id: "ch19_t02_c02", filename: "ch19_t02_c02.html",
            title: "Moon phases — from New Moon to Full Moon and back",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t02_c03": ArticleEntry(id: "ch19_t02_c03", filename: "ch19_t02_c03.html",
            title: "Tidal locking — why the Moon shows only one face",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t02_c04": ArticleEntry(id: "ch19_t02_c04", filename: "ch19_t02_c04.html",
            title: "Solar eclipse — when the Moon hides the Sun",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t02_c05": ArticleEntry(id: "ch19_t02_c05", filename: "ch19_t02_c05.html",
            title: "Lunar eclipse — when Earth's shadow falls on the Moon",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t02_c06": ArticleEntry(id: "ch19_t02_c06", filename: "ch19_t02_c06.html",
            title: "Tides — how the Moon pulls on Earth's oceans",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t02_c07": ArticleEntry(id: "ch19_t02_c07", filename: "ch19_t02_c07.html",
            title: "Spring tides and neap tides",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t02_c08": ArticleEntry(id: "ch19_t02_c08", filename: "ch19_t02_c08.html",
            title: "The Moon landing — Neil Armstrong and Apollo 11",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),

        "ch19_t03": ArticleEntry(id: "ch19_t03", filename: "ch19_t03_overview.html",
            title: "Stars, constellations, and the Solar System — Topic Overview",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t03_c01": ArticleEntry(id: "ch19_t03_c01", filename: "ch19_t03_c01.html",
            title: "What stars are — giant balls of nuclear fusion",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t03_c02": ArticleEntry(id: "ch19_t03_c02", filename: "ch19_t03_c02.html",
            title: "Why stars twinkle but planets don't",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t03_c03": ArticleEntry(id: "ch19_t03_c03", filename: "ch19_t03_c03.html",
            title: "Constellations — star patterns in the sky",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t03_c04": ArticleEntry(id: "ch19_t03_c04", filename: "ch19_t03_c04.html",
            title: "The Pole Star (Dhruv Tara) and finding north",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t03_c05": ArticleEntry(id: "ch19_t03_c05", filename: "ch19_t03_c05.html",
            title: "The Solar System — Sun, 8 planets, and more",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t03_c06": ArticleEntry(id: "ch19_t03_c06", filename: "ch19_t03_c06.html",
            title: "Inner rocky planets vs outer gas giants",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),
        "ch19_t03_c07": ArticleEntry(id: "ch19_t03_c07", filename: "ch19_t03_c07.html",
            title: "Asteroids, comets, and meteors",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),

        // Common Mistakes (chapter-level enrichment) — Ch.2-19 articles
        // generated 2026-05-26 by scripts/generate_mistakes_articles.py
        // from each chapter's `misconceptions` JSON. Ch.1 has a bespoke
        // entry above (line 283); these 18 entries complete the surface
        // to 19/19 coverage so ChapterDetailView's CommonMistakesCard
        // appears on every chapter.
        "ch02_mistakes": ArticleEntry(id: "ch02_mistakes", filename: "ch02_mistakes.html",
            title: "Five Wrong Answers Class 7 Students Give",
            chapterFolder: chapter2Folder, estimatedMinutes: 5),
        "ch03_mistakes": ArticleEntry(id: "ch03_mistakes", filename: "ch03_mistakes.html",
            title: "Five Wrong Answers Class 7 Students Give",
            chapterFolder: chapter3Folder, estimatedMinutes: 5),
        "ch04_mistakes": ArticleEntry(id: "ch04_mistakes", filename: "ch04_mistakes.html",
            title: "Five Wrong Answers Class 7 Students Give",
            chapterFolder: chapter4Folder, estimatedMinutes: 5),
        "ch05_mistakes": ArticleEntry(id: "ch05_mistakes", filename: "ch05_mistakes.html",
            title: "Five Wrong Answers Class 7 Students Give",
            chapterFolder: chapter5Folder, estimatedMinutes: 5),
        "ch06_mistakes": ArticleEntry(id: "ch06_mistakes", filename: "ch06_mistakes.html",
            title: "Five Wrong Answers Class 7 Students Give",
            chapterFolder: chapter6Folder, estimatedMinutes: 5),
        "ch07_mistakes": ArticleEntry(id: "ch07_mistakes", filename: "ch07_mistakes.html",
            title: "Five Wrong Answers Class 7 Students Give",
            chapterFolder: chapter7Folder, estimatedMinutes: 5),
        "ch08_mistakes": ArticleEntry(id: "ch08_mistakes", filename: "ch08_mistakes.html",
            title: "Five Wrong Answers Class 7 Students Give",
            chapterFolder: chapter8Folder, estimatedMinutes: 5),
        "ch09_mistakes": ArticleEntry(id: "ch09_mistakes", filename: "ch09_mistakes.html",
            title: "Five Wrong Answers Class 7 Students Give",
            chapterFolder: chapter9Folder, estimatedMinutes: 5),
        "ch10_mistakes": ArticleEntry(id: "ch10_mistakes", filename: "ch10_mistakes.html",
            title: "Five Wrong Answers Class 7 Students Give",
            chapterFolder: chapter10Folder, estimatedMinutes: 5),
        "ch11_mistakes": ArticleEntry(id: "ch11_mistakes", filename: "ch11_mistakes.html",
            title: "Five Wrong Answers Class 7 Students Give",
            chapterFolder: chapter11Folder, estimatedMinutes: 5),
        "ch12_mistakes": ArticleEntry(id: "ch12_mistakes", filename: "ch12_mistakes.html",
            title: "Five Wrong Answers Class 7 Students Give",
            chapterFolder: chapter12Folder, estimatedMinutes: 5),
        "ch13_mistakes": ArticleEntry(id: "ch13_mistakes", filename: "ch13_mistakes.html",
            title: "Five Wrong Answers Class 7 Students Give",
            chapterFolder: chapter13Folder, estimatedMinutes: 5),
        "ch14_mistakes": ArticleEntry(id: "ch14_mistakes", filename: "ch14_mistakes.html",
            title: "Five Wrong Answers Class 7 Students Give",
            chapterFolder: chapter14Folder, estimatedMinutes: 5),
        "ch15_mistakes": ArticleEntry(id: "ch15_mistakes", filename: "ch15_mistakes.html",
            title: "Five Wrong Answers Class 7 Students Give",
            chapterFolder: chapter15Folder, estimatedMinutes: 5),
        "ch16_mistakes": ArticleEntry(id: "ch16_mistakes", filename: "ch16_mistakes.html",
            title: "Five Wrong Answers Class 7 Students Give",
            chapterFolder: chapter16Folder, estimatedMinutes: 5),
        "ch17_mistakes": ArticleEntry(id: "ch17_mistakes", filename: "ch17_mistakes.html",
            title: "Five Wrong Answers Class 7 Students Give",
            chapterFolder: chapter17Folder, estimatedMinutes: 5),
        "ch18_mistakes": ArticleEntry(id: "ch18_mistakes", filename: "ch18_mistakes.html",
            title: "Five Wrong Answers Class 7 Students Give",
            chapterFolder: chapter18Folder, estimatedMinutes: 5),
        "ch19_mistakes": ArticleEntry(id: "ch19_mistakes", filename: "ch19_mistakes.html",
            title: "Five Wrong Answers Class 7 Students Give",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),

        // Vocabulary-deck articles (chapter-level enrichment) —
        // Ch.2-19 generated 2026-05-26 by
        // scripts/generate_glossary_articles.py from each chapter's
        // `glossary` JSON. Ch.1 has the bespoke 30-term entry above
        // (line 248). The existing `glossaryButton` on
        // ChapterDetailView still opens GlossarySheet (a sheet
        // surface keyed to the same JSON); these HTML articles are
        // the deeper read-mode surface, linked from Beyond articles
        // and surfaced via a Vocabulary Deck card in a follow-up
        // session.
        "ch02_glossary": ArticleEntry(id: "ch02_glossary", filename: "ch02_glossary.html",
            title: "A Class 7 Nutrition in Animals Dictionary",
            chapterFolder: chapter2Folder, estimatedMinutes: 5),
        "ch03_glossary": ArticleEntry(id: "ch03_glossary", filename: "ch03_glossary.html",
            title: "A Class 7 Fibre to Fabric Dictionary",
            chapterFolder: chapter3Folder, estimatedMinutes: 5),
        "ch04_glossary": ArticleEntry(id: "ch04_glossary", filename: "ch04_glossary.html",
            title: "A Class 7 Heat Dictionary",
            chapterFolder: chapter4Folder, estimatedMinutes: 5),
        "ch05_glossary": ArticleEntry(id: "ch05_glossary", filename: "ch05_glossary.html",
            title: "A Class 7 Acids, Bases and Salts Dictionary",
            chapterFolder: chapter5Folder, estimatedMinutes: 5),
        "ch06_glossary": ArticleEntry(id: "ch06_glossary", filename: "ch06_glossary.html",
            title: "A Class 7 Physical and Chemical Changes Dictionary",
            chapterFolder: chapter6Folder, estimatedMinutes: 5),
        "ch07_glossary": ArticleEntry(id: "ch07_glossary", filename: "ch07_glossary.html",
            title: "A Class 7 Weather, Climate and Adaptations Dictionary",
            chapterFolder: chapter7Folder, estimatedMinutes: 5),
        "ch08_glossary": ArticleEntry(id: "ch08_glossary", filename: "ch08_glossary.html",
            title: "A Class 7 Winds, Storms and Cyclones Dictionary",
            chapterFolder: chapter8Folder, estimatedMinutes: 5),
        "ch09_glossary": ArticleEntry(id: "ch09_glossary", filename: "ch09_glossary.html",
            title: "A Class 7 Soil Dictionary",
            chapterFolder: chapter9Folder, estimatedMinutes: 5),
        "ch10_glossary": ArticleEntry(id: "ch10_glossary", filename: "ch10_glossary.html",
            title: "A Class 7 Respiration in Organisms Dictionary",
            chapterFolder: chapter10Folder, estimatedMinutes: 5),
        "ch11_glossary": ArticleEntry(id: "ch11_glossary", filename: "ch11_glossary.html",
            title: "A Class 7 Transportation in Animals and Plants Dictionary",
            chapterFolder: chapter11Folder, estimatedMinutes: 5),
        "ch12_glossary": ArticleEntry(id: "ch12_glossary", filename: "ch12_glossary.html",
            title: "A Class 7 Reproduction in Plants Dictionary",
            chapterFolder: chapter12Folder, estimatedMinutes: 5),
        "ch13_glossary": ArticleEntry(id: "ch13_glossary", filename: "ch13_glossary.html",
            title: "A Class 7 Motion and Time Dictionary",
            chapterFolder: chapter13Folder, estimatedMinutes: 5),
        "ch14_glossary": ArticleEntry(id: "ch14_glossary", filename: "ch14_glossary.html",
            title: "A Class 7 Electric Current and its Effect Dictionary",
            chapterFolder: chapter14Folder, estimatedMinutes: 5),
        "ch15_glossary": ArticleEntry(id: "ch15_glossary", filename: "ch15_glossary.html",
            title: "A Class 7 Light Dictionary",
            chapterFolder: chapter15Folder, estimatedMinutes: 5),
        "ch16_glossary": ArticleEntry(id: "ch16_glossary", filename: "ch16_glossary.html",
            title: "A Class 7 Water: A Precious Resource Dictionary",
            chapterFolder: chapter16Folder, estimatedMinutes: 5),
        "ch17_glossary": ArticleEntry(id: "ch17_glossary", filename: "ch17_glossary.html",
            title: "A Class 7 Forest: Our Lifeline Dictionary",
            chapterFolder: chapter17Folder, estimatedMinutes: 5),
        "ch18_glossary": ArticleEntry(id: "ch18_glossary", filename: "ch18_glossary.html",
            title: "A Class 7 Wastewater Story Dictionary",
            chapterFolder: chapter18Folder, estimatedMinutes: 5),
        "ch19_glossary": ArticleEntry(id: "ch19_glossary", filename: "ch19_glossary.html",
            title: "A Class 7 Earth, Moon and the Sun Dictionary",
            chapterFolder: chapter19Folder, estimatedMinutes: 5),

        // NCERT Q&A — exam-prep articles for Ch.2-19, generated
        // 2026-05-26 by scripts/generate_ncert_qa_articles.py from
        // chapter.ncertQA JSON. Ch.1 has a bespoke 8-Q entry above.
        "ch02_ncert_qa": ArticleEntry(id: "ch02_ncert_qa", filename: "ch02_ncert_qa.html",
            title: "NCERT Exercise Q&A — Chapter 2",
            chapterFolder: chapter2Folder, estimatedMinutes: 12),
        "ch03_ncert_qa": ArticleEntry(id: "ch03_ncert_qa", filename: "ch03_ncert_qa.html",
            title: "NCERT Exercise Q&A — Chapter 3",
            chapterFolder: chapter3Folder, estimatedMinutes: 12),
        "ch04_ncert_qa": ArticleEntry(id: "ch04_ncert_qa", filename: "ch04_ncert_qa.html",
            title: "NCERT Exercise Q&A — Chapter 4",
            chapterFolder: chapter4Folder, estimatedMinutes: 12),
        "ch05_ncert_qa": ArticleEntry(id: "ch05_ncert_qa", filename: "ch05_ncert_qa.html",
            title: "NCERT Exercise Q&A — Chapter 5",
            chapterFolder: chapter5Folder, estimatedMinutes: 12),
        "ch06_ncert_qa": ArticleEntry(id: "ch06_ncert_qa", filename: "ch06_ncert_qa.html",
            title: "NCERT Exercise Q&A — Chapter 6",
            chapterFolder: chapter6Folder, estimatedMinutes: 12),
        "ch07_ncert_qa": ArticleEntry(id: "ch07_ncert_qa", filename: "ch07_ncert_qa.html",
            title: "NCERT Exercise Q&A — Chapter 7",
            chapterFolder: chapter7Folder, estimatedMinutes: 12),
        "ch08_ncert_qa": ArticleEntry(id: "ch08_ncert_qa", filename: "ch08_ncert_qa.html",
            title: "NCERT Exercise Q&A — Chapter 8",
            chapterFolder: chapter8Folder, estimatedMinutes: 12),
        "ch09_ncert_qa": ArticleEntry(id: "ch09_ncert_qa", filename: "ch09_ncert_qa.html",
            title: "NCERT Exercise Q&A — Chapter 9",
            chapterFolder: chapter9Folder, estimatedMinutes: 12),
        "ch10_ncert_qa": ArticleEntry(id: "ch10_ncert_qa", filename: "ch10_ncert_qa.html",
            title: "NCERT Exercise Q&A — Chapter 10",
            chapterFolder: chapter10Folder, estimatedMinutes: 12),
        "ch11_ncert_qa": ArticleEntry(id: "ch11_ncert_qa", filename: "ch11_ncert_qa.html",
            title: "NCERT Exercise Q&A — Chapter 11",
            chapterFolder: chapter11Folder, estimatedMinutes: 12),
        "ch12_ncert_qa": ArticleEntry(id: "ch12_ncert_qa", filename: "ch12_ncert_qa.html",
            title: "NCERT Exercise Q&A — Chapter 12",
            chapterFolder: chapter12Folder, estimatedMinutes: 12),
        "ch13_ncert_qa": ArticleEntry(id: "ch13_ncert_qa", filename: "ch13_ncert_qa.html",
            title: "NCERT Exercise Q&A — Chapter 13",
            chapterFolder: chapter13Folder, estimatedMinutes: 12),
        "ch14_ncert_qa": ArticleEntry(id: "ch14_ncert_qa", filename: "ch14_ncert_qa.html",
            title: "NCERT Exercise Q&A — Chapter 14",
            chapterFolder: chapter14Folder, estimatedMinutes: 12),
        "ch15_ncert_qa": ArticleEntry(id: "ch15_ncert_qa", filename: "ch15_ncert_qa.html",
            title: "NCERT Exercise Q&A — Chapter 15",
            chapterFolder: chapter15Folder, estimatedMinutes: 12),
        "ch16_ncert_qa": ArticleEntry(id: "ch16_ncert_qa", filename: "ch16_ncert_qa.html",
            title: "NCERT Exercise Q&A — Chapter 16",
            chapterFolder: chapter16Folder, estimatedMinutes: 12),
        "ch17_ncert_qa": ArticleEntry(id: "ch17_ncert_qa", filename: "ch17_ncert_qa.html",
            title: "NCERT Exercise Q&A — Chapter 17",
            chapterFolder: chapter17Folder, estimatedMinutes: 12),
        "ch18_ncert_qa": ArticleEntry(id: "ch18_ncert_qa", filename: "ch18_ncert_qa.html",
            title: "NCERT Exercise Q&A — Chapter 18",
            chapterFolder: chapter18Folder, estimatedMinutes: 12),
        "ch19_ncert_qa": ArticleEntry(id: "ch19_ncert_qa", filename: "ch19_ncert_qa.html",
            title: "NCERT Exercise Q&A — Chapter 19",
            chapterFolder: chapter19Folder, estimatedMinutes: 12),

        // Scientist Spotlight (biography articles) — Ch.2-19 generated
        // 2026-05-26 by scripts/generate_scientists_articles.py from
        // chapter.scientists JSON (1 entry per chapter). Ch.1 has a
        // bespoke 5-scientist anchor with an SVG timeline; this
        // surface complements that by giving every chapter exactly
        // one tightly-focused biography page.
        "ch02_scientists": ArticleEntry(id: "ch02_scientists", filename: "ch02_scientists.html",
            title: "Scientist Spotlight — Chapter 2",
            chapterFolder: chapter2Folder, estimatedMinutes: 4),
        "ch03_scientists": ArticleEntry(id: "ch03_scientists", filename: "ch03_scientists.html",
            title: "Scientist Spotlight — Chapter 3",
            chapterFolder: chapter3Folder, estimatedMinutes: 4),
        "ch04_scientists": ArticleEntry(id: "ch04_scientists", filename: "ch04_scientists.html",
            title: "Scientist Spotlight — Chapter 4",
            chapterFolder: chapter4Folder, estimatedMinutes: 4),
        "ch05_scientists": ArticleEntry(id: "ch05_scientists", filename: "ch05_scientists.html",
            title: "Scientist Spotlight — Chapter 5",
            chapterFolder: chapter5Folder, estimatedMinutes: 4),
        "ch06_scientists": ArticleEntry(id: "ch06_scientists", filename: "ch06_scientists.html",
            title: "Scientist Spotlight — Chapter 6",
            chapterFolder: chapter6Folder, estimatedMinutes: 4),
        "ch07_scientists": ArticleEntry(id: "ch07_scientists", filename: "ch07_scientists.html",
            title: "Scientist Spotlight — Chapter 7",
            chapterFolder: chapter7Folder, estimatedMinutes: 4),
        "ch08_scientists": ArticleEntry(id: "ch08_scientists", filename: "ch08_scientists.html",
            title: "Scientist Spotlight — Chapter 8",
            chapterFolder: chapter8Folder, estimatedMinutes: 4),
        "ch09_scientists": ArticleEntry(id: "ch09_scientists", filename: "ch09_scientists.html",
            title: "Scientist Spotlight — Chapter 9",
            chapterFolder: chapter9Folder, estimatedMinutes: 4),
        "ch10_scientists": ArticleEntry(id: "ch10_scientists", filename: "ch10_scientists.html",
            title: "Scientist Spotlight — Chapter 10",
            chapterFolder: chapter10Folder, estimatedMinutes: 4),
        "ch11_scientists": ArticleEntry(id: "ch11_scientists", filename: "ch11_scientists.html",
            title: "Scientist Spotlight — Chapter 11",
            chapterFolder: chapter11Folder, estimatedMinutes: 4),
        "ch12_scientists": ArticleEntry(id: "ch12_scientists", filename: "ch12_scientists.html",
            title: "Scientist Spotlight — Chapter 12",
            chapterFolder: chapter12Folder, estimatedMinutes: 4),
        "ch13_scientists": ArticleEntry(id: "ch13_scientists", filename: "ch13_scientists.html",
            title: "Scientist Spotlight — Chapter 13",
            chapterFolder: chapter13Folder, estimatedMinutes: 4),
        "ch14_scientists": ArticleEntry(id: "ch14_scientists", filename: "ch14_scientists.html",
            title: "Scientist Spotlight — Chapter 14",
            chapterFolder: chapter14Folder, estimatedMinutes: 4),
        "ch15_scientists": ArticleEntry(id: "ch15_scientists", filename: "ch15_scientists.html",
            title: "Scientist Spotlight — Chapter 15",
            chapterFolder: chapter15Folder, estimatedMinutes: 4),
        "ch16_scientists": ArticleEntry(id: "ch16_scientists", filename: "ch16_scientists.html",
            title: "Scientist Spotlight — Chapter 16",
            chapterFolder: chapter16Folder, estimatedMinutes: 4),
        "ch17_scientists": ArticleEntry(id: "ch17_scientists", filename: "ch17_scientists.html",
            title: "Scientist Spotlight — Chapter 17",
            chapterFolder: chapter17Folder, estimatedMinutes: 4),
        "ch18_scientists": ArticleEntry(id: "ch18_scientists", filename: "ch18_scientists.html",
            title: "Scientist Spotlight — Chapter 18",
            chapterFolder: chapter18Folder, estimatedMinutes: 4),
        "ch19_scientists": ArticleEntry(id: "ch19_scientists", filename: "ch19_scientists.html",
            title: "Scientist Spotlight — Chapter 19",
            chapterFolder: chapter19Folder, estimatedMinutes: 4),

        // What If? (thought-experiment articles) — Ch.2-19 generated
        // 2026-05-26 by scripts/generate_whatif_articles.py from
        // chapter.whatIfs JSON (3 entries per chapter; 54 total).
        // Ch.1 has a bespoke 5-scenario anchor entry above.
        "ch02_whatif": ArticleEntry(id: "ch02_whatif", filename: "ch02_whatif.html",
            title: "What If? — Chapter 2", chapterFolder: chapter2Folder, estimatedMinutes: 7),
        "ch03_whatif": ArticleEntry(id: "ch03_whatif", filename: "ch03_whatif.html",
            title: "What If? — Chapter 3", chapterFolder: chapter3Folder, estimatedMinutes: 7),
        "ch04_whatif": ArticleEntry(id: "ch04_whatif", filename: "ch04_whatif.html",
            title: "What If? — Chapter 4", chapterFolder: chapter4Folder, estimatedMinutes: 7),
        "ch05_whatif": ArticleEntry(id: "ch05_whatif", filename: "ch05_whatif.html",
            title: "What If? — Chapter 5", chapterFolder: chapter5Folder, estimatedMinutes: 7),
        "ch06_whatif": ArticleEntry(id: "ch06_whatif", filename: "ch06_whatif.html",
            title: "What If? — Chapter 6", chapterFolder: chapter6Folder, estimatedMinutes: 7),
        "ch07_whatif": ArticleEntry(id: "ch07_whatif", filename: "ch07_whatif.html",
            title: "What If? — Chapter 7", chapterFolder: chapter7Folder, estimatedMinutes: 7),
        "ch08_whatif": ArticleEntry(id: "ch08_whatif", filename: "ch08_whatif.html",
            title: "What If? — Chapter 8", chapterFolder: chapter8Folder, estimatedMinutes: 7),
        "ch09_whatif": ArticleEntry(id: "ch09_whatif", filename: "ch09_whatif.html",
            title: "What If? — Chapter 9", chapterFolder: chapter9Folder, estimatedMinutes: 7),
        "ch10_whatif": ArticleEntry(id: "ch10_whatif", filename: "ch10_whatif.html",
            title: "What If? — Chapter 10", chapterFolder: chapter10Folder, estimatedMinutes: 7),
        "ch11_whatif": ArticleEntry(id: "ch11_whatif", filename: "ch11_whatif.html",
            title: "What If? — Chapter 11", chapterFolder: chapter11Folder, estimatedMinutes: 7),
        "ch12_whatif": ArticleEntry(id: "ch12_whatif", filename: "ch12_whatif.html",
            title: "What If? — Chapter 12", chapterFolder: chapter12Folder, estimatedMinutes: 7),
        "ch13_whatif": ArticleEntry(id: "ch13_whatif", filename: "ch13_whatif.html",
            title: "What If? — Chapter 13", chapterFolder: chapter13Folder, estimatedMinutes: 7),
        "ch14_whatif": ArticleEntry(id: "ch14_whatif", filename: "ch14_whatif.html",
            title: "What If? — Chapter 14", chapterFolder: chapter14Folder, estimatedMinutes: 7),
        "ch15_whatif": ArticleEntry(id: "ch15_whatif", filename: "ch15_whatif.html",
            title: "What If? — Chapter 15", chapterFolder: chapter15Folder, estimatedMinutes: 7),
        "ch16_whatif": ArticleEntry(id: "ch16_whatif", filename: "ch16_whatif.html",
            title: "What If? — Chapter 16", chapterFolder: chapter16Folder, estimatedMinutes: 7),
        "ch17_whatif": ArticleEntry(id: "ch17_whatif", filename: "ch17_whatif.html",
            title: "What If? — Chapter 17", chapterFolder: chapter17Folder, estimatedMinutes: 7),
        "ch18_whatif": ArticleEntry(id: "ch18_whatif", filename: "ch18_whatif.html",
            title: "What If? — Chapter 18", chapterFolder: chapter18Folder, estimatedMinutes: 7),
        "ch19_whatif": ArticleEntry(id: "ch19_whatif", filename: "ch19_whatif.html",
            title: "What If? — Chapter 19", chapterFolder: chapter19Folder, estimatedMinutes: 7),

        // Mini Projects (hands-on activities) — Ch.2-19 generated
        // 2026-05-26 by scripts/generate_miniproject_articles.py from
        // chapter.miniProjects JSON (2 entries per chapter; 36 total).
        "ch02_miniproject": ArticleEntry(id: "ch02_miniproject", filename: "ch02_miniproject.html", title: "Mini Projects — Chapter 2", chapterFolder: chapter2Folder, estimatedMinutes: 60),
        "ch03_miniproject": ArticleEntry(id: "ch03_miniproject", filename: "ch03_miniproject.html", title: "Mini Projects — Chapter 3", chapterFolder: chapter3Folder, estimatedMinutes: 60),
        "ch04_miniproject": ArticleEntry(id: "ch04_miniproject", filename: "ch04_miniproject.html", title: "Mini Projects — Chapter 4", chapterFolder: chapter4Folder, estimatedMinutes: 60),
        "ch05_miniproject": ArticleEntry(id: "ch05_miniproject", filename: "ch05_miniproject.html", title: "Mini Projects — Chapter 5", chapterFolder: chapter5Folder, estimatedMinutes: 60),
        "ch06_miniproject": ArticleEntry(id: "ch06_miniproject", filename: "ch06_miniproject.html", title: "Mini Projects — Chapter 6", chapterFolder: chapter6Folder, estimatedMinutes: 60),
        "ch07_miniproject": ArticleEntry(id: "ch07_miniproject", filename: "ch07_miniproject.html", title: "Mini Projects — Chapter 7", chapterFolder: chapter7Folder, estimatedMinutes: 60),
        "ch08_miniproject": ArticleEntry(id: "ch08_miniproject", filename: "ch08_miniproject.html", title: "Mini Projects — Chapter 8", chapterFolder: chapter8Folder, estimatedMinutes: 60),
        "ch09_miniproject": ArticleEntry(id: "ch09_miniproject", filename: "ch09_miniproject.html", title: "Mini Projects — Chapter 9", chapterFolder: chapter9Folder, estimatedMinutes: 60),
        "ch10_miniproject": ArticleEntry(id: "ch10_miniproject", filename: "ch10_miniproject.html", title: "Mini Projects — Chapter 10", chapterFolder: chapter10Folder, estimatedMinutes: 60),
        "ch11_miniproject": ArticleEntry(id: "ch11_miniproject", filename: "ch11_miniproject.html", title: "Mini Projects — Chapter 11", chapterFolder: chapter11Folder, estimatedMinutes: 60),
        "ch12_miniproject": ArticleEntry(id: "ch12_miniproject", filename: "ch12_miniproject.html", title: "Mini Projects — Chapter 12", chapterFolder: chapter12Folder, estimatedMinutes: 60),
        "ch13_miniproject": ArticleEntry(id: "ch13_miniproject", filename: "ch13_miniproject.html", title: "Mini Projects — Chapter 13", chapterFolder: chapter13Folder, estimatedMinutes: 60),
        "ch14_miniproject": ArticleEntry(id: "ch14_miniproject", filename: "ch14_miniproject.html", title: "Mini Projects — Chapter 14", chapterFolder: chapter14Folder, estimatedMinutes: 60),
        "ch15_miniproject": ArticleEntry(id: "ch15_miniproject", filename: "ch15_miniproject.html", title: "Mini Projects — Chapter 15", chapterFolder: chapter15Folder, estimatedMinutes: 60),
        "ch16_miniproject": ArticleEntry(id: "ch16_miniproject", filename: "ch16_miniproject.html", title: "Mini Projects — Chapter 16", chapterFolder: chapter16Folder, estimatedMinutes: 60),
        "ch17_miniproject": ArticleEntry(id: "ch17_miniproject", filename: "ch17_miniproject.html", title: "Mini Projects — Chapter 17", chapterFolder: chapter17Folder, estimatedMinutes: 60),
        "ch18_miniproject": ArticleEntry(id: "ch18_miniproject", filename: "ch18_miniproject.html", title: "Mini Projects — Chapter 18", chapterFolder: chapter18Folder, estimatedMinutes: 60),
        "ch19_miniproject": ArticleEntry(id: "ch19_miniproject", filename: "ch19_miniproject.html", title: "Mini Projects — Chapter 19", chapterFolder: chapter19Folder, estimatedMinutes: 60),

        // Self-Check (5-question revision quiz) — Ch.2-19 generated
        // 2026-05-26 by scripts/generate_selfcheck_articles.py
        // sampling chapter.topics[].questions (5 representatives).
        "ch02_selfcheck": ArticleEntry(id: "ch02_selfcheck", filename: "ch02_selfcheck.html", title: "Self-Check — Chapter 2", chapterFolder: chapter2Folder, estimatedMinutes: 7),
        "ch03_selfcheck": ArticleEntry(id: "ch03_selfcheck", filename: "ch03_selfcheck.html", title: "Self-Check — Chapter 3", chapterFolder: chapter3Folder, estimatedMinutes: 7),
        "ch04_selfcheck": ArticleEntry(id: "ch04_selfcheck", filename: "ch04_selfcheck.html", title: "Self-Check — Chapter 4", chapterFolder: chapter4Folder, estimatedMinutes: 7),
        "ch05_selfcheck": ArticleEntry(id: "ch05_selfcheck", filename: "ch05_selfcheck.html", title: "Self-Check — Chapter 5", chapterFolder: chapter5Folder, estimatedMinutes: 7),
        "ch06_selfcheck": ArticleEntry(id: "ch06_selfcheck", filename: "ch06_selfcheck.html", title: "Self-Check — Chapter 6", chapterFolder: chapter6Folder, estimatedMinutes: 7),
        "ch07_selfcheck": ArticleEntry(id: "ch07_selfcheck", filename: "ch07_selfcheck.html", title: "Self-Check — Chapter 7", chapterFolder: chapter7Folder, estimatedMinutes: 7),
        "ch08_selfcheck": ArticleEntry(id: "ch08_selfcheck", filename: "ch08_selfcheck.html", title: "Self-Check — Chapter 8", chapterFolder: chapter8Folder, estimatedMinutes: 7),
        "ch09_selfcheck": ArticleEntry(id: "ch09_selfcheck", filename: "ch09_selfcheck.html", title: "Self-Check — Chapter 9", chapterFolder: chapter9Folder, estimatedMinutes: 7),
        "ch10_selfcheck": ArticleEntry(id: "ch10_selfcheck", filename: "ch10_selfcheck.html", title: "Self-Check — Chapter 10", chapterFolder: chapter10Folder, estimatedMinutes: 7),
        "ch11_selfcheck": ArticleEntry(id: "ch11_selfcheck", filename: "ch11_selfcheck.html", title: "Self-Check — Chapter 11", chapterFolder: chapter11Folder, estimatedMinutes: 7),
        "ch12_selfcheck": ArticleEntry(id: "ch12_selfcheck", filename: "ch12_selfcheck.html", title: "Self-Check — Chapter 12", chapterFolder: chapter12Folder, estimatedMinutes: 7),
        "ch13_selfcheck": ArticleEntry(id: "ch13_selfcheck", filename: "ch13_selfcheck.html", title: "Self-Check — Chapter 13", chapterFolder: chapter13Folder, estimatedMinutes: 7),
        "ch14_selfcheck": ArticleEntry(id: "ch14_selfcheck", filename: "ch14_selfcheck.html", title: "Self-Check — Chapter 14", chapterFolder: chapter14Folder, estimatedMinutes: 7),
        "ch15_selfcheck": ArticleEntry(id: "ch15_selfcheck", filename: "ch15_selfcheck.html", title: "Self-Check — Chapter 15", chapterFolder: chapter15Folder, estimatedMinutes: 7),
        "ch16_selfcheck": ArticleEntry(id: "ch16_selfcheck", filename: "ch16_selfcheck.html", title: "Self-Check — Chapter 16", chapterFolder: chapter16Folder, estimatedMinutes: 7),
        "ch17_selfcheck": ArticleEntry(id: "ch17_selfcheck", filename: "ch17_selfcheck.html", title: "Self-Check — Chapter 17", chapterFolder: chapter17Folder, estimatedMinutes: 7),
        "ch18_selfcheck": ArticleEntry(id: "ch18_selfcheck", filename: "ch18_selfcheck.html", title: "Self-Check — Chapter 18", chapterFolder: chapter18Folder, estimatedMinutes: 7),
        "ch19_selfcheck": ArticleEntry(id: "ch19_selfcheck", filename: "ch19_selfcheck.html", title: "Self-Check — Chapter 19", chapterFolder: chapter19Folder, estimatedMinutes: 7),

        // Story Mode (narrative scenes from real life) — Ch.2-19
        // generated 2026-05-26 by scripts/generate_storymode_articles.py
        // weaving chapter.realWorldExamples into vignettes.
        "ch02_storymode": ArticleEntry(id: "ch02_storymode", filename: "ch02_storymode.html", title: "Story Mode — Chapter 2", chapterFolder: chapter2Folder, estimatedMinutes: 10),
        "ch03_storymode": ArticleEntry(id: "ch03_storymode", filename: "ch03_storymode.html", title: "Story Mode — Chapter 3", chapterFolder: chapter3Folder, estimatedMinutes: 10),
        "ch04_storymode": ArticleEntry(id: "ch04_storymode", filename: "ch04_storymode.html", title: "Story Mode — Chapter 4", chapterFolder: chapter4Folder, estimatedMinutes: 10),
        "ch05_storymode": ArticleEntry(id: "ch05_storymode", filename: "ch05_storymode.html", title: "Story Mode — Chapter 5", chapterFolder: chapter5Folder, estimatedMinutes: 10),
        "ch06_storymode": ArticleEntry(id: "ch06_storymode", filename: "ch06_storymode.html", title: "Story Mode — Chapter 6", chapterFolder: chapter6Folder, estimatedMinutes: 10),
        "ch07_storymode": ArticleEntry(id: "ch07_storymode", filename: "ch07_storymode.html", title: "Story Mode — Chapter 7", chapterFolder: chapter7Folder, estimatedMinutes: 10),
        "ch08_storymode": ArticleEntry(id: "ch08_storymode", filename: "ch08_storymode.html", title: "Story Mode — Chapter 8", chapterFolder: chapter8Folder, estimatedMinutes: 10),
        "ch09_storymode": ArticleEntry(id: "ch09_storymode", filename: "ch09_storymode.html", title: "Story Mode — Chapter 9", chapterFolder: chapter9Folder, estimatedMinutes: 10),
        "ch10_storymode": ArticleEntry(id: "ch10_storymode", filename: "ch10_storymode.html", title: "Story Mode — Chapter 10", chapterFolder: chapter10Folder, estimatedMinutes: 10),
        "ch11_storymode": ArticleEntry(id: "ch11_storymode", filename: "ch11_storymode.html", title: "Story Mode — Chapter 11", chapterFolder: chapter11Folder, estimatedMinutes: 10),
        "ch12_storymode": ArticleEntry(id: "ch12_storymode", filename: "ch12_storymode.html", title: "Story Mode — Chapter 12", chapterFolder: chapter12Folder, estimatedMinutes: 10),
        "ch13_storymode": ArticleEntry(id: "ch13_storymode", filename: "ch13_storymode.html", title: "Story Mode — Chapter 13", chapterFolder: chapter13Folder, estimatedMinutes: 10),
        "ch14_storymode": ArticleEntry(id: "ch14_storymode", filename: "ch14_storymode.html", title: "Story Mode — Chapter 14", chapterFolder: chapter14Folder, estimatedMinutes: 10),
        "ch15_storymode": ArticleEntry(id: "ch15_storymode", filename: "ch15_storymode.html", title: "Story Mode — Chapter 15", chapterFolder: chapter15Folder, estimatedMinutes: 10),
        "ch16_storymode": ArticleEntry(id: "ch16_storymode", filename: "ch16_storymode.html", title: "Story Mode — Chapter 16", chapterFolder: chapter16Folder, estimatedMinutes: 10),
        "ch17_storymode": ArticleEntry(id: "ch17_storymode", filename: "ch17_storymode.html", title: "Story Mode — Chapter 17", chapterFolder: chapter17Folder, estimatedMinutes: 10),
        "ch18_storymode": ArticleEntry(id: "ch18_storymode", filename: "ch18_storymode.html", title: "Story Mode — Chapter 18", chapterFolder: chapter18Folder, estimatedMinutes: 10),
        "ch19_storymode": ArticleEntry(id: "ch19_storymode", filename: "ch19_storymode.html", title: "Story Mode — Chapter 19", chapterFolder: chapter19Folder, estimatedMinutes: 10),
        // ── Maths (Class 7) articles — keys carry the m-prefix (mch01…) ──
        "mch01_mistakes": ArticleEntry(id: "mch01_mistakes", filename: "mch01_mistakes.html", title: "Common Mistakes — Large Numbers Around Us", chapterFolder: "Articles/MathsChapter1", estimatedMinutes: 5),
        "mch01_glossary": ArticleEntry(id: "mch01_glossary", filename: "mch01_glossary.html", title: "Vocabulary Deck — Large Numbers Around Us", chapterFolder: "Articles/MathsChapter1", estimatedMinutes: 4),
        "mch01_ncert_qa": ArticleEntry(id: "mch01_ncert_qa", filename: "mch01_ncert_qa.html", title: "NCERT Q&A — Large Numbers Around Us", chapterFolder: "Articles/MathsChapter1", estimatedMinutes: 6),
        "mch01_beyond": ArticleEntry(id: "mch01_beyond", filename: "mch01_beyond.html", title: "Beyond the Book — How Big Is Big?", chapterFolder: "Articles/MathsChapter1", estimatedMinutes: 6),
        "mch02_mistakes": ArticleEntry(id: "mch02_mistakes", filename: "mch02_mistakes.html", title: "Common Mistakes — Arithmetic Expressions", chapterFolder: "Articles/MathsChapter2", estimatedMinutes: 5),
        "mch02_glossary": ArticleEntry(id: "mch02_glossary", filename: "mch02_glossary.html", title: "Vocabulary Deck — Arithmetic Expressions", chapterFolder: "Articles/MathsChapter2", estimatedMinutes: 4),
        "mch02_ncert_qa": ArticleEntry(id: "mch02_ncert_qa", filename: "mch02_ncert_qa.html", title: "NCERT Q&A — Arithmetic Expressions", chapterFolder: "Articles/MathsChapter2", estimatedMinutes: 6),
        "mch02_beyond": ArticleEntry(id: "mch02_beyond", filename: "mch02_beyond.html", title: "Beyond the Book — Who Invented the Signs?", chapterFolder: "Articles/MathsChapter2", estimatedMinutes: 6),
        "mch03_mistakes": ArticleEntry(id: "mch03_mistakes", filename: "mch03_mistakes.html", title: "Common Mistakes — A Peek Beyond the Point", chapterFolder: "Articles/MathsChapter3", estimatedMinutes: 5),
        "mch03_glossary": ArticleEntry(id: "mch03_glossary", filename: "mch03_glossary.html", title: "Vocabulary Deck — A Peek Beyond the Point", chapterFolder: "Articles/MathsChapter3", estimatedMinutes: 4),
        "mch03_ncert_qa": ArticleEntry(id: "mch03_ncert_qa", filename: "mch03_ncert_qa.html", title: "NCERT Q&A — A Peek Beyond the Point", chapterFolder: "Articles/MathsChapter3", estimatedMinutes: 6),
        "mch03_beyond": ArticleEntry(id: "mch03_beyond", filename: "mch03_beyond.html", title: "Beyond the Book — The Tiny Dot That Changed Counting", chapterFolder: "Articles/MathsChapter3", estimatedMinutes: 6),
        "mch04_mistakes": ArticleEntry(id: "mch04_mistakes", filename: "mch04_mistakes.html", title: "Common Mistakes — Expressions Using Letter-Numbers", chapterFolder: "Articles/MathsChapter4", estimatedMinutes: 5),
        "mch04_glossary": ArticleEntry(id: "mch04_glossary", filename: "mch04_glossary.html", title: "Vocabulary Deck — Expressions Using Letter-Numbers", chapterFolder: "Articles/MathsChapter4", estimatedMinutes: 4),
        "mch04_ncert_qa": ArticleEntry(id: "mch04_ncert_qa", filename: "mch04_ncert_qa.html", title: "NCERT Q&A — Expressions Using Letter-Numbers", chapterFolder: "Articles/MathsChapter4", estimatedMinutes: 6),
        "mch04_beyond": ArticleEntry(id: "mch04_beyond", filename: "mch04_beyond.html", title: "Beyond the Book — The Day Letters Became Numbers", chapterFolder: "Articles/MathsChapter4", estimatedMinutes: 6),
        "mch05_mistakes": ArticleEntry(id: "mch05_mistakes", filename: "mch05_mistakes.html", title: "Common Mistakes — Parallel and Intersecting Lines", chapterFolder: "Articles/MathsChapter5", estimatedMinutes: 5),
        "mch05_glossary": ArticleEntry(id: "mch05_glossary", filename: "mch05_glossary.html", title: "Vocabulary Deck — Parallel and Intersecting Lines", chapterFolder: "Articles/MathsChapter5", estimatedMinutes: 4),
        "mch05_ncert_qa": ArticleEntry(id: "mch05_ncert_qa", filename: "mch05_ncert_qa.html", title: "NCERT Q&A — Parallel and Intersecting Lines", chapterFolder: "Articles/MathsChapter5", estimatedMinutes: 6),
        "mch05_beyond": ArticleEntry(id: "mch05_beyond", filename: "mch05_beyond.html", title: "Beyond the Book — The Lines That Never Meet", chapterFolder: "Articles/MathsChapter5", estimatedMinutes: 6),
        "mch06_mistakes": ArticleEntry(id: "mch06_mistakes", filename: "mch06_mistakes.html", title: "Common Mistakes — Number Play", chapterFolder: "Articles/MathsChapter6", estimatedMinutes: 5),
        "mch06_glossary": ArticleEntry(id: "mch06_glossary", filename: "mch06_glossary.html", title: "Vocabulary Deck — Number Play", chapterFolder: "Articles/MathsChapter6", estimatedMinutes: 4),
        "mch06_ncert_qa": ArticleEntry(id: "mch06_ncert_qa", filename: "mch06_ncert_qa.html", title: "NCERT Q&A — Number Play", chapterFolder: "Articles/MathsChapter6", estimatedMinutes: 6),
        "mch06_beyond": ArticleEntry(id: "mch06_beyond", filename: "mch06_beyond.html", title: "Beyond the Book — A Sequence Born in Sanskrit Poetry", chapterFolder: "Articles/MathsChapter6", estimatedMinutes: 6),
        "mch07_mistakes": ArticleEntry(id: "mch07_mistakes", filename: "mch07_mistakes.html", title: "Common Mistakes — A Tale of Three Intersecting Lines", chapterFolder: "Articles/MathsChapter7", estimatedMinutes: 5),
        "mch07_glossary": ArticleEntry(id: "mch07_glossary", filename: "mch07_glossary.html", title: "Vocabulary Deck — A Tale of Three Intersecting Lines", chapterFolder: "Articles/MathsChapter7", estimatedMinutes: 4),
        "mch07_ncert_qa": ArticleEntry(id: "mch07_ncert_qa", filename: "mch07_ncert_qa.html", title: "NCERT Q&A — A Tale of Three Intersecting Lines", chapterFolder: "Articles/MathsChapter7", estimatedMinutes: 6),
        "mch07_beyond": ArticleEntry(id: "mch07_beyond", filename: "mch07_beyond.html", title: "Beyond the Book — Why the World Is Built on Triangles", chapterFolder: "Articles/MathsChapter7", estimatedMinutes: 6),
        "mch08_mistakes": ArticleEntry(id: "mch08_mistakes", filename: "mch08_mistakes.html", title: "Common Mistakes — Working with Fractions", chapterFolder: "Articles/MathsChapter8", estimatedMinutes: 5),
        "mch08_glossary": ArticleEntry(id: "mch08_glossary", filename: "mch08_glossary.html", title: "Vocabulary Deck — Working with Fractions", chapterFolder: "Articles/MathsChapter8", estimatedMinutes: 4),
        "mch08_ncert_qa": ArticleEntry(id: "mch08_ncert_qa", filename: "mch08_ncert_qa.html", title: "NCERT Q&A — Working with Fractions", chapterFolder: "Articles/MathsChapter8", estimatedMinutes: 6),
        "mch08_beyond": ArticleEntry(id: "mch08_beyond", filename: "mch08_beyond.html", title: "Beyond the Book — How Ancient Egypt Did Fractions", chapterFolder: "Articles/MathsChapter8", estimatedMinutes: 6),
        "mch09_mistakes": ArticleEntry(id: "mch09_mistakes", filename: "mch09_mistakes.html", title: "Common Mistakes — Geometric Twins", chapterFolder: "Articles/MathsChapter9", estimatedMinutes: 5),
        "mch09_glossary": ArticleEntry(id: "mch09_glossary", filename: "mch09_glossary.html", title: "Vocabulary Deck — Geometric Twins", chapterFolder: "Articles/MathsChapter9", estimatedMinutes: 4),
        "mch09_ncert_qa": ArticleEntry(id: "mch09_ncert_qa", filename: "mch09_ncert_qa.html", title: "NCERT Q&A — Geometric Twins", chapterFolder: "Articles/MathsChapter9", estimatedMinutes: 6),
        "mch09_beyond": ArticleEntry(id: "mch09_beyond", filename: "mch09_beyond.html", title: "Beyond the Book — When Same Shape Built the Modern World", chapterFolder: "Articles/MathsChapter9", estimatedMinutes: 6),
        "mch10_mistakes": ArticleEntry(id: "mch10_mistakes", filename: "mch10_mistakes.html", title: "Common Mistakes — Operations with Integers", chapterFolder: "Articles/MathsChapter10", estimatedMinutes: 5),
        "mch10_glossary": ArticleEntry(id: "mch10_glossary", filename: "mch10_glossary.html", title: "Vocabulary Deck — Operations with Integers", chapterFolder: "Articles/MathsChapter10", estimatedMinutes: 4),
        "mch10_ncert_qa": ArticleEntry(id: "mch10_ncert_qa", filename: "mch10_ncert_qa.html", title: "NCERT Q&A — Operations with Integers", chapterFolder: "Articles/MathsChapter10", estimatedMinutes: 6),
        "mch10_beyond": ArticleEntry(id: "mch10_beyond", filename: "mch10_beyond.html", title: "Beyond the Book — When Numbers Went Negative", chapterFolder: "Articles/MathsChapter10", estimatedMinutes: 6),
        "mch11_mistakes": ArticleEntry(id: "mch11_mistakes", filename: "mch11_mistakes.html", title: "Common Mistakes — Finding Common Ground", chapterFolder: "Articles/MathsChapter11", estimatedMinutes: 5),
        "mch11_glossary": ArticleEntry(id: "mch11_glossary", filename: "mch11_glossary.html", title: "Vocabulary Deck — Finding Common Ground", chapterFolder: "Articles/MathsChapter11", estimatedMinutes: 4),
        "mch11_ncert_qa": ArticleEntry(id: "mch11_ncert_qa", filename: "mch11_ncert_qa.html", title: "NCERT Q&A — Finding Common Ground", chapterFolder: "Articles/MathsChapter11", estimatedMinutes: 6),
        "mch11_beyond": ArticleEntry(id: "mch11_beyond", filename: "mch11_beyond.html", title: "Beyond the Book — The Cleverest Old Trick for Common Factors", chapterFolder: "Articles/MathsChapter11", estimatedMinutes: 6),
        "mch12_mistakes": ArticleEntry(id: "mch12_mistakes", filename: "mch12_mistakes.html", title: "Common Mistakes — Another Peek Beyond the Point", chapterFolder: "Articles/MathsChapter12", estimatedMinutes: 5),
        "mch12_glossary": ArticleEntry(id: "mch12_glossary", filename: "mch12_glossary.html", title: "Vocabulary Deck — Another Peek Beyond the Point", chapterFolder: "Articles/MathsChapter12", estimatedMinutes: 4),
        "mch12_ncert_qa": ArticleEntry(id: "mch12_ncert_qa", filename: "mch12_ncert_qa.html", title: "NCERT Q&A — Another Peek Beyond the Point", chapterFolder: "Articles/MathsChapter12", estimatedMinutes: 6),
        "mch12_beyond": ArticleEntry(id: "mch12_beyond", filename: "mch12_beyond.html", title: "Beyond the Book — Why the Whole World Counts in Tens", chapterFolder: "Articles/MathsChapter12", estimatedMinutes: 6),
        "mch13_mistakes": ArticleEntry(id: "mch13_mistakes", filename: "mch13_mistakes.html", title: "Common Mistakes — Connecting the Dots", chapterFolder: "Articles/MathsChapter13", estimatedMinutes: 5),
        "mch13_glossary": ArticleEntry(id: "mch13_glossary", filename: "mch13_glossary.html", title: "Vocabulary Deck — Connecting the Dots", chapterFolder: "Articles/MathsChapter13", estimatedMinutes: 4),
        "mch13_ncert_qa": ArticleEntry(id: "mch13_ncert_qa", filename: "mch13_ncert_qa.html", title: "NCERT Q&A — Connecting the Dots", chapterFolder: "Articles/MathsChapter13", estimatedMinutes: 6),
        "mch13_beyond": ArticleEntry(id: "mch13_beyond", filename: "mch13_beyond.html", title: "Beyond the Book — How One Average Can Fool You", chapterFolder: "Articles/MathsChapter13", estimatedMinutes: 6),
        "mch14_mistakes": ArticleEntry(id: "mch14_mistakes", filename: "mch14_mistakes.html", title: "Common Mistakes — Constructions and Tilings", chapterFolder: "Articles/MathsChapter14", estimatedMinutes: 5),
        "mch14_glossary": ArticleEntry(id: "mch14_glossary", filename: "mch14_glossary.html", title: "Vocabulary Deck — Constructions and Tilings", chapterFolder: "Articles/MathsChapter14", estimatedMinutes: 4),
        "mch14_ncert_qa": ArticleEntry(id: "mch14_ncert_qa", filename: "mch14_ncert_qa.html", title: "NCERT Q&A — Constructions and Tilings", chapterFolder: "Articles/MathsChapter14", estimatedMinutes: 6),
        "mch14_beyond": ArticleEntry(id: "mch14_beyond", filename: "mch14_beyond.html", title: "Beyond the Book — A Compass, a Ruler, and Three Impossible Puzzles", chapterFolder: "Articles/MathsChapter14", estimatedMinutes: 6),
        "mch15_mistakes": ArticleEntry(id: "mch15_mistakes", filename: "mch15_mistakes.html", title: "Common Mistakes — Finding the Unknown", chapterFolder: "Articles/MathsChapter15", estimatedMinutes: 5),
        "mch15_glossary": ArticleEntry(id: "mch15_glossary", filename: "mch15_glossary.html", title: "Vocabulary Deck — Finding the Unknown", chapterFolder: "Articles/MathsChapter15", estimatedMinutes: 4),
        "mch15_ncert_qa": ArticleEntry(id: "mch15_ncert_qa", filename: "mch15_ncert_qa.html", title: "NCERT Q&A — Finding the Unknown", chapterFolder: "Articles/MathsChapter15", estimatedMinutes: 6),
        "mch15_beyond": ArticleEntry(id: "mch15_beyond", filename: "mch15_beyond.html", title: "Beyond the Book — The Balance That Solves for x", chapterFolder: "Articles/MathsChapter15", estimatedMinutes: 6),
        "mch01_miniproject": ArticleEntry(id: "mch01_miniproject", filename: "mch01_miniproject.html", title: "Mini Project — Lakh and Crore Around Me", chapterFolder: "Articles/MathsChapter1", estimatedMinutes: 60),
        "mch01_selfcheck": ArticleEntry(id: "mch01_selfcheck", filename: "mch01_selfcheck.html", title: "Self-Check — Large Numbers Around Us", chapterFolder: "Articles/MathsChapter1", estimatedMinutes: 5),
        "mch01_storymode": ArticleEntry(id: "mch01_storymode", filename: "mch01_storymode.html", title: "Story Mode — Large Numbers Around Us", chapterFolder: "Articles/MathsChapter1", estimatedMinutes: 6),
        "mch02_miniproject": ArticleEntry(id: "mch02_miniproject", filename: "mch02_miniproject.html", title: "Mini Project — Expression Storyteller", chapterFolder: "Articles/MathsChapter2", estimatedMinutes: 30),
        "mch02_selfcheck": ArticleEntry(id: "mch02_selfcheck", filename: "mch02_selfcheck.html", title: "Self-Check — Arithmetic Expressions", chapterFolder: "Articles/MathsChapter2", estimatedMinutes: 5),
        "mch02_storymode": ArticleEntry(id: "mch02_storymode", filename: "mch02_storymode.html", title: "Story Mode — Arithmetic Expressions", chapterFolder: "Articles/MathsChapter2", estimatedMinutes: 6),
        "mch03_miniproject": ArticleEntry(id: "mch03_miniproject", filename: "mch03_miniproject.html", title: "Mini Project — Make Your Own Tenths Ruler", chapterFolder: "Articles/MathsChapter3", estimatedMinutes: 40),
        "mch03_selfcheck": ArticleEntry(id: "mch03_selfcheck", filename: "mch03_selfcheck.html", title: "Self-Check — A Peek Beyond the Point", chapterFolder: "Articles/MathsChapter3", estimatedMinutes: 5),
        "mch03_storymode": ArticleEntry(id: "mch03_storymode", filename: "mch03_storymode.html", title: "Story Mode — A Peek Beyond the Point", chapterFolder: "Articles/MathsChapter3", estimatedMinutes: 6),
        "mch04_miniproject": ArticleEntry(id: "mch04_miniproject", filename: "mch04_miniproject.html", title: "Mini Project — Letter-Number Detective", chapterFolder: "Articles/MathsChapter4", estimatedMinutes: 35),
        "mch04_selfcheck": ArticleEntry(id: "mch04_selfcheck", filename: "mch04_selfcheck.html", title: "Self-Check — Expressions Using Letter-Numbers", chapterFolder: "Articles/MathsChapter4", estimatedMinutes: 5),
        "mch04_storymode": ArticleEntry(id: "mch04_storymode", filename: "mch04_storymode.html", title: "Story Mode — Expressions Using Letter-Numbers", chapterFolder: "Articles/MathsChapter4", estimatedMinutes: 6),
        "mch05_miniproject": ArticleEntry(id: "mch05_miniproject", filename: "mch05_miniproject.html", title: "Mini Project — Paper-Fold Parallel & Perpendicular Hunt", chapterFolder: "Articles/MathsChapter5", estimatedMinutes: 40),
        "mch05_selfcheck": ArticleEntry(id: "mch05_selfcheck", filename: "mch05_selfcheck.html", title: "Self-Check — Parallel and Intersecting Lines", chapterFolder: "Articles/MathsChapter5", estimatedMinutes: 5),
        "mch05_storymode": ArticleEntry(id: "mch05_storymode", filename: "mch05_storymode.html", title: "Story Mode — Parallel and Intersecting Lines", chapterFolder: "Articles/MathsChapter5", estimatedMinutes: 6),
        "mch06_miniproject": ArticleEntry(id: "mch06_miniproject", filename: "mch06_miniproject.html", title: "Mini Project — Parity Detective", chapterFolder: "Articles/MathsChapter6", estimatedMinutes: 30),
        "mch06_selfcheck": ArticleEntry(id: "mch06_selfcheck", filename: "mch06_selfcheck.html", title: "Self-Check — Number Play", chapterFolder: "Articles/MathsChapter6", estimatedMinutes: 5),
        "mch06_storymode": ArticleEntry(id: "mch06_storymode", filename: "mch06_storymode.html", title: "Story Mode — Number Play", chapterFolder: "Articles/MathsChapter6", estimatedMinutes: 6),
        "mch07_miniproject": ArticleEntry(id: "mch07_miniproject", filename: "mch07_miniproject.html", title: "Mini Project — Triangle or Not? The Straw Test", chapterFolder: "Articles/MathsChapter7", estimatedMinutes: 40),
        "mch07_selfcheck": ArticleEntry(id: "mch07_selfcheck", filename: "mch07_selfcheck.html", title: "Self-Check — A Tale of Three Intersecting Lines", chapterFolder: "Articles/MathsChapter7", estimatedMinutes: 5),
        "mch07_storymode": ArticleEntry(id: "mch07_storymode", filename: "mch07_storymode.html", title: "Story Mode — A Tale of Three Intersecting Lines", chapterFolder: "Articles/MathsChapter7", estimatedMinutes: 6),
        "mch08_miniproject": ArticleEntry(id: "mch08_miniproject", filename: "mch08_miniproject.html", title: "Mini Project — Chocolate-Bar Fraction Lab", chapterFolder: "Articles/MathsChapter8", estimatedMinutes: 35),
        "mch08_selfcheck": ArticleEntry(id: "mch08_selfcheck", filename: "mch08_selfcheck.html", title: "Self-Check — Working with Fractions", chapterFolder: "Articles/MathsChapter8", estimatedMinutes: 5),
        "mch08_storymode": ArticleEntry(id: "mch08_storymode", filename: "mch08_storymode.html", title: "Story Mode — Working with Fractions", chapterFolder: "Articles/MathsChapter8", estimatedMinutes: 6),
        "mch09_miniproject": ArticleEntry(id: "mch09_miniproject", filename: "mch09_miniproject.html", title: "Mini Project — Congruence by Cut-and-Fold", chapterFolder: "Articles/MathsChapter9", estimatedMinutes: 35),
        "mch09_selfcheck": ArticleEntry(id: "mch09_selfcheck", filename: "mch09_selfcheck.html", title: "Self-Check — Geometric Twins", chapterFolder: "Articles/MathsChapter9", estimatedMinutes: 5),
        "mch09_storymode": ArticleEntry(id: "mch09_storymode", filename: "mch09_storymode.html", title: "Story Mode — Geometric Twins", chapterFolder: "Articles/MathsChapter9", estimatedMinutes: 6),
        "mch10_miniproject": ArticleEntry(id: "mch10_miniproject", filename: "mch10_miniproject.html", title: "Mini Project — Token-Bag Integer Machine", chapterFolder: "Articles/MathsChapter10", estimatedMinutes: 35),
        "mch10_selfcheck": ArticleEntry(id: "mch10_selfcheck", filename: "mch10_selfcheck.html", title: "Self-Check — Operations with Integers", chapterFolder: "Articles/MathsChapter10", estimatedMinutes: 5),
        "mch10_storymode": ArticleEntry(id: "mch10_storymode", filename: "mch10_storymode.html", title: "Story Mode — Operations with Integers", chapterFolder: "Articles/MathsChapter10", estimatedMinutes: 6),
        "mch11_miniproject": ArticleEntry(id: "mch11_miniproject", filename: "mch11_miniproject.html", title: "Mini Project — Tile the Room (HCF) & Sync the Bells (LCM)", chapterFolder: "Articles/MathsChapter11", estimatedMinutes: 40),
        "mch11_selfcheck": ArticleEntry(id: "mch11_selfcheck", filename: "mch11_selfcheck.html", title: "Self-Check — Finding Common Ground", chapterFolder: "Articles/MathsChapter11", estimatedMinutes: 5),
        "mch11_storymode": ArticleEntry(id: "mch11_storymode", filename: "mch11_storymode.html", title: "Story Mode — Finding Common Ground", chapterFolder: "Articles/MathsChapter11", estimatedMinutes: 6),
        "mch12_miniproject": ArticleEntry(id: "mch12_miniproject", filename: "mch12_miniproject.html", title: "Mini Project — Decimal Shopping Check", chapterFolder: "Articles/MathsChapter12", estimatedMinutes: 30),
        "mch12_selfcheck": ArticleEntry(id: "mch12_selfcheck", filename: "mch12_selfcheck.html", title: "Self-Check — Another Peek Beyond the Point", chapterFolder: "Articles/MathsChapter12", estimatedMinutes: 5),
        "mch12_storymode": ArticleEntry(id: "mch12_storymode", filename: "mch12_storymode.html", title: "Story Mode — Another Peek Beyond the Point", chapterFolder: "Articles/MathsChapter12", estimatedMinutes: 6),
        "mch13_miniproject": ArticleEntry(id: "mch13_miniproject", filename: "mch13_miniproject.html", title: "Mini Project — Class Data Detective", chapterFolder: "Articles/MathsChapter13", estimatedMinutes: 45),
        "mch13_selfcheck": ArticleEntry(id: "mch13_selfcheck", filename: "mch13_selfcheck.html", title: "Self-Check — Connecting the Dots", chapterFolder: "Articles/MathsChapter13", estimatedMinutes: 5),
        "mch13_storymode": ArticleEntry(id: "mch13_storymode", filename: "mch13_storymode.html", title: "Story Mode — Connecting the Dots", chapterFolder: "Articles/MathsChapter13", estimatedMinutes: 6),
        "mch14_miniproject": ArticleEntry(id: "mch14_miniproject", filename: "mch14_miniproject.html", title: "Mini Project — Construct & Tile", chapterFolder: "Articles/MathsChapter14", estimatedMinutes: 45),
        "mch14_selfcheck": ArticleEntry(id: "mch14_selfcheck", filename: "mch14_selfcheck.html", title: "Self-Check — Constructions and Tilings", chapterFolder: "Articles/MathsChapter14", estimatedMinutes: 5),
        "mch14_storymode": ArticleEntry(id: "mch14_storymode", filename: "mch14_storymode.html", title: "Story Mode — Constructions and Tilings", chapterFolder: "Articles/MathsChapter14", estimatedMinutes: 6),
        "mch15_miniproject": ArticleEntry(id: "mch15_miniproject", filename: "mch15_miniproject.html", title: "Mini Project — Build a Balance, Solve an Equation", chapterFolder: "Articles/MathsChapter15", estimatedMinutes: 40),
        "mch15_selfcheck": ArticleEntry(id: "mch15_selfcheck", filename: "mch15_selfcheck.html", title: "Self-Check — Finding the Unknown", chapterFolder: "Articles/MathsChapter15", estimatedMinutes: 5),
        "mch15_storymode": ArticleEntry(id: "mch15_storymode", filename: "mch15_storymode.html", title: "Story Mode — Finding the Unknown", chapterFolder: "Articles/MathsChapter15", estimatedMinutes: 6),
    ]

    static func entry(forConceptId id: String) -> ArticleEntry? {
        entries[id]
    }

    static func entry(forTopicId id: String) -> ArticleEntry? {
        entries[id]
    }

    static func entry(forChapterId id: String) -> ArticleEntry? {
        entries[id]
    }
}
