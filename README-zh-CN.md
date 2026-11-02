# AirStats 简体中文版

AirStats 是一款 macOS 菜单栏状态监测工具。本仓库提供基于上游 AirStats 的非官方简体中文适配版，支持中英文切换，并把 Pulse 的 AI 使用额度监控整合进同一个应用。

## 下载

当前版本 **v1.7.0**：前往 [GitHub Releases](https://github.com/nibaba999/AirStats-zh-CN/releases/tag/v1.7.0) 下载 Apple 芯片版 DMG 或 ZIP。DMG 打开后将 AirStats 拖入“应用程序”。发布页包含 SHA-256 校验和更新说明。

要求：Apple 芯片 Mac、macOS 14 或更高版本。安装包使用临时签名，没有 Developer ID 签名或 Apple 公证，macOS 可能显示安全提示。

## 功能

- 在菜单栏查看 CPU、内存、网络、磁盘、电池和 AI 额度等状态。
- AI 提供商、账号、提醒和额度设置直接集成在 AirStats 的“AI 额度”设置页；菜单栏摘要可单独开关。
- 点击菜单栏图标打开 AirStats 状态面板。面板不再出现会另开窗口的重复“AI 额度”按钮。
- 网速可选紧凑上下两行或单行文字布局；刷新间隔可在设置中调整。
- 在“通用 → 语言”选择简体中文或 English，退出并重新打开应用后生效。

为遵守素材许可，Pulse 上游可选的 Grok Bot 动画素材未随本项目发布；额度监控和账号设置不受影响，额度环中继续显示各服务商图标。中文界面仍可能有少量第三方文案为英文。

## 构建源码

需要 Xcode 26 或更高版本以及网络访问以获取 Swift Package 依赖：

```bash
git clone https://github.com/nibaba999/AirStats-zh-CN.git
cd AirStats-zh-CN
Scripts/build.sh release
```

编译结果为 `.build/release/AirStats.app`。上游的 Homebrew 命令安装的是英文原版，不是本适配版。

## 开源和许可

本项目承诺持续公开源码、构建方式、逐版本变更记录与可校验的发布包，欢迎提交问题和贡献。不同来源的代码按各自许可发布：AirStats 上游及中文适配适用 [MIT](LICENSE)；整合的 Pulse 源码适用 [Apache-2.0](THIRD_PARTY_LICENSES/Pulse/LICENSE)；其图标、Sparkle 与其他第三方声明见 [第三方许可目录](THIRD_PARTY_LICENSES)。请阅读[开源与许可说明](OPEN_SOURCE.md)了解各自范围。

本项目与 AirStats 上游作者及 Pulse 维护者无隶属关系。详情见[版本更新记录](CHANGELOG.md)和[贡献指南](CONTRIBUTING.md)。
