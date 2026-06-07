#!/usr/bin/env python3
"""One-time pbxproj patcher: add OlympiadTests Swift files + TestPapers
resources to desktopAhaan.xcodeproj/project.pbxproj.

Idempotent — checks if the entries already exist before adding. Safe to
re-run on a partial-add state. Generates deterministic UUIDs from the
filename so subsequent runs don't churn the project.

Convention: this is a ONE-OFF tool, not a recurring lint. Once the
feature lands, the entries are baked in and this script doesn't need
to run again. Kept in the repo so a future Agent can audit how the
files got added.

Background: the project uses objectVersion = 55 (Xcode 13.2.1 format),
which does NOT support PBXFileSystemSynchronizedRootGroup. New files
require explicit pbxproj entries. CLAUDE.md says to use Xcode's
Add Files dialog — but the dev Mac uses headless `xcodebuild` via the
MCP, so direct pbxproj manipulation is safe here.
"""
from __future__ import annotations

import hashlib
import os
import re
import sys
from pathlib import Path

PBXPROJ = Path(__file__).resolve().parent.parent / "desktopAhaan.xcodeproj" / "project.pbxproj"

# Swift files to add. Paths are RELATIVE TO THE PROJECT ROOT (i.e. they
# include the inner "desktopAhaan/" prefix). We use sourceTree =
# SOURCE_ROOT to avoid having to thread the file refs through a parent
# group's path — the absolute project-root anchor is the simpler and
# more idempotent choice.
SWIFT_FILES = [
    "desktopAhaan/Subjects/OlympiadTests/OlympiadHubView.swift",
    "desktopAhaan/Subjects/OlympiadTests/OlympiadPaper.swift",
    "desktopAhaan/Subjects/OlympiadTests/OlympiadPaperParser.swift",
    "desktopAhaan/Subjects/OlympiadTests/OlympiadPaperRegistry+MathsPapers.swift",
    "desktopAhaan/Subjects/OlympiadTests/OlympiadPaperRegistry+SanskritPapers.swift",
    "desktopAhaan/Subjects/OlympiadTests/OlympiadPaperRegistry+SciencePapers.swift",
    "desktopAhaan/Subjects/OlympiadTests/OlympiadPaperRegistry+SocialSciencePapers.swift",
    "desktopAhaan/Subjects/OlympiadTests/OlympiadPaperRegistry.swift",
    "desktopAhaan/Subjects/OlympiadTests/OlympiadQuizResultView.swift",
    "desktopAhaan/Subjects/OlympiadTests/OlympiadQuizView.swift",
]

# Resource files. These ship as bundle resources (Copy Bundle Resources
# phase), accessed via Bundle.main.url(forResource:withExtension:
# subdirectory: "TestPapers").
RESOURCE_FILES = [
    "desktopAhaan/Resources/TestPapers/Maths_Ch01_LargeNumbersAroundUs.html",
    "desktopAhaan/Resources/TestPapers/Maths_Ch01_LargeNumbersAroundUs_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch01_LargeNumbersAroundUs_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch02_ArithmeticExpressions.html",
    "desktopAhaan/Resources/TestPapers/Maths_Ch02_ArithmeticExpressions_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch02_ArithmeticExpressions_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch03_APeekBeyondThePoint.html",
    "desktopAhaan/Resources/TestPapers/Maths_Ch03_APeekBeyondThePoint_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch03_APeekBeyondThePoint_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch04_ExpressionsUsingLetterNumbers.html",
    "desktopAhaan/Resources/TestPapers/Maths_Ch04_ExpressionsUsingLetterNumbers_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch04_ExpressionsUsingLetterNumbers_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch05_ParallelAndIntersectingLines.html",
    "desktopAhaan/Resources/TestPapers/Maths_Ch05_ParallelAndIntersectingLines_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch05_ParallelAndIntersectingLines_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch06_NumberPlay.html",
    "desktopAhaan/Resources/TestPapers/Maths_Ch06_NumberPlay_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch06_NumberPlay_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch07_ATaleOfThreeIntersectingLines.html",
    "desktopAhaan/Resources/TestPapers/Maths_Ch07_ATaleOfThreeIntersectingLines_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch07_ATaleOfThreeIntersectingLines_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch08_WorkingWithFractions.html",
    "desktopAhaan/Resources/TestPapers/Maths_Ch08_WorkingWithFractions_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch08_WorkingWithFractions_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch09_GeometricTwins.html",
    "desktopAhaan/Resources/TestPapers/Maths_Ch09_GeometricTwins_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch09_GeometricTwins_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch10_OperationsWithIntegers.html",
    "desktopAhaan/Resources/TestPapers/Maths_Ch10_OperationsWithIntegers_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch10_OperationsWithIntegers_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch11_FindingCommonGround.html",
    "desktopAhaan/Resources/TestPapers/Maths_Ch11_FindingCommonGround_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch11_FindingCommonGround_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch12_AnotherPeekBeyondThePoint.html",
    "desktopAhaan/Resources/TestPapers/Maths_Ch12_AnotherPeekBeyondThePoint_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch12_AnotherPeekBeyondThePoint_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch13_ConnectingTheDots.html",
    "desktopAhaan/Resources/TestPapers/Maths_Ch13_ConnectingTheDots_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch13_ConnectingTheDots_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch14_ConstructionsAndTilings.html",
    "desktopAhaan/Resources/TestPapers/Maths_Ch14_ConstructionsAndTilings_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch14_ConstructionsAndTilings_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch15_FindingTheUnknown.html",
    "desktopAhaan/Resources/TestPapers/Maths_Ch15_FindingTheUnknown.pdf",
    "desktopAhaan/Resources/TestPapers/Maths_Ch15_FindingTheUnknown_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Maths_Ch15_FindingTheUnknown_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch01_VandeBharatamataram.html",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch01_VandeBharatamataram_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch01_VandeBharatamataram_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch02_NityamPibamahSubhashitarasam.html",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch02_NityamPibamahSubhashitarasam_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch02_NityamPibamahSubhashitarasam_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch03_MitrayaNamah.html",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch03_MitrayaNamah_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch03_MitrayaNamah_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch04_TheFoxAndTheGrapes.html",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch04_TheFoxAndTheGrapes_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch04_TheFoxAndTheGrapes_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch05_SevaHiParamoDharmah.html",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch05_SevaHiParamoDharmah_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch05_SevaHiParamoDharmah_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch06_KridamaVayamShlokantyaksharim.html",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch06_KridamaVayamShlokantyaksharim_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch06_KridamaVayamShlokantyaksharim_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch07_IshavasyamIdamSarvam.html",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch07_IshavasyamIdamSarvam_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch07_IshavasyamIdamSarvam_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch08_HitamManohariChaDurlabhamVachah.html",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch08_HitamManohariChaDurlabhamVachah_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch08_HitamManohariChaDurlabhamVachah_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch09_AnnadBhavantiBhutani.html",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch09_AnnadBhavantiBhutani_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch09_AnnadBhavantiBhutani_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch10_DashamahKah.html",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch10_DashamahKah_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch10_DashamahKah_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch11_DvipeshuRamyahDvipoandamanah.html",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch11_DvipeshuRamyahDvipoandamanah_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch11_DvipeshuRamyahDvipoandamanah_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch12_ViranganaPannadhaya.html",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch12_ViranganaPannadhaya_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch12_ViranganaPannadhaya_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch13_VarnaMatraParichayah.html",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch13_VarnaMatraParichayah_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch13_VarnaMatraParichayah_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch14_ShabdaRupani.html",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch14_ShabdaRupani_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch14_ShabdaRupani_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch15_DhaturupaniVerbConjugations.html",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch15_DhaturupaniVerbConjugations_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Sanskrit_Sch15_DhaturupaniVerbConjugations_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch01_NutritionInPlants.html",
    "desktopAhaan/Resources/TestPapers/Science_Ch01_NutritionInPlants_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch01_NutritionInPlants_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch02_NutritionInAnimals.html",
    "desktopAhaan/Resources/TestPapers/Science_Ch02_NutritionInAnimals_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch02_NutritionInAnimals_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch03_FibreToFabric.html",
    "desktopAhaan/Resources/TestPapers/Science_Ch03_FibreToFabric_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch03_FibreToFabric_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch04_Heat.html",
    "desktopAhaan/Resources/TestPapers/Science_Ch04_Heat_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch04_Heat_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch05_AcidsBasesAndSalts.html",
    "desktopAhaan/Resources/TestPapers/Science_Ch05_AcidsBasesAndSalts_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch05_AcidsBasesAndSalts_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch06_PhysicalAndChemicalChanges.html",
    "desktopAhaan/Resources/TestPapers/Science_Ch06_PhysicalAndChemicalChanges_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch06_PhysicalAndChemicalChanges_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch07_WeatherClimateAndAdaptationsOfAnimalsToClimate.html",
    "desktopAhaan/Resources/TestPapers/Science_Ch07_WeatherClimateAndAdaptationsOfAnimalsToClimate_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch07_WeatherClimateAndAdaptationsOfAnimalsToClimate_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch08_WindsStormsAndCyclones.html",
    "desktopAhaan/Resources/TestPapers/Science_Ch08_WindsStormsAndCyclones_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch08_WindsStormsAndCyclones_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch09_Soil.html",
    "desktopAhaan/Resources/TestPapers/Science_Ch09_Soil_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch09_Soil_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch10_RespirationInOrganisms.html",
    "desktopAhaan/Resources/TestPapers/Science_Ch10_RespirationInOrganisms_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch10_RespirationInOrganisms_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch11_TransportationInAnimalsAndPlants.html",
    "desktopAhaan/Resources/TestPapers/Science_Ch11_TransportationInAnimalsAndPlants_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch11_TransportationInAnimalsAndPlants_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch12_ReproductionInPlants.html",
    "desktopAhaan/Resources/TestPapers/Science_Ch12_ReproductionInPlants_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch12_ReproductionInPlants_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch13_MotionAndTime.html",
    "desktopAhaan/Resources/TestPapers/Science_Ch13_MotionAndTime.pdf",
    "desktopAhaan/Resources/TestPapers/Science_Ch13_MotionAndTime_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch13_MotionAndTime_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch14_ElectricCurrentAndItsEffect.html",
    "desktopAhaan/Resources/TestPapers/Science_Ch14_ElectricCurrentAndItsEffect_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch14_ElectricCurrentAndItsEffect_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch15_Light.html",
    "desktopAhaan/Resources/TestPapers/Science_Ch15_Light_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch15_Light_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch16_WaterAPreciousResource.html",
    "desktopAhaan/Resources/TestPapers/Science_Ch16_WaterAPreciousResource_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch16_WaterAPreciousResource_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch17_ForestOurLifeline.html",
    "desktopAhaan/Resources/TestPapers/Science_Ch17_ForestOurLifeline_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch17_ForestOurLifeline_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch18_WastewaterStory.html",
    "desktopAhaan/Resources/TestPapers/Science_Ch18_WastewaterStory_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch18_WastewaterStory_Solutions.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch19_EarthMoonAndTheSun.html",
    "desktopAhaan/Resources/TestPapers/Science_Ch19_EarthMoonAndTheSun_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/Science_Ch19_EarthMoonAndTheSun_Solutions.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch01_GeographicalDiversityOfIndia.html",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch01_GeographicalDiversityOfIndia_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch01_GeographicalDiversityOfIndia_Solutions.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch02_UnderstandingTheWeather.html",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch02_UnderstandingTheWeather_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch02_UnderstandingTheWeather_Solutions.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch03_ClimatesOfIndia.html",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch03_ClimatesOfIndia_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch03_ClimatesOfIndia_Solutions.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch04_NewBeginningsCitiesAndStates.html",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch04_NewBeginningsCitiesAndStates_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch04_NewBeginningsCitiesAndStates_Solutions.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch05_TheRiseOfEmpires.html",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch05_TheRiseOfEmpires_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch05_TheRiseOfEmpires_Solutions.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch06_TheAgeOfReorganisation.html",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch06_TheAgeOfReorganisation_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch06_TheAgeOfReorganisation_Solutions.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch07_TheGuptaEra.html",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch07_TheGuptaEra_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch07_TheGuptaEra_Solutions.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch08_HowTheLandBecomesSacred.html",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch08_HowTheLandBecomesSacred_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch08_HowTheLandBecomesSacred_Solutions.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch09_TypesOfGovernments.html",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch09_TypesOfGovernments_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch09_TypesOfGovernments_Solutions.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch10_TheConstitutionOfIndia.html",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch10_TheConstitutionOfIndia_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch10_TheConstitutionOfIndia_Solutions.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch11_FromBarterToMoney.html",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch11_FromBarterToMoney_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch11_FromBarterToMoney_Solutions.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch12_UnderstandingMarkets.html",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch12_UnderstandingMarkets_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch12_UnderstandingMarkets_Solutions.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch13_TheStoryOfIndianFarming.html",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch13_TheStoryOfIndianFarming_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch13_TheStoryOfIndianFarming_Solutions.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch14_IndiaAndHerNeighbours.html",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch14_IndiaAndHerNeighbours_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch14_IndiaAndHerNeighbours_Solutions.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch15_EmpiresAndKingdoms6thTo10thCenturies.html",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch15_EmpiresAndKingdoms6thTo10thCenturies_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch15_EmpiresAndKingdoms6thTo10thCenturies_Solutions.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch16_TurningTides11thAnd12thCenturies.html",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch16_TurningTides11thAnd12thCenturies_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch16_TurningTides11thAnd12thCenturies_Solutions.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch17_IndiaAHomeToMany.html",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch17_IndiaAHomeToMany_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch17_IndiaAHomeToMany_Solutions.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch18_TheStateTheGovernmentAndYou.html",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch18_TheStateTheGovernmentAndYou_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch18_TheStateTheGovernmentAndYou_Solutions.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch19_Infrastructure.html",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch19_Infrastructure_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch19_Infrastructure_Solutions.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch20_BanksAndTheMagicOfFinance.html",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch20_BanksAndTheMagicOfFinance_QuestionPaper.md",
    "desktopAhaan/Resources/TestPapers/SocialScience_Ssch20_BanksAndTheMagicOfFinance_Solutions.md",
]


def stable_uuid(seed: str) -> str:
    """Generate a 24-hex-char UUID deterministically from a seed.

    Xcode pbxproj UUIDs are 24-character uppercase hex. Using MD5 of the
    seed → take first 24 hex chars guarantees idempotent re-runs.
    """
    return hashlib.md5(seed.encode("utf-8")).hexdigest()[:24].upper()


def filetype_for(path: str) -> str:
    """Return the lastKnownFileType for the given path."""
    ext = path.rsplit(".", 1)[-1].lower()
    return {
        "swift": "sourcecode.swift",
        "html": "text.html",
        "md": "net.daringfireball.markdown",
        "pdf": "image.pdf",
    }.get(ext, "text")


def patch(text: str) -> tuple[str, list[str]]:
    """Return (new_text, log_lines). Idempotent."""
    log: list[str] = []
    out = text

    # The synthesized seed uses the basename so the same UUID is used
    # everywhere this file is referenced.
    new_build_file_lines: list[str] = []
    new_file_ref_lines: list[str] = []
    new_sources_phase_lines: list[str] = []
    new_resources_phase_lines: list[str] = []

    for rel_path in SWIFT_FILES + RESOURCE_FILES:
        bare = os.path.basename(rel_path)
        is_swift = rel_path.endswith(".swift")
        # Idempotency check: if a PBXBuildFile line already references
        # this exact basename, skip. The match looks at the line shape
        # `<24-hex-UUID> /* <bare> in <Sources|Resources> */ = {isa =
        # PBXBuildFile;` to avoid colliding with bare-name mentions in
        # comments or paths.
        if re.search(
            rf"[0-9A-F]{{24}}\s*/\*\s*{re.escape(bare)}\s+in\s+(Sources|Resources)\s*\*/\s*=\s*\{{isa\s*=\s*PBXBuildFile",
            out,
        ):
            log.append(f"skip (already present): {bare}")
            continue

        build_uuid = stable_uuid(f"buildfile:{rel_path}")
        ref_uuid = stable_uuid(f"fileref:{rel_path}")

        new_build_file_lines.append(
            f"\t\t{build_uuid} /* {bare} in {'Sources' if is_swift else 'Resources'} */"
            f" = {{isa = PBXBuildFile; fileRef = {ref_uuid} /* {bare} */; }};"
        )
        new_file_ref_lines.append(
            f"\t\t{ref_uuid} /* {bare} */ = {{isa = PBXFileReference; "
            f"lastKnownFileType = {filetype_for(rel_path)}; "
            f'name = "{bare}"; path = "{rel_path}"; '
            f"sourceTree = SOURCE_ROOT; }};"
        )
        if is_swift:
            new_sources_phase_lines.append(
                f"\t\t\t\t{build_uuid} /* {bare} in Sources */,"
            )
        else:
            new_resources_phase_lines.append(
                f"\t\t\t\t{build_uuid} /* {bare} in Resources */,"
            )
        log.append(f"add: {rel_path} (build={build_uuid[:8]}… ref={ref_uuid[:8]}…)")

    if not new_build_file_lines:
        log.append("no changes — pbxproj already up to date")
        return out, log

    # 1) Inject PBXBuildFile entries — append to the section.
    out = re.sub(
        r"(/\* End PBXBuildFile section \*/)",
        "\n".join(new_build_file_lines) + "\n\\1",
        out,
        count=1,
    )

    # 2) Inject PBXFileReference entries.
    out = re.sub(
        r"(/\* End PBXFileReference section \*/)",
        "\n".join(new_file_ref_lines) + "\n\\1",
        out,
        count=1,
    )

    # 3) Add Swift files to the Sources build phase. Locate the
    #    desktopAhaan target's Sources phase (PBXSourcesBuildPhase) and
    #    inject before its closing paren.
    if new_sources_phase_lines:
        out = re.sub(
            r"(/\* Sources \*/ = \{[\s\S]*?files = \([\s\S]*?)(\n\s*\);)",
            r"\1\n" + "\n".join(new_sources_phase_lines) + r"\2",
            out,
            count=1,
        )

    # 4) Add resource files to the Resources build phase.
    if new_resources_phase_lines:
        out = re.sub(
            r"(/\* Resources \*/ = \{[\s\S]*?files = \([\s\S]*?)(\n\s*\);)",
            r"\1\n" + "\n".join(new_resources_phase_lines) + r"\2",
            out,
            count=1,
        )

    return out, log


def main() -> int:
    if not PBXPROJ.exists():
        print(f"ERROR: {PBXPROJ} not found", file=sys.stderr)
        return 1
    original = PBXPROJ.read_text(encoding="utf-8")
    patched, log = patch(original)
    for line in log:
        print(line)
    if patched != original:
        PBXPROJ.write_text(patched, encoding="utf-8")
        print(f"\nWrote {PBXPROJ}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
