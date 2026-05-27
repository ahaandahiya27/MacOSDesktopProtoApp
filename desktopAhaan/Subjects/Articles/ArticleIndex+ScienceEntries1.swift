import Foundation

// Science (NCERT Class 7) article registrations, part 1 (ch01–ch03).
// Split out of the monolithic ArticleIndex.entries literal so per-subject
// content edits stay disjoint and each partial stays under the 600-LOC ceiling.
// Merged into ArticleIndex.entries in ArticleIndex.swift.
extension ArticleIndex {
    static let scienceEntries1: [String: ArticleEntry] = [
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
    ]
}
