import SwiftUI

/// Scene 5 — Sorter's Disease Lab.
///
/// A drawn microscope. Three slides below: clean, contaminated, sterilized.
/// Tap each slide — microscope shows: clean (no spores), contaminated (red spore dots),
/// sterilized (no spores). Worker icon puts on PPE when contaminated is selected.
struct Scene5_SortersDiseaseLab: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var selectedSlide: Int? = nil
    @State private var showSpores = false
    @State private var showPPE = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let slides = [
        ("Clean Fleece", 0),
        ("Contaminated", 1),
        ("Sterilized", 2)
    ]

    var body: some View {
        VStack(spacing: 18) {
            HStack {
                Text("Sorter's Disease Lab")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.indigo)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)

            ZStack {
                // Drawn microscope
                Canvas { context, _ in
                    // Base
                    context.fill(
                        Path(roundedRect: CGRect(x: 100, y: 200, width: 200, height: 30), cornerRadius: 4),
                        with: .color(.gray)
                    )

                    // Arm
                    context.stroke(
                        Path { p in
                            p.move(to: CGPoint(x: 200, y: 200))
                            p.addLine(to: CGPoint(x: 200, y: 100))
                        },
                        with: .color(.gray),
                        lineWidth: 8
                    )

                    // Eyepiece
                    context.fill(
                        Path(ellipseIn: CGRect(x: 180, y: 70, width: 40, height: 40)),
                        with: .color(.gray.opacity(0.7))
                    )

                    // Objective lens
                    context.fill(
                        Path(ellipseIn: CGRect(x: 185, y: 130, width: 30, height: 30)),
                        with: .color(.blue.opacity(0.5))
                    )

                    // Stage
                    context.fill(
                        Path(ellipseIn: CGRect(x: 175, y: 145, width: 50, height: 50)),
                        with: .color(.white)
                    )
                    context.stroke(
                        Path(ellipseIn: CGRect(x: 175, y: 145, width: 50, height: 50)),
                        with: .color(.gray),
                        lineWidth: 1
                    )
                }
                .frame(width: 400, height: 280)

                // Viewed through eyepiece
                VStack {
                    ZStack {
                        Circle()
                            .fill(.black)
                            .frame(width: 100, height: 100)
                            .position(x: 200, y: 90)

                        if showSpores {
                            ForEach(0..<12, id: \.self) { i in
                                Circle()
                                    .fill(.red.opacity(0.8))
                                    .frame(width: 4, height: 4)
                                    .position(
                                        x: 200 + CGFloat.random(in: -30...30),
                                        y: 90 + CGFloat.random(in: -30...30)
                                    )
                            }
                        }
                    }
                }

                // Worker icon with PPE
                if showPPE {
                    VStack(spacing: 2) {
                        Text("😷👤")
                            .font(.system(size: 48))
                    }
                    .position(x: 320, y: 180)
                }
            }
            .frame(height: 280)

            // Slides
            HStack(spacing: 16) {
                ForEach(slides, id: \.1) { slideLabel, slideIdx in
                    slideButton(slideLabel, index: slideIdx)
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            SoftShadowCard(padding: 14) {
                VStack(alignment: .leading, spacing: 6) {
                    Label("Anthrax Protection", systemImage: "shield.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.orange)
                    Text("Modern wool sorters wear N95 masks and gloves to prevent breathing spores. Raw fleece is disinfected before processing.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: 600)
            .padding(.horizontal, 24)

            GotItButton {
                onComplete()
            }
            .padding(.bottom, 20)
        }
    }

    @ViewBuilder
    private func slideButton(_ label: String, index: Int) -> some View {
        Button {
            withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.4)) {
                selectedSlide = index
                showSpores = (index == 1)
                showPPE = (index == 1)
            }
        } label: {
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(slideColor(index))
                    .frame(height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(selectedSlide == index ? Color.indigo : Color.clear, lineWidth: 2.5)
                    )
                Text(label)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .accessibilityLabel(label)
    }

    private func slideColor(_ index: Int) -> Color {
        switch index {
        case 0: return .green.opacity(0.2)
        case 1: return .red.opacity(0.2)
        case 2: return .green.opacity(0.2)
        default: return .gray.opacity(0.1)
        }
    }
}
