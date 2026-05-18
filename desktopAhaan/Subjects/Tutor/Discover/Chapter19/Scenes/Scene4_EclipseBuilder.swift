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
        // Refactored ZStack-overlap pattern to ScrollView+VStack so
        // explanation cards don't cover the interactive content.
        ScrollView {
            VStack(spacing: 14) {
                VStack(spacing: 16) {
                    Text("Eclipse Builder")
                        .font(.title2.bold())
                        .padding(.top, 14)

                    Text("\(explored.count) / 2 eclipses explored")
                        .font(.caption.weight(.medium))
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

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
                                            .foregroundColor(.green)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(isSelected ? Color.accentColor.opacity(0.15) : Color.white)
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

                Group {
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label(selectedType.rawValue, systemImage: selectedType == .solar ? "sun.max.fill" : "moon.fill")
                                .font(.title2.bold())
                                .foregroundColor(selectedType == .solar ? .orange : Color.compatIndigo)

                            Text(explanationText(for: selectedType))
                                .font(.body)
                                .lineSpacing(4)

                            Text("Not every New or Full Moon causes an eclipse because the Moon's orbit is tilted about 5 degrees relative to Earth's orbit around the Sun.")
                                .font(.callout)
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                                .lineSpacing(3)
                                .padding(.top, 4)
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    LookingAheadCallout(
                        title: "Class 11/12 Physics → JEE / NEET (Optics + Geometry)",
                        detail: "Solar eclipse possible because the Sun is 400× larger than the Moon AND 400× farther — they appear the same size from Earth. A cosmic coincidence, not a design. JEE asks the similar-triangles geometry. NEET asks 'why don't eclipses happen every month?' Answer: the Moon's orbit is tilted 5° to Earth's orbit — eclipses only when the three align in 3D, not 2D."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    TryAtHomeCallout(
                        title: "Simulate an eclipse with a ball and a lamp",
                        detail: "In a dark room, place a desk lamp (Sun). Hold a tennis ball (Moon) between you and the lamp at arm's length. Your face is in the Moon's shadow = a tiny solar eclipse. Move the ball aside — the lamp lights your face again. Reverse it (lamp behind you, ball in front lit by lamp) — that's a lunar eclipse, where Earth's shadow falls on the Moon."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    if allExplored {
                        GotItButton { onComplete() }
                            .padding(.bottom, 12)
                    }
                
                }
                .padding(.horizontal, 24)
            
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
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
                .font(.system(.caption, design: .monospaced).weight(.medium))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
    }

    private func celestialBody(_ name: String, color: Color, size: CGFloat) -> some View {
        VStack(spacing: 4) {
            Circle()
                .fill(color)
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
