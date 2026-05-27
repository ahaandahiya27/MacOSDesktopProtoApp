import Foundation

// Science (NCERT Class 7) article registrations, part 3 (ch13–ch05).
// Split out of the monolithic ArticleIndex.entries literal so per-subject
// content edits stay disjoint and each partial stays under the 600-LOC ceiling.
// Merged into ArticleIndex.entries in ArticleIndex.swift.
extension ArticleIndex {
    static let scienceEntries3: [String: ArticleEntry] = [


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
    ]
}
