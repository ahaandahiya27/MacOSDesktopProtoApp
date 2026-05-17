import Foundation

struct ArticleEntry: Hashable {
    let id: String
    let filename: String
    let title: String
    let chapterFolder: String
    let estimatedMinutes: Int
}

enum ArticleIndex {
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
        "ch05_t02_c03": ArticleEntry(id: "ch05_t02_c03", filename: "ch05_t02_c03.html",
            title: "Acid Rain — When the Sky Turns Sour",
            chapterFolder: chapter5Folder, estimatedMinutes: 6),
        "ch05_t02_c04": ArticleEntry(id: "ch05_t02_c04", filename: "ch05_t02_c04.html",
            title: "Antacids and Bee Stings — Neutralisation in Daily Life",
            chapterFolder: chapter5Folder, estimatedMinutes: 5),
        "ch05_t02_c05": ArticleEntry(id: "ch05_t02_c05", filename: "ch05_t02_c05.html",
            title: "Soil pH and Farming — Why Farmers Add Lime",
            chapterFolder: chapter5Folder, estimatedMinutes: 6),

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
        "ch06_t02_c03": ArticleEntry(id: "ch06_t02_c03", filename: "ch06_t02_c03.html",
            title: "Crystals in Nature and Industry",
            chapterFolder: chapter6Folder, estimatedMinutes: 6),

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
        "ch07_t02_c04": ArticleEntry(id: "ch07_t02_c04", filename: "ch07_t02_c04.html",
            title: "Desert Adaptations — Camels, Foxes, and Scorpions",
            chapterFolder: chapter7Folder, estimatedMinutes: 6),
        "ch07_t02_c05": ArticleEntry(id: "ch07_t02_c05", filename: "ch07_t02_c05.html",
            title: "Hibernation and Aestivation — Sleeping Through Extremes",
            chapterFolder: chapter7Folder, estimatedMinutes: 5),

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
