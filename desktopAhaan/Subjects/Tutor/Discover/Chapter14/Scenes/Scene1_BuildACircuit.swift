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
        VStack(spacing: 14) {
            Text("Build a Circuit").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Connect a cell, close the switch, and watch the bulb glow.")
                .font(.callout).foregroundColor(.secondary)

            ZStack {
                CircuitWires(active: glowing)
                    .frame(width: 360, height: 220)

                VStack(spacing: 20) {
                    HStack {
                        // Cell on the left
                        VStack(spacing: 2) {
                            Text(hasCell ? "🔋" : "🪫")
                                .font(.system(size: 44))
                                .opacity(hasCell ? 1 : 0.35)
                            Text("Cell").font(.caption2)
                        }
                        Spacer()
                        // Bulb on the right
                        VStack(spacing: 2) {
                            Text("💡")
                                .font(.system(size: 50))
                                .opacity(glowing ? 1 : 0.25)
                                .shadow(color: .yellow.opacity(glowing ? 0.8 : 0), radius: glowing ? 8 : 0)
                            Text("Bulb").font(.caption2)
                        }
                    }
                    .padding(.horizontal, 50)

                    // Switch at the bottom
                    VStack(spacing: 2) {
                        Text(switchOn ? "🔘" : "⚪")
                            .font(.system(size: 32))
                        Text("Switch").font(.caption2)
                    }
                }
                .frame(width: 360, height: 220)
            }

            HStack(spacing: 24) {
                Toggle("Cell connected",   isOn: $hasCell)
                Toggle("Switch ON",        isOn: $switchOn)
            }
            .frame(maxWidth: 400)

            Text(glowing ? "✅ Circuit complete — current flows!" : "⛔ Open circuit — no current")
                .font(.headline)
                .foregroundColor(glowing ? .green : .secondary)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Closed loop = current", systemImage: "bolt.fill")
                        .font(.title2.bold())
                    Text("Electric current flows only when there's an unbroken path from one terminal of a cell, through a conductor, and back to the other terminal. Open the switch anywhere and the loop breaks.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 10 / 12 Physics → JEE",
                detail: "The closed-loop idea you just toggled is what Class 10 calls Ohm's Law (V = IR) and what Class 12 turns into Kirchhoff's Voltage and Current Laws (KVL/KCL). JEE/NEET both expect fluent circuit analysis."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
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
