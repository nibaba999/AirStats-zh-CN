import Testing
import Foundation
@testable import AirStatKit
@testable import AirStatUI

@Suite("AI usage is a native AirStats menu-bar readout")
struct MenuBarAIUsageTests {
    @Test("Pulse values, alerts, accessibility, and compact styles reach the renderer")
    func rendersPulseSummary() {
        let config = MenuBarItemConfig(metric: .aiUsage, style: .iconAndText, showsCaption: false)
        let summary = AIUsageMenuBarSummary(valueText: "82%", widestText: "100%", fraction: 0.82,
                                            accessibilityLabel: "Claude, 82% left, five-hour limit",
                                            isAlert: true)
        let model = MenuBarRenderModel(
            snapshot: SnapshotFixtures.nominal,
            history: SnapshotFixtures.history(),
            settings: Settings(menuBar: MenuBarSettings(items: [config])),
            isStale: false,
            aiUsage: summary
        )

        let item = model.items[0]
        #expect(item.primary.valueText == "82%")
        #expect(item.primary.widestText == "100%")
        #expect(item.level == 0.82)
        #expect(item.symbolName == "sparkles")
        #expect(item.accessibilityLabel == "Claude, 82% left, five-hour limit")
        #expect(item.isAlert)
        #expect(!item.isUnavailable)
        #expect(MenuBarMetric.aiUsage.label == L("AI 额度", "AI Usage"))
        #expect(MenuBarMetric.aiUsage.supportedStyles == [.ring, .ringSplit, .iconAndText, .text])
    }

    @Test("AI ring styles receive Pulse window fractions and compact values")
    func rendersPulseWindowsForRingStyles() {
        let windows = [
            AIUsageMenuBarSummary.Window(label: "5h", valueText: "82%", fraction: 0.82),
            AIUsageMenuBarSummary.Window(label: "周", valueText: "37%", fraction: 0.37, isAlert: true)
        ]
        let summary = AIUsageMenuBarSummary(valueText: "82%", widestText: "100%", fraction: 0.82,
                                            accessibilityLabel: "Claude, 82% left", windows: windows)
        let config = MenuBarItemConfig(metric: .aiUsage, style: .ringSplit, showsCaption: false)
        let model = MenuBarRenderModel(snapshot: SnapshotFixtures.nominal,
                                       history: SnapshotFixtures.history(),
                                       settings: Settings(menuBar: MenuBarSettings(items: [config])),
                                       isStale: false, aiUsage: summary)
        let item = model.items[0]
        #expect(item.primary.valueText == "5h 82%")
        #expect(item.secondary?.valueText == "周 37%")
        #expect(item.level == 0.82)
        #expect(item.aiWindows == windows)
        #expect(!item.isAlert)
        #expect(item.aiWindows[1].isAlert)
    }

    @Test("missing provider readings stay selectable and show a named unavailable state")
    func keepsMissingReadingExplicit() {
        let config = MenuBarItemConfig(metric: .aiUsage, style: .iconAndText, showsCaption: false)
        let model = MenuBarRenderModel(
            snapshot: SnapshotFixtures.nominal,
            history: SnapshotFixtures.history(),
            settings: Settings(menuBar: MenuBarSettings(items: [config])),
            isStale: false
        )

        #expect(model.items[0].isUnavailable)
        #expect(model.items[0].primary.valueText == MetricFormatter.unavailable)
        #expect(model.items[0].accessibilityLabel.contains("AI"))
    }

    @Test("Existing menu-bar preferences gain one removable AI item")
    @MainActor
    func migratesExistingMenuBarPreferences() throws {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent("AirStats-AI-menu-migration-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }

        let old = Settings(schemaVersion: Settings.currentSchemaVersion - 1,
                           menuBar: MenuBarSettings(items: [
            MenuBarItemConfig(metric: .cpuUsage, style: .text)
        ]))
        try JSONEncoder().encode(old).write(to: directory.appendingPathComponent("settings.json"))

        let store = SettingsStore(directory: directory)
        #expect(store.settings.menuBar.items.filter { $0.metric == .aiUsage }.count == 1)
        #expect(store.settings.menuBar.items.first { $0.metric == .aiUsage }?.isEnabled == true)
        #expect(store.settings.menuBar.items.first { $0.metric == .aiUsage }?.style == .ring)

        store.update { $0.menuBar.items.removeAll { $0.metric == .aiUsage } }
        store.flush()
        let reopened = SettingsStore(directory: directory)
        #expect(!reopened.settings.menuBar.items.contains { $0.metric == .aiUsage })
    }
}
