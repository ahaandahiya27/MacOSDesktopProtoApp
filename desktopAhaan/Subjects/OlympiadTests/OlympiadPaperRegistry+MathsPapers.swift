import Foundation

// 15 Maths Olympiad papers. Split into this per-subject
// file so no single registry file approaches the 600-LOC Big-Sur
// Swift-5.5 type-checker ceiling (a 69-element array literal in one
// file both broke the file-size gate and risked a slow type-check).

extension OlympiadPaperRegistry {
    static let mathsPapers: [OlympiadPaper] = [
        OlympiadPaper(
            id: "olympiad_maths_ch01",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 1,
            chapterTitle: "Large Numbers Around Us",
            displayTitle: "Large Numbers Around Us — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch01_LargeNumbersAroundUs_QuestionPaper.md",
            solutionsMD: "Maths_Ch01_LargeNumbersAroundUs_Solutions.md",
            questionPaperHTML: "Maths_Ch01_LargeNumbersAroundUs.html",
            questionPaperPDF: "Maths_Ch01_LargeNumbersAroundUs.pdf",
            suggestedTimeMinutes: 90,
            solvedGuideHTML: "Maths_Ch01_LargeNumbersAroundUs_SolvedGuide.html"
        ),
        OlympiadPaper(
            id: "olympiad_maths_ch02",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 2,
            chapterTitle: "Arithmetic Expressions",
            displayTitle: "Arithmetic Expressions — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch02_ArithmeticExpressions_QuestionPaper.md",
            solutionsMD: "Maths_Ch02_ArithmeticExpressions_Solutions.md",
            questionPaperHTML: "Maths_Ch02_ArithmeticExpressions.html",
            questionPaperPDF: "Maths_Ch02_ArithmeticExpressions.pdf",
            suggestedTimeMinutes: 90,
            solvedGuideHTML: "Maths_Ch02_ArithmeticExpressions_SolvedGuide.html"
        ),
        OlympiadPaper(
            id: "olympiad_maths_ch03",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 3,
            chapterTitle: "A Peek Beyond the Point",
            displayTitle: "A Peek Beyond the Point — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch03_APeekBeyondThePoint_QuestionPaper.md",
            solutionsMD: "Maths_Ch03_APeekBeyondThePoint_Solutions.md",
            questionPaperHTML: "Maths_Ch03_APeekBeyondThePoint.html",
            questionPaperPDF: "Maths_Ch03_APeekBeyondThePoint.pdf",
            suggestedTimeMinutes: 90,
            solvedGuideHTML: "Maths_Ch03_APeekBeyondThePoint_SolvedGuide.html"
        ),
        OlympiadPaper(
            id: "olympiad_maths_ch04",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 4,
            chapterTitle: "Expressions Using Letter-Numbers",
            displayTitle: "Expressions Using Letter-Numbers — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch04_ExpressionsUsingLetterNumbers_QuestionPaper.md",
            solutionsMD: "Maths_Ch04_ExpressionsUsingLetterNumbers_Solutions.md",
            questionPaperHTML: "Maths_Ch04_ExpressionsUsingLetterNumbers.html",
            questionPaperPDF: "Maths_Ch04_ExpressionsUsingLetterNumbers.pdf",
            suggestedTimeMinutes: 90,
            solvedGuideHTML: "Maths_Ch04_ExpressionsUsingLetterNumbers_SolvedGuide.html"
        ),
        OlympiadPaper(
            id: "olympiad_maths_ch05",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 5,
            chapterTitle: "Parallel and Intersecting Lines",
            displayTitle: "Parallel and Intersecting Lines — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch05_ParallelAndIntersectingLines_QuestionPaper.md",
            solutionsMD: "Maths_Ch05_ParallelAndIntersectingLines_Solutions.md",
            questionPaperHTML: "Maths_Ch05_ParallelAndIntersectingLines.html",
            questionPaperPDF: "Maths_Ch05_ParallelAndIntersectingLines.pdf",
            suggestedTimeMinutes: 90,
            solvedGuideHTML: "Maths_Ch05_ParallelAndIntersectingLines_SolvedGuide.html"
        ),
        OlympiadPaper(
            id: "olympiad_maths_ch06",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 6,
            chapterTitle: "Number Play",
            displayTitle: "Number Play — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch06_NumberPlay_QuestionPaper.md",
            solutionsMD: "Maths_Ch06_NumberPlay_Solutions.md",
            questionPaperHTML: "Maths_Ch06_NumberPlay.html",
            questionPaperPDF: "Maths_Ch06_NumberPlay.pdf",
            suggestedTimeMinutes: 90,
            solvedGuideHTML: "Maths_Ch06_NumberPlay_SolvedGuide.html"
        ),
        OlympiadPaper(
            id: "olympiad_maths_ch07",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 7,
            chapterTitle: "A Tale of Three Intersecting Lines",
            displayTitle: "A Tale of Three Intersecting Lines — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch07_ATaleOfThreeIntersectingLines_QuestionPaper.md",
            solutionsMD: "Maths_Ch07_ATaleOfThreeIntersectingLines_Solutions.md",
            questionPaperHTML: "Maths_Ch07_ATaleOfThreeIntersectingLines.html",
            questionPaperPDF: "Maths_Ch07_ATaleOfThreeIntersectingLines.pdf",
            suggestedTimeMinutes: 90,
            solvedGuideHTML: "Maths_Ch07_ATaleOfThreeIntersectingLines_SolvedGuide.html"
        ),
        OlympiadPaper(
            id: "olympiad_maths_ch08",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 8,
            chapterTitle: "Working with Fractions",
            displayTitle: "Working with Fractions — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch08_WorkingWithFractions_QuestionPaper.md",
            solutionsMD: "Maths_Ch08_WorkingWithFractions_Solutions.md",
            questionPaperHTML: "Maths_Ch08_WorkingWithFractions.html",
            questionPaperPDF: "Maths_Ch08_WorkingWithFractions.pdf",
            suggestedTimeMinutes: 90,
            solvedGuideHTML: "Maths_Ch08_WorkingWithFractions_SolvedGuide.html"
        ),
        OlympiadPaper(
            id: "olympiad_maths_ch09",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 9,
            chapterTitle: "Geometric Twins",
            displayTitle: "Geometric Twins — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch09_GeometricTwins_QuestionPaper.md",
            solutionsMD: "Maths_Ch09_GeometricTwins_Solutions.md",
            questionPaperHTML: "Maths_Ch09_GeometricTwins.html",
            questionPaperPDF: "Maths_Ch09_GeometricTwins.pdf",
            suggestedTimeMinutes: 90,
            solvedGuideHTML: "Maths_Ch09_GeometricTwins_SolvedGuide.html"
        ),
        OlympiadPaper(
            id: "olympiad_maths_ch10",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 10,
            chapterTitle: "Operations with Integers",
            displayTitle: "Operations with Integers — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch10_OperationsWithIntegers_QuestionPaper.md",
            solutionsMD: "Maths_Ch10_OperationsWithIntegers_Solutions.md",
            questionPaperHTML: "Maths_Ch10_OperationsWithIntegers.html",
            questionPaperPDF: "Maths_Ch10_OperationsWithIntegers.pdf",
            suggestedTimeMinutes: 90,
            solvedGuideHTML: "Maths_Ch10_OperationsWithIntegers_SolvedGuide.html"
        ),
        OlympiadPaper(
            id: "olympiad_maths_ch11",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 11,
            chapterTitle: "Finding Common Ground",
            displayTitle: "Finding Common Ground — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch11_FindingCommonGround_QuestionPaper.md",
            solutionsMD: "Maths_Ch11_FindingCommonGround_Solutions.md",
            questionPaperHTML: "Maths_Ch11_FindingCommonGround.html",
            questionPaperPDF: "Maths_Ch11_FindingCommonGround.pdf",
            suggestedTimeMinutes: 90,
            solvedGuideHTML: "Maths_Ch11_FindingCommonGround_SolvedGuide.html"
        ),
        OlympiadPaper(
            id: "olympiad_maths_ch12",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 12,
            chapterTitle: "Another Peek Beyond the Point",
            displayTitle: "Another Peek Beyond the Point — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch12_AnotherPeekBeyondThePoint_QuestionPaper.md",
            solutionsMD: "Maths_Ch12_AnotherPeekBeyondThePoint_Solutions.md",
            questionPaperHTML: "Maths_Ch12_AnotherPeekBeyondThePoint.html",
            questionPaperPDF: "Maths_Ch12_AnotherPeekBeyondThePoint.pdf",
            suggestedTimeMinutes: 90,
            solvedGuideHTML: "Maths_Ch12_AnotherPeekBeyondThePoint_SolvedGuide.html"
        ),
        OlympiadPaper(
            id: "olympiad_maths_ch13",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 13,
            chapterTitle: "Connecting the Dots",
            displayTitle: "Connecting the Dots — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch13_ConnectingTheDots_QuestionPaper.md",
            solutionsMD: "Maths_Ch13_ConnectingTheDots_Solutions.md",
            questionPaperHTML: "Maths_Ch13_ConnectingTheDots.html",
            questionPaperPDF: "Maths_Ch13_ConnectingTheDots.pdf",
            suggestedTimeMinutes: 90,
            solvedGuideHTML: "Maths_Ch13_ConnectingTheDots_SolvedGuide.html"
        ),
        OlympiadPaper(
            id: "olympiad_maths_ch14",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 14,
            chapterTitle: "Constructions and Tilings",
            displayTitle: "Constructions and Tilings — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch14_ConstructionsAndTilings_QuestionPaper.md",
            solutionsMD: "Maths_Ch14_ConstructionsAndTilings_Solutions.md",
            questionPaperHTML: "Maths_Ch14_ConstructionsAndTilings.html",
            questionPaperPDF: "Maths_Ch14_ConstructionsAndTilings.pdf",
            suggestedTimeMinutes: 90,
            solvedGuideHTML: "Maths_Ch14_ConstructionsAndTilings_SolvedGuide.html"
        ),
        OlympiadPaper(
            id: "olympiad_maths_ch15",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 15,
            chapterTitle: "Finding the Unknown",
            displayTitle: "Finding the Unknown — Paper 1 (Foundation)",
            questionPaperMD: "Maths_Ch15_FindingTheUnknown_QuestionPaper.md",
            solutionsMD: "Maths_Ch15_FindingTheUnknown_Solutions.md",
            questionPaperHTML: "Maths_Ch15_FindingTheUnknown.html",
            questionPaperPDF: "Maths_Ch15_FindingTheUnknown.pdf",
            suggestedTimeMinutes: 90,
            solvedGuideHTML: "Maths_Ch15_FindingTheUnknown_SolvedGuide.html"
        ),
        OlympiadPaper(
            id: "olympiad_maths_ch15_advanced",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 15,
            chapterTitle: "Finding the Unknown",
            displayTitle: "Finding the Unknown — Paper 2 (Advanced)",
            questionPaperMD: "Maths_Ch15_FindingTheUnknown_Advanced_QuestionPaper.md",
            solutionsMD: "Maths_Ch15_FindingTheUnknown_Advanced_Solutions.md",
            // Reuses Paper 1's printable HTML + PDF until Advanced print
            // assets are generated. See the matching Science Ch13
            // Advanced entry for the reasoning — the tier=.advanced
            // field is what makes this row distinct in the registry.
            questionPaperHTML: "Maths_Ch15_FindingTheUnknown.html",
            questionPaperPDF: "Maths_Ch15_FindingTheUnknown.pdf",
            suggestedTimeMinutes: 90,
            solvedGuideHTML: "Maths_Ch15_FindingTheUnknown_Advanced_SolvedGuide.html",
            tier: .advanced
        )
    ]
}
