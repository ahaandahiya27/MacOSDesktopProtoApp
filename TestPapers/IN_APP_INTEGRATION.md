# In-App Integration Handoff — Science Olympiad Papers

This is a **text handoff** for the agent wiring the in-app Olympiad feature.
Each finished Science chapter below contributes one ready-to-paste
`OlympiadPaper(...)` entry for `allPapers` in
`desktopAhaan/Subjects/OlympiadTests/OlympiadPaperRegistry.swift`.

**Do NOT** consider this file authoritative for the Swift edit — the content
agent never edits Swift, pbxproj, or `desktopAhaan/Resources/**`. Wiring steps
for whoever integrates:

1. Copy the 4 deliverable files for each chapter from repo-root `TestPapers/`
   into `desktopAhaan/Resources/TestPapers/` (the bundled location) and add them
   to the Xcode target (pbxproj) — same as Ch13.
2. Paste the matching `OlympiadPaper(...)` snippet into `allPapers`, sorted by
   subject then chapter number ascending.
3. The `solvedGuideHTML:` filename follows the convention
   `Science_Ch<NN>_<Slug>_SolvedGuide.html`. The content agent does **not**
   produce the Solved-Guide HTML (that's generated in-app via
   `scripts/make_solved_guide.py` from the bundled `_Solutions.md`). The
   filename is pre-named here so the struct compiles once the guide is built.

All papers: `subjectId: "science_class7"`, `subjectName: "Science"`,
`maxMarks 240` (struct default), `suggestedTimeMinutes: 90`, 60 MCQ.

---

## Registry entries

```swift
        OlympiadPaper(
            id: "olympiad_science_ch01",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 1,
            chapterTitle: "Nutrition in Plants",
            displayTitle: "Nutrition in Plants — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch01_NutritionInPlants_QuestionPaper.md",
            solutionsMD: "Science_Ch01_NutritionInPlants_Solutions.md",
            questionPaperHTML: "Science_Ch01_NutritionInPlants.html",
            questionPaperPDF: "Science_Ch01_NutritionInPlants.pdf",
            solvedGuideHTML: "Science_Ch01_NutritionInPlants_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_science_ch02",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 2,
            chapterTitle: "Nutrition in Animals",
            displayTitle: "Nutrition in Animals — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch02_NutritionInAnimals_QuestionPaper.md",
            solutionsMD: "Science_Ch02_NutritionInAnimals_Solutions.md",
            questionPaperHTML: "Science_Ch02_NutritionInAnimals.html",
            questionPaperPDF: "Science_Ch02_NutritionInAnimals.pdf",
            solvedGuideHTML: "Science_Ch02_NutritionInAnimals_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_science_ch03",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 3,
            chapterTitle: "Fibre to Fabric",
            displayTitle: "Fibre to Fabric — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch03_FibreToFabric_QuestionPaper.md",
            solutionsMD: "Science_Ch03_FibreToFabric_Solutions.md",
            questionPaperHTML: "Science_Ch03_FibreToFabric.html",
            questionPaperPDF: "Science_Ch03_FibreToFabric.pdf",
            solvedGuideHTML: "Science_Ch03_FibreToFabric_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_science_ch04",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 4,
            chapterTitle: "Heat",
            displayTitle: "Heat — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch04_Heat_QuestionPaper.md",
            solutionsMD: "Science_Ch04_Heat_Solutions.md",
            questionPaperHTML: "Science_Ch04_Heat.html",
            questionPaperPDF: "Science_Ch04_Heat.pdf",
            solvedGuideHTML: "Science_Ch04_Heat_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_science_ch05",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 5,
            chapterTitle: "Acids, Bases and Salts",
            displayTitle: "Acids, Bases and Salts — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch05_AcidsBasesAndSalts_QuestionPaper.md",
            solutionsMD: "Science_Ch05_AcidsBasesAndSalts_Solutions.md",
            questionPaperHTML: "Science_Ch05_AcidsBasesAndSalts.html",
            questionPaperPDF: "Science_Ch05_AcidsBasesAndSalts.pdf",
            solvedGuideHTML: "Science_Ch05_AcidsBasesAndSalts_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_science_ch06",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 6,
            chapterTitle: "Physical and Chemical Changes",
            displayTitle: "Physical and Chemical Changes — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch06_PhysicalAndChemicalChanges_QuestionPaper.md",
            solutionsMD: "Science_Ch06_PhysicalAndChemicalChanges_Solutions.md",
            questionPaperHTML: "Science_Ch06_PhysicalAndChemicalChanges.html",
            questionPaperPDF: "Science_Ch06_PhysicalAndChemicalChanges.pdf",
            solvedGuideHTML: "Science_Ch06_PhysicalAndChemicalChanges_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_science_ch07",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 7,
            chapterTitle: "Weather, Climate and Adaptations of Animals to Climate",
            displayTitle: "Weather, Climate and Adaptations — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch07_WeatherClimateAndAdaptationsOfAnimalsToClimate_QuestionPaper.md",
            solutionsMD: "Science_Ch07_WeatherClimateAndAdaptationsOfAnimalsToClimate_Solutions.md",
            questionPaperHTML: "Science_Ch07_WeatherClimateAndAdaptationsOfAnimalsToClimate.html",
            questionPaperPDF: "Science_Ch07_WeatherClimateAndAdaptationsOfAnimalsToClimate.pdf",
            solvedGuideHTML: "Science_Ch07_WeatherClimateAndAdaptationsOfAnimalsToClimate_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_science_ch08",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 8,
            chapterTitle: "Winds, Storms and Cyclones",
            displayTitle: "Winds, Storms and Cyclones — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch08_WindsStormsAndCyclones_QuestionPaper.md",
            solutionsMD: "Science_Ch08_WindsStormsAndCyclones_Solutions.md",
            questionPaperHTML: "Science_Ch08_WindsStormsAndCyclones.html",
            questionPaperPDF: "Science_Ch08_WindsStormsAndCyclones.pdf",
            solvedGuideHTML: "Science_Ch08_WindsStormsAndCyclones_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_science_ch09",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 9,
            chapterTitle: "Soil",
            displayTitle: "Soil — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch09_Soil_QuestionPaper.md",
            solutionsMD: "Science_Ch09_Soil_Solutions.md",
            questionPaperHTML: "Science_Ch09_Soil.html",
            questionPaperPDF: "Science_Ch09_Soil.pdf",
            solvedGuideHTML: "Science_Ch09_Soil_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_science_ch10",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 10,
            chapterTitle: "Respiration in Organisms",
            displayTitle: "Respiration in Organisms — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch10_RespirationInOrganisms_QuestionPaper.md",
            solutionsMD: "Science_Ch10_RespirationInOrganisms_Solutions.md",
            questionPaperHTML: "Science_Ch10_RespirationInOrganisms.html",
            questionPaperPDF: "Science_Ch10_RespirationInOrganisms.pdf",
            solvedGuideHTML: "Science_Ch10_RespirationInOrganisms_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_science_ch11",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 11,
            chapterTitle: "Transportation in Animals and Plants",
            displayTitle: "Transportation in Animals and Plants — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch11_TransportationInAnimalsAndPlants_QuestionPaper.md",
            solutionsMD: "Science_Ch11_TransportationInAnimalsAndPlants_Solutions.md",
            questionPaperHTML: "Science_Ch11_TransportationInAnimalsAndPlants.html",
            questionPaperPDF: "Science_Ch11_TransportationInAnimalsAndPlants.pdf",
            solvedGuideHTML: "Science_Ch11_TransportationInAnimalsAndPlants_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_science_ch12",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 12,
            chapterTitle: "Reproduction in Plants",
            displayTitle: "Reproduction in Plants — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch12_ReproductionInPlants_QuestionPaper.md",
            solutionsMD: "Science_Ch12_ReproductionInPlants_Solutions.md",
            questionPaperHTML: "Science_Ch12_ReproductionInPlants.html",
            questionPaperPDF: "Science_Ch12_ReproductionInPlants.pdf",
            solvedGuideHTML: "Science_Ch12_ReproductionInPlants_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_science_ch14",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 14,
            chapterTitle: "Electric Current and its Effect",
            displayTitle: "Electric Current and its Effect — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch14_ElectricCurrentAndItsEffect_QuestionPaper.md",
            solutionsMD: "Science_Ch14_ElectricCurrentAndItsEffect_Solutions.md",
            questionPaperHTML: "Science_Ch14_ElectricCurrentAndItsEffect.html",
            questionPaperPDF: "Science_Ch14_ElectricCurrentAndItsEffect.pdf",
            solvedGuideHTML: "Science_Ch14_ElectricCurrentAndItsEffect_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_science_ch15",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 15,
            chapterTitle: "Light",
            displayTitle: "Light — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch15_Light_QuestionPaper.md",
            solutionsMD: "Science_Ch15_Light_Solutions.md",
            questionPaperHTML: "Science_Ch15_Light.html",
            questionPaperPDF: "Science_Ch15_Light.pdf",
            solvedGuideHTML: "Science_Ch15_Light_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_science_ch16",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 16,
            chapterTitle: "Water: A Precious Resource",
            displayTitle: "Water: A Precious Resource — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch16_WaterAPreciousResource_QuestionPaper.md",
            solutionsMD: "Science_Ch16_WaterAPreciousResource_Solutions.md",
            questionPaperHTML: "Science_Ch16_WaterAPreciousResource.html",
            questionPaperPDF: "Science_Ch16_WaterAPreciousResource.pdf",
            solvedGuideHTML: "Science_Ch16_WaterAPreciousResource_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_science_ch17",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 17,
            chapterTitle: "Forest: Our Lifeline",
            displayTitle: "Forest: Our Lifeline — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch17_ForestOurLifeline_QuestionPaper.md",
            solutionsMD: "Science_Ch17_ForestOurLifeline_Solutions.md",
            questionPaperHTML: "Science_Ch17_ForestOurLifeline.html",
            questionPaperPDF: "Science_Ch17_ForestOurLifeline.pdf",
            solvedGuideHTML: "Science_Ch17_ForestOurLifeline_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_science_ch18",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 18,
            chapterTitle: "Wastewater Story",
            displayTitle: "Wastewater Story — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch18_WastewaterStory_QuestionPaper.md",
            solutionsMD: "Science_Ch18_WastewaterStory_Solutions.md",
            questionPaperHTML: "Science_Ch18_WastewaterStory.html",
            questionPaperPDF: "Science_Ch18_WastewaterStory.pdf",
            solvedGuideHTML: "Science_Ch18_WastewaterStory_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_science_ch19",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 19,
            chapterTitle: "Earth, Moon and the Sun",
            displayTitle: "Earth, Moon and the Sun — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch19_EarthMoonAndTheSun_QuestionPaper.md",
            solutionsMD: "Science_Ch19_EarthMoonAndTheSun_Solutions.md",
            questionPaperHTML: "Science_Ch19_EarthMoonAndTheSun.html",
            questionPaperPDF: "Science_Ch19_EarthMoonAndTheSun.pdf",
            solvedGuideHTML: "Science_Ch19_EarthMoonAndTheSun_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_ch01",
            subjectId: "maths_class7",
            subjectName: "Mathematics",
            chapterNumber: 1,
            chapterTitle: "Large Numbers Around Us",
            displayTitle: "Large Numbers Around Us — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch01_LargeNumbersAroundUs_QuestionPaper.md",
            solutionsMD: "Maths_Ch01_LargeNumbersAroundUs_Solutions.md",
            questionPaperHTML: "Maths_Ch01_LargeNumbersAroundUs.html",
            questionPaperPDF: "Maths_Ch01_LargeNumbersAroundUs.pdf",
            solvedGuideHTML: "Maths_Ch01_LargeNumbersAroundUs_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_ch02",
            subjectId: "maths_class7",
            subjectName: "Mathematics",
            chapterNumber: 2,
            chapterTitle: "Arithmetic Expressions",
            displayTitle: "Arithmetic Expressions — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch02_ArithmeticExpressions_QuestionPaper.md",
            solutionsMD: "Maths_Ch02_ArithmeticExpressions_Solutions.md",
            questionPaperHTML: "Maths_Ch02_ArithmeticExpressions.html",
            questionPaperPDF: "Maths_Ch02_ArithmeticExpressions.pdf",
            solvedGuideHTML: "Maths_Ch02_ArithmeticExpressions_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_ch03",
            subjectId: "maths_class7",
            subjectName: "Mathematics",
            chapterNumber: 3,
            chapterTitle: "A Peek Beyond the Point",
            displayTitle: "A Peek Beyond the Point — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch03_APeekBeyondThePoint_QuestionPaper.md",
            solutionsMD: "Maths_Ch03_APeekBeyondThePoint_Solutions.md",
            questionPaperHTML: "Maths_Ch03_APeekBeyondThePoint.html",
            questionPaperPDF: "Maths_Ch03_APeekBeyondThePoint.pdf",
            solvedGuideHTML: "Maths_Ch03_APeekBeyondThePoint_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_ch04",
            subjectId: "maths_class7",
            subjectName: "Mathematics",
            chapterNumber: 4,
            chapterTitle: "Expressions Using Letter-Numbers",
            displayTitle: "Expressions Using Letter-Numbers — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch04_ExpressionsUsingLetterNumbers_QuestionPaper.md",
            solutionsMD: "Maths_Ch04_ExpressionsUsingLetterNumbers_Solutions.md",
            questionPaperHTML: "Maths_Ch04_ExpressionsUsingLetterNumbers.html",
            questionPaperPDF: "Maths_Ch04_ExpressionsUsingLetterNumbers.pdf",
            solvedGuideHTML: "Maths_Ch04_ExpressionsUsingLetterNumbers_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_ch05",
            subjectId: "maths_class7",
            subjectName: "Mathematics",
            chapterNumber: 5,
            chapterTitle: "Parallel and Intersecting Lines",
            displayTitle: "Parallel and Intersecting Lines — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch05_ParallelAndIntersectingLines_QuestionPaper.md",
            solutionsMD: "Maths_Ch05_ParallelAndIntersectingLines_Solutions.md",
            questionPaperHTML: "Maths_Ch05_ParallelAndIntersectingLines.html",
            questionPaperPDF: "Maths_Ch05_ParallelAndIntersectingLines.pdf",
            solvedGuideHTML: "Maths_Ch05_ParallelAndIntersectingLines_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_ch06",
            subjectId: "maths_class7",
            subjectName: "Mathematics",
            chapterNumber: 6,
            chapterTitle: "Number Play",
            displayTitle: "Number Play — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch06_NumberPlay_QuestionPaper.md",
            solutionsMD: "Maths_Ch06_NumberPlay_Solutions.md",
            questionPaperHTML: "Maths_Ch06_NumberPlay.html",
            questionPaperPDF: "Maths_Ch06_NumberPlay.pdf",
            solvedGuideHTML: "Maths_Ch06_NumberPlay_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_ch07",
            subjectId: "maths_class7",
            subjectName: "Mathematics",
            chapterNumber: 7,
            chapterTitle: "A Tale of Three Intersecting Lines",
            displayTitle: "A Tale of Three Intersecting Lines — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch07_ATaleOfThreeIntersectingLines_QuestionPaper.md",
            solutionsMD: "Maths_Ch07_ATaleOfThreeIntersectingLines_Solutions.md",
            questionPaperHTML: "Maths_Ch07_ATaleOfThreeIntersectingLines.html",
            questionPaperPDF: "Maths_Ch07_ATaleOfThreeIntersectingLines.pdf",
            solvedGuideHTML: "Maths_Ch07_ATaleOfThreeIntersectingLines_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_ch08",
            subjectId: "maths_class7",
            subjectName: "Mathematics",
            chapterNumber: 8,
            chapterTitle: "Working with Fractions",
            displayTitle: "Working with Fractions — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch08_WorkingWithFractions_QuestionPaper.md",
            solutionsMD: "Maths_Ch08_WorkingWithFractions_Solutions.md",
            questionPaperHTML: "Maths_Ch08_WorkingWithFractions.html",
            questionPaperPDF: "Maths_Ch08_WorkingWithFractions.pdf",
            solvedGuideHTML: "Maths_Ch08_WorkingWithFractions_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_ch09",
            subjectId: "maths_class7",
            subjectName: "Mathematics",
            chapterNumber: 9,
            chapterTitle: "Geometric Twins",
            displayTitle: "Geometric Twins — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch09_GeometricTwins_QuestionPaper.md",
            solutionsMD: "Maths_Ch09_GeometricTwins_Solutions.md",
            questionPaperHTML: "Maths_Ch09_GeometricTwins.html",
            questionPaperPDF: "Maths_Ch09_GeometricTwins.pdf",
            solvedGuideHTML: "Maths_Ch09_GeometricTwins_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_ch10",
            subjectId: "maths_class7",
            subjectName: "Mathematics",
            chapterNumber: 10,
            chapterTitle: "Operations with Integers",
            displayTitle: "Operations with Integers — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch10_OperationsWithIntegers_QuestionPaper.md",
            solutionsMD: "Maths_Ch10_OperationsWithIntegers_Solutions.md",
            questionPaperHTML: "Maths_Ch10_OperationsWithIntegers.html",
            questionPaperPDF: "Maths_Ch10_OperationsWithIntegers.pdf",
            solvedGuideHTML: "Maths_Ch10_OperationsWithIntegers_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_ch11",
            subjectId: "maths_class7",
            subjectName: "Mathematics",
            chapterNumber: 11,
            chapterTitle: "Finding Common Ground",
            displayTitle: "Finding Common Ground — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch11_FindingCommonGround_QuestionPaper.md",
            solutionsMD: "Maths_Ch11_FindingCommonGround_Solutions.md",
            questionPaperHTML: "Maths_Ch11_FindingCommonGround.html",
            questionPaperPDF: "Maths_Ch11_FindingCommonGround.pdf",
            solvedGuideHTML: "Maths_Ch11_FindingCommonGround_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_ch12",
            subjectId: "maths_class7",
            subjectName: "Mathematics",
            chapterNumber: 12,
            chapterTitle: "Another Peek Beyond the Point",
            displayTitle: "Another Peek Beyond the Point — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch12_AnotherPeekBeyondThePoint_QuestionPaper.md",
            solutionsMD: "Maths_Ch12_AnotherPeekBeyondThePoint_Solutions.md",
            questionPaperHTML: "Maths_Ch12_AnotherPeekBeyondThePoint.html",
            questionPaperPDF: "Maths_Ch12_AnotherPeekBeyondThePoint.pdf",
            solvedGuideHTML: "Maths_Ch12_AnotherPeekBeyondThePoint_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_ch13",
            subjectId: "maths_class7",
            subjectName: "Mathematics",
            chapterNumber: 13,
            chapterTitle: "Connecting the Dots",
            displayTitle: "Connecting the Dots — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch13_ConnectingTheDots_QuestionPaper.md",
            solutionsMD: "Maths_Ch13_ConnectingTheDots_Solutions.md",
            questionPaperHTML: "Maths_Ch13_ConnectingTheDots.html",
            questionPaperPDF: "Maths_Ch13_ConnectingTheDots.pdf",
            solvedGuideHTML: "Maths_Ch13_ConnectingTheDots_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_ch14",
            subjectId: "maths_class7",
            subjectName: "Mathematics",
            chapterNumber: 14,
            chapterTitle: "Constructions and Tilings",
            displayTitle: "Constructions and Tilings — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch14_ConstructionsAndTilings_QuestionPaper.md",
            solutionsMD: "Maths_Ch14_ConstructionsAndTilings_Solutions.md",
            questionPaperHTML: "Maths_Ch14_ConstructionsAndTilings.html",
            questionPaperPDF: "Maths_Ch14_ConstructionsAndTilings.pdf",
            solvedGuideHTML: "Maths_Ch14_ConstructionsAndTilings_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```
