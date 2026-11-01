import Foundation

/// Language selection is independent of metric settings and takes effect on relaunch.
public enum InterfaceLanguage: String, CaseIterable, Sendable {
    case chinese = "zh-Hans"
    case english = "en"

    public static let defaultsKey = "AirStatsInterfaceLanguage"

    /// Cached for the process lifetime so sampling does not repeatedly read defaults.
    public static let selected: InterfaceLanguage = {
        let process = ProcessInfo.processInfo
        if process.arguments.contains("--render"),
           let raw = process.environment["AIRSTATS_RENDER_LANGUAGE"],
           let language = InterfaceLanguage(rawValue: raw) {
            return language
        }
        return InterfaceLanguage(rawValue: UserDefaults.standard.string(forKey: defaultsKey) ?? "") ?? .chinese
    }()

    public func text(_ chinese: String, _ english: String) -> String {
        self == .english ? english : chinese
    }
}

/// Selects a presentation string without changing stored metric identifiers or units.
public func L(_ chinese: String, _ english: String) -> String {
    InterfaceLanguage.selected.text(chinese, english)
}
