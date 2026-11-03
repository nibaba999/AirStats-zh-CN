// Copyright (c) 2026 qunqin24. Licensed under the Apache License, Version 2.0.
import AppKit
import Observation
import SwiftUI
import AirStatKit

/// Hosts Pulse inside AirStats. Pulse keeps its usage engine, settings and panel;
/// AirStats owns the only menu bar status item and supplies the entry points.
@MainActor
public final class PulseEmbeddedController {
    private let host: AppDelegate
    private var started = false
    private var summaryHandler: (@MainActor (AIUsageMenuBarSummary?) -> Void)?
    public var onRequestSettings: (() -> Void)? {
        didSet { host.onEmbeddedSettingsRequest = onRequestSettings }
    }

    public init() {
        LegacyDefaults.migrateIfNeeded()
        let settings = AppSettings.restored()
        settings.language = InterfaceLanguage.selected == .english ? .english : .chineseSimplified
        host = AppDelegate(settings: settings, embedded: true)
    }

    public func start() {
        guard !started else { return }
        started = true
        host.start()
    }

    public func showPanel() {
        if !started { start() }
        host.showEmbeddedPanel()
    }

    public func showSettings() {
        if !started { start() }
        host.showSettings()
    }

    /// The native Pulse settings tree, rendered inside AirStats' settings window.
    public func settingsPane() -> AnyView {
        if !started { start() }
        return host.makeEmbeddedSettingsPane()
    }

    /// The live Pulse account overview embedded in AirStats' click-down panel.
    public func panelDashboardContent() -> AnyView {
        if !started { start() }
        return host.embeddedUsageDashboard()
    }

    /// Streams the same provider reading into AirStats' own status-item renderer.
    public func observeMenuBarSummary(_ handler: @escaping @MainActor (AIUsageMenuBarSummary?) -> Void) {
        summaryHandler = handler
        publishAndObserveSummary()
    }

    private func publishAndObserveSummary() {
        let summary = withObservationTracking {
            host.embeddedMenuBarSummary()
        } onChange: { [weak self] in
            Task { @MainActor in self?.publishAndObserveSummary() }
        }
        summaryHandler?(summary)
    }

    public func open(_ url: URL) {
        if !started { start() }
        host.application(NSApplication.shared, open: [url])
    }
}

/// Pulse modes that must run before AirStats creates its menu bar UI.
public enum PulseCommandLine {
    @discardableResult
    public static func runIfRequested() -> Bool {
        let arguments = CommandLine.arguments
        if arguments.contains(StatusLineHook.modeArgument) {
            StatusLineHook.runAsStatusLine()
            exit(0)
        }
        if arguments.contains("--install-statusline") {
            print(StatusLineHook.install() ? "installed" : "failed")
            exit(0)
        }
        if arguments.contains("--uninstall-statusline") {
            print(StatusLineHook.uninstall() ? "uninstalled" : "failed")
            exit(0)
        }
        if arguments.contains(UsageReport.modeArgument) {
            exit(UsageReport.run())
        }
        if arguments.contains(RecapReport.modeArgument) {
            RecapReport.run(arguments: arguments)
        }
        return false
    }
}
