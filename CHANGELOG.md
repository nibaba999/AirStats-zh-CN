# Changelog / 更新记录

This project follows versioned releases. Each entry describes user-visible changes; the linked GitHub release contains the downloadable build and checksum.

## [1.7.0] — 2026-11-02

### Added

- Integrated Pulse AI quota monitoring and provider/account/alert settings into AirStats.
- Added compact AI quota ring and multi-window ring styles to the native AirStats menu bar, with account and warning state.
- Added Simplified Chinese and English localization for the integrated AI settings and menu-bar readout.
- Added persistent menu-bar readout selection with a migration that preserves existing layout choices.
- Migrated the previous default AI text readout to the compact ring style; user-selected text remains unchanged.
- Added a compact two-line network speed style alongside the single-line style; sampling interval remains configurable.

### Changed

- Removed the redundant “AI Usage” action from the AirStats status panel. The panel opens as before and contains Settings and Quit; AI configuration stays in the AirStats settings window.
- AirStats now hosts Pulse settings and routes Pulse settings links into the matching AirStats settings page.
- Excluded Pulse's optional animated Grok Bot mark and related controls because the upstream geometry data has no open-source license. Provider marks remain in quota rings.
- Updated bilingual project documentation, license scope, release notes and contribution information.

### Packaging

- Apple silicon; macOS 14 or later.
- Ad-hoc signed; not Developer ID signed or notarized by Apple. Gatekeeper may show a warning.

### 中文摘要

- 将 Pulse AI 额度监控、服务商/账号/提醒设置和菜单栏额度摘要整合进 AirStats，并补齐中文与英文界面。
- 移除状态面板中会重复打开浮动窗口的“AI 额度”按钮；AI 功能仍可在菜单栏与 AirStats 设置中使用。
- 网速增加上下两行紧凑布局，同时保留单行样式；刷新间隔可配置。
- 为遵守素材许可，未分发 Pulse 上游未获得开源许可的机器人动画几何素材及相关设置。
- 安装包仅支持 Apple 芯片、macOS 14 及以上；采用临时签名，未经过 Apple 公证。

下载文件及校验值见 [v1.7.0 GitHub Release](https://github.com/nibaba999/AirStats-zh-CN/releases/tag/v1.7.0)。
