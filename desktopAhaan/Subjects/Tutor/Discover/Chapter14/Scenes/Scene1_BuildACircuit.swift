import SwiftUI

/// Scene 1 — Build a Circuit. Toggle cell + switch; bulb lights only when
/// both are present and the switch is closed. Wires are drawn as a real
/// rectangular loop that "lights up" when current flows.
struct Scene1_BuildACircuit: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var hasCell = true
    @State private var switchOn = false

    private var glowing: Bool { hasCell && switchOn }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Build a Circuit").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Connect a cell, close the switch, and watch the bulb glow.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                ZStack {
                    CircuitWires(active: glowing)
                        .frame(width: 360, height: 220)

                    VStack(spacing: 20) {
                        HStack {
                            // Cell on the left
                            VStack(spacing: DesignTokens.Spacing.xxs) {
                                Text(hasCell ? "🔋" : "🪫")
                                    .font(.system(size: 44))
                                    .opacity(hasCell ? 1 : 0.35)
                                Text("Cell").font(.caption2)
                            }
                            Spacer()
                            // Bulb on the right
                            VStack(spacing: DesignTokens.Spacing.xxs) {
                                Text("💡")
                                    .font(.system(size: 50))
                                    .opacity(glowing ? 1 : 0.25)
                                    .shadow(color: .yellow.opacity(glowing ? 0.8 : 0), radius: glowing ? 8 : 0)
                                Text("Bulb").font(.caption2)
                            }
                        }
                        .padding(.horizontal, 50)

                        // Switch at the bottom
                        VStack(spacing: DesignTokens.Spacing.xxs) {
                            Text(switchOn ? "🔘" : "⚪")
                                .font(.system(size: 32))
                            Text("Switch").font(.caption2)
                        }
                    }
                    .frame(width: 360, height: 220)
                }

                HStack(spacing: DesignTokens.Spacing.xl) {
                    Toggle("Cell connected",   isOn: $hasCell)
                    Toggle("Switch ON",        isOn: $switchOn)
                }
                .frame(maxWidth: 400)

                Text(glowing ? "✅ Circuit complete — current flows!" : "⛔ Open circuit — no current")
                    .font(.headline)
                    .foregroundColor(glowing ? .green : .secondary)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        Label("Closed loop = current", systemImage: "bolt.fill")
                            .font(.title2.bold())
                        Text("Electric current flows only when there's an unbroken path from one terminal of a cell, through a conductor, and back to the other terminal. Open the switch anywhere and the loop breaks.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, DesignTokens.Spacing.xl)

                // Grouped so the outer VStack stays within Swift 5.5's
                // 10-child ViewBuilder limit.
                Group {
                    ProcessTimeline(
                        title: "How current flows when you close the switch",
                        steps: [
                            .init(title: "Cell pushes electrons",
                                  detail: "The chemical reaction inside the cell creates a voltage — a 'push' that lifts electrons up to the negative terminal."),
                            .init(title: "Electrons enter the wire",
                                  detail: "Once the switch is closed, electrons flow from the negative terminal into the copper wire. Each electron nudges the next — like marbles in a tube."),
                            .init(title: "Electrons reach the bulb",
                                  detail: "The bulb's filament is a thin tungsten wire. Electrons squeezing through it bump into atoms — friction heats the metal until it glows."),
                            .init(title: "Electrons return to the cell",
                                  detail: "Electrons leaving the bulb travel back along the second wire to the cell's positive terminal — the loop is complete."),
                            .init(title: "Open the switch → flow stops",
                                  detail: "Break the loop anywhere — switch off, wire cut, bulb burnt — and the whole chain stops instantly. No closed path = no current.")
                        ],
                        accent: .yellow
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)

                    LookingAheadCallout(
                        title: "Class 10 / 12 Physics → JEE",
                        detail: "The closed-loop idea you just toggled is what Class 10 calls Ohm's Law (V = IR) and what Class 12 turns into Kirchhoff's Voltage and Current Laws (KVL/KCL). JEE/NEET both expect fluent circuit analysis."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)

                    TryAtHomeCallout(
                        title: "Smallest possible circuit",
                        detail: "Find a fresh AA cell, a small bulb (the kind in physics kits with two wires already attached), and a piece of insulated copper wire. Touch the bulb wires to the cell terminals via the copper. The bulb glows — that's a closed loop you built with your own hands."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)

                    GotItButton { onComplete() }.padding(.bottom, DesignTokens.Spacing.md)
                    Spacer(minLength: 0)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// Rectangular wire loop. When `active`, draws in solid indigo; otherwise
/// faded grey to show the path but signal no current.
private struct CircuitWires: View {
    let active: Bool

    var body: some View {
        GeometryReader { geo in
            let inset: CGFloat = 24
            let rect = CGRect(x: inset, y: inset,
                              width: geo.size.width - inset * 2,
                              height: geo.size.height - inset * 2)
            Path { p in
                p.addRoundedRect(in: rect, cornerSize: CGSize(width: 18, height: 18))
            }
            .stroke(active ? Color.compatIndigo : Color.gray.opacity(0.35),
                    style: StrokeStyle(lineWidth: active ? 4 : 3))
        }
    }
}
