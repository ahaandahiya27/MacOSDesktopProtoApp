import SwiftUI

// MARK: - TrendChartView — Big-Sur-safe mastery-over-time line chart (v8)
//
// v8 Longitudinal Insights · Phase 2. A pure-SwiftUI line chart over a
// `[ProgressSeriesPoint]` mastery series, drawn entirely with `Path`/`Shape` —
// NO `Charts` framework (banned on Big Sur), NO `Canvas`, NO `.foregroundStyle`,
// NO particles. Axes + gridlines are plain `Shape`s; the data line is a stroked
// `TrendLineShape`. The reveal animation routes through
// `withAnimationRespectingReduceMotion` so it's instant under Reduce Motion, and
// it's a single trimmed path — trivially within the AMD R9 M290X budget.
//
// Self-contained: it takes a set of selectable `TrendSeries` (e.g. an "Overall"
// line plus one per subject) and owns the toggle. The host (InsightsView, the
// preview) just builds the series; the chart owns drawing + selection. Mastery
// is the plotted axis (0…100%); the y-domain is fixed 0…1 so two subjects are
// visually comparable.

/// One named, tinted line the chart can show. `points` are oldest → newest.
struct TrendSeries: Identifiable, Hashable {
    /// Stable id — `"overall"` or a packId.
    let id: String
    /// Toggle label, e.g. "Overall", "Science".
    let label: String
    /// Line colour (a `Color.compat*` / DesignTokens value supplied by the host).
    let tint: Color
    /// The mastery/coverage series, oldest → newest.
    let points: [ProgressSeriesPoint]
}

/// The polyline for one normalised series. `normalizedPoints` use x ∈ 0…1
/// (left → right) and y ∈ 0…1 (0 = bottom, 1 = top); `path(in:)` maps them into
/// the rect, flipping y to SwiftUI's top-left origin. Pure + unit-testable.
struct TrendLineShape: Shape {
    /// Normalised points, oldest → newest. x left→right, y bottom→top.
    var normalizedPoints: [CGPoint]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard let first = normalizedPoints.first else { return path }
        func map(_ p: CGPoint) -> CGPoint {
            CGPoint(x: rect.minX + p.x * rect.width,
                    y: rect.maxY - p.y * rect.height)
        }
        path.move(to: map(first))
        for p in normalizedPoints.dropFirst() {
            path.addLine(to: map(p))
        }
        return path
    }
}

/// Horizontal gridlines + the left and bottom axes for the plot rect. Drawn as
/// one `Shape` so it strokes in a single pass.
struct TrendGridShape: Shape {
    /// Number of horizontal gridlines (including 0% and 100%).
    var lineCount: Int = 5

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let n = max(2, lineCount)
        for i in 0..<n {
            let frac = CGFloat(i) / CGFloat(n - 1)
            let y = rect.maxY - frac * rect.height
            path.move(to: CGPoint(x: rect.minX, y: y))
            path.addLine(to: CGPoint(x: rect.maxX, y: y))
        }
        // Left + bottom axis (drawn heavier by the caller via a second stroke).
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        return path
    }
}

@MainActor
struct TrendChartView: View {
    let seriesOptions: [TrendSeries]
    /// Caption beneath the plot (e.g. the date range). Optional.
    var subtitle: String? = nil

    @State private var selectedId: String
    @State private var revealed = false

    /// `seriesOptions` must be non-empty; the first is selected by default.
    init(seriesOptions: [TrendSeries], subtitle: String? = nil) {
        self.seriesOptions = seriesOptions
        self.subtitle = subtitle
        _selectedId = State(initialValue: seriesOptions.first?.id ?? "overall")
    }

    private var selected: TrendSeries? {
        seriesOptions.first { $0.id == selectedId } ?? seriesOptions.first
    }

    private static let axisDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "MMM d"
        return f
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if seriesOptions.count > 1 { picker }
            chartBody
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
        }
        .onAppear {
            withAnimationRespectingReduceMotion(.easeOut(duration: 0.55)) {
                revealed = true
            }
        }
    }

    // MARK: - Subject toggle

    private var picker: some View {
        Picker("Show", selection: $selectedId) {
            ForEach(seriesOptions) { option in
                Text(option.label).tag(option.id)
            }
        }
        .pickerStyle(.segmented)
        .labelsHidden()
        .accessibilityLabel("Choose which subject's mastery trend to show.")
    }

    // MARK: - Chart

    @ViewBuilder
    private var chartBody: some View {
        if let series = selected, series.points.count >= 2 {
            plot(series)
        } else {
            notEnoughData
        }
    }

    private func plot(_ series: TrendSeries) -> some View {
        let pts = normalized(series.points)
        return VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            GeometryReader { _ in
                ZStack {
                    // Gridlines (faint) + axes (heavier) in two strokes.
                    TrendGridShape(lineCount: 5)
                        .stroke(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.18),
                                lineWidth: 1)
                    TrendGridShape(lineCount: 2) // just the 0% + 100% frame edges
                        .stroke(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.35),
                                lineWidth: 1.4)
                    // The data line, revealed via a reduce-motion-gated trim.
                    TrendLineShape(normalizedPoints: pts)
                        .trim(from: 0, to: revealed ? 1 : 0)
                        .stroke(series.tint,
                                style: StrokeStyle(lineWidth: 2.6, lineCap: .round, lineJoin: .round))
                    // Endpoint dot so the "today" value reads at a glance.
                    if let last = pts.last {
                        endpointDot(at: last, tint: series.tint)
                    }
                }
                .padding(.vertical, DesignTokens.Spacing.xxs)
            }
            .frame(height: 150)
            axisLabels(series)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityDescription(series))
    }

    private func endpointDot(at normalized: CGPoint, tint: Color) -> some View {
        GeometryReader { geo in
            let x = normalized.x * geo.size.width
            let y = geo.size.height - normalized.y * geo.size.height
            Circle()
                .fill(tint)
                .frame(width: 7, height: 7)
                .position(x: x, y: y)
                .opacity(revealed ? 1 : 0)
        }
    }

    private func axisLabels(_ series: TrendSeries) -> some View {
        HStack {
            Text(Self.axisDateFormatter.string(from: series.points.first?.date ?? Date()))
            Spacer()
            Text("0–100% mastery")
            Spacer()
            Text(Self.axisDateFormatter.string(from: series.points.last?.date ?? Date()))
        }
        .font(.caption2)
        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
    }

    private var notEnoughData: some View {
        VStack(spacing: 6) {
            Text("📈").font(.system(size: 30)).accessibilityHidden(true)
            Text("Not enough history yet")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Keep practising — a trend line appears once there are at least two days of progress.")
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .accessibilityElement(children: .combine)
    }

    // MARK: - Normalisation

    /// Map a series to normalised points (x by date across the domain, y by
    /// mastery fraction 0…1). A single distinct date collapses to x = 1 (right
    /// edge) so the lone point still draws as the endpoint.
    private func normalized(_ points: [ProgressSeriesPoint]) -> [CGPoint] {
        guard let first = points.first, let last = points.last else { return [] }
        let t0 = first.date.timeIntervalSince1970
        let t1 = last.date.timeIntervalSince1970
        let span = t1 - t0
        return points.map { p in
            let x: CGFloat = span > 0
                ? CGFloat((p.date.timeIntervalSince1970 - t0) / span)
                : 1
            let y = CGFloat(max(0, min(1, p.masteryFraction)))
            return CGPoint(x: x, y: y)
        }
    }

    // MARK: - Accessibility

    private func accessibilityDescription(_ series: TrendSeries) -> String {
        guard let first = series.points.first, let last = series.points.last else {
            return "\(series.label) mastery trend. No data."
        }
        let start = Int((first.masteryFraction * 100).rounded())
        let end = Int((last.masteryFraction * 100).rounded())
        let dir: String
        if end > start { dir = "up from \(start)% to \(end)%" }
        else if end < start { dir = "down from \(start)% to \(end)%" }
        else { dir = "steady at \(end)%" }
        return "\(series.label) mastery trend over \(series.points.count) days: \(dir)."
    }
}

#if DEBUG
struct Preview_TrendChart: PreviewProvider {
    static func demoSeries(_ vals: [Double]) -> [ProgressSeriesPoint] {
        let base = Date(timeIntervalSince1970: 1_700_000_000)
        return vals.enumerated().map { i, v in
            ProgressSeriesPoint(date: base.addingTimeInterval(Double(i) * 86_400),
                                masteryFraction: v, coverageFraction: v * 0.8)
        }
    }
    static var previews: some View {
        TrendChartView(
            seriesOptions: [
                TrendSeries(id: "overall", label: "Overall", tint: DesignTokens.BrandColor.success,
                            points: demoSeries([0.1, 0.15, 0.22, 0.3, 0.28, 0.4, 0.52])),
                TrendSeries(id: "science_class7", label: "Science", tint: Color.compatBlue,
                            points: demoSeries([0.2, 0.25, 0.4, 0.45, 0.5, 0.6, 0.7])),
            ],
            subtitle: "Last 7 days"
        )
        .frame(width: 420)
        .padding()
    }
}
#endif
