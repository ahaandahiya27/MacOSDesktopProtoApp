import SwiftUI
import AppKit

// MARK: - ShapeDiagramRegistry
//
// Lookup table mapping a `MediaAsset.resource` string (used when the
// asset's `kind == .shapeDiagram`) to a SwiftUI view factory that
// renders the diagram.
//
// State today (2026-05-23): the registry is intentionally EMPTY —
// authoring 76 chapter-specific shape diagrams was out of scope for
// the surface-the-content session. `MediaAssetView` falls back to a
// placeholder card for unregistered keys, so packs ship cleanly even
// without entries here.
//
// Adding a new diagram:
//   1. Build the view (e.g. a SwiftUI Shape composition) — typically
//      a few dozen lines.
//   2. Register it under its `resource` key by adding an entry to
//      `Self.registrations`.
//   3. Re-build; the chapter's MediaAssetGallery picks it up
//      automatically.

enum ShapeDiagramRegistry {
    typealias Factory = () -> AnyView

    /// Returns the factory for `key`, or nil if no diagram has been
    /// registered for that resource id. `MediaAssetView` shows a
    /// placeholder when nil.
    static func factory(for key: String) -> Factory? {
        return registrations[key]
    }

    /// Map of registered diagrams. Populated one chapter-slice at a time
    /// (v7 Phase 3). Keys follow `chNN_<short_name>`, matching the JSON
    /// `resource` values of each `shapeDiagram` MediaAsset. Unregistered
    /// keys still render the placeholder card cleanly.
    private static let registrations: [String: Factory] = [
        // ch01 — Nutrition in Plants
        "ch01_chloroplast": { AnyView(ChloroplastDiagram()) },
        "ch01_stomata": { AnyView(StomataDiagram()) },
        "ch01_photosynthesis_equation": { AnyView(PhotosynthesisEquationDiagram()) },
        "ch01_leaf_anatomy": { AnyView(LeafAnatomyDiagram()) },
        // ch02 — Nutrition in Animals
        "ch02_digestive_system": { AnyView(DigestiveSystemDiagram()) },
        "ch02_villi": { AnyView(VilliDiagram()) },
        "ch02_tooth_types": { AnyView(ToothTypesDiagram()) },
        "ch02_rumen": { AnyView(RumenDiagram()) },
        // ch03 — Fibre to Fabric (wool & silk)
        "ch03_wool_process": { AnyView(WoolProcessDiagram()) },
        "ch03_silkworm_lifecycle": { AnyView(SilkwormLifecycleDiagram()) },
        "ch03_polymer_chain": { AnyView(PolymerChainDiagram()) },
        "ch03_fibre_compare": { AnyView(FibreCompareDiagram()) },
        // ch04 — Heat
        "ch04_thermometer": { AnyView(ThermometerDiagram()) },
        "ch04_three_modes": { AnyView(ThreeModesDiagram()) },
        "ch04_thermos_flask": { AnyView(ThermosFlaskDiagram()) },
        "ch04_sea_breeze": { AnyView(SeaBreezeDiagram()) },
        // ch05 — Acids, Bases and Salts
        "ch05_ph_scale": { AnyView(PHScaleDiagram()) },
        "ch05_neutralisation": { AnyView(NeutralisationDiagram()) },
        "ch05_indicators": { AnyView(IndicatorsDiagram()) },
        "ch05_tooth_decay": { AnyView(ToothDecayDiagram()) },
        // ch06 — Physical and Chemical Changes
        "ch06_physical_vs_chemical": { AnyView(PhysicalVsChemicalDiagram()) },
        "ch06_rust_formation": { AnyView(RustFormationDiagram()) },
        "ch06_crystallization": { AnyView(CrystallizationDiagram()) },
        "ch06_balanced_equation": { AnyView(BalancedEquationDiagram()) },
        // ch07 — Weather, Climate and Adaptations
        "ch07_atmosphere_layers": { AnyView(AtmosphereLayersDiagram()) },
        "ch07_monsoon_winds": { AnyView(MonsoonWindsDiagram()) },
        "ch07_polar_adapt": { AnyView(PolarAdaptDiagram()) },
        "ch07_climate_zones": { AnyView(ClimateZonesDiagram()) },
        // ch08 — Winds, Storms and Cyclones
        "ch08_high_low_pressure": { AnyView(HighLowPressureDiagram()) },
        "ch08_cyclone_spiral": { AnyView(CycloneSpiralDiagram()) },
        "ch08_coriolis": { AnyView(CoriolisDiagram()) },
        "ch08_thunderstorm": { AnyView(ThunderstormDiagram()) },
        // ch09 — Soil
        "ch09_soil_profile": { AnyView(SoilProfileDiagram()) },
        "ch09_soil_types": { AnyView(SoilTypesDiagram()) },
        "ch09_erosion": { AnyView(ErosionDiagram()) },
        "ch09_contour_terracing": { AnyView(ContourTerracingDiagram()) },
        // ch10 — Respiration in Organisms
        "ch10_lung_anatomy": { AnyView(LungAnatomyDiagram()) },
        "ch10_alveolus": { AnyView(AlveolusDiagram()) },
        "ch10_mitochondrion": { AnyView(MitochondrionDiagram()) },
        "ch10_gas_exchange": { AnyView(GasExchangeDiagram()) },
        // ch11 — Transportation in Animals and Plants
        "ch11_heart_4chambers": { AnyView(HeartChambersDiagram()) },
        "ch11_nephron": { AnyView(NephronDiagram()) },
        "ch11_xylem_phloem": { AnyView(XylemPhloemDiagram()) },
        "ch11_blood_cells": { AnyView(BloodCellsDiagram()) },
        // ch12 — Reproduction in Plants
        "ch12_flower_anatomy": { AnyView(FlowerAnatomyDiagram()) },
        "ch12_pollen_tube": { AnyView(PollenTubeDiagram()) },
        "ch12_seed_dispersal": { AnyView(SeedDispersalDiagram()) },
        "ch12_vegetative": { AnyView(VegetativeDiagram()) },
        // ch13 — Motion and Time
        "ch13_distance_time": { AnyView(DistanceTimeDiagram()) },
        "ch13_pendulum": { AnyView(PendulumDiagram()) },
        "ch13_clock_history": { AnyView(ClockHistoryDiagram()) },
        "ch13_speed_compare": { AnyView(SpeedCompareDiagram()) },
        // ch14 — Electric Current and Its Effects
        "ch14_simple_circuit": { AnyView(SimpleCircuitDiagram()) },
        "ch14_electromagnet": { AnyView(ElectromagnetDiagram()) },
        "ch14_fuse_mcb": { AnyView(FuseMCBDiagram()) },
        "ch14_orsted": { AnyView(OerstedDiagram()) },
        // ch15 — Light
        "ch15_reflection_law": { AnyView(ReflectionLawDiagram()) },
        "ch15_prism": { AnyView(PrismDiagram()) },
        "ch15_lens_types": { AnyView(LensTypesDiagram()) },
        "ch15_periscope": { AnyView(PeriscopeDiagram()) },
        // ch16 — Water: A Precious Resource
        "ch16_water_cycle": { AnyView(WaterCycleDiagram()) },
        "ch16_aquifer": { AnyView(AquiferDiagram()) },
        "ch16_drip_system": { AnyView(DripSystemDiagram()) },
        "ch16_baori": { AnyView(BaoriDiagram()) },
        // ch17 — Forests: Our Lifeline
        "ch17_forest_layers": { AnyView(ForestLayersDiagram()) },
        "ch17_food_pyramid": { AnyView(FoodPyramidDiagram()) },
        "ch17_nutrient_cycle": { AnyView(NutrientCycleDiagram()) },
        "ch17_deforestation": { AnyView(DeforestationDiagram()) },
        // ch18 — Wastewater Story
        "ch18_wwtp_flow": { AnyView(WWTPFlowDiagram()) },
        "ch18_sulabh_toilet": { AnyView(SulabhToiletDiagram()) },
        "ch18_biogas_plant": { AnyView(BiogasPlantDiagram()) },
        "ch18_septic_tank": { AnyView(SepticTankDiagram()) },
        // ch19 — Stars and the Solar System
        "ch19_earth_tilt": { AnyView(EarthTiltDiagram()) },
        "ch19_moon_phases": { AnyView(MoonPhasesDiagram()) },
        "ch19_solar_system": { AnyView(SolarSystemDiagram()) },
        "ch19_eclipse": { AnyView(EclipseDiagram()) }
    ]

    /// Resource keys with a registered diagram (sorted). Exposed so a test
    /// can assert the covered set without reflecting over the private map.
    static var registeredKeys: [String] { registrations.keys.sorted() }
}
