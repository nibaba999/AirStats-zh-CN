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
    @AppStorage(InterfaceLanguage.defaultsKey) private var interfaceLanguage = InterfaceLanguage.chinese.rawValue
    @State private var languageRestartNotice = false

    var body: some View {
        Form {
            Section {
                Picker(L("语言", "Language"), selection: $interfaceLanguage) {
                    Text("简体中文").tag(InterfaceLanguage.chinese.rawValue)
                    Text("English").tag(InterfaceLanguage.english.rawValue)
                }
                .onChange(of: interfaceLanguage) { _, _ in languageRestartNotice = true }
            } header: {
                Text(L("语言 / Language", "Language / 语言"))
            } footer: {
                SettingsFootnote(L("切换后请退出并重新打开 AirStats，以更新界面语言。",
                                   "Quit and reopen AirStats after changing the language."))
            }

            Section {
                Toggle(L("登录时打开 AirStats", "Open AirStats at login"),
                       isOn: settings.binding(\.general.launchAtLogin, onChange: applyLoginItem))
                if let loginItemError {
                    SettingsCaution(loginItemError)
                }
                Toggle(L("在程序坞中显示图标", "Show icon in the Dock"),
                       isOn: settings.binding(\.general.showsDockIcon, onChange: applyDockIcon))
            } header: {
                Text(L("启动", "Startup"))
            }

            Section {
                Picker(L("更新间隔", "Update interval"), selection: settings.binding(\.general.updateInterval)) {
                    ForEach(GeneralSettings.allowedIntervals, id: \.self) { interval in
                        Text(SettingsLabels.interval(interval)).tag(interval)
                    }
                }
                Toggle(L("菜单栏隐藏时降低更新频率", "Slow down when the menu bar is hidden"),
                       isOn: settings.binding(\.general.throttlesWhenOccluded))
                Toggle(L("低电量模式下暂停采样", "Pause sampling on Low Power Mode"),
                       isOn: settings.binding(\.general.pausesOnLowPower))
            } header: {
                Text(L("采样", "Sampling"))
            }

            Section {
                Picker(L("温度", "Temperature"), selection: settings.binding(\.general.temperatureUnit)) {
                    ForEach(TemperatureUnit.allCases, id: \.self) { unit in
                        Text(unit.label).tag(unit)
                    }
                }
                Picker(L("网络速率", "Network rate"), selection: settings.binding(\.general.networkRateUnit)) {
                    ForEach(NetworkRateUnit.allCases, id: \.self) { unit in
                        Text(unit.label).tag(unit)
                    }
                }
                Picker(L("存储单位", "Storage sizes"), selection: settings.binding(\.general.byteUnitStyle)) {
                    ForEach(ByteUnitStyle.allCases, id: \.self) { style in
                        Text(style.label).tag(style)
                    }
                }
                Toggle(L("显示百分号", "Show the percent sign"), isOn: settings.binding(\.general.showsPercentSign))
            } header: {
                Text(L("单位", "Units"))
            }

            Section {
                SettingsFootnote(L("中文适配版不使用上游自动更新，请查看本项目仓库获取更新。", "Automatic updates are disabled in this adaptation. Check the project repository for updates."))
            } header: {
                Text(L("更新", "Updates"))
            }

            Section {
                Toggle(L("查询公网 IP 地址", "Look up my public IP address"),
                       isOn: settings.binding(\.general.fetchesPublicIP))
            } header: {
                Text(L("隐私", "Privacy"))
            } footer: {
                SettingsFootnote(L("关闭后，网络模块只显示本地", "When off, the Network module shows local ")
                                 + L("地址，AirStats 不会发起网络请求。", "addresses only and AirStats does not make a network request."))
            }
        }
        .settingsFormStyle()
        .alert(L("请重新打开 AirStats", "Reopen AirStats"), isPresented: $languageRestartNotice) {
            Button(L("知道了", "OK"), role: .cancel) {}
        } message: {
            Text(L("退出并重新打开后，将应用所选界面语言。",
                   "Quit and reopen the app to apply the selected language."))
        }
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
                Text(L("正在检查…", "Checking…"))
            }
            .foregroundStyle(.secondary)
        } else if let failure = updater?.lastCheckFailure {
            Text(L("无法检查", "Couldn't check"))
                .foregroundStyle(.secondary)
                .help(failure)
                .accessibilityValue(failure)
        } else if updater?.pending != nil || updater?.lastCheck != nil {
            VStack(alignment: .trailing, spacing: Design.Space.xxs) {
                if let pending = updater?.pending {
                    Text(pending.isReadyToInstall ? "AirStats \(pending.version) is ready"
                                                  : "AirStats \(pending.version) is available")
                } else {
                    Text(L("已是最新版本", "Up to date"))
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
