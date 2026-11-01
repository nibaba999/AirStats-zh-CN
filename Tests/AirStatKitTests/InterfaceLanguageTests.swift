import Testing
@testable import AirStatKit

@Suite("Interface language")
struct InterfaceLanguageTests {
    @Test("returns the requested translation")
    func selectsTranslation() {
        #expect(InterfaceLanguage.chinese.text("网络", "Network") == "网络")
        #expect(InterfaceLanguage.english.text("网络", "Network") == "Network")
    }

    @Test("language codes stay stable")
    func stableCodes() {
        #expect(InterfaceLanguage(rawValue: "zh-Hans") == .chinese)
        #expect(InterfaceLanguage(rawValue: "en") == .english)
        #expect(InterfaceLanguage(rawValue: "unknown") == nil)
    }
}
