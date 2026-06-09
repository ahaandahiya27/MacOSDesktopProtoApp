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

## Registry entries — Social Science (socialscience_class7)

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch01",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 1,
            chapterTitle: "Geographical Diversity of India",
            displayTitle: "Geographical Diversity of India — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch01_GeographicalDiversityOfIndia_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch01_GeographicalDiversityOfIndia_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch01_GeographicalDiversityOfIndia.html",
            questionPaperPDF: "SocialScience_Ssch01_GeographicalDiversityOfIndia.pdf",
            solvedGuideHTML: "SocialScience_Ssch01_GeographicalDiversityOfIndia_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_socialscience_ssch02",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 2,
            chapterTitle: "Understanding the Weather",
            displayTitle: "Understanding the Weather — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch02_UnderstandingTheWeather_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch02_UnderstandingTheWeather_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch02_UnderstandingTheWeather.html",
            questionPaperPDF: "SocialScience_Ssch02_UnderstandingTheWeather.pdf",
            solvedGuideHTML: "SocialScience_Ssch02_UnderstandingTheWeather_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_socialscience_ssch03",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 3,
            chapterTitle: "Climates of India",
            displayTitle: "Climates of India — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch03_ClimatesOfIndia_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch03_ClimatesOfIndia_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch03_ClimatesOfIndia.html",
            questionPaperPDF: "SocialScience_Ssch03_ClimatesOfIndia.pdf",
            solvedGuideHTML: "SocialScience_Ssch03_ClimatesOfIndia_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_socialscience_ssch04",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 4,
            chapterTitle: "New Beginnings: Cities and States",
            displayTitle: "New Beginnings: Cities and States — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch04_NewBeginningsCitiesAndStates_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch04_NewBeginningsCitiesAndStates_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch04_NewBeginningsCitiesAndStates.html",
            questionPaperPDF: "SocialScience_Ssch04_NewBeginningsCitiesAndStates.pdf",
            solvedGuideHTML: "SocialScience_Ssch04_NewBeginningsCitiesAndStates_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_socialscience_ssch05",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 5,
            chapterTitle: "The Rise of Empires",
            displayTitle: "The Rise of Empires — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch05_TheRiseOfEmpires_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch05_TheRiseOfEmpires_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch05_TheRiseOfEmpires.html",
            questionPaperPDF: "SocialScience_Ssch05_TheRiseOfEmpires.pdf",
            solvedGuideHTML: "SocialScience_Ssch05_TheRiseOfEmpires_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch06",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 6,
            chapterTitle: "The Age of Reorganisation",
            displayTitle: "The Age of Reorganisation — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch06_TheAgeOfReorganisation_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch06_TheAgeOfReorganisation_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch06_TheAgeOfReorganisation.html",
            questionPaperPDF: "SocialScience_Ssch06_TheAgeOfReorganisation.pdf",
            solvedGuideHTML: "SocialScience_Ssch06_TheAgeOfReorganisation_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch07",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 7,
            chapterTitle: "The Gupta Era: An Age of Tireless Creativity",
            displayTitle: "The Gupta Era: An Age of Tireless Creativity — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch07_TheGuptaEra_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch07_TheGuptaEra_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch07_TheGuptaEra.html",
            questionPaperPDF: "SocialScience_Ssch07_TheGuptaEra.pdf",
            solvedGuideHTML: "SocialScience_Ssch07_TheGuptaEra_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch08",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 8,
            chapterTitle: "How the Land Becomes Sacred",
            displayTitle: "How the Land Becomes Sacred — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch08_HowTheLandBecomesSacred_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch08_HowTheLandBecomesSacred_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch08_HowTheLandBecomesSacred.html",
            questionPaperPDF: "SocialScience_Ssch08_HowTheLandBecomesSacred.pdf",
            solvedGuideHTML: "SocialScience_Ssch08_HowTheLandBecomesSacred_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch09",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 9,
            chapterTitle: "From the Rulers to the Ruled: Types of Governments",
            displayTitle: "From the Rulers to the Ruled: Types of Governments — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch09_TypesOfGovernments_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch09_TypesOfGovernments_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch09_TypesOfGovernments.html",
            questionPaperPDF: "SocialScience_Ssch09_TypesOfGovernments.pdf",
            solvedGuideHTML: "SocialScience_Ssch09_TypesOfGovernments_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch10",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 10,
            chapterTitle: "The Constitution of India — An Introduction",
            displayTitle: "The Constitution of India — An Introduction — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch10_TheConstitutionOfIndia_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch10_TheConstitutionOfIndia_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch10_TheConstitutionOfIndia.html",
            questionPaperPDF: "SocialScience_Ssch10_TheConstitutionOfIndia.pdf",
            solvedGuideHTML: "SocialScience_Ssch10_TheConstitutionOfIndia_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch11",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 11,
            chapterTitle: "From Barter to Money",
            displayTitle: "From Barter to Money — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch11_FromBarterToMoney_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch11_FromBarterToMoney_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch11_FromBarterToMoney.html",
            questionPaperPDF: "SocialScience_Ssch11_FromBarterToMoney.pdf",
            solvedGuideHTML: "SocialScience_Ssch11_FromBarterToMoney_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch12",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 12,
            chapterTitle: "Understanding Markets",
            displayTitle: "Understanding Markets — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch12_UnderstandingMarkets_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch12_UnderstandingMarkets_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch12_UnderstandingMarkets.html",
            questionPaperPDF: "SocialScience_Ssch12_UnderstandingMarkets.pdf",
            solvedGuideHTML: "SocialScience_Ssch12_UnderstandingMarkets_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch13",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 13,
            chapterTitle: "The Story of Indian Farming",
            displayTitle: "The Story of Indian Farming — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch13_TheStoryOfIndianFarming_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch13_TheStoryOfIndianFarming_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch13_TheStoryOfIndianFarming.html",
            questionPaperPDF: "SocialScience_Ssch13_TheStoryOfIndianFarming.pdf",
            solvedGuideHTML: "SocialScience_Ssch13_TheStoryOfIndianFarming_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch14",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 14,
            chapterTitle: "India and Her Neighbours",
            displayTitle: "India and Her Neighbours — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch14_IndiaAndHerNeighbours_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch14_IndiaAndHerNeighbours_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch14_IndiaAndHerNeighbours.html",
            questionPaperPDF: "SocialScience_Ssch14_IndiaAndHerNeighbours.pdf",
            solvedGuideHTML: "SocialScience_Ssch14_IndiaAndHerNeighbours_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch15",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 15,
            chapterTitle: "Empires and Kingdoms: 6th to 10th Centuries",
            displayTitle: "Empires and Kingdoms: 6th to 10th Centuries — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch15_EmpiresAndKingdoms6thTo10thCenturies_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch15_EmpiresAndKingdoms6thTo10thCenturies_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch15_EmpiresAndKingdoms6thTo10thCenturies.html",
            questionPaperPDF: "SocialScience_Ssch15_EmpiresAndKingdoms6thTo10thCenturies.pdf",
            solvedGuideHTML: "SocialScience_Ssch15_EmpiresAndKingdoms6thTo10thCenturies_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch16",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 16,
            chapterTitle: "Turning Tides: 11th and 12th Centuries",
            displayTitle: "Turning Tides: 11th and 12th Centuries — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch16_TurningTides11thAnd12thCenturies_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch16_TurningTides11thAnd12thCenturies_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch16_TurningTides11thAnd12thCenturies.html",
            questionPaperPDF: "SocialScience_Ssch16_TurningTides11thAnd12thCenturies.pdf",
            solvedGuideHTML: "SocialScience_Ssch16_TurningTides11thAnd12thCenturies_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch17",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 17,
            chapterTitle: "India, a Home to Many",
            displayTitle: "India, a Home to Many — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch17_IndiaAHomeToMany_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch17_IndiaAHomeToMany_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch17_IndiaAHomeToMany.html",
            questionPaperPDF: "SocialScience_Ssch17_IndiaAHomeToMany.pdf",
            solvedGuideHTML: "SocialScience_Ssch17_IndiaAHomeToMany_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch18",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 18,
            chapterTitle: "The State, the Government, and You",
            displayTitle: "The State, the Government, and You — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch18_TheStateTheGovernmentAndYou_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch18_TheStateTheGovernmentAndYou_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch18_TheStateTheGovernmentAndYou.html",
            questionPaperPDF: "SocialScience_Ssch18_TheStateTheGovernmentAndYou.pdf",
            solvedGuideHTML: "SocialScience_Ssch18_TheStateTheGovernmentAndYou_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch19",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 19,
            chapterTitle: "Infrastructure: Engine of India's Development",
            displayTitle: "Infrastructure: Engine of India's Development — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch19_Infrastructure_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch19_Infrastructure_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch19_Infrastructure.html",
            questionPaperPDF: "SocialScience_Ssch19_Infrastructure.pdf",
            solvedGuideHTML: "SocialScience_Ssch19_Infrastructure_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch20",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 20,
            chapterTitle: "Banks and the Magic of Finance",
            displayTitle: "Banks and the Magic of Finance — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch20_BanksAndTheMagicOfFinance_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch20_BanksAndTheMagicOfFinance_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch20_BanksAndTheMagicOfFinance.html",
            questionPaperPDF: "SocialScience_Ssch20_BanksAndTheMagicOfFinance.pdf",
            solvedGuideHTML: "SocialScience_Ssch20_BanksAndTheMagicOfFinance_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch01",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 1,
            chapterTitle: "वन्दे भारतमातरम् (Vande Bharatamataram)",
            displayTitle: "वन्दे भारतमातरम् (Vande Bharatamataram) — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch01_VandeBharatamataram_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch01_VandeBharatamataram_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch01_VandeBharatamataram.html",
            questionPaperPDF: "Sanskrit_Sch01_VandeBharatamataram.pdf",
            solvedGuideHTML: "Sanskrit_Sch01_VandeBharatamataram_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch02",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 2,
            chapterTitle: "नित्यं पिबामः सुभाषितरसम् (Nityam Pibamah Subhashitarasam)",
            displayTitle: "नित्यं पिबामः सुभाषितरसम् (Nityam Pibamah Subhashitarasam) — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch02_NityamPibamahSubhashitarasam_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch02_NityamPibamahSubhashitarasam_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch02_NityamPibamahSubhashitarasam.html",
            questionPaperPDF: "Sanskrit_Sch02_NityamPibamahSubhashitarasam.pdf",
            solvedGuideHTML: "Sanskrit_Sch02_NityamPibamahSubhashitarasam_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch03",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 3,
            chapterTitle: "मित्राय नमः (Mitraya Namah)",
            displayTitle: "मित्राय नमः (Mitraya Namah) — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch03_MitrayaNamah_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch03_MitrayaNamah_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch03_MitrayaNamah.html",
            questionPaperPDF: "Sanskrit_Sch03_MitrayaNamah.pdf",
            solvedGuideHTML: "Sanskrit_Sch03_MitrayaNamah_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch04",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 4,
            chapterTitle: "न लभ्यते चेत् आम्लं द्राक्षाफलम् (The Fox and the Grapes)",
            displayTitle: "न लभ्यते चेत् आम्लं द्राक्षाफलम् (The Fox and the Grapes) — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch04_TheFoxAndTheGrapes_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch04_TheFoxAndTheGrapes_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch04_TheFoxAndTheGrapes.html",
            questionPaperPDF: "Sanskrit_Sch04_TheFoxAndTheGrapes.pdf",
            solvedGuideHTML: "Sanskrit_Sch04_TheFoxAndTheGrapes_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch05",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 5,
            chapterTitle: "सेवा हि परमो धर्मः (Seva Hi Paramo Dharmah)",
            displayTitle: "सेवा हि परमो धर्मः (Seva Hi Paramo Dharmah) — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch05_SevaHiParamoDharmah_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch05_SevaHiParamoDharmah_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch05_SevaHiParamoDharmah.html",
            questionPaperPDF: "Sanskrit_Sch05_SevaHiParamoDharmah.pdf",
            solvedGuideHTML: "Sanskrit_Sch05_SevaHiParamoDharmah_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch06",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 6,
            chapterTitle: "क्रीडाम वयं श्लोकान्त्याक्षरीम् (Shloka-Antyakshari)",
            displayTitle: "क्रीडाम वयं श्लोकान्त्याक्षरीम् (Shloka-Antyakshari) — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch06_KridamaVayamShlokantyaksharim_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch06_KridamaVayamShlokantyaksharim_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch06_KridamaVayamShlokantyaksharim.html",
            questionPaperPDF: "Sanskrit_Sch06_KridamaVayamShlokantyaksharim.pdf",
            solvedGuideHTML: "Sanskrit_Sch06_KridamaVayamShlokantyaksharim_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch07",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 7,
            chapterTitle: "ईशावास्यम् इदं सर्वम् (Ishavasyam Idam Sarvam)",
            displayTitle: "ईशावास्यम् इदं सर्वम् (Ishavasyam Idam Sarvam) — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch07_IshavasyamIdamSarvam_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch07_IshavasyamIdamSarvam_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch07_IshavasyamIdamSarvam.html",
            questionPaperPDF: "Sanskrit_Sch07_IshavasyamIdamSarvam.pdf",
            solvedGuideHTML: "Sanskrit_Sch07_IshavasyamIdamSarvam_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch08",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 8,
            chapterTitle: "हितं मनोहारि च दुर्लभं वचः (Hitam Manohari cha Durlabham Vachah)",
            displayTitle: "हितं मनोहारि च दुर्लभं वचः (Hitam Manohari cha Durlabham Vachah) — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch08_HitamManohariChaDurlabhamVachah_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch08_HitamManohariChaDurlabhamVachah_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch08_HitamManohariChaDurlabhamVachah.html",
            questionPaperPDF: "Sanskrit_Sch08_HitamManohariChaDurlabhamVachah.pdf",
            solvedGuideHTML: "Sanskrit_Sch08_HitamManohariChaDurlabhamVachah_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch09",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 9,
            chapterTitle: "अन्नाद् भवन्ति भूतानि (Annad Bhavanti Bhutani)",
            displayTitle: "अन्नाद् भवन्ति भूतानि (Annad Bhavanti Bhutani) — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch09_AnnadBhavantiBhutani_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch09_AnnadBhavantiBhutani_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch09_AnnadBhavantiBhutani.html",
            questionPaperPDF: "Sanskrit_Sch09_AnnadBhavantiBhutani.pdf",
            solvedGuideHTML: "Sanskrit_Sch09_AnnadBhavantiBhutani_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch10",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 10,
            chapterTitle: "दशमः कः? (Dashamah Kah?)",
            displayTitle: "दशमः कः? (Dashamah Kah?) — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch10_DashamahKah_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch10_DashamahKah_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch10_DashamahKah.html",
            questionPaperPDF: "Sanskrit_Sch10_DashamahKah.pdf",
            solvedGuideHTML: "Sanskrit_Sch10_DashamahKah_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch11",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 11,
            chapterTitle: "द्वीपेषु रम्यः द्वीपोऽण्डमानः (The Andaman Islands)",
            displayTitle: "द्वीपेषु रम्यः द्वीपोऽण्डमानः (The Andaman Islands) — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch11_DvipeshuRamyahDvipoandamanah_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch11_DvipeshuRamyahDvipoandamanah_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch11_DvipeshuRamyahDvipoandamanah.html",
            questionPaperPDF: "Sanskrit_Sch11_DvipeshuRamyahDvipoandamanah.pdf",
            solvedGuideHTML: "Sanskrit_Sch11_DvipeshuRamyahDvipoandamanah_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch12",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 12,
            chapterTitle: "वीराङ्गना पन्नाधाया (Panna Dhai, the Brave)",
            displayTitle: "वीराङ्गना पन्नाधाया (Panna Dhai, the Brave) — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch12_ViranganaPannadhaya_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch12_ViranganaPannadhaya_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch12_ViranganaPannadhaya.html",
            questionPaperPDF: "Sanskrit_Sch12_ViranganaPannadhaya.pdf",
            solvedGuideHTML: "Sanskrit_Sch12_ViranganaPannadhaya_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch13",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 13,
            chapterTitle: "वर्णमात्रा-परिचयः (Varna-Matra)",
            displayTitle: "वर्णमात्रा-परिचयः (Varna-Matra) — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch13_VarnaMatraParichayah_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch13_VarnaMatraParichayah_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch13_VarnaMatraParichayah.html",
            questionPaperPDF: "Sanskrit_Sch13_VarnaMatraParichayah.pdf",
            solvedGuideHTML: "Sanskrit_Sch13_VarnaMatraParichayah_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch14",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 14,
            chapterTitle: "शब्दरूपाणि (Shabda-Rupani)",
            displayTitle: "शब्दरूपाणि (Shabda-Rupani) — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch14_ShabdaRupani_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch14_ShabdaRupani_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch14_ShabdaRupani.html",
            questionPaperPDF: "Sanskrit_Sch14_ShabdaRupani.pdf",
            solvedGuideHTML: "Sanskrit_Sch14_ShabdaRupani_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch15",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 15,
            chapterTitle: "धातुरूपाणि (Dhatu-Rupani)",
            displayTitle: "धातुरूपाणि (Dhatu-Rupani) — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch15_DhaturupaniVerbConjugations_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch15_DhaturupaniVerbConjugations_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch15_DhaturupaniVerbConjugations.html",
            questionPaperPDF: "Sanskrit_Sch15_DhaturupaniVerbConjugations.pdf",
            solvedGuideHTML: "Sanskrit_Sch15_DhaturupaniVerbConjugations_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch01_p3",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 1,
            chapterTitle: "Nutrition in Plants",
            displayTitle: "Nutrition in Plants — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch01_NutritionInPlants_P3_QuestionPaper.md",
            solutionsMD: "Science_Ch01_NutritionInPlants_P3_Solutions.md",
            questionPaperHTML: "Science_Ch01_NutritionInPlants_P3.html",
            questionPaperPDF: "Science_Ch01_NutritionInPlants_P3.pdf",
            solvedGuideHTML: "Science_Ch01_NutritionInPlants_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch01_p4",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 1,
            chapterTitle: "Nutrition in Plants",
            displayTitle: "Nutrition in Plants — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch01_NutritionInPlants_P4_QuestionPaper.md",
            solutionsMD: "Science_Ch01_NutritionInPlants_P4_Solutions.md",
            questionPaperHTML: "Science_Ch01_NutritionInPlants_P4.html",
            questionPaperPDF: "Science_Ch01_NutritionInPlants_P4.pdf",
            solvedGuideHTML: "Science_Ch01_NutritionInPlants_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch02_p3",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 2,
            chapterTitle: "Nutrition in Animals",
            displayTitle: "Nutrition in Animals — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch02_NutritionInAnimals_P3_QuestionPaper.md",
            solutionsMD: "Science_Ch02_NutritionInAnimals_P3_Solutions.md",
            questionPaperHTML: "Science_Ch02_NutritionInAnimals_P3.html",
            questionPaperPDF: "Science_Ch02_NutritionInAnimals_P3.pdf",
            solvedGuideHTML: "Science_Ch02_NutritionInAnimals_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch03_p3",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 3,
            chapterTitle: "Fibre to Fabric",
            displayTitle: "Fibre to Fabric — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch03_FibreToFabric_P3_QuestionPaper.md",
            solutionsMD: "Science_Ch03_FibreToFabric_P3_Solutions.md",
            questionPaperHTML: "Science_Ch03_FibreToFabric_P3.html",
            questionPaperPDF: "Science_Ch03_FibreToFabric_P3.pdf",
            solvedGuideHTML: "Science_Ch03_FibreToFabric_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch04_p3",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 4,
            chapterTitle: "Heat",
            displayTitle: "Heat — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch04_Heat_P3_QuestionPaper.md",
            solutionsMD: "Science_Ch04_Heat_P3_Solutions.md",
            questionPaperHTML: "Science_Ch04_Heat_P3.html",
            questionPaperPDF: "Science_Ch04_Heat_P3.pdf",
            solvedGuideHTML: "Science_Ch04_Heat_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch05_p3",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 5,
            chapterTitle: "Acids, Bases and Salts",
            displayTitle: "Acids, Bases and Salts — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch05_AcidsBasesAndSalts_P3_QuestionPaper.md",
            solutionsMD: "Science_Ch05_AcidsBasesAndSalts_P3_Solutions.md",
            questionPaperHTML: "Science_Ch05_AcidsBasesAndSalts_P3.html",
            questionPaperPDF: "Science_Ch05_AcidsBasesAndSalts_P3.pdf",
            solvedGuideHTML: "Science_Ch05_AcidsBasesAndSalts_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch06_p3",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 6,
            chapterTitle: "Physical and Chemical Changes",
            displayTitle: "Physical and Chemical Changes — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch06_PhysicalAndChemicalChanges_P3_QuestionPaper.md",
            solutionsMD: "Science_Ch06_PhysicalAndChemicalChanges_P3_Solutions.md",
            questionPaperHTML: "Science_Ch06_PhysicalAndChemicalChanges_P3.html",
            questionPaperPDF: "Science_Ch06_PhysicalAndChemicalChanges_P3.pdf",
            solvedGuideHTML: "Science_Ch06_PhysicalAndChemicalChanges_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch07_p3",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 7,
            chapterTitle: "Weather, Climate and Adaptations of Animals to Climate",
            displayTitle: "Weather, Climate and Adaptations of Animals to Climate — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch07_WeatherClimateAndAdaptationsOfAnimalsToClimate_P3_QuestionPaper.md",
            solutionsMD: "Science_Ch07_WeatherClimateAndAdaptationsOfAnimalsToClimate_P3_Solutions.md",
            questionPaperHTML: "Science_Ch07_WeatherClimateAndAdaptationsOfAnimalsToClimate_P3.html",
            questionPaperPDF: "Science_Ch07_WeatherClimateAndAdaptationsOfAnimalsToClimate_P3.pdf",
            solvedGuideHTML: "Science_Ch07_WeatherClimateAndAdaptationsOfAnimalsToClimate_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch08_p3",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 8,
            chapterTitle: "Winds, Storms and Cyclones",
            displayTitle: "Winds, Storms and Cyclones — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch08_WindsStormsAndCyclones_P3_QuestionPaper.md",
            solutionsMD: "Science_Ch08_WindsStormsAndCyclones_P3_Solutions.md",
            questionPaperHTML: "Science_Ch08_WindsStormsAndCyclones_P3.html",
            questionPaperPDF: "Science_Ch08_WindsStormsAndCyclones_P3.pdf",
            solvedGuideHTML: "Science_Ch08_WindsStormsAndCyclones_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch09_p3",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 9,
            chapterTitle: "Soil",
            displayTitle: "Soil — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch09_Soil_P3_QuestionPaper.md",
            solutionsMD: "Science_Ch09_Soil_P3_Solutions.md",
            questionPaperHTML: "Science_Ch09_Soil_P3.html",
            questionPaperPDF: "Science_Ch09_Soil_P3.pdf",
            solvedGuideHTML: "Science_Ch09_Soil_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch10_p3",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 10,
            chapterTitle: "Respiration in Organisms",
            displayTitle: "Respiration in Organisms — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch10_RespirationInOrganisms_P3_QuestionPaper.md",
            solutionsMD: "Science_Ch10_RespirationInOrganisms_P3_Solutions.md",
            questionPaperHTML: "Science_Ch10_RespirationInOrganisms_P3.html",
            questionPaperPDF: "Science_Ch10_RespirationInOrganisms_P3.pdf",
            solvedGuideHTML: "Science_Ch10_RespirationInOrganisms_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch11_p3",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 11,
            chapterTitle: "Transportation in Animals and Plants",
            displayTitle: "Transportation in Animals and Plants — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch11_TransportationInAnimalsAndPlants_P3_QuestionPaper.md",
            solutionsMD: "Science_Ch11_TransportationInAnimalsAndPlants_P3_Solutions.md",
            questionPaperHTML: "Science_Ch11_TransportationInAnimalsAndPlants_P3.html",
            questionPaperPDF: "Science_Ch11_TransportationInAnimalsAndPlants_P3.pdf",
            solvedGuideHTML: "Science_Ch11_TransportationInAnimalsAndPlants_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch12_p3",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 12,
            chapterTitle: "Reproduction in Plants",
            displayTitle: "Reproduction in Plants — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch12_ReproductionInPlants_P3_QuestionPaper.md",
            solutionsMD: "Science_Ch12_ReproductionInPlants_P3_Solutions.md",
            questionPaperHTML: "Science_Ch12_ReproductionInPlants_P3.html",
            questionPaperPDF: "Science_Ch12_ReproductionInPlants_P3.pdf",
            solvedGuideHTML: "Science_Ch12_ReproductionInPlants_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch13_p3",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 13,
            chapterTitle: "Motion and Time",
            displayTitle: "Motion and Time — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch13_MotionAndTime_P3_QuestionPaper.md",
            solutionsMD: "Science_Ch13_MotionAndTime_P3_Solutions.md",
            questionPaperHTML: "Science_Ch13_MotionAndTime_P3.html",
            questionPaperPDF: "Science_Ch13_MotionAndTime_P3.pdf",
            solvedGuideHTML: "Science_Ch13_MotionAndTime_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch14_p3",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 14,
            chapterTitle: "Electric Current and Its Effect",
            displayTitle: "Electric Current and Its Effect — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch14_ElectricCurrentAndItsEffect_P3_QuestionPaper.md",
            solutionsMD: "Science_Ch14_ElectricCurrentAndItsEffect_P3_Solutions.md",
            questionPaperHTML: "Science_Ch14_ElectricCurrentAndItsEffect_P3.html",
            questionPaperPDF: "Science_Ch14_ElectricCurrentAndItsEffect_P3.pdf",
            solvedGuideHTML: "Science_Ch14_ElectricCurrentAndItsEffect_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch15_p3",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 15,
            chapterTitle: "Light",
            displayTitle: "Light — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch15_Light_P3_QuestionPaper.md",
            solutionsMD: "Science_Ch15_Light_P3_Solutions.md",
            questionPaperHTML: "Science_Ch15_Light_P3.html",
            questionPaperPDF: "Science_Ch15_Light_P3.pdf",
            solvedGuideHTML: "Science_Ch15_Light_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch16_p3",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 16,
            chapterTitle: "Water: A Precious Resource",
            displayTitle: "Water: A Precious Resource — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch16_WaterAPreciousResource_P3_QuestionPaper.md",
            solutionsMD: "Science_Ch16_WaterAPreciousResource_P3_Solutions.md",
            questionPaperHTML: "Science_Ch16_WaterAPreciousResource_P3.html",
            questionPaperPDF: "Science_Ch16_WaterAPreciousResource_P3.pdf",
            solvedGuideHTML: "Science_Ch16_WaterAPreciousResource_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch17_p3",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 17,
            chapterTitle: "Forest: Our Lifeline",
            displayTitle: "Forest: Our Lifeline — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch17_ForestOurLifeline_P3_QuestionPaper.md",
            solutionsMD: "Science_Ch17_ForestOurLifeline_P3_Solutions.md",
            questionPaperHTML: "Science_Ch17_ForestOurLifeline_P3.html",
            questionPaperPDF: "Science_Ch17_ForestOurLifeline_P3.pdf",
            solvedGuideHTML: "Science_Ch17_ForestOurLifeline_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch18_p3",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 18,
            chapterTitle: "Wastewater Story",
            displayTitle: "Wastewater Story — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch18_WastewaterStory_P3_QuestionPaper.md",
            solutionsMD: "Science_Ch18_WastewaterStory_P3_Solutions.md",
            questionPaperHTML: "Science_Ch18_WastewaterStory_P3.html",
            questionPaperPDF: "Science_Ch18_WastewaterStory_P3.pdf",
            solvedGuideHTML: "Science_Ch18_WastewaterStory_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch19_p3",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 19,
            chapterTitle: "Earth, Moon and the Sun",
            displayTitle: "Earth, Moon and the Sun — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch19_EarthMoonAndTheSun_P3_QuestionPaper.md",
            solutionsMD: "Science_Ch19_EarthMoonAndTheSun_P3_Solutions.md",
            questionPaperHTML: "Science_Ch19_EarthMoonAndTheSun_P3.html",
            questionPaperPDF: "Science_Ch19_EarthMoonAndTheSun_P3.pdf",
            solvedGuideHTML: "Science_Ch19_EarthMoonAndTheSun_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch01_p3",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 1,
            chapterTitle: "Large Numbers Around Us",
            displayTitle: "Large Numbers Around Us — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch01_LargeNumbersAroundUs_P3_QuestionPaper.md",
            solutionsMD: "Maths_Ch01_LargeNumbersAroundUs_P3_Solutions.md",
            questionPaperHTML: "Maths_Ch01_LargeNumbersAroundUs_P3.html",
            questionPaperPDF: "Maths_Ch01_LargeNumbersAroundUs_P3.pdf",
            solvedGuideHTML: "Maths_Ch01_LargeNumbersAroundUs_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch02_p3",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 2,
            chapterTitle: "Arithmetic Expressions",
            displayTitle: "Arithmetic Expressions — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch02_ArithmeticExpressions_P3_QuestionPaper.md",
            solutionsMD: "Maths_Ch02_ArithmeticExpressions_P3_Solutions.md",
            questionPaperHTML: "Maths_Ch02_ArithmeticExpressions_P3.html",
            questionPaperPDF: "Maths_Ch02_ArithmeticExpressions_P3.pdf",
            solvedGuideHTML: "Maths_Ch02_ArithmeticExpressions_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch03_p3",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 3,
            chapterTitle: "A Peek Beyond the Point",
            displayTitle: "A Peek Beyond the Point — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch03_APeekBeyondThePoint_P3_QuestionPaper.md",
            solutionsMD: "Maths_Ch03_APeekBeyondThePoint_P3_Solutions.md",
            questionPaperHTML: "Maths_Ch03_APeekBeyondThePoint_P3.html",
            questionPaperPDF: "Maths_Ch03_APeekBeyondThePoint_P3.pdf",
            solvedGuideHTML: "Maths_Ch03_APeekBeyondThePoint_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch04_p3",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 4,
            chapterTitle: "Expressions Using Letter-Numbers",
            displayTitle: "Expressions Using Letter-Numbers — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch04_ExpressionsUsingLetterNumbers_P3_QuestionPaper.md",
            solutionsMD: "Maths_Ch04_ExpressionsUsingLetterNumbers_P3_Solutions.md",
            questionPaperHTML: "Maths_Ch04_ExpressionsUsingLetterNumbers_P3.html",
            questionPaperPDF: "Maths_Ch04_ExpressionsUsingLetterNumbers_P3.pdf",
            solvedGuideHTML: "Maths_Ch04_ExpressionsUsingLetterNumbers_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch05_p3",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 5,
            chapterTitle: "Parallel and Intersecting Lines",
            displayTitle: "Parallel and Intersecting Lines — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch05_ParallelAndIntersectingLines_P3_QuestionPaper.md",
            solutionsMD: "Maths_Ch05_ParallelAndIntersectingLines_P3_Solutions.md",
            questionPaperHTML: "Maths_Ch05_ParallelAndIntersectingLines_P3.html",
            questionPaperPDF: "Maths_Ch05_ParallelAndIntersectingLines_P3.pdf",
            solvedGuideHTML: "Maths_Ch05_ParallelAndIntersectingLines_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch06_p3",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 6,
            chapterTitle: "Number Play",
            displayTitle: "Number Play — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch06_NumberPlay_P3_QuestionPaper.md",
            solutionsMD: "Maths_Ch06_NumberPlay_P3_Solutions.md",
            questionPaperHTML: "Maths_Ch06_NumberPlay_P3.html",
            questionPaperPDF: "Maths_Ch06_NumberPlay_P3.pdf",
            solvedGuideHTML: "Maths_Ch06_NumberPlay_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch07_p3",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 7,
            chapterTitle: "A Tale of Three Intersecting Lines",
            displayTitle: "A Tale of Three Intersecting Lines — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch07_ATaleOfThreeIntersectingLines_P3_QuestionPaper.md",
            solutionsMD: "Maths_Ch07_ATaleOfThreeIntersectingLines_P3_Solutions.md",
            questionPaperHTML: "Maths_Ch07_ATaleOfThreeIntersectingLines_P3.html",
            questionPaperPDF: "Maths_Ch07_ATaleOfThreeIntersectingLines_P3.pdf",
            solvedGuideHTML: "Maths_Ch07_ATaleOfThreeIntersectingLines_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch08_p3",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 8,
            chapterTitle: "Working with Fractions",
            displayTitle: "Working with Fractions — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch08_WorkingWithFractions_P3_QuestionPaper.md",
            solutionsMD: "Maths_Ch08_WorkingWithFractions_P3_Solutions.md",
            questionPaperHTML: "Maths_Ch08_WorkingWithFractions_P3.html",
            questionPaperPDF: "Maths_Ch08_WorkingWithFractions_P3.pdf",
            solvedGuideHTML: "Maths_Ch08_WorkingWithFractions_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch09_p3",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 9,
            chapterTitle: "Geometric Twins",
            displayTitle: "Geometric Twins — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch09_GeometricTwins_P3_QuestionPaper.md",
            solutionsMD: "Maths_Ch09_GeometricTwins_P3_Solutions.md",
            questionPaperHTML: "Maths_Ch09_GeometricTwins_P3.html",
            questionPaperPDF: "Maths_Ch09_GeometricTwins_P3.pdf",
            solvedGuideHTML: "Maths_Ch09_GeometricTwins_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch10_p3",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 10,
            chapterTitle: "Operations with Integers",
            displayTitle: "Operations with Integers — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch10_OperationsWithIntegers_P3_QuestionPaper.md",
            solutionsMD: "Maths_Ch10_OperationsWithIntegers_P3_Solutions.md",
            questionPaperHTML: "Maths_Ch10_OperationsWithIntegers_P3.html",
            questionPaperPDF: "Maths_Ch10_OperationsWithIntegers_P3.pdf",
            solvedGuideHTML: "Maths_Ch10_OperationsWithIntegers_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch11_p3",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 11,
            chapterTitle: "Finding Common Ground",
            displayTitle: "Finding Common Ground — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch11_FindingCommonGround_P3_QuestionPaper.md",
            solutionsMD: "Maths_Ch11_FindingCommonGround_P3_Solutions.md",
            questionPaperHTML: "Maths_Ch11_FindingCommonGround_P3.html",
            questionPaperPDF: "Maths_Ch11_FindingCommonGround_P3.pdf",
            solvedGuideHTML: "Maths_Ch11_FindingCommonGround_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch12_p3",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 12,
            chapterTitle: "Another Peek Beyond the Point",
            displayTitle: "Another Peek Beyond the Point — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch12_AnotherPeekBeyondThePoint_P3_QuestionPaper.md",
            solutionsMD: "Maths_Ch12_AnotherPeekBeyondThePoint_P3_Solutions.md",
            questionPaperHTML: "Maths_Ch12_AnotherPeekBeyondThePoint_P3.html",
            questionPaperPDF: "Maths_Ch12_AnotherPeekBeyondThePoint_P3.pdf",
            solvedGuideHTML: "Maths_Ch12_AnotherPeekBeyondThePoint_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch13_p3",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 13,
            chapterTitle: "Connecting the Dots",
            displayTitle: "Connecting the Dots — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch13_ConnectingTheDots_P3_QuestionPaper.md",
            solutionsMD: "Maths_Ch13_ConnectingTheDots_P3_Solutions.md",
            questionPaperHTML: "Maths_Ch13_ConnectingTheDots_P3.html",
            questionPaperPDF: "Maths_Ch13_ConnectingTheDots_P3.pdf",
            solvedGuideHTML: "Maths_Ch13_ConnectingTheDots_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch14_p3",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 14,
            chapterTitle: "Constructions and Tilings",
            displayTitle: "Constructions and Tilings — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch14_ConstructionsAndTilings_P3_QuestionPaper.md",
            solutionsMD: "Maths_Ch14_ConstructionsAndTilings_P3_Solutions.md",
            questionPaperHTML: "Maths_Ch14_ConstructionsAndTilings_P3.html",
            questionPaperPDF: "Maths_Ch14_ConstructionsAndTilings_P3.pdf",
            solvedGuideHTML: "Maths_Ch14_ConstructionsAndTilings_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch15_p3",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 15,
            chapterTitle: "Finding the Unknown",
            displayTitle: "Finding the Unknown — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch15_FindingTheUnknown_P3_QuestionPaper.md",
            solutionsMD: "Maths_Ch15_FindingTheUnknown_P3_Solutions.md",
            questionPaperHTML: "Maths_Ch15_FindingTheUnknown_P3.html",
            questionPaperPDF: "Maths_Ch15_FindingTheUnknown_P3.pdf",
            solvedGuideHTML: "Maths_Ch15_FindingTheUnknown_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch01_p3",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 1,
            chapterTitle: "Geographical Diversity of India",
            displayTitle: "Geographical Diversity of India — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch01_GeographicalDiversityOfIndia_P3_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch01_GeographicalDiversityOfIndia_P3_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch01_GeographicalDiversityOfIndia_P3.html",
            questionPaperPDF: "SocialScience_Ssch01_GeographicalDiversityOfIndia_P3.pdf",
            solvedGuideHTML: "SocialScience_Ssch01_GeographicalDiversityOfIndia_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch02_p3",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 2,
            chapterTitle: "Understanding the Weather",
            displayTitle: "Understanding the Weather — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch02_UnderstandingTheWeather_P3_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch02_UnderstandingTheWeather_P3_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch02_UnderstandingTheWeather_P3.html",
            questionPaperPDF: "SocialScience_Ssch02_UnderstandingTheWeather_P3.pdf",
            solvedGuideHTML: "SocialScience_Ssch02_UnderstandingTheWeather_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch03_p3",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 3,
            chapterTitle: "Climates of India",
            displayTitle: "Climates of India — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch03_ClimatesOfIndia_P3_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch03_ClimatesOfIndia_P3_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch03_ClimatesOfIndia_P3.html",
            questionPaperPDF: "SocialScience_Ssch03_ClimatesOfIndia_P3.pdf",
            solvedGuideHTML: "SocialScience_Ssch03_ClimatesOfIndia_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch04_p3",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 4,
            chapterTitle: "New Beginnings: Cities and States",
            displayTitle: "New Beginnings: Cities and States — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch04_NewBeginningsCitiesAndStates_P3_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch04_NewBeginningsCitiesAndStates_P3_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch04_NewBeginningsCitiesAndStates_P3.html",
            questionPaperPDF: "SocialScience_Ssch04_NewBeginningsCitiesAndStates_P3.pdf",
            solvedGuideHTML: "SocialScience_Ssch04_NewBeginningsCitiesAndStates_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch05_p3",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 5,
            chapterTitle: "The Rise of Empires",
            displayTitle: "The Rise of Empires — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch05_TheRiseOfEmpires_P3_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch05_TheRiseOfEmpires_P3_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch05_TheRiseOfEmpires_P3.html",
            questionPaperPDF: "SocialScience_Ssch05_TheRiseOfEmpires_P3.pdf",
            solvedGuideHTML: "SocialScience_Ssch05_TheRiseOfEmpires_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch06_p3",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 6,
            chapterTitle: "The Age of Reorganisation",
            displayTitle: "The Age of Reorganisation — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch06_TheAgeOfReorganisation_P3_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch06_TheAgeOfReorganisation_P3_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch06_TheAgeOfReorganisation_P3.html",
            questionPaperPDF: "SocialScience_Ssch06_TheAgeOfReorganisation_P3.pdf",
            solvedGuideHTML: "SocialScience_Ssch06_TheAgeOfReorganisation_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch07_p3",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 7,
            chapterTitle: "The Gupta Era",
            displayTitle: "The Gupta Era — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch07_TheGuptaEra_P3_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch07_TheGuptaEra_P3_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch07_TheGuptaEra_P3.html",
            questionPaperPDF: "SocialScience_Ssch07_TheGuptaEra_P3.pdf",
            solvedGuideHTML: "SocialScience_Ssch07_TheGuptaEra_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch08_p3",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 8,
            chapterTitle: "How the Land Becomes Sacred",
            displayTitle: "How the Land Becomes Sacred — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch08_HowTheLandBecomesSacred_P3_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch08_HowTheLandBecomesSacred_P3_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch08_HowTheLandBecomesSacred_P3.html",
            questionPaperPDF: "SocialScience_Ssch08_HowTheLandBecomesSacred_P3.pdf",
            solvedGuideHTML: "SocialScience_Ssch08_HowTheLandBecomesSacred_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch09_p3",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 9,
            chapterTitle: "Types of Governments",
            displayTitle: "Types of Governments — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch09_TypesOfGovernments_P3_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch09_TypesOfGovernments_P3_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch09_TypesOfGovernments_P3.html",
            questionPaperPDF: "SocialScience_Ssch09_TypesOfGovernments_P3.pdf",
            solvedGuideHTML: "SocialScience_Ssch09_TypesOfGovernments_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch10_p3",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 10,
            chapterTitle: "The Constitution of India",
            displayTitle: "The Constitution of India — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch10_TheConstitutionOfIndia_P3_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch10_TheConstitutionOfIndia_P3_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch10_TheConstitutionOfIndia_P3.html",
            questionPaperPDF: "SocialScience_Ssch10_TheConstitutionOfIndia_P3.pdf",
            solvedGuideHTML: "SocialScience_Ssch10_TheConstitutionOfIndia_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch11_p3",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 11,
            chapterTitle: "From Barter to Money",
            displayTitle: "From Barter to Money — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch11_FromBarterToMoney_P3_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch11_FromBarterToMoney_P3_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch11_FromBarterToMoney_P3.html",
            questionPaperPDF: "SocialScience_Ssch11_FromBarterToMoney_P3.pdf",
            solvedGuideHTML: "SocialScience_Ssch11_FromBarterToMoney_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch12_p3",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 12,
            chapterTitle: "Understanding Markets",
            displayTitle: "Understanding Markets — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch12_UnderstandingMarkets_P3_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch12_UnderstandingMarkets_P3_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch12_UnderstandingMarkets_P3.html",
            questionPaperPDF: "SocialScience_Ssch12_UnderstandingMarkets_P3.pdf",
            solvedGuideHTML: "SocialScience_Ssch12_UnderstandingMarkets_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch13_p3",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 13,
            chapterTitle: "The Story of Indian Farming",
            displayTitle: "The Story of Indian Farming — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch13_TheStoryOfIndianFarming_P3_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch13_TheStoryOfIndianFarming_P3_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch13_TheStoryOfIndianFarming_P3.html",
            questionPaperPDF: "SocialScience_Ssch13_TheStoryOfIndianFarming_P3.pdf",
            solvedGuideHTML: "SocialScience_Ssch13_TheStoryOfIndianFarming_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch14_p3",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 14,
            chapterTitle: "India and Her Neighbours",
            displayTitle: "India and Her Neighbours — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch14_IndiaAndHerNeighbours_P3_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch14_IndiaAndHerNeighbours_P3_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch14_IndiaAndHerNeighbours_P3.html",
            questionPaperPDF: "SocialScience_Ssch14_IndiaAndHerNeighbours_P3.pdf",
            solvedGuideHTML: "SocialScience_Ssch14_IndiaAndHerNeighbours_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch15_p3",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 15,
            chapterTitle: "Empires and Kingdoms (6th to 10th Centuries)",
            displayTitle: "Empires and Kingdoms (6th to 10th Centuries) — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch15_EmpiresAndKingdoms6thTo10thCenturies_P3_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch15_EmpiresAndKingdoms6thTo10thCenturies_P3_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch15_EmpiresAndKingdoms6thTo10thCenturies_P3.html",
            questionPaperPDF: "SocialScience_Ssch15_EmpiresAndKingdoms6thTo10thCenturies_P3.pdf",
            solvedGuideHTML: "SocialScience_Ssch15_EmpiresAndKingdoms6thTo10thCenturies_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch16_p3",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 16,
            chapterTitle: "Turning Tides: 11th and 12th Centuries",
            displayTitle: "Turning Tides: 11th and 12th Centuries — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch16_TurningTides11thAnd12thCenturies_P3_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch16_TurningTides11thAnd12thCenturies_P3_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch16_TurningTides11thAnd12thCenturies_P3.html",
            questionPaperPDF: "SocialScience_Ssch16_TurningTides11thAnd12thCenturies_P3.pdf",
            solvedGuideHTML: "SocialScience_Ssch16_TurningTides11thAnd12thCenturies_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch17_p3",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 17,
            chapterTitle: "India, a Home to Many",
            displayTitle: "India, a Home to Many — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch17_IndiaAHomeToMany_P3_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch17_IndiaAHomeToMany_P3_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch17_IndiaAHomeToMany_P3.html",
            questionPaperPDF: "SocialScience_Ssch17_IndiaAHomeToMany_P3.pdf",
            solvedGuideHTML: "SocialScience_Ssch17_IndiaAHomeToMany_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch18_p3",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 18,
            chapterTitle: "The State, the Government, and You",
            displayTitle: "The State, the Government, and You — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch18_TheStateTheGovernmentAndYou_P3_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch18_TheStateTheGovernmentAndYou_P3_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch18_TheStateTheGovernmentAndYou_P3.html",
            questionPaperPDF: "SocialScience_Ssch18_TheStateTheGovernmentAndYou_P3.pdf",
            solvedGuideHTML: "SocialScience_Ssch18_TheStateTheGovernmentAndYou_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch19_p3",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 19,
            chapterTitle: "Infrastructure: Engine of India's Development",
            displayTitle: "Infrastructure: Engine of India's Development — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch19_Infrastructure_P3_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch19_Infrastructure_P3_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch19_Infrastructure_P3.html",
            questionPaperPDF: "SocialScience_Ssch19_Infrastructure_P3.pdf",
            solvedGuideHTML: "SocialScience_Ssch19_Infrastructure_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_socialscience_ssch20_p3",
            subjectId: "socialscience_class7",
            subjectName: "Social Science",
            chapterNumber: 20,
            chapterTitle: "Banks and the Magic of Finance",
            displayTitle: "Banks and the Magic of Finance — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "SocialScience_Ssch20_BanksAndTheMagicOfFinance_P3_QuestionPaper.md",
            solutionsMD: "SocialScience_Ssch20_BanksAndTheMagicOfFinance_P3_Solutions.md",
            questionPaperHTML: "SocialScience_Ssch20_BanksAndTheMagicOfFinance_P3.html",
            questionPaperPDF: "SocialScience_Ssch20_BanksAndTheMagicOfFinance_P3.pdf",
            solvedGuideHTML: "SocialScience_Ssch20_BanksAndTheMagicOfFinance_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch01_p3",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 1,
            chapterTitle: "वन्दे भारतमातरम् (Vande Bharatamataram)",
            displayTitle: "वन्दे भारतमातरम् (Vande Bharatamataram) — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch01_VandeBharatamataram_P3_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch01_VandeBharatamataram_P3_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch01_VandeBharatamataram_P3.html",
            questionPaperPDF: "Sanskrit_Sch01_VandeBharatamataram_P3.pdf",
            solvedGuideHTML: "Sanskrit_Sch01_VandeBharatamataram_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch02_p3",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 2,
            chapterTitle: "नित्यं पिबामः सुभाषितरसम् (Nityam Pibamah Subhashitarasam)",
            displayTitle: "नित्यं पिबामः सुभाषितरसम् (Nityam Pibamah Subhashitarasam) — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch02_NityamPibamahSubhashitarasam_P3_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch02_NityamPibamahSubhashitarasam_P3_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch02_NityamPibamahSubhashitarasam_P3.html",
            questionPaperPDF: "Sanskrit_Sch02_NityamPibamahSubhashitarasam_P3.pdf",
            solvedGuideHTML: "Sanskrit_Sch02_NityamPibamahSubhashitarasam_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch03_p3",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 3,
            chapterTitle: "मित्राय नमः (Mitraya Namah)",
            displayTitle: "मित्राय नमः (Mitraya Namah) — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch03_MitrayaNamah_P3_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch03_MitrayaNamah_P3_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch03_MitrayaNamah_P3.html",
            questionPaperPDF: "Sanskrit_Sch03_MitrayaNamah_P3.pdf",
            solvedGuideHTML: "Sanskrit_Sch03_MitrayaNamah_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch04_p3",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 4,
            chapterTitle: "न लभ्यते चेत् आम्लं द्राक्षाफलम् (The Fox and the Grapes)",
            displayTitle: "न लभ्यते चेत् आम्लं द्राक्षाफलम् (The Fox and the Grapes) — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch04_TheFoxAndTheGrapes_P3_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch04_TheFoxAndTheGrapes_P3_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch04_TheFoxAndTheGrapes_P3.html",
            questionPaperPDF: "Sanskrit_Sch04_TheFoxAndTheGrapes_P3.pdf",
            solvedGuideHTML: "Sanskrit_Sch04_TheFoxAndTheGrapes_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch05_p3",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 5,
            chapterTitle: "सेवा हि परमो धर्मः (Seva Hi Paramo Dharmah)",
            displayTitle: "सेवा हि परमो धर्मः (Seva Hi Paramo Dharmah) — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch05_SevaHiParamoDharmah_P3_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch05_SevaHiParamoDharmah_P3_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch05_SevaHiParamoDharmah_P3.html",
            questionPaperPDF: "Sanskrit_Sch05_SevaHiParamoDharmah_P3.pdf",
            solvedGuideHTML: "Sanskrit_Sch05_SevaHiParamoDharmah_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch06_p3",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 6,
            chapterTitle: "क्रीडाम वयं श्लोकान्त्याक्षरीम् (Let Us Play Shloka-Antyakshari)",
            displayTitle: "क्रीडाम वयं श्लोकान्त्याक्षरीम् (Let Us Play Shloka-Antyakshari) — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch06_KridamaVayamShlokantyaksharim_P3_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch06_KridamaVayamShlokantyaksharim_P3_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch06_KridamaVayamShlokantyaksharim_P3.html",
            questionPaperPDF: "Sanskrit_Sch06_KridamaVayamShlokantyaksharim_P3.pdf",
            solvedGuideHTML: "Sanskrit_Sch06_KridamaVayamShlokantyaksharim_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch07_p3",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 7,
            chapterTitle: "ईशावास्यम् इदं सर्वम् (Ishavasyam Idam Sarvam)",
            displayTitle: "ईशावास्यम् इदं सर्वम् (Ishavasyam Idam Sarvam) — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch07_IshavasyamIdamSarvam_P3_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch07_IshavasyamIdamSarvam_P3_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch07_IshavasyamIdamSarvam_P3.html",
            questionPaperPDF: "Sanskrit_Sch07_IshavasyamIdamSarvam_P3.pdf",
            solvedGuideHTML: "Sanskrit_Sch07_IshavasyamIdamSarvam_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch08_p3",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 8,
            chapterTitle: "हितं मनोहारि च दुर्लभं वचः (Hitam Manohari cha Durlabham Vachah)",
            displayTitle: "हितं मनोहारि च दुर्लभं वचः (Hitam Manohari cha Durlabham Vachah) — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch08_HitamManohariChaDurlabhamVachah_P3_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch08_HitamManohariChaDurlabhamVachah_P3_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch08_HitamManohariChaDurlabhamVachah_P3.html",
            questionPaperPDF: "Sanskrit_Sch08_HitamManohariChaDurlabhamVachah_P3.pdf",
            solvedGuideHTML: "Sanskrit_Sch08_HitamManohariChaDurlabhamVachah_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch09_p3",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 9,
            chapterTitle: "अन्नाद् भवन्ति भूतानि (Annad Bhavanti Bhutani)",
            displayTitle: "अन्नाद् भवन्ति भूतानि (Annad Bhavanti Bhutani) — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch09_AnnadBhavantiBhutani_P3_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch09_AnnadBhavantiBhutani_P3_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch09_AnnadBhavantiBhutani_P3.html",
            questionPaperPDF: "Sanskrit_Sch09_AnnadBhavantiBhutani_P3.pdf",
            solvedGuideHTML: "Sanskrit_Sch09_AnnadBhavantiBhutani_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch10_p3",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 10,
            chapterTitle: "दशमः कः? (Dashamah Kah? - Who Is the Tenth?)",
            displayTitle: "दशमः कः? (Dashamah Kah? - Who Is the Tenth?) — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch10_DashamahKah_P3_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch10_DashamahKah_P3_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch10_DashamahKah_P3.html",
            questionPaperPDF: "Sanskrit_Sch10_DashamahKah_P3.pdf",
            solvedGuideHTML: "Sanskrit_Sch10_DashamahKah_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch11_p3",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 11,
            chapterTitle: "द्वीपेषु रम्यः द्वीपोऽण्डमानः (The Andaman Islands)",
            displayTitle: "द्वीपेषु रम्यः द्वीपोऽण्डमानः (The Andaman Islands) — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch11_DvipeshuRamyahDvipoandamanah_P3_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch11_DvipeshuRamyahDvipoandamanah_P3_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch11_DvipeshuRamyahDvipoandamanah_P3.html",
            questionPaperPDF: "Sanskrit_Sch11_DvipeshuRamyahDvipoandamanah_P3.pdf",
            solvedGuideHTML: "Sanskrit_Sch11_DvipeshuRamyahDvipoandamanah_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch12_p3",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 12,
            chapterTitle: "वीराङ्गना पन्नाधाया (Panna Dhai, the Brave)",
            displayTitle: "वीराङ्गना पन्नाधाया (Panna Dhai, the Brave) — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch12_ViranganaPannadhaya_P3_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch12_ViranganaPannadhaya_P3_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch12_ViranganaPannadhaya_P3.html",
            questionPaperPDF: "Sanskrit_Sch12_ViranganaPannadhaya_P3.pdf",
            solvedGuideHTML: "Sanskrit_Sch12_ViranganaPannadhaya_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch13_p3",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 13,
            chapterTitle: "वर्णमात्रा-परिचयः (Varna-Matra: Vowel Quantity)",
            displayTitle: "वर्णमात्रा-परिचयः (Varna-Matra: Vowel Quantity) — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch13_VarnaMatraParichayah_P3_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch13_VarnaMatraParichayah_P3_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch13_VarnaMatraParichayah_P3.html",
            questionPaperPDF: "Sanskrit_Sch13_VarnaMatraParichayah_P3.pdf",
            solvedGuideHTML: "Sanskrit_Sch13_VarnaMatraParichayah_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch14_p3",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 14,
            chapterTitle: "शब्दरूपाणि (Shabda-Rupani: Noun Declensions)",
            displayTitle: "शब्दरूपाणि (Shabda-Rupani: Noun Declensions) — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch14_ShabdaRupani_P3_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch14_ShabdaRupani_P3_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch14_ShabdaRupani_P3.html",
            questionPaperPDF: "Sanskrit_Sch14_ShabdaRupani_P3.pdf",
            solvedGuideHTML: "Sanskrit_Sch14_ShabdaRupani_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_sanskrit_sch15_p3",
            subjectId: "sanskrit_class7",
            subjectName: "Sanskrit",
            chapterNumber: 15,
            chapterTitle: "धातुरूपाणि (Dhatu-Rupani: Verb Conjugations)",
            displayTitle: "धातुरूपाणि (Dhatu-Rupani: Verb Conjugations) — Paper 3 — 60 MCQ Olympiad",
            questionPaperMD: "Sanskrit_Sch15_DhaturupaniVerbConjugations_P3_QuestionPaper.md",
            solutionsMD: "Sanskrit_Sch15_DhaturupaniVerbConjugations_P3_Solutions.md",
            questionPaperHTML: "Sanskrit_Sch15_DhaturupaniVerbConjugations_P3.html",
            questionPaperPDF: "Sanskrit_Sch15_DhaturupaniVerbConjugations_P3.pdf",
            solvedGuideHTML: "Sanskrit_Sch15_DhaturupaniVerbConjugations_P3_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch02_p4",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 2,
            chapterTitle: "Nutrition in Animals",
            displayTitle: "Nutrition in Animals — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch02_NutritionInAnimals_P4_QuestionPaper.md",
            solutionsMD: "Science_Ch02_NutritionInAnimals_P4_Solutions.md",
            questionPaperHTML: "Science_Ch02_NutritionInAnimals_P4.html",
            questionPaperPDF: "Science_Ch02_NutritionInAnimals_P4.pdf",
            solvedGuideHTML: "Science_Ch02_NutritionInAnimals_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch03_p4",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 3,
            chapterTitle: "Fibre to Fabric",
            displayTitle: "Fibre to Fabric — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch03_FibreToFabric_P4_QuestionPaper.md",
            solutionsMD: "Science_Ch03_FibreToFabric_P4_Solutions.md",
            questionPaperHTML: "Science_Ch03_FibreToFabric_P4.html",
            questionPaperPDF: "Science_Ch03_FibreToFabric_P4.pdf",
            solvedGuideHTML: "Science_Ch03_FibreToFabric_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch04_p4",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 4,
            chapterTitle: "Heat",
            displayTitle: "Heat — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch04_Heat_P4_QuestionPaper.md",
            solutionsMD: "Science_Ch04_Heat_P4_Solutions.md",
            questionPaperHTML: "Science_Ch04_Heat_P4.html",
            questionPaperPDF: "Science_Ch04_Heat_P4.pdf",
            solvedGuideHTML: "Science_Ch04_Heat_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch05_p4",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 5,
            chapterTitle: "Acids, Bases and Salts",
            displayTitle: "Acids, Bases and Salts — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch05_AcidsBasesAndSalts_P4_QuestionPaper.md",
            solutionsMD: "Science_Ch05_AcidsBasesAndSalts_P4_Solutions.md",
            questionPaperHTML: "Science_Ch05_AcidsBasesAndSalts_P4.html",
            questionPaperPDF: "Science_Ch05_AcidsBasesAndSalts_P4.pdf",
            solvedGuideHTML: "Science_Ch05_AcidsBasesAndSalts_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch06_p4",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 6,
            chapterTitle: "Physical and Chemical Changes",
            displayTitle: "Physical and Chemical Changes — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch06_PhysicalAndChemicalChanges_P4_QuestionPaper.md",
            solutionsMD: "Science_Ch06_PhysicalAndChemicalChanges_P4_Solutions.md",
            questionPaperHTML: "Science_Ch06_PhysicalAndChemicalChanges_P4.html",
            questionPaperPDF: "Science_Ch06_PhysicalAndChemicalChanges_P4.pdf",
            solvedGuideHTML: "Science_Ch06_PhysicalAndChemicalChanges_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch07_p4",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 7,
            chapterTitle: "Weather, Climate and Adaptations of Animals to Climate",
            displayTitle: "Weather, Climate and Adaptations of Animals to Climate — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch07_WeatherClimateAndAdaptationsOfAnimalsToClimate_P4_QuestionPaper.md",
            solutionsMD: "Science_Ch07_WeatherClimateAndAdaptationsOfAnimalsToClimate_P4_Solutions.md",
            questionPaperHTML: "Science_Ch07_WeatherClimateAndAdaptationsOfAnimalsToClimate_P4.html",
            questionPaperPDF: "Science_Ch07_WeatherClimateAndAdaptationsOfAnimalsToClimate_P4.pdf",
            solvedGuideHTML: "Science_Ch07_WeatherClimateAndAdaptationsOfAnimalsToClimate_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch08_p4",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 8,
            chapterTitle: "Winds, Storms and Cyclones",
            displayTitle: "Winds, Storms and Cyclones — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch08_WindsStormsAndCyclones_P4_QuestionPaper.md",
            solutionsMD: "Science_Ch08_WindsStormsAndCyclones_P4_Solutions.md",
            questionPaperHTML: "Science_Ch08_WindsStormsAndCyclones_P4.html",
            questionPaperPDF: "Science_Ch08_WindsStormsAndCyclones_P4.pdf",
            solvedGuideHTML: "Science_Ch08_WindsStormsAndCyclones_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch09_p4",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 9,
            chapterTitle: "Soil",
            displayTitle: "Soil — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch09_Soil_P4_QuestionPaper.md",
            solutionsMD: "Science_Ch09_Soil_P4_Solutions.md",
            questionPaperHTML: "Science_Ch09_Soil_P4.html",
            questionPaperPDF: "Science_Ch09_Soil_P4.pdf",
            solvedGuideHTML: "Science_Ch09_Soil_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch10_p4",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 10,
            chapterTitle: "Respiration in Organisms",
            displayTitle: "Respiration in Organisms — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch10_RespirationInOrganisms_P4_QuestionPaper.md",
            solutionsMD: "Science_Ch10_RespirationInOrganisms_P4_Solutions.md",
            questionPaperHTML: "Science_Ch10_RespirationInOrganisms_P4.html",
            questionPaperPDF: "Science_Ch10_RespirationInOrganisms_P4.pdf",
            solvedGuideHTML: "Science_Ch10_RespirationInOrganisms_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch11_p4",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 11,
            chapterTitle: "Transportation in Animals and Plants",
            displayTitle: "Transportation in Animals and Plants — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch11_TransportationInAnimalsAndPlants_P4_QuestionPaper.md",
            solutionsMD: "Science_Ch11_TransportationInAnimalsAndPlants_P4_Solutions.md",
            questionPaperHTML: "Science_Ch11_TransportationInAnimalsAndPlants_P4.html",
            questionPaperPDF: "Science_Ch11_TransportationInAnimalsAndPlants_P4.pdf",
            solvedGuideHTML: "Science_Ch11_TransportationInAnimalsAndPlants_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch12_p4",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 12,
            chapterTitle: "Reproduction in Plants",
            displayTitle: "Reproduction in Plants — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch12_ReproductionInPlants_P4_QuestionPaper.md",
            solutionsMD: "Science_Ch12_ReproductionInPlants_P4_Solutions.md",
            questionPaperHTML: "Science_Ch12_ReproductionInPlants_P4.html",
            questionPaperPDF: "Science_Ch12_ReproductionInPlants_P4.pdf",
            solvedGuideHTML: "Science_Ch12_ReproductionInPlants_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch13_p4",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 13,
            chapterTitle: "Motion and Time",
            displayTitle: "Motion and Time — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch13_MotionAndTime_P4_QuestionPaper.md",
            solutionsMD: "Science_Ch13_MotionAndTime_P4_Solutions.md",
            questionPaperHTML: "Science_Ch13_MotionAndTime_P4.html",
            questionPaperPDF: "Science_Ch13_MotionAndTime_P4.pdf",
            solvedGuideHTML: "Science_Ch13_MotionAndTime_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch14_p4",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 14,
            chapterTitle: "Electric Current and Its Effect",
            displayTitle: "Electric Current and Its Effect — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch14_ElectricCurrentAndItsEffect_P4_QuestionPaper.md",
            solutionsMD: "Science_Ch14_ElectricCurrentAndItsEffect_P4_Solutions.md",
            questionPaperHTML: "Science_Ch14_ElectricCurrentAndItsEffect_P4.html",
            questionPaperPDF: "Science_Ch14_ElectricCurrentAndItsEffect_P4.pdf",
            solvedGuideHTML: "Science_Ch14_ElectricCurrentAndItsEffect_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch15_p4",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 15,
            chapterTitle: "Light",
            displayTitle: "Light — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch15_Light_P4_QuestionPaper.md",
            solutionsMD: "Science_Ch15_Light_P4_Solutions.md",
            questionPaperHTML: "Science_Ch15_Light_P4.html",
            questionPaperPDF: "Science_Ch15_Light_P4.pdf",
            solvedGuideHTML: "Science_Ch15_Light_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch16_p4",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 16,
            chapterTitle: "Water: A Precious Resource",
            displayTitle: "Water: A Precious Resource — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch16_WaterAPreciousResource_P4_QuestionPaper.md",
            solutionsMD: "Science_Ch16_WaterAPreciousResource_P4_Solutions.md",
            questionPaperHTML: "Science_Ch16_WaterAPreciousResource_P4.html",
            questionPaperPDF: "Science_Ch16_WaterAPreciousResource_P4.pdf",
            solvedGuideHTML: "Science_Ch16_WaterAPreciousResource_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch17_p4",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 17,
            chapterTitle: "Forest: Our Lifeline",
            displayTitle: "Forest: Our Lifeline — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch17_ForestOurLifeline_P4_QuestionPaper.md",
            solutionsMD: "Science_Ch17_ForestOurLifeline_P4_Solutions.md",
            questionPaperHTML: "Science_Ch17_ForestOurLifeline_P4.html",
            questionPaperPDF: "Science_Ch17_ForestOurLifeline_P4.pdf",
            solvedGuideHTML: "Science_Ch17_ForestOurLifeline_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch18_p4",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 18,
            chapterTitle: "Wastewater Story",
            displayTitle: "Wastewater Story — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch18_WastewaterStory_P4_QuestionPaper.md",
            solutionsMD: "Science_Ch18_WastewaterStory_P4_Solutions.md",
            questionPaperHTML: "Science_Ch18_WastewaterStory_P4.html",
            questionPaperPDF: "Science_Ch18_WastewaterStory_P4.pdf",
            solvedGuideHTML: "Science_Ch18_WastewaterStory_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_science_ch19_p4",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 19,
            chapterTitle: "Earth, Moon and the Sun",
            displayTitle: "Earth, Moon and the Sun — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch19_EarthMoonAndTheSun_P4_QuestionPaper.md",
            solutionsMD: "Science_Ch19_EarthMoonAndTheSun_P4_Solutions.md",
            questionPaperHTML: "Science_Ch19_EarthMoonAndTheSun_P4.html",
            questionPaperPDF: "Science_Ch19_EarthMoonAndTheSun_P4.pdf",
            solvedGuideHTML: "Science_Ch19_EarthMoonAndTheSun_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch01_p4",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 1,
            chapterTitle: "Large Numbers Around Us",
            displayTitle: "Large Numbers Around Us — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch01_LargeNumbersAroundUs_P4_QuestionPaper.md",
            solutionsMD: "Maths_Ch01_LargeNumbersAroundUs_P4_Solutions.md",
            questionPaperHTML: "Maths_Ch01_LargeNumbersAroundUs_P4.html",
            questionPaperPDF: "Maths_Ch01_LargeNumbersAroundUs_P4.pdf",
            solvedGuideHTML: "Maths_Ch01_LargeNumbersAroundUs_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch02_p4",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 2,
            chapterTitle: "Arithmetic Expressions",
            displayTitle: "Arithmetic Expressions — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch02_ArithmeticExpressions_P4_QuestionPaper.md",
            solutionsMD: "Maths_Ch02_ArithmeticExpressions_P4_Solutions.md",
            questionPaperHTML: "Maths_Ch02_ArithmeticExpressions_P4.html",
            questionPaperPDF: "Maths_Ch02_ArithmeticExpressions_P4.pdf",
            solvedGuideHTML: "Maths_Ch02_ArithmeticExpressions_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch03_p4",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 3,
            chapterTitle: "A Peek Beyond the Point",
            displayTitle: "A Peek Beyond the Point — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch03_APeekBeyondThePoint_P4_QuestionPaper.md",
            solutionsMD: "Maths_Ch03_APeekBeyondThePoint_P4_Solutions.md",
            questionPaperHTML: "Maths_Ch03_APeekBeyondThePoint_P4.html",
            questionPaperPDF: "Maths_Ch03_APeekBeyondThePoint_P4.pdf",
            solvedGuideHTML: "Maths_Ch03_APeekBeyondThePoint_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch04_p4",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 4,
            chapterTitle: "Expressions Using Letter-Numbers",
            displayTitle: "Expressions Using Letter-Numbers — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch04_ExpressionsUsingLetterNumbers_P4_QuestionPaper.md",
            solutionsMD: "Maths_Ch04_ExpressionsUsingLetterNumbers_P4_Solutions.md",
            questionPaperHTML: "Maths_Ch04_ExpressionsUsingLetterNumbers_P4.html",
            questionPaperPDF: "Maths_Ch04_ExpressionsUsingLetterNumbers_P4.pdf",
            solvedGuideHTML: "Maths_Ch04_ExpressionsUsingLetterNumbers_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch05_p4",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 5,
            chapterTitle: "Parallel and Intersecting Lines",
            displayTitle: "Parallel and Intersecting Lines — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch05_ParallelAndIntersectingLines_P4_QuestionPaper.md",
            solutionsMD: "Maths_Ch05_ParallelAndIntersectingLines_P4_Solutions.md",
            questionPaperHTML: "Maths_Ch05_ParallelAndIntersectingLines_P4.html",
            questionPaperPDF: "Maths_Ch05_ParallelAndIntersectingLines_P4.pdf",
            solvedGuideHTML: "Maths_Ch05_ParallelAndIntersectingLines_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch06_p4",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 6,
            chapterTitle: "Number Play",
            displayTitle: "Number Play — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch06_NumberPlay_P4_QuestionPaper.md",
            solutionsMD: "Maths_Ch06_NumberPlay_P4_Solutions.md",
            questionPaperHTML: "Maths_Ch06_NumberPlay_P4.html",
            questionPaperPDF: "Maths_Ch06_NumberPlay_P4.pdf",
            solvedGuideHTML: "Maths_Ch06_NumberPlay_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch07_p4",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 7,
            chapterTitle: "A Tale of Three Intersecting Lines",
            displayTitle: "A Tale of Three Intersecting Lines — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch07_ATaleOfThreeIntersectingLines_P4_QuestionPaper.md",
            solutionsMD: "Maths_Ch07_ATaleOfThreeIntersectingLines_P4_Solutions.md",
            questionPaperHTML: "Maths_Ch07_ATaleOfThreeIntersectingLines_P4.html",
            questionPaperPDF: "Maths_Ch07_ATaleOfThreeIntersectingLines_P4.pdf",
            solvedGuideHTML: "Maths_Ch07_ATaleOfThreeIntersectingLines_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch08_p4",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 8,
            chapterTitle: "Working with Fractions",
            displayTitle: "Working with Fractions — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch08_WorkingWithFractions_P4_QuestionPaper.md",
            solutionsMD: "Maths_Ch08_WorkingWithFractions_P4_Solutions.md",
            questionPaperHTML: "Maths_Ch08_WorkingWithFractions_P4.html",
            questionPaperPDF: "Maths_Ch08_WorkingWithFractions_P4.pdf",
            solvedGuideHTML: "Maths_Ch08_WorkingWithFractions_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch09_p4",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 9,
            chapterTitle: "Geometric Twins",
            displayTitle: "Geometric Twins — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch09_GeometricTwins_P4_QuestionPaper.md",
            solutionsMD: "Maths_Ch09_GeometricTwins_P4_Solutions.md",
            questionPaperHTML: "Maths_Ch09_GeometricTwins_P4.html",
            questionPaperPDF: "Maths_Ch09_GeometricTwins_P4.pdf",
            solvedGuideHTML: "Maths_Ch09_GeometricTwins_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch10_p4",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 10,
            chapterTitle: "Operations with Integers",
            displayTitle: "Operations with Integers — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch10_OperationsWithIntegers_P4_QuestionPaper.md",
            solutionsMD: "Maths_Ch10_OperationsWithIntegers_P4_Solutions.md",
            questionPaperHTML: "Maths_Ch10_OperationsWithIntegers_P4.html",
            questionPaperPDF: "Maths_Ch10_OperationsWithIntegers_P4.pdf",
            solvedGuideHTML: "Maths_Ch10_OperationsWithIntegers_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch11_p4",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 11,
            chapterTitle: "Finding Common Ground",
            displayTitle: "Finding Common Ground — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch11_FindingCommonGround_P4_QuestionPaper.md",
            solutionsMD: "Maths_Ch11_FindingCommonGround_P4_Solutions.md",
            questionPaperHTML: "Maths_Ch11_FindingCommonGround_P4.html",
            questionPaperPDF: "Maths_Ch11_FindingCommonGround_P4.pdf",
            solvedGuideHTML: "Maths_Ch11_FindingCommonGround_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch12_p4",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 12,
            chapterTitle: "Another Peek Beyond the Point",
            displayTitle: "Another Peek Beyond the Point — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch12_AnotherPeekBeyondThePoint_P4_QuestionPaper.md",
            solutionsMD: "Maths_Ch12_AnotherPeekBeyondThePoint_P4_Solutions.md",
            questionPaperHTML: "Maths_Ch12_AnotherPeekBeyondThePoint_P4.html",
            questionPaperPDF: "Maths_Ch12_AnotherPeekBeyondThePoint_P4.pdf",
            solvedGuideHTML: "Maths_Ch12_AnotherPeekBeyondThePoint_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch13_p4",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 13,
            chapterTitle: "Connecting the Dots",
            displayTitle: "Connecting the Dots — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch13_ConnectingTheDots_P4_QuestionPaper.md",
            solutionsMD: "Maths_Ch13_ConnectingTheDots_P4_Solutions.md",
            questionPaperHTML: "Maths_Ch13_ConnectingTheDots_P4.html",
            questionPaperPDF: "Maths_Ch13_ConnectingTheDots_P4.pdf",
            solvedGuideHTML: "Maths_Ch13_ConnectingTheDots_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```

```swift
        OlympiadPaper(
            id: "olympiad_maths_mch14_p4",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 14,
            chapterTitle: "Constructions and Tilings",
            displayTitle: "Constructions and Tilings — Paper 4 — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch14_ConstructionsAndTilings_P4_QuestionPaper.md",
            solutionsMD: "Maths_Ch14_ConstructionsAndTilings_P4_Solutions.md",
            questionPaperHTML: "Maths_Ch14_ConstructionsAndTilings_P4.html",
            questionPaperPDF: "Maths_Ch14_ConstructionsAndTilings_P4.pdf",
            solvedGuideHTML: "Maths_Ch14_ConstructionsAndTilings_P4_SolvedGuide.html",
            suggestedTimeMinutes: 90
        ),
```
