import SwiftUI

/// Scene 4 — Eclipse Builder.
/// Two tabs: Solar Eclipse and Lunar Eclipse. Each shows Sun, Earth, Moon alignment diagram.
/// User explores both to unlock GotIt.
struct Scene4_EclipseBuilder: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    private enum EclipseType: String, CaseIterable, Identifiable {
        case solar = "Solar Eclipse"
        case lunar = "Lunar Eclipse"
        var id: String { rawValue }
    }

    @State private var selectedType: EclipseType = .solar
    @State private var explored: Set<String> = []
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var allExplored: Bool { explored.count == EclipseType.allCases.count }

    var body: some View {
        GeometryReader { _ in
            ZStack {
                VStack(spacing: 16) {
                    Text("Eclipse Builder")
                        .font(.title2.bold())
                        .padding(.top, 14)

                    Text("\(explored.count) / 2 eclipses explored")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)

                    // Tab picker
                    HStack(spacing: 12) {
                        ForEach(EclipseType.allCases) { type in
                            let isSelected = selectedType == type
                            let isExplored = explored.contains(type.id)

                            Button {
                                withAnimation(reduceMotion ? .none : .spring()) {
                                    selectedType = type
                                    explored.insert(type.id)
                                }
                            } label: {
                                HStack(spacing: 6) {
                                    Text(type.rawValue)
                                        .font(.body.weight(.semibold))
                                    if isExplored {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.caption)
                                            .foregroundStyle(.green)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(isSelected ? Color.accentColor.opacity(0.15) : Color(nsColor: .windowBackgroundColor))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .strokeBorder(isSelected ? Color.accentColor : .gray.opacity(0.25), lineWidth: 1.5)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    // Diagram
                    eclipseDiagram(for: selectedType)
                        .frame(maxWidth: 500, maxHeight: 180)
                        .padding(.top, 8)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)

                VStack(spacing: 14) {
                    Spacer()

                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label(selectedType.rawValue, systemImage: selectedType == .solar ? "sun.max.fill" : "moon.fill")
                                .font(.title2.bold())
                                .foregroundStyle(selectedType == .solar ? .orange : .indigo)

                            Text(explanationText(for: selectedType))
                                .font(.body)
                                .lineSpacing(4)

                            Text("Not every New or Full Moon causes an eclipse because the Moon's orbit is tilted about 5 degrees relative to Earth's orbit around the Sun.")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                                .lineSpacing(3)
                                .padding(.top, 4)
                        }
                    }
                    .frame(maxWidth: 640)

                    if allExplored {
                        GotItButton { onComplete() }
                            .padding(.bottom, 12)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
        }
    }

    // MARK: - Diagram

    @ViewBuilder
    private func eclipseDiagram(for type: EclipseType) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 0) {
                switch type {
                case .solar:
                    // Sun — Moon — Earth
                    celestialBody("Sun", color: .yellow, size: 70)
                    Spacer()
                    shadowBeam(color: .gray.opacity(0.25))
                    Spacer()
                    celestialBody("Moon", color: .gray, size: 32)
                    Spacer()
                    shadowBeam(color: .gray.opacity(0.15))
                    Spacer()
                    celestialBody("Earth", color: .blue, size: 50)

                case .lunar:
                    // Sun — Earth — Moon
                    celestialBody("Sun", color: .yellow, size: 70)
                    Spacer()
                    shadowBeam(color: .blue.opacity(0.2))
                    Spacer()
                    celestialBody("Earth", color: .blue, size: 50)
                    Spacer()
                    shadowBeam(color: .blue.opacity(0.15))
                    Spacer()
                    celestialBody("Moon", color: .red.opacity(0.6), size: 32)
                }
            }
            .padding(.horizontal, 24)

            Text(type == .solar
                 ? "Sun  >>>  Moon  >>>  Earth"
                 : "Sun  >>>  Earth  >>>  Moon")
                .font(.caption.weight(.medium).monospaced())
                .foregroundStyle(.secondary)
        }
    }

    private func celestialBody(_ name: String, color: Color, size: CGFloat) -> some View {
        VStack(spacing: 4) {
            Circle()
                .fill(color.gradient)
                .frame(width: size, height: size)
                .shadow(color: color.opacity(0.4), radius: 6)
            Text(name)
                .font(.caption.weight(.semibold))
        }
    }

    private func shadowBeam(color: Color) -> some View {
        Rectangle()
            .fill(color)
            .frame(height: 4)
            .frame(maxWidth: 40)
    }

    // MARK: - Explanation

    private func explanationText(for type: EclipseType) -> String {
        switch type {
        case .solar:
            return "During a solar eclipse, the Moon passes between the Sun and Earth, blocking the Sun's light. The Moon's shadow falls on a small area of Earth. This can only happen at New Moon, when the Moon is between Earth and the Sun."
        case .lunar:
            return "During a lunar eclipse, Earth passes between the Sun and the Moon, blocking sunlight from reaching the Moon. Earth's shadow falls on the Moon, often giving it a reddish colour. This can only happen at Full Moon, when Earth is between the Sun and the Moon."
        }
    }
}
