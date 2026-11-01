# AirStats 简体中文版 / AirStats Simplified Chinese Edition

[简体中文](#简体中文) | [English](#english) | [下载 / Downloads](https://github.com/nibaba999/AirStats-zh-CN/releases)

## 简体中文

AirStats 简体中文版是一款 Mac 菜单栏状态监测工具，基于 [AirStats](https://github.com/byrencheema/airstats) 1.6 修改。它可以显示 CPU、内存、网络、磁盘、电池等状态。本项目是**非官方汉化适配**，与原作者没有隶属关系。

### 版本与语言

- **中文版：v1.6-zh.1**，本仓库发布的版本；主要面板和设置已汉化，部分提示、无障碍文字和第三方组件仍为英文。
- **English: upstream AirStats 1.6**，英文原版请访问[上游项目](https://github.com/byrencheema/airstats)。本仓库目前没有独立的英文安装包，不能在中文版中切换回完整英文。
- 本版本增加紧凑网速布局：在“菜单栏”设置里将“网络（上传与下载）”设为“文字”，即可上下两行显示下载和上传。
- 刷新间隔可在“通用 → 更新间隔”中设置为 0.5、1、2、3、5、10 或 30 秒。

### 下载与安装

前往 [Releases](https://github.com/nibaba999/AirStats-zh-CN/releases) 下载 `AirStats-zh-CN-v1.6-zh.1-macOS-arm64.zip`，解压后将 `AirStats.app` 拖入“应用程序”文件夹。

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

编译结果位于 `.build/release/AirStats.app`，使用临时签名。请勿使用上游项目的 Homebrew 安装命令下载本中文版：它安装的是英文原版。

### 许可与归属

本项目保留上游作者 Byren Cheema 的版权声明和 [MIT 许可证](LICENSE)，同时注明中文适配的版权。上游源码基于提交 `0609c85256c9d713d7333b90ea345cbf3560dff7`；第三方依赖 Sparkle 及其组成部分的许可与版权声明见 [Sparkle 许可证](THIRD_PARTY_LICENSES/Sparkle-LICENSE.txt)。原项目的名称和图标仅用于标识本适配的来源，不代表官方背书。上游原始说明保留在 [README.upstream.md](README.upstream.md)。

---

## English

AirStats Simplified Chinese Edition is an **unofficial adaptation** of [AirStats](https://github.com/byrencheema/airstats) 1.6 by Byren Cheema. It monitors CPU, memory, network traffic, disk, battery and other metrics from the macOS menu bar.

### Editions and languages

- **Chinese edition: v1.6-zh.1**, distributed from this repository. Main panels and settings are translated; some prompts, accessibility text and third-party components remain in English.
- **English edition:** use the [upstream AirStats project](https://github.com/byrencheema/airstats). This repository does not provide a separate English installer or an in-app switch to a fully English interface.
- To show compact network rates on two lines, select **Text** for the combined upload/download readout in menu-bar settings. Download is on top; upload is below.
- The sampling interval can be set to 0.5, 1, 2, 3, 5, 10 or 30 seconds in General settings.

### Download and install

Download `AirStats-zh-CN-v1.6-zh.1-macOS-arm64.zip` from [Releases](https://github.com/nibaba999/AirStats-zh-CN/releases), extract it and move `AirStats.app` to Applications.

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

The ad-hoc signed result is `.build/release/AirStats.app`. The upstream Homebrew installation command installs the original English application, not this adaptation.

### License and attribution

The [MIT license](LICENSE) retains the upstream copyright notice for Byren Cheema and credits the Chinese adaptation. Upstream base commit: `0609c85256c9d713d7333b90ea345cbf3560dff7`. The copyright and license notices for Sparkle and its components are included in [the Sparkle license](THIRD_PARTY_LICENSES/Sparkle-LICENSE.txt). Upstream names and icons identify the source and do not imply endorsement. The original upstream documentation is retained in [README.upstream.md](README.upstream.md).
