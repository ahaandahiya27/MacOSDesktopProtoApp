import SwiftUI

/// Scene 7 — Fluffy Birds, Fluffy Sweaters.
/// Bird fluffs feathers in cold; trapped air pockets shown. Parallel sweater analogy.

struct Scene7_FluffyBirdsFluffySweaters: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var isCold = false
    @State private var showAirPockets = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GeometryReader { geo in
            ZStack {
                HStack(spacing: 40) {
                    // Bird side
                    VStack(spacing: 14) {
                        Text("Bird")
                            .font(.headline)

                        ZStack {
                            // Bird body
                            Ellipse()
                                .fill(LinearGradient(colors: [Color.compatBrown.opacity(0.6), Color.compatBrown.opacity(0.3)], startPoint: .top, endPoint: .bottom))
                                .frame(
                                    width: isCold ? 150 : 110,
                                    height: isCold ? 140 : 110
                                )
                                .animation(reduceMotion ? .none : .spring(response: 0.5))
                                .accessibilityLabel(isCold ? "Bird with fluffed feathers" : "Bird with normal feathers")

                            // Head
                            Circle()
                                .fill(Color.compatBrown.opacity(0.5))
                                .frame(width: 40, height: 40)
                                .offset(y: isCold ? -60 : -50)

                            // Beak
                            Triangle()
                                .fill(.orange)
                                .frame(width: 14, height: 10)
                                .offset(x: 18, y: isCold ? -58 : -48)

                            // Eye
                            Circle()
                                .fill(.black)
                                .frame(width: 6, height: 6)
                                .offset(x: 6, y: isCold ? -64 : -54)

                            // Air pocket dots
                            if showAirPockets {
                                ForEach(0..<8, id: \.self) { i in
                                    let angle = Double(i) * .pi / 4
                                    let r: CGFloat = isCold ? 50 : 35
                                    Circle()
                                        .fill(Color.compatCyan.opacity(0.4))
                                        .frame(width: 10, height: 10)
                                        .offset(
                                            x: cos(angle) * r,
                                            y: sin(angle) * r * 0.7
                                        )
                                }
                            }
                        }
                        .frame(height: 180)

                        Text(isCold ? "Feathers fluffed!" : "Normal feathers")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    // Sweater side
                    VStack(spacing: 14) {
                        Text("Sweater")
                            .font(.headline)

                        ZStack {
                            // Sweater body
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(LinearGradient(colors: [.red.opacity(0.7), .red.opacity(0.4)], startPoint: .top, endPoint: .bottom))
                                .frame(width: 120, height: 140)

                            // Sweater pattern lines
                            VStack(spacing: 12) {
                                ForEach(0..<5, id: \.self) { _ in
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.red.opacity(0.3))
                                        .frame(width: 90, height: 3)
                                }
                            }

                            // Air pocket dots in sweater
                            if showAirPockets {
                                ForEach(0..<6, id: \.self) { i in
                                    let row = i / 3
                                    let col = i % 3
                                    Circle()
                                        .fill(Color.compatCyan.opacity(0.4))
                                        .frame(width: 10, height: 10)
                                        .offset(
                                            x: CGFloat(col - 1) * 30,
                                            y: CGFloat(row) * 35 - 20
                                        )
                                }
                            }
                        }
                        .frame(height: 180)
                        .accessibilityLabel("Sweater with trapped air pockets")

                        Text(showAirPockets ? "Air pockets trap heat" : "Woollen sweater")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

                VStack(spacing: 14) {
                    // Button at top area
                    Button(isCold ? "Make it warm!" : "Make it cold!") {
                        toggleCold()
                    }
                    
                    .accentColor(isCold ? .orange : Color.compatCyan)
                    .padding(.top, 16)

                    Spacer()

                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Fluffy Birds, Fluffy Sweaters", systemImage: SFSymbolCompat.name("bird.fill"))
                                .font(.title2.bold())
                            Text("When it is cold, birds fluff their feathers to trap air between them. Air is a very poor conductor — it is one of the best insulators! Woollen sweaters work the same way: tiny air pockets between the fibres keep you warm.")
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: 640)
                    GotItButton { onComplete() }
                        .padding(.bottom, 12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
        }
    }

    private func toggleCold() {
        withAnimation(reduceMotion ? .none : .spring(response: 0.5, dampingFraction: 0.7)) {
            isCold.toggle()
        }
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5).delay(0.3)) {
            showAirPockets = isCold
        }
    }
}

// MARK: - Triangle shape

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.midX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            p.closeSubpath()
        }
    }
}
