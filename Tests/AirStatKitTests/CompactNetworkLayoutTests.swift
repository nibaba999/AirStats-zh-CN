import AppKit
import Testing
@testable import AirStatKit
@testable import AirStatUI

@MainActor
@Suite("Compact network menu bar")
struct CompactNetworkLayoutTests {
    private func model(down: Double, up: Double, style: MenuBarDisplayStyle) -> MenuBarRenderModel {
        var snapshot = SnapshotFixtures.nominal
        snapshot.network = .value(SnapshotFixtures.network(down: down, up: up))
        let item = MenuBarItemConfig(metric: .networkThroughput, style: style)
        return MenuBarRenderModel(snapshot: snapshot, history: SnapshotFixtures.history(),
                                  settings: Settings(menuBar: MenuBarSettings(items: [item])), isStale: false)
    }

    private func width(_ model: MenuBarRenderModel) -> CGFloat {
        let view = MenuBarContentView(frame: .zero)
        view.update(with: model)
        return view.intrinsicContentSize.width
    }

    @Test("two-line text is narrower than the existing horizontal icon layout")
    func compactIsNarrower() {
        let compact = model(down: 2_400_000, up: 340_000, style: .compactNetwork)
        let original = model(down: 2_400_000, up: 340_000, style: .iconAndText)
        #expect(compact.items[0].primary.glyph == "↓")
        #expect(compact.items[0].secondary?.glyph == "↑")
        #expect(width(compact) < width(original))
    }

    @Test("width remains stable as traffic rates change")
    func widthDoesNotJump() {
        let idle = model(down: 0, up: 0, style: .compactNetwork)
        let busy = model(down: 99_000_000, up: 9_000_000, style: .compactNetwork)
        #expect(width(idle) == width(busy))
    }

    @Test("compact network renders in both appearances and backing scales")
    func rendersCompactNetwork() throws {
        let override = ProcessInfo.processInfo.environment["AIRSTATS_RENDER_COMPACT_DIR"]
        let directory = override.map { URL(fileURLWithPath: $0) }
            ?? FileManager.default.temporaryDirectory.appendingPathComponent("AirStatsCompact-\(UUID())")
        defer { if override == nil { try? FileManager.default.removeItem(at: directory) } }
        var settings = Settings()
        settings.menuBar.items = [MenuBarItemConfig(metric: .networkThroughput, style: .compactNetwork)]
        for isDark in [false, true] {
            for scale: CGFloat in [1, 2] {
                let request = OffscreenRenderer.Request(surface: .menuBar, isDark: isDark,
                                                         scale: scale, settings: settings)
                let url = try OffscreenRenderer.render(request, to: directory)
                #expect(try Data(contentsOf: url).count > 0)
            }
        }
    }
}
