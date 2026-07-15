# Win11Debloat-CN 发行说明

## 版本信息

- 汉化发行版本：`2026.07.11-zh-CN.1`
- 上游基线版本：`2026.07.11`
- 独立发行名称：`Win11Debloat-CN`
- 上游项目：[Raphire/Win11Debloat](https://github.com/Raphire/Win11Debloat)
- 原作者：Raphire
- 中文汉化：被窝
- 发行性质：社区维护的简体中文本地化版本，非上游官方发行版

## 本次发行

本发行包以 Win11Debloat `2026.07.11` 为基础，提供简体中文界面、控制台
提示、配置可见文本和随附说明。除发行说明明确列出的差异外，功能行为以对应
上游基线为准。

窗口会显示 `Win11Debloat-CN | 中文汉化：被窝`，以便与上游原版区分。此署名仅
说明本地化工作，不代表原作者 Raphire 或上游项目的官方立场。

## 启动方式

解压发行包后，以管理员身份运行 `Run.bat`，再按中文界面提示操作。请不要把
上游 README 中的远程一键命令当作本汉化版入口：它会下载并执行上游脚本，而不
是本地的 Win11Debloat-CN 文件。

如需手动启动，请使用 Windows PowerShell 5.1，并在解压目录中执行：

```powershell
.\Win11Debloat.ps1
```

## 发行包内容

发行包应包含运行所需的 `Win11Debloat.ps1`、`Run.bat`、`Scripts/`、
`Schemas/`、`Config/`、`Regfiles/`、`Assets/`、本说明、`README.md`、
`UPSTREAM.md` 和 `LICENSE`。

发行包不得包含运行痕迹或本地状态，例如：

- `Logs/`
- `Backups/`
- `Config/LastUsedSettings.json`
- 构建输出 `dist/`
- 压缩包、校验文件及其他测试产物

## 许可与再发行

本项目沿用上游的 MIT 许可证。发布、复制或再分发 Win11Debloat-CN 时，必须
完整保留根目录 `LICENSE` 文件，以及其中的原始版权声明：

```text
Copyright (c) 2020 Raphire (https://github.com/Raphire)
```

请同时保留上游项目链接、上游基线版本、独立发行名称和“中文汉化：被窝”署名，
并清楚标记该包为非官方社区汉化版本。
