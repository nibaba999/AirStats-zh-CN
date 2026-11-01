import SwiftUI
import AppKit
import UniformTypeIdentifiers
import AirStatKit

struct AboutPane: View {
    let settings: SettingsStore
    let engine: MetricsEngine?
    /// Absent in the offscreen renderer, which has no running app to update.
    var updater: SoftwareUpdater?

    @State private var transferResult: String?
    @State private var transferFailed = false
    @State private var isConfirmingFullReset = false

    /// Live identity when the app is running; the render harness has no engine, so
    /// it shows the same fixture machine every other rendered surface shows.
    private var systemState: MetricState<SystemInfoSnapshot> {
        engine?.system ?? .value(SnapshotFixtures.system())
    }

    private var formatter: MetricFormatter {
        MetricFormatter(settings: settings.settings.general)
    }

    var body: some View {
        Form {
            Section {
                HStack(spacing: Design.Space.xl) {
                    LogoMark(size: 52)
                        .foregroundStyle(Design.Palette.primaryText)
                    VStack(alignment: .leading, spacing: Design.Space.xxs) {
                        Text("AirStats").font(.title2.weight(.medium))
                        Text(versionText).foregroundStyle(Design.Palette.secondaryText)
                    }
                    Spacer()
                }
                .padding(.vertical, Design.Space.xs)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("AirStats, \(versionText)")
            }

            Section {
                MetricContent(systemState) { system in
                    Group {
                        LabeledContent(L("电脑", "Computer"), value: system.computerName)
                        LabeledContent(L("型号", "Model"), value: system.modelName)
                        LabeledContent(L("芯片", "Chip"), value: system.chipName)
                        LabeledContent(L("核心数", "Cores"), value: coreText(system))
                        LabeledContent(L("内存", "Memory"), value: formatter.memory(system.totalMemoryBytes))
                        LabeledContent(L("系统", "System"), value: "\(system.osName) \(system.osVersion) (\(system.osBuild))")
                        LabeledContent(L("运行时间", "uptime"), value: formatter.compactUptime(system.uptime))
                    }
                }
            } header: {
                Text(L("本机", "This Mac"))
            }

            Section {
                HStack(spacing: Design.Space.l) {
                    Button(L("导出…", "Export…")) { export() }
                        .accessibilityHint(L("将设置写入 JSON 文件", "Writes your settings to a JSON file"))
                    Button(L("导入…", "Import…")) { importSettings() }
                        .accessibilityHint(L("使用 JSON 文件替换设置", "Replaces your settings from a JSON file"))
                    Spacer()
                }
                if let transferResult {
                    if transferFailed {
                        SettingsCaution(transferResult)
                    } else {
                        SettingsFootnote(transferResult)
                    }
                }
                LabeledContent(L("位置", "Location"), value: settings.settingsFileURL.path)
                    .font(.callout)
                    .foregroundStyle(Design.Palette.secondaryText)
                    .textSelection(.enabled)
                Button(L("在访达中显示", "Show in Finder")) {
                    NSWorkspace.shared.activateFileViewerSelecting([settings.settingsFileURL])
                }
            } header: {
                Text(L("设置文件", "Settings File"))
            }

            // One section's defaults are restored from the bar under that section's
            // own pane, where the user can see what is about to change. This is the
            // only reset that reaches settings you are not looking at, so it is the
            // only one that belongs here.
            Section {
                Button(L("恢复所有设置…", "Restore All Settings…"), role: .destructive) { isConfirmingFullReset = true }
                    .confirmationDialog(L("将所有设置恢复为默认值？", "Restore every setting to its defaults?"),
                                        isPresented: $isConfirmingFullReset) {
                        Button(L("恢复所有设置", "Restore All Settings"), role: .destructive) {
                            settings.resetToDefaults()
                        }
                        Button(L("取消", "Cancel"), role: .cancel) {}
                    } message: {
                        Text("Your menu bar readouts, desktop widget, colours, notification rules and shortcuts all go back to how AirStats shipped.")
                    }
            } header: {
                Text(L("重置", "Reset"))
            } footer: {
                if let diagnostic = settings.loadDiagnostic {
                    SettingsCaution(diagnostic)
                }
            }
        }
        .settingsFormStyle()
    }

    /// The marketing version alone. The build number beside it is what Sparkle
    /// compares releases by and means nothing to the person reading it.
    private var versionText: String {
        guard let short = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            // Running the bare SwiftPM binary rather than the assembled .app.
            return L("开发版本", "Development build")
        }
        return "Version \(short)"
    }

    private func coreText(_ system: SystemInfoSnapshot) -> String {
        var text = "\(system.logicalCores)"
        if system.performanceCores > 0 || system.efficiencyCores > 0 {
            text += " (\(system.performanceCores) performance, \(system.efficiencyCores) efficiency)"
        }
        if let gpu = system.gpuCoreCount {
            text += " · \(gpu) GPU"
        }
        return text
    }

    // MARK: Import / export

    private func export() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.json]
        panel.nameFieldStringValue = "AirStats Settings.json"
        panel.canCreateDirectories = true
        guard panel.runModal() == .OK, let url = panel.url else { return }
        do {
            try settings.exportJSON().write(to: url, options: .atomic)
            transferFailed = false
            transferResult = "Exported to \(url.lastPathComponent)."
        } catch {
            transferFailed = true
            transferResult = "Could not export: \(error.localizedDescription)"
        }
    }

    private func importSettings() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.json]
        panel.allowsMultipleSelection = false
        guard panel.runModal() == .OK, let url = panel.url else { return }
        do {
            try settings.importJSON(Data(contentsOf: url))
            transferFailed = false
            transferResult = "Imported from \(url.lastPathComponent)."
        } catch {
            transferFailed = true
            transferResult = "\(url.lastPathComponent) is not a settings file AirStats can read. Your settings are unchanged."
        }
    }
}
