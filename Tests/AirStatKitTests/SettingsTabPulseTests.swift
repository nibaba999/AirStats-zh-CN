import Testing
@testable import AirStatUI

@Suite("Integrated AI usage settings")
struct SettingsTabPulseTests {
    @Test("AI usage has a localized, stable settings entry")
    func aiUsageEntry() {
        #expect(SettingsTab.aiUsage.id == "aiUsage")
        #expect(["AI 额度", "AI Usage"].contains(SettingsTab.aiUsage.label))
        #expect(SettingsTab.aiUsage.symbolName == "sparkles.rectangle.stack")
        #expect(SettingsTab.aiUsage.sections.isEmpty)
        #expect(SettingsTab.aiUsage.startsGroup)
    }

    @Test("AI usage gets enough room for Pulse native settings")
    func aiUsageWindowSize() {
        #expect(SettingsRootView.windowSize(for: .aiUsage).width == 1040)
        #expect(SettingsRootView.windowSize(for: .aiUsage).height == 700)
        #expect(SettingsRootView.windowSize(for: .general).width == SettingsRootView.windowSize.width)
    }
}
