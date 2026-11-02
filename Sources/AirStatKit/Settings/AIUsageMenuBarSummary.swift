/// A compact AI provider reading supplied by the embedded Pulse engine.
/// AirStatKit owns the value shape so the menu bar renderer stays independent
/// from Pulse's account and provider implementation.
public struct AIUsageMenuBarSummary: Equatable, Sendable {
    public var valueText: String
    public var widestText: String
    public var fraction: Double?
    public var accessibilityLabel: String
    public var isAlert: Bool
    public var windows: [Window]

    public struct Window: Equatable, Sendable {
        public var label: String
        public var valueText: String
        public var fraction: Double
        public var isAlert: Bool

        public init(label: String, valueText: String, fraction: Double, isAlert: Bool = false) {
            self.label = label
            self.valueText = valueText
            self.fraction = min(max(fraction, 0), 1)
            self.isAlert = isAlert
        }
    }

    public init(valueText: String, widestText: String, fraction: Double? = nil,
                accessibilityLabel: String, isAlert: Bool = false, windows: [Window] = []) {
        self.valueText = valueText
        self.widestText = widestText
        self.fraction = fraction.map { min(max($0, 0), 1) }
        self.accessibilityLabel = accessibilityLabel
        self.isAlert = isAlert
        self.windows = Array(windows.prefix(2))
    }
}
