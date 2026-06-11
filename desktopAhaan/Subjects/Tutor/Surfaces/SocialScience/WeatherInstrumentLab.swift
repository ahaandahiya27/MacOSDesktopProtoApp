import SwiftUI

// MARK: - WeatherInstrumentLab
//
// Bespoke interactive for Social Science Ch.2 "Understanding the Weather"
// (`socialscience_class7` / ssch02). The chapter's spine is that weather is made
// of FIVE elements (ssch02_t01_c03) — temperature, precipitation, atmospheric
// pressure, wind and humidity — and that each is read with its own instrument:
// the thermometer (t02_c01), rain gauge (t02_c03), barometer (t03_c01), wind vane
// & anemometer (t03_c03) and hygrometer (t04_c01).
//
// This widget upgrades ssch02 from the generic glossary-match to a chapter-
// specific "weather station" lab. Tap an element to see which instrument measures
// it, the unit it is read in, a real sample reading the chapter itself gives
// (15 °C = 59 °F, 5 mm of rain, ~1013 mb at the coast, 60–80% humidity in humid
// weather), and a kid-friendly note on how the instrument works. Every fact is
// straight from ssch02_t01–t04.
//
// Big Sur compat: self-contained, @SceneStorage (namespaced by chapter),
// Color(red:green:blue:), SFSymbolCompat (SF Symbols 1 only), RM-gated motion,
// VoiceOver labels. No macOS 12+ APIs (no .animation(_:value:)), no force-unwraps.

struct WeatherInstrumentLab: View {
    let chapterId: String

    @SceneStorage private var selected: Int
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(chapterId: String) {
        self.chapterId = chapterId
        self._selected = SceneStorage(wrappedValue: 0, "ssinteractive.\(chapterId).weatherlab")
    }

    private let skyBlue = Color(red: 0.16, green: 0.40, blue: 0.62)

    // MARK: - The five elements of weather (grounded in ssch02_t01_c03 + instruments)

    private struct Element {
        let name: String
        let symbol: String
        let instrument: String
        let unit: String
        let reading: String     // a real sample reading from the chapter
        let how: String         // kid-friendly "how it works"
    }

    private let elements: [Element] = [
        Element(
            name: "Temperature",
            symbol: "thermometer",
            instrument: "Thermometer",
            unit: "°C / °F",
            reading: "A cool 15 °C is the same as 59 °F.",
            how: "Many thermometers hold a coloured liquid that expands and rises up a tube when it gets warmer, and sinks when it cools. Digital ones are more precise and can record lots of data."),
        Element(
            name: "Precipitation",
            symbol: "cloud.rain.fill",
            instrument: "Rain gauge",
            unit: "millimetres (mm)",
            reading: "If the collected water is 5 mm deep, the area got 5 mm of rainfall.",
            how: "Rain falls into a funnel, collects in a cylinder, and a scale on the side measures how deep the water is. If snow falls, we let it melt first before measuring."),
        Element(
            name: "Atmospheric Pressure",
            symbol: "gauge",
            instrument: "Barometer",
            unit: "millibars (mb)",
            reading: "Normal pressure at the coast is about 1013 mb; below 1000 mb means a 'depression'.",
            how: "There is a whole ocean of air above your head, and it has weight pressing down. Pressure is higher near the coast and lower high in the mountains, where the air is thinner — that is why climbers can feel breathless."),
        Element(
            name: "Wind",
            symbol: "wind",
            instrument: "Wind vane + Anemometer",
            unit: "direction + km/h",
            reading: "A wind vane points to where the wind comes FROM; an anemometer reads its SPEED in km/h.",
            how: "The vane's tail is pushed by the wind so the pointer swings to show its direction. The anemometer has three or four cups that spin faster the stronger the wind, and a meter counts the spins to work out the speed."),
        Element(
            name: "Humidity",
            symbol: "drop.fill",
            instrument: "Hygrometer",
            unit: "relative humidity (%)",
            reading: "Dry weather is usually 20–40%; humid weather is 60–80%.",
            how: "Humidity is how much water vapour (water as an invisible gas) is in the air. 100% means the air is completely full of vapour — that is when sweat and wet clothes dry slowly and you feel sticky.")
    ]

    private var current: Element { elements[max(0, min(selected, elements.count - 1))] }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            chipWrap
            detailPanel
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                .fill(Color.white.opacity(0.92))
                .overlay(RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                    .strokeBorder(skyBlue.opacity(0.28), lineWidth: 1))
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text("The weather station")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Weather is made of five elements — each read with its own instrument. Tap one to step up to the instrument.")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // Manual wrapping into rows of up to 2 (element names are long).
    private var chipWrap: some View {
        let rows = stride(from: 0, to: elements.count, by: 2).map { start -> [Int] in
            Array(elements.indices[start..<min(start + 2, elements.count)])
        }
        return VStack(alignment: .leading, spacing: 7) {
            ForEach(rows.indices, id: \.self) { r in
                HStack(spacing: 7) {
                    ForEach(rows[r], id: \.self) { idx in chip(idx) }
                    Spacer(minLength: 0)
                }
            }
        }
    }

    private func chip(_ idx: Int) -> some View {
        let element = elements[idx]
        let on = selected == idx
        return Button { selectElement(idx) } label: {
            HStack(spacing: 6) {
                Image(systemName: SFSymbolCompat.name(element.symbol))
                    .font(.caption)
                    .accessibilityHidden(true)
                Text(element.name)
                    .font(.caption.weight(.semibold))
            }
            .foregroundColor(on ? .white : DesignTokens.BrandColor.canvasText)
            .padding(.horizontal, DesignTokens.Spacing.md).padding(.vertical, 7)
            .background(Capsule().fill(on ? skyBlue : skyBlue.opacity(0.10)))
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("\(element.name)\(on ? ", selected" : "")")
        .accessibilityHint("Tap to see which instrument measures \(element.name.lowercased()).")
    }

    private var detailPanel: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                Image(systemName: SFSymbolCompat.name(current.symbol))
                    .font(.title3)
                    .foregroundColor(skyBlue)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 1) {
                    Text(current.instrument)
                        .font(.subheadline.weight(.bold))
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    Text("measures \(current.name.lowercased()) · \(current.unit)")
                        .font(.caption2)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
            }
            detailRow(symbol: "number", text: current.reading)
            Text(current.how)
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.sm).fill(skyBlue.opacity(0.12)))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(current.name) is measured by the \(current.instrument) in \(current.unit). \(current.reading) \(current.how)")
    }

    private func detailRow(symbol: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: SFSymbolCompat.name(symbol))
                .font(.caption2)
                .foregroundColor(skyBlue)
                .accessibilityHidden(true)
            Text(text)
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func selectElement(_ idx: Int) {
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
            selected = idx
        }
    }
}
