# Open Source and Licensing / 开源与许可

## Open-source commitment / 开源承诺

This repository is the source of truth for the unofficial AirStats Simplified Chinese edition. Application source, build scripts, documentation and version history are public. Each downloadable release is published with a matching source tag, release notes and SHA-256 checksums. Issues and pull requests are welcome under [CONTRIBUTING.md](CONTRIBUTING.md). The release page identifies platform requirements, signing status and known limitations.

本仓库是 AirStats 简体中文版的源代码与版本记录来源。应用源码、构建脚本和说明保持公开；每个下载版本对应同名源码标签，并提供更新记录与 SHA-256 校验值。欢迎按[贡献指南](CONTRIBUTING.md)提交问题和代码。每个版本说明会标明系统要求、签名状态和已知限制。

## License scope / 许可范围

This is a mixed-license repository. Do not assume the root MIT license relicenses vendored components.

| Component | License and notice |
| --- | --- |
| AirStats upstream source and this edition's adaptation | [MIT](LICENSE). The upstream copyright notice is retained and the Chinese adaptation is credited. Upstream base commit: `0609c85256c9d713d7333b90ea345cbf3560dff7`. |
| Embedded Pulse source | [Apache License 2.0](THIRD_PARTY_LICENSES/Pulse/LICENSE), upstream version 1.12.4, commit `13f0cf89775e1b88686cbd610a50a3f7bb2cdb65`. Original source headers are retained. |
| Lobe Icons provider marks | MIT notice reproduced in [Pulse third-party notices](THIRD_PARTY_LICENSES/Pulse/THIRD_PARTY_NOTICES.md). |
| Sparkle and included external components | Notices and license terms in [Sparkle-LICENSE.txt](THIRD_PARTY_LICENSES/Sparkle-LICENSE.txt). |
| Other Pulse marks and dependencies | See [Pulse third-party notices](THIRD_PARTY_LICENSES/Pulse/THIRD_PARTY_NOTICES.md) and [integration record](THIRD_PARTY_LICENSES/Pulse/INTEGRATION.md). |

The optional animated Grok Bot mark from Pulse is not redistributed here: its geometry data is derived from a reference project that grants no open-source license. The animation data and related settings have therefore been omitted; AI quota monitoring and provider/account settings remain available.

本仓库采用多种许可，根目录的 MIT 许可不会替代 vendored 组件自身的许可。上表和第三方声明文件逐项列明来源与适用许可。Pulse 的可选 Grok Bot 动画几何素材源自未授予开源许可的参考项目，因此本项目不再分发该动画素材及相关设置；AI 额度监控与服务商/账号设置仍可使用。

## Attribution and relationship / 归属与关系

This is an unofficial adaptation. It is not endorsed by or affiliated with Byren Cheema, the AirStats project, qunqin24 or the Pulse project. Upstream project names and marks are used only to identify their respective components. The upstream AirStats documentation is retained in [README.upstream.md](README.upstream.md).

本项目为非官方适配，与 AirStats 上游作者、AirStats 项目、qunqin24 或 Pulse 项目没有隶属或背书关系。项目名称和图标用于标识各自来源。上游 AirStats 文档保留于 [README.upstream.md](README.upstream.md)。
