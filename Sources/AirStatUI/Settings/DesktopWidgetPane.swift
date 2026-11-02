import SwiftUI
import AirStatKit

struct DesktopWidgetPane: View {
    let settings: SettingsStore
    let engine: MetricsEngine?

    @State private var dropTarget: PanelModule?

    private var availability: MetricAvailability {
        MetricAvailability(snapshot: SettingsPreview.snapshot(engine))
    }

    private var desktopWidget: DesktopWidgetSettings { settings.settings.desktopWidget }

    var body: some View {
        Form {
            // No header: it would repeat the pane's own name in the source list
            // beside it, and this row is the pane's subject rather than a section of
            // it — everything below configures the thing this switch puts on screen.
            Section {
                Toggle(L("显示桌面小组件", "Show the desktop widget"), isOn: settings.binding(\.desktopWidget.isEnabled))
            }

            // The preview and the list that fills it, side by side. Stacked, the
            // thumbnail was a band across the pane and the modules were somewhere
            // below it; beside them, reordering one is watching the other.
            //
            // Below the switch rather than above it, so a pane opened with the desktop widget
            // off says it is off before it shows what it would look like. The preview
            // itself is never disabled: what the desktop widget would be is exactly what
            // someone deciding whether to switch it on wants to see.
            Section {
                HStack(alignment: .top, spacing: Design.Space.xl) {
                    if let engine {
                        DesktopWidgetPreview(engine: engine, settings: settings)
                    }
                    VStack(alignment: .leading, spacing: Design.Space.m) {
                        moduleList
                        moduleControls
                    }
                    .disabled(!desktopWidget.isEnabled)
                }
            } header: {
                Text(L("模块", "Modules"))
            }

            Section {
                SettingsSlider(title: L("宽度", "Width"),
                               value: settings.quantized(\.desktopWidget.width, step: 4),
                               range: 160...480,
                               format: SettingsLabels.points)
                Toggle(L("使用紧凑布局", "Use compact layout"), isOn: settings.binding(\.desktopWidget.isCompact))
                Toggle(L("显示 24 小时历史记录", "Show a 24-hour history"), isOn: settings.binding(\.desktopWidget.showsHistoryChart))
                SettingsSlider(title: L("不透明度", "Opacity"),
                               value: settings.quantized(\.desktopWidget.opacity, step: 0.05),
                               range: 0.2...1,
                               format: SettingsLabels.percent)
                Toggle(L("不使用时淡出", "Fade when not in use"), isOn: settings.binding(\.desktopWidget.dimsWhenInactive))
                if desktopWidget.dimsWhenInactive {
                    SettingsSlider(title: L("淡出时的不透明度", "Faded opacity"),
                                   value: settings.quantized(\.desktopWidget.inactiveOpacity, step: 0.05),
                                   range: 0.15...1,
                                   format: SettingsLabels.percent)
                }
            } header: {
                Text(L("大小和透明度", "Size & Transparency"))
            }
            .disabled(!desktopWidget.isEnabled)

            Section {
                Picker(L("位置", "Location"), selection: settings.binding(\.desktopWidget.corner)) {
                    ForEach(DesktopWidgetCorner.allCases, id: \.self) { corner in
                        Text(corner.label).tag(corner)
                    }
                }
                if desktopWidget.corner == .free {
                    LabeledContent(L("已保存的位置", "Saved position"), value: savedPositionText)
                        .foregroundStyle(Design.Palette.secondaryText)
                    Button(L("清除已保存的位置", "Forget Saved Position")) {
                        settings.update {
                            $0.desktopWidget.originX = nil
                            $0.desktopWidget.originY = nil
                        }
                    }
                    .disabled(desktopWidget.originX == nil && desktopWidget.originY == nil)
                }
            } header: {
                Text(L("位置", "Location"))
            }
            .disabled(!desktopWidget.isEnabled)

            Section {
                Picker(L("图层", "Layer"), selection: settings.binding(\.desktopWidget.depth)) {
                    ForEach(DesktopWidgetDepth.allCases, id: \.self) { depth in
                        Text(depth.label).tag(depth)
                    }
                }
                Toggle(L("允许鼠标穿透桌面小组件", "Click through the desktop widget"), isOn: settings.binding(\.desktopWidget.isClickThrough))
                Toggle(L("在所有空间中显示", "Show on all spaces"), isOn: settings.binding(\.desktopWidget.showsOnAllSpaces))
            } header: {
                Text(L("行为", "Behaviour"))
            } footer: {
                Text(desktopWidget.depth.detail)
                    .font(.callout)
                    .foregroundStyle(Design.Palette.secondaryText)
            }
            // Restore Defaults below stays live: a pane the user has switched off is
            // still a pane they may want to put back the way it shipped.
            .disabled(!desktopWidget.isEnabled)

        }
        .settingsFormStyle()
    }

    // MARK: Modules

    private var moduleList: some View {
        SettingsListBox {
            ForEach(Array(desktopWidget.modules.enumerated()), id: \.element) { index, module in
                SettingsListRow(isFirst: index == 0, isDropTarget: module == dropTarget) {
                    HStack(spacing: Design.Space.m) {
                        ModuleLabel(module: module)
                        Spacer(minLength: Design.Space.m)
                        if let reason = availability.note(for: module) {
                            UnavailableBadge(reason: reason)
                        }
                        ReorderControls(canMoveUp: index > 0,
                                        canMoveDown: index < desktopWidget.modules.count - 1,
                                        itemLabel: module.label) { offset in
                            move(module, by: offset)
                        }
                        RowIconButton(systemName: "trash",
                                      help: desktopWidget.modules.count <= 1
                                          ? L("桌面小组件至少需要一个模块。", "The desktop widget needs at least one module.")
                                          : L("从桌面小组件移除\(module.label)", "Remove \(module.label) from the desktop widget"),
                                      label: L("移除\(module.label)", "Remove \(module.label)")) {
                            settings.update { $0.desktopWidget.modules.removeAll { $0 == module } }
                        }
                        .disabled(desktopWidget.modules.count <= 1)
                    }
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel(module.label)
                }
                .draggable(module.rawValue) {
                    Text(module.label).padding(Design.Space.xs)
                }
                .dropDestination(for: String.self) { payload, _ in
                    dropTarget = nil
                    guard let raw = payload.first, let dragged = PanelModule(rawValue: raw) else { return false }
                    return move(dragged, to: index)
                } isTargeted: { targeted in
                    dropTarget = targeted ? module : (dropTarget == module ? nil : dropTarget)
                }
            }
        }
        .accessibilityLabel(L("桌面小组件模块", "Desktop Widget modules"))
    }

    private var moduleControls: some View {
        HStack(spacing: Design.Space.m) {
            Menu {
                ForEach(availableModules, id: \.self) { module in
                    Button(module.label) {
                        settings.update { $0.desktopWidget.modules.append(module) }
                    }
                }
            } label: {
                Label(L("添加模块", "Add Module"), systemImage: "plus")
            }
            .menuStyle(.borderlessButton)
            .fixedSize()
            .disabled(availableModules.isEmpty)
            .help(availableModules.isEmpty ? L("所有模块均已添加到桌面小组件。", "Every module is already in the desktop widget.") : "")
            .accessibilityLabel(L("为桌面小组件添加模块", "Add a module to the desktop widget"))

            Spacer()
        }
    }

    private var availableModules: [PanelModule] {
        PanelModule.allCases.filter { !desktopWidget.modules.contains($0) }
    }

    private func move(_ module: PanelModule, by offset: Int) {
        settings.update { s in
            guard let index = s.desktopWidget.modules.firstIndex(of: module) else { return }
            let target = index + offset
            guard s.desktopWidget.modules.indices.contains(target) else { return }
            s.desktopWidget.modules.swapAt(index, target)
        }
    }

    private func move(_ module: PanelModule, to destination: Int) -> Bool {
        guard let source = desktopWidget.modules.firstIndex(of: module), source != destination,
              desktopWidget.modules.indices.contains(destination) else { return false }
        settings.update { s in
            guard s.desktopWidget.modules.indices.contains(source),
                  s.desktopWidget.modules.indices.contains(destination) else { return }
            s.desktopWidget.modules.insert(s.desktopWidget.modules.remove(at: source), at: destination)
        }
        return true
    }

    private var savedPositionText: String {
        guard let x = desktopWidget.originX, let y = desktopWidget.originY else { return L("未设置", "Not set") }
        return "\(Int(x)), \(Int(y))"
    }
}
