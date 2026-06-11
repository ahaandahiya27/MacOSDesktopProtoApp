import SwiftUI
import AppKit

// MARK: - BuildASoilSandbox
//
// Three-slider sandbox for Ch.9 (Soil). The student sets the
// proportions of sand, clay, and silt — the three particle-size
// classes that define every soil. The widget normalises the three
// sliders to sum to 1.0 and renders the resulting USDA soil-texture
// triangle classification (sandy, loam, silty clay, etc.) plus two
// derived properties: percolation rate and water retention.
//
// Pedagogical hook: the kid can directly feel why loam is the
// agricultural ideal — high sand drains too fast, high clay holds
// water but suffocates roots. Loam (mixed) is the goldilocks zone.

struct BuildASoilSandbox: View {
    let chapterId: String

    @SceneStorage private var sand: Double
    @SceneStorage private var clay: Double
    @State private var isShowingExplainer: Bool = false

    init(chapterId: String) {
        self.chapterId = chapterId
        self._sand = SceneStorage(wrappedValue: 0.40, "sandbox.\(chapterId).sand")
        self._clay = SceneStorage(wrappedValue: 0.30, "sandbox.\(chapterId).clay")
    }

    // MARK: - Model
    //
    // Silt is the dependent variable: silt = 1 - sand - clay,
    // clamped to 0. The two free sliders are sand and clay.

    private var silt: Double { max(0, 1.0 - sand - clay) }
    private var totalShown: Double { sand + clay + silt }

    private var percolationRate: Double {
        // High sand drains fast; high clay drains slow.
        let raw = 0.95 * sand + 0.40 * silt + 0.05 * clay
        return max(0, min(1, raw))
    }

    private var waterRetention: Double {
        // Inverse of drain — high clay retains; high sand doesn't.
        let raw = 0.10 * sand + 0.55 * silt + 0.95 * clay
        return max(0, min(1, raw))
    }

    private var fertilityScore: Double {
        // Loam (balanced sand/silt/clay around equal thirds) is best.
        // Penalty grows quadratically as any component dominates.
        let ideal = 1.0 / 3.0
        let penalty = pow(sand - ideal, 2) + pow(clay - ideal, 2) + pow(silt - ideal, 2)
        return max(0, min(1, 1.0 - penalty * 2.5))
    }

    private var textureLabel: String {
        if sand > 0.70 { return "Sandy" }
        if clay > 0.55 { return "Heavy clay" }
        if clay > 0.40 && sand < 0.25 { return "Silty clay" }
        if sand > 0.45 && clay < 0.20 { return "Sandy loam" }
        if silt > 0.55 { return "Silt loam" }
        if abs(sand - 1.0/3.0) < 0.15 && abs(clay - 1.0/3.0) < 0.15 {
            return "Loam (ideal)"
        }
        return "Clay loam"
    }

    private var soilColor: Color {
        if sand > 0.70 { return DesignTokens.BrandColor.mnemonic }
        if clay > 0.55 { return DesignTokens.BrandColor.tryAtHome }
        if silt > 0.55 { return Color.compatBrown }
        return DesignTokens.BrandColor.relatedConcepts
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            slidersBlock
            compositionBar
            outputBlock
            explainerToggle
            if isShowingExplainer {
                explainerBody
            }
        }
        .padding(DesignTokens.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.compatBrown.opacity(0.10))
        )
        .respectReduceMotion(animation: .easeInOut(duration: 0.22))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Build-a-soil sandbox")
        .accessibilityHint("Two sliders set sand and clay proportions. Silt is the rest. The output classifies the soil and rates its percolation, retention, and fertility.")
    }

    private var header: some View {
        HStack(spacing: 10) {
            Image(systemName: SFSymbolCompat.name("square.layers.3d.fill"))
                .font(.title3)
                .foregroundColor(Color.compatBrown)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                Text("Build-a-Soil sandbox")
                    .font(.headline)
                Text("Mix sand, clay, and silt — which combination is best for farming?")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
        }
    }

    private var slidersBlock: some View {
        VStack(spacing: 10) {
            SoilSliderRow(
                label: "Sand (large grains)", value: $sand,
                color: DesignTokens.BrandColor.mnemonic, symbol: "circle.grid.3x3.fill")
            SoilSliderRow(
                label: "Clay (fine particles)", value: $clay,
                color: DesignTokens.BrandColor.tryAtHome, symbol: "circle.fill")
            HStack(spacing: 6) {
                Image(systemName: SFSymbolCompat.name("smallcircle.filled.circle"))
                    .font(.caption)
                    .foregroundColor(Color.compatBrown)
                    .accessibilityHidden(true)
                Text("Silt (medium — the rest)")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.primary)
                Spacer()
                Text("\(Int(silt * 100))%")
                    .font(.caption.monospacedDigit())
                    .foregroundColor(.secondary)
            }
        }
    }

    /// Stacked horizontal bar showing the three components.
    private var compositionBar: some View {
        GeometryReader { geo in
            let sandWidth: CGFloat = geo.size.width * CGFloat(sand)
            let siltWidth: CGFloat = geo.size.width * CGFloat(silt)
            let clayWidth: CGFloat = geo.size.width * CGFloat(clay)
            HStack(spacing: 0) {
                Rectangle()
                    .fill(DesignTokens.BrandColor.mnemonic)
                    .frame(width: sandWidth)
                Rectangle()
                    .fill(Color.compatBrown)
                    .frame(width: siltWidth)
                Rectangle()
                    .fill(DesignTokens.BrandColor.tryAtHome)
                    .frame(width: clayWidth)
            }
            .cornerRadius(7)
            .respectReduceMotion(animation: .easeOut(duration: 0.32))
        }
        .frame(height: 14)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Soil composition: \(Int(sand * 100))% sand, \(Int(silt * 100))% silt, \(Int(clay * 100))% clay.")
    }

    private var outputBlock: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            HStack {
                Text("Soil type")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Spacer()
                Text(textureLabel)
                    .font(.caption.weight(.bold))
                    .foregroundColor(soilColor)
            }
            HStack {
                Text("Percolation rate")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(Int(percolationRate * 100))%")
                    .font(.caption.monospacedDigit().weight(.bold))
                    .foregroundColor(.primary)
            }
            HStack {
                Text("Water retention")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(Int(waterRetention * 100))%")
                    .font(.caption.monospacedDigit().weight(.bold))
                    .foregroundColor(.primary)
            }
            HStack {
                Text("Fertility (loam = best)")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(Int(fertilityScore * 100))%")
                    .font(.caption.monospacedDigit().weight(.bold))
                    .foregroundColor(DesignTokens.BrandColor.primaryAction)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Soil output")
        .accessibilityValue("\(textureLabel). Percolation \(Int(percolationRate * 100)) percent. Retention \(Int(waterRetention * 100)) percent. Fertility \(Int(fertilityScore * 100)) percent.")
    }

    private var explainerToggle: some View {
        Button(action: {
            withAnimationRespectingReduceMotion(.easeOut(duration: 0.18)) {
                isShowingExplainer.toggle()
            }
        }) {
            HStack(spacing: 6) {
                Image(systemName: isShowingExplainer ? "chevron.down" : "chevron.right")
                    .font(.caption.weight(.bold))
                Text(isShowingExplainer ? "Hide explanation" : "Why is loam the ideal?")
                    .font(.caption.weight(.semibold))
            }
            .foregroundColor(DesignTokens.BrandColor.relatedConcepts)
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityHint("Reveals a short explanation of why loam is the agricultural sweet spot.")
    }

    private var explainerBody: some View {
        Text("Soil is classified by the size of its mineral particles. Sand grains are large (0.05–2 mm) and leave big pores — water drains fast, but roots and nutrients flush out too. Clay particles are tiny (<0.002 mm) and pack tight — they hold water and nutrients well, but the pores are so small that roots suffocate. Silt sits between (0.002–0.05 mm). Loam — roughly equal parts of all three — gives roots air AND water AND nutrient grip. Almost every productive farmland in India is some kind of loam.")
            .font(.callout)
            .foregroundColor(.primary)
            .lineSpacing(3)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, DesignTokens.Spacing.xs)
            .transition(.opacity)
            .accessibilityHint("Plain-language explanation of why loam soils are agriculturally ideal.")
    }
}

// MARK: - SoilSliderRow

private struct SoilSliderRow: View {
    let label: String
    @Binding var value: Double
    let color: Color
    let symbol: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(spacing: 6) {
                Image(systemName: SFSymbolCompat.name(symbol))
                    .font(.caption)
                    .foregroundColor(color)
                    .accessibilityHidden(true)
                Text(label)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.primary)
                Spacer()
                Text("\(Int(value * 100))%")
                    .font(.caption.monospacedDigit())
                    .foregroundColor(.secondary)
            }
            Slider(value: $value, in: 0...1)
                .accentColor(color)
                .accessibilityLabel(label)
                .accessibilityValue("\(Int(value * 100)) percent")
                .accessibilityHint("Drag to change the proportion of \(label.lowercased()).")
        }
    }
}
