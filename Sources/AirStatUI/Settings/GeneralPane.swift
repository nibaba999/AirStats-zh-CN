import SwiftUI
import AppKit
import AirStatKit

struct GeneralPane: View {
    let settings: SettingsStore
    /// Absent in the offscreen renderer, which has no running app to update.
    var updater: SoftwareUpdater?

    /// `LoginItem.synchronize` reports a real failure — a missing bundle, a
    /// revoked approval — and the toggle is worthless if that is swallowed.
    @State private var loginItemError: String?

    var body: some View {
        Form {
            Section {
                Toggle("登录时打开 AirStats",
                       isOn: settings.binding(\.general.launchAtLogin, onChange: applyLoginItem))
                if let loginItemError {
                    SettingsCaution(loginItemError)
                }
                Toggle("在程序坞中显示图标",
                       isOn: settings.binding(\.general.showsDockIcon, onChange: applyDockIcon))
            } header: {
                Text("启动")
            }

            Section {
                Picker("更新间隔", selection: settings.binding(\.general.updateInterval)) {
                    ForEach(GeneralSettings.allowedIntervals, id: \.self) { interval in
                        Text(SettingsLabels.interval(interval)).tag(interval)
                    }
                }
                Toggle("菜单栏隐藏时降低更新频率",
                       isOn: settings.binding(\.general.throttlesWhenOccluded))
                Toggle("低电量模式下暂停采样",
                       isOn: settings.binding(\.general.pausesOnLowPower))
            } header: {
                Text("采样")
            }

            Section {
                Picker("温度", selection: settings.binding(\.general.temperatureUnit)) {
                    ForEach(TemperatureUnit.allCases, id: \.self) { unit in
                        Text(unit.label).tag(unit)
                    }
                }
                Picker("网络速率", selection: settings.binding(\.general.networkRateUnit)) {
                    ForEach(NetworkRateUnit.allCases, id: \.self) { unit in
                        Text(unit.label).tag(unit)
                    }
                }
                Picker("存储单位", selection: settings.binding(\.general.byteUnitStyle)) {
                    ForEach(ByteUnitStyle.allCases, id: \.self) { style in
                        Text(style.label).tag(style)
                    }
                }
                Toggle("显示百分号", isOn: settings.binding(\.general.showsPercentSign))
            } header: {
                Text("单位")
            }

            Section {
                SettingsFootnote("中文适配版不使用上游自动更新，请查看本项目仓库获取更新。")
            } header: {
                Text("更新")
            }

            Section {
                Toggle("查询公网 IP 地址",
                       isOn: settings.binding(\.general.fetchesPublicIP))
            } header: {
                Text("隐私")
            } footer: {
                SettingsFootnote("关闭后，网络模块只显示本地"
                                 + "地址，AirStats 不会发起网络请求。")
            }
        }
        .settingsFormStyle()
    }

    // MARK: Side effects

    private var checksAutomatically: Binding<Bool> {
        Binding(get: { updater?.checksAutomatically ?? true },
                set: { updater?.setChecksAutomatically($0) })
    }

    private var installsAutomatically: Binding<Bool> {
        Binding(get: { updater?.installsAutomatically ?? false },
                set: { updater?.setInstallsAutomatically($0) })
    }

    /// The state of updates, beside the button that changes it. It also answers "is
    /// this thing actually running?": the automatic check is silent when it finds
    /// nothing, so without the checked time a user who never pressed anything would see
    /// no sign of it at all. A failure is named, because Sparkle stamps the check date
    /// on failure too and a feed unreachable for a month would otherwise read as fine.
    @ViewBuilder
    private var updateStatus: some View {
        if updater?.isChecking == true {
            HStack(spacing: Design.Space.s) {
                ProgressView().controlSize(.small)
                Text("正在检查…")
            }
            .foregroundStyle(.secondary)
        } else if let failure = updater?.lastCheckFailure {
            Text("无法检查")
                .foregroundStyle(.secondary)
                .help(failure)
                .accessibilityValue(failure)
        } else if updater?.pending != nil || updater?.lastCheck != nil {
            VStack(alignment: .trailing, spacing: Design.Space.xxs) {
                if let pending = updater?.pending {
                    Text(pending.isReadyToInstall ? "AirStats \(pending.version) is ready"
                                                  : "AirStats \(pending.version) is available")
                } else {
                    Text("已是最新版本")
                }
                if let checked = updater?.lastCheck {
                    Text("Checked \(Self.checkedPhrase(checked))")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .foregroundStyle(.secondary)
            .lineLimit(1)
            .accessibilityElement(children: .combine)
        }
    }

    /// A check that has just finished is stamped a moment after the `Date()` it is
    /// drawn against, and the formatter reads that as "in 0 seconds".
    private static func checkedPhrase(_ checked: Date) -> String {
        let now = Date()
        guard now.timeIntervalSince(checked) >= 60 else { return "just now" }
        return relative.localizedString(for: checked, relativeTo: now)
    }

    private static let relative: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()

    /// Process-level state rather than a stored preference, so the store's value alone
    /// would change nothing until the next launch.
    private func applyDockIcon(_ shows: Bool) {
        NSApp.setActivationPolicy(shows ? .regular : .accessory)
        // Switching policy drops key window status; take it back so the settings
        // window the user is standing in does not slide behind everything.
        NSApp.activate(ignoringOtherApps: true)
    }

    private func applyLoginItem(_ enabled: Bool) {
        if let error = LoginItem.synchronize(enabled: enabled) {
            loginItemError = "macOS refused to \(enabled ? "register" : "remove") the login item: \(error.localizedDescription)"
            // The stored preference must not claim something the system rejected.
            settings.update { $0.general.launchAtLogin = LoginItem.isEnabled }
        } else {
            loginItemError = nil
        }
    }
}
