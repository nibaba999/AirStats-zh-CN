# AirStats 简体中文版 / AirStats Simplified Chinese Edition

[简体中文](#简体中文) | [English](#english) | [下载 / Downloads](https://github.com/nibaba999/AirStats-zh-CN/releases)

## 简体中文

AirStats 简体中文版是一款 Mac 菜单栏状态监测工具，基于 [AirStats](https://github.com/byrencheema/airstats) 1.6 修改。它可以显示 CPU、内存、网络、磁盘、电池等状态。本项目是**非官方汉化适配**，与原作者没有隶属关系。

### 当前版本：v1.7.0

- AI 额度监控已直接整合进 AirStats：状态栏默认用紧凑圆环显示额度比例，也可选择最多两个额度窗口的多时段圆环；在“设置 → 菜单栏 → AI 额度 → 显示方式”切换样式，在“设置 → AI 额度”管理服务商、账号、刷新、历史和提醒。
- 点击 AirStats 菜单栏图标只打开 AirStats 状态面板；面板保留设置和退出操作，不再显示会另开浮动窗口的“AI 额度”按钮。
- 网速提供“紧凑（上下两行）”和“文字（单行）”等显示方式，可在“菜单栏”设置中按需切换。
- 刷新间隔可在“通用 → 更新间隔”中设置为 0.5、1、2、3、5、10 或 30 秒。

### 版本与语言

- **中英文切换版：v1.7.0**，本仓库发布的版本。可在“通用 → 语言”选择简体中文或 English；退出并重新打开后生效。中文仍有少量提示、无障碍文字和第三方组件为英文。
- **英文原版：AirStats 1.6**，可访问[上游项目](https://github.com/byrencheema/airstats)下载；本仓库的中英文切换版属于非官方适配。
- Pulse 已接入 77 种内置 AI 服务商/工具的额度读取与账号管理；状态栏只显示所选账号的额度窗口和预警，避免把完整配置和历史挤进菜单栏。

### 下载与安装

前往 [Releases](https://github.com/nibaba999/AirStats-zh-CN/releases/tag/v1.7.0) 下载 `AirStats-zh-CN-v1.7.0-macOS-arm64.dmg`，打开后将 `AirStats.app` 拖到 `Applications` 文件夹。也可下载 ZIP，解压后安装。发布页提供 SHA-256 校验值和逐版本更新记录。

**系统要求：**Apple 芯片 Mac、macOS 14 或更高版本。当前包未提供 Intel 版本。

**签名说明：**本包仅使用临时签名，未使用 Apple Developer ID 签名，也未经过 Apple 公证。macOS 的 Gatekeeper 可能阻止打开或提示无法验证开发者；请勿将其误认为上游官方签名版本。首次运行的具体提示取决于系统安全设置。

中文版使用独立的应用标识和设置目录，默认不开机启动，且关闭上游自动更新，避免英文版覆盖汉化。与官方版同名，安装时请留意“应用程序”目录中的替换提示。

### 从源码构建

需要 Xcode 26 或更高版本及网络访问以获取 Swift Package 依赖：

```bash
git clone https://github.com/nibaba999/AirStats-zh-CN.git
cd AirStats-zh-CN
Scripts/build.sh release
```

构建脚本会输出 `.app` 的实际路径，使用临时签名。若仓库位于 macOS 文件提供商管理的目录，安装包会暂存到本地临时目录以完成签名。请勿使用上游项目的 Homebrew 安装命令下载本中文版：它安装的是英文原版。

### 开源承诺与许可

本仓库公开应用源码、构建脚本、版本记录和发布包。欢迎查阅、复现、提交问题和贡献代码；后续版本继续以可核验的源码与版本标签同步发布。许可按来源分别适用：AirStats 上游和本项目适配部分依照根目录 [MIT 许可证](LICENSE)；整合的 Pulse 源码依照 [Apache-2.0](THIRD_PARTY_LICENSES/Pulse/LICENSE)；Pulse 携带的第三方组件和图标许可记录见 [Pulse 第三方声明](THIRD_PARTY_LICENSES/Pulse/THIRD_PARTY_NOTICES.md)，Sparkle 许可见 [Sparkle 声明](THIRD_PARTY_LICENSES/Sparkle-LICENSE.txt)。具体边界、上游版本和提交记录见 [开源与许可说明](OPEN_SOURCE.md)。

AirStats 中文版是非官方适配，与上游作者和 Pulse 项目无隶属关系。原项目名称和图标仅用于标识来源，不代表官方背书。上游原始说明保留在 [README.upstream.md](README.upstream.md)。

### 更新记录

各版本新增、修复和已知限制请查看 [CHANGELOG.md](CHANGELOG.md)；可下载的历史构建位于 [Releases](https://github.com/nibaba999/AirStats-zh-CN/releases)。

---

## English

AirStats Simplified Chinese Edition is an **unofficial adaptation** of [AirStats](https://github.com/byrencheema/airstats) 1.6 by Byren Cheema. It monitors CPU, memory, network traffic, disk, battery and other metrics from the macOS menu bar.

### Editions and languages

- **Bilingual edition: v1.7.0**, distributed from this repository. Select Simplified Chinese or English in General → Language, then quit and reopen the app. Some prompts, accessibility text and third-party components remain in English in Chinese mode.
- AI quota monitoring is integrated into AirStats. The compact ring shows the selected account's quota by default; an optional multi-window ring can show up to two quota windows. Choose the style in Settings → Menu Bar → AI Usage → Display Style. Provider, account, refresh, history and alert settings remain in Settings → AI Usage. Clicking the AirStats menu bar icon opens its status panel, which no longer contains the redundant AI Usage button.
- Pulse includes quota readers and account management for more than 70 built-in AI services and tools; the status bar stays focused on the selected account's quota windows and warning state.
- **Original English edition:** available from the [upstream AirStats project](https://github.com/byrencheema/airstats). This repository is an unofficial adaptation.
- The combined network readout offers **Compact (two lines)** and **Text (single line)**, along with other display styles, in menu-bar settings. The compact style puts download above upload.
- The sampling interval can be set to 0.5, 1, 2, 3, 5, 10 or 30 seconds in General settings.

### Download and install

Download `AirStats-zh-CN-v1.7.0-macOS-arm64.dmg` from [Releases](https://github.com/nibaba999/AirStats-zh-CN/releases/tag/v1.7.0), open it and drag `AirStats.app` to Applications. A ZIP, SHA-256 checksums and version-specific notes are also available.

**Requirements:** Apple silicon and macOS 14 or later. An Intel build is not provided.

**Signing:** This build is ad-hoc signed, not signed with Apple Developer ID and not notarized by Apple. macOS Gatekeeper may block it or report that the developer cannot be verified. It is not the officially signed upstream release.

The adaptation has a separate bundle identifier and settings directory, does not launch at login by default, and disables upstream automatic updates. Its app bundle has the same filename as the upstream app, so review any replacement prompt during installation.

### Build from source

Xcode 26 or later and network access to Swift Package dependencies are required:

```bash
git clone https://github.com/nibaba999/AirStats-zh-CN.git
cd AirStats-zh-CN
Scripts/build.sh release
```

The build script prints the path to its ad-hoc signed `.app`. In a macOS File Provider-managed checkout, it stages the bundle in a local temporary directory to avoid sync metadata breaking the signature. The upstream Homebrew installation command installs the original English application, not this adaptation.

### Open-source commitment and licenses

This repository publishes the application source, build scripts, version history and release packages. Issues and contributions are welcome; future versions will remain paired with inspectable source and version tags. Licenses apply by component: upstream AirStats and this adaptation are under the root [MIT license](LICENSE); embedded Pulse source is under [Apache-2.0](THIRD_PARTY_LICENSES/Pulse/LICENSE); notices for Pulse's third-party components and marks are in [Pulse third-party notices](THIRD_PARTY_LICENSES/Pulse/THIRD_PARTY_NOTICES.md), and Sparkle's notices are in [the Sparkle license file](THIRD_PARTY_LICENSES/Sparkle-LICENSE.txt). See [Open Source and Licensing](OPEN_SOURCE.md) for scope and upstream references.

This is an unofficial AirStats adaptation and is not affiliated with the AirStats or Pulse maintainers. Names and marks identify upstream components and do not imply endorsement. The original AirStats documentation is retained in [README.upstream.md](README.upstream.md). See [CHANGELOG.md](CHANGELOG.md) for changes by version and [Releases](https://github.com/nibaba999/AirStats-zh-CN/releases) for downloads.
