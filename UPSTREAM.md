# 上游同步说明

## 上游信息

- 项目：[Raphire/Win11Debloat](https://github.com/Raphire/Win11Debloat)
- 原作者：Raphire
- 当前汉化基线：`2026.07.11`
- 本地发行名称：`Win11Debloat-CN`
- 中文汉化：被窝

Win11Debloat-CN 是独立维护的社区本地化版本，非上游官方发行版本或渠道。同步时，
请以已发布的上游版本或标签为基准，并在发行说明中记录新的上游基线。

## 同步流程

1. 记录当前汉化发行版本、对应上游版本和本地未合并的翻译修改。
2. 从上游仓库获取目标版本的源代码或发行包；如使用 Git，可添加
   `https://github.com/Raphire/Win11Debloat.git` 为只读的 `upstream` 远程仓库。
3. 将上游更新导入本地工作副本，比较 `Win11Debloat.ps1`、`Scripts/`、
   `Schemas/`、`Config/`、`Regfiles/` 和 `Run.bat` 的变化。
4. 将新增或变更的可见文本翻译为简体中文；不要随意翻译 PowerShell 参数、
   注册表路径、包名、命令名称或文件路径。
5. 保留 `LICENSE` 中 Raphire 的完整 MIT 版权与许可文本，并更新
   `README.md`、`RELEASE.zh-CN.md` 的上游基线和本地发行版本。
6. 在干净的 Windows 测试环境中启动本地 `Run.bat`，检查界面、控制台输出、
   管理员提升和主要设置流程。
7. 从干净工作目录打包发行文件，确认不包含 `Logs/`、`Backups/`、
   `Config/LastUsedSettings.json`、`dist/`、压缩包或校验文件。

## 本地入口规则

Win11Debloat-CN 的用户入口始终是发行包内的 `Run.bat` 或本地
`Win11Debloat.ps1`。不要在本项目的说明、快捷方式或发布页中把上游远程一键
命令作为本地汉化版启动方式；该命令会下载和运行上游脚本，无法保证使用到本地
翻译和本地发行版本。

## 版本命名

建议使用 `上游版本-zh-CN.序号`，例如 `2026.07.11-zh-CN.1`。当上游基线更新
时，更新前半部分；同一上游基线内仅修订翻译或发行内容时，递增末尾序号。
