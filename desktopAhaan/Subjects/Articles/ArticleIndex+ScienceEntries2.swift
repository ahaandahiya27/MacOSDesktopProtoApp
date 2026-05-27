import Foundation

// Science (NCERT Class 7) article registrations, part 2 (ch04–ch12).
// Split out of the monolithic ArticleIndex.entries literal so per-subject
// content edits stay disjoint and each partial stays under the 600-LOC ceiling.
// Merged into ArticleIndex.entries in ArticleIndex.swift.
extension ArticleIndex {
    static let scienceEntries2: [String: ArticleEntry] = [

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
        "ch09_t02_c03": ArticleEntry(id: "ch09_t02_c03", filename: "ch09_t02_c03.html",
            title: "Percolation Rate and How to Measure It",
            chapterFolder: chapter9Folder, estimatedMinutes: 6),

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
        "ch10_t02_c03": ArticleEntry(id: "ch10_t02_c03", filename: "ch10_t02_c03.html",
            title: "Anaerobic Respiration — Without Oxygen",
            chapterFolder: chapter10Folder, estimatedMinutes: 6),

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
    ]
}
