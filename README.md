# Win11Debloat-CN

Win11Debloat-CN 是 [Raphire/Win11Debloat](https://github.com/Raphire/Win11Debloat)
的独立简体中文本地化发行版，当前以其 `2026.07.11` 版本为上游基线。

- 汉化发行版本：`2026.07.11-zh-CN.1`
- 上游项目：[Raphire/Win11Debloat](https://github.com/Raphire/Win11Debloat)
- 上游原作者：Raphire
- 中文汉化：被窝
- 发行性质：社区维护的本地化版本，非上游官方发行版

## 本版本定位

本版本将界面、控制台提示、配置可见文本和随附说明翻译为简体中文。除发行说明
明确列出的差异外，功能行为以标注的上游基线为准。

`Win11Debloat-CN` 是独立的本地发行名称，不代表、不替代，也不以 Raphire 或
上游 Win11Debloat 项目的名义发布。

## 本地启动

1. 下载并解压本版本的发行压缩包。
2. 运行 `Run.bat`，并在 Windows 弹出权限提示时允许以管理员身份运行。
3. 按中文界面提示选择需要的项目。

如需手动启动，请在解压目录中以管理员身份打开 Windows PowerShell 5.1 并运行
`Win11Debloat.ps1`。主脚本不应使用 PowerShell 7（`pwsh`）启动。

请不要把上游 README 中的远程一键命令作为本版本的启动入口。该命令会从
`https://debloat.raphi.re/` 下载并启动上游脚本，而不是本地的 Win11Debloat-CN
文件。

## 使用提示

本工具会修改 Windows 设置，并可能移除预装应用。执行前请创建还原点或备份重要
数据，逐项阅读提示，只应用自己了解的更改。

## 发行与同步

当前发行内容、再发行要求见 [RELEASE.zh-CN.md](RELEASE.zh-CN.md)。同步上游的
操作规范见 [UPSTREAM.md](UPSTREAM.md)；导入上游更新后，必须在发布前重新测试
本地中文版本。

## 许可与署名

上游项目使用 MIT 许可证。完整的原始许可证和版权声明保留在
[LICENSE](LICENSE) 中，包括：

```text
Copyright (c) 2020 Raphire (https://github.com/Raphire)
```

依据 MIT 许可证，复制、发布或再分发本版本时，必须保留上述版权声明及完整许可
文本。“中文汉化：被窝”仅说明本地化工作，不替代上游作者或版权持有人。
