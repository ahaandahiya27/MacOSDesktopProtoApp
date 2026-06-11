import SwiftUI

/// Scene 5 — Sorter's Disease Lab.
///
/// A drawn microscope. Three slides below: clean, contaminated, sterilized.
/// Tap each slide — microscope shows: clean (no spores), contaminated (red spore dots),
/// sterilized (no spores). Worker icon puts on PPE when contaminated is selected.
/// Big Sur (macOS 11) compatible — the microscope diagram is now drawn
/// with standard SwiftUI shapes (RoundedRectangle, Path, Ellipse)
/// instead of a Canvas.
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
        ScrollView {
            LazyVStack(spacing: 18) {
                HStack {
                    Text("Sorter's Disease Lab")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color.compatIndigo)
                    Spacer()
                }
                .padding(.horizontal, DesignTokens.Spacing.xl)
                .padding(.top, 20)

                ZStack {
                    // Drawn microscope (Shapes, was Canvas)
                    MicroscopeDiagram()
                        .frame(width: 400, height: 280)

                    // Viewed through eyepiece
                    VStack {
                        ZStack {
                            Circle()
                                .fill(Color.primary)
                                .frame(width: 100, height: 100)
                                .position(x: 200, y: 90)

                            if showSpores {
                                ForEach(0..<12, id: \.self) { i in
                                    let sporeX: CGFloat = 200 + CGFloat.random(in: -30...30)
                                    let sporeY: CGFloat = 90 + CGFloat.random(in: -30...30)
                                    Circle()
                                        .fill(Color.red.opacity(0.8))
                                        .frame(width: 4, height: 4)
                                        .position(
                                            x: sporeX,
                                            y: sporeY
                                        )
                                }
                            }
                        }
                    }

                    // Worker icon with PPE
                    if showPPE {
                        VStack(spacing: DesignTokens.Spacing.xxs) {
                            Text("😷👤")
                                .font(.system(size: 48))
                        }
                        .position(x: 320, y: 180)
                    }
                }
                .frame(height: 280)

                // Slides
                HStack(spacing: DesignTokens.Spacing.lg) {
                    ForEach(slides, id: \.1) { slideLabel, slideIdx in
                        slideButton(slideLabel, index: slideIdx)
                    }
                }
                .padding(.horizontal, DesignTokens.Spacing.xl)

                Group {
                    SoftShadowCard(padding: 14) {
                        VStack(alignment: .leading, spacing: 6) {
                            Label("Anthrax Protection", systemImage: "shield.fill")
                                .font(.caption.weight(.semibold))
                                .foregroundColor(.orange)
                            Text("Modern wool sorters wear N95 masks and gloves to prevent breathing spores. Raw fleece is disinfected before processing.")
                                .font(.caption)
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }
                    }
                    .frame(maxWidth: 600)
                    .padding(.horizontal, DesignTokens.Spacing.xl)

                    LookingAheadCallout(
                        title: "Class 12 Biology → NEET (Microbiology)",
                        detail: "Sorter's disease is anthrax — caused by *Bacillus anthracis*, the same organism Robert Koch used in 1876 to prove a microbe could cause a disease. NEET asks the four steps of Koch's Postulates and 'why is anthrax such a stable spore?' (the spore coat is one of the toughest natural structures — survives years in soil)."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)

                    TryAtHomeCallout(
                        title: "Safety-first reading",
                        detail: "Read about Sorter's disease / Woolsorter's pneumonia online (any verified source — WHO, CDC, NCBI). Don't search images. The point isn't gore — it's that simple workplace safety (face masks, dust extraction) eliminated this disease in modern wool mills. Public health = engineering against biology."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)

                    GotItButton {
                        onComplete()
                    }
                    .padding(.bottom, DesignTokens.Spacing.md)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
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
            VStack(spacing: DesignTokens.Spacing.sm) {
                RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                    .fill(slideColor(index))
                    .frame(height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                            .strokeBorder(selectedSlide == index ? Color.compatIndigo : Color.clear, lineWidth: 2.5)
                    )
                Text(label)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .accessibilityLabel(label)
        .accessibilityHint("Selects this slide for viewing under the microscope")
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


/// Microscope side view used in Scene5_SortersDiseaseLab. Was previously
/// drawn via Canvas; rebuilt with standard shapes so it renders on macOS 11.
struct MicroscopeDiagram: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Base
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray)
                .frame(width: 200, height: 30)
                .offset(x: 100, y: 200)

            // Arm
            Path { p in
                p.move(to: CGPoint(x: 200, y: 200))
                p.addLine(to: CGPoint(x: 200, y: 100))
            }
            .stroke(Color.gray, lineWidth: 8)

            // Eyepiece
            Ellipse()
                .fill(Color.gray.opacity(0.7))
                .frame(width: 40, height: 40)
                .offset(x: 180, y: 70)

            // Objective lens
            Ellipse()
                .fill(Color.blue.opacity(0.5))
                .frame(width: 30, height: 30)
                .offset(x: 185, y: 130)

            // Stage (fill + stroke)
            ZStack {
                Ellipse().fill(Color(NSColor.controlBackgroundColor))
                Ellipse().stroke(Color.gray, lineWidth: 1)
            }
            .frame(width: 50, height: 50)
            .offset(x: 175, y: 145)
        }
    }
}
