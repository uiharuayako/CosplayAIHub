# 工具接入

## 能力分工

| 工具 | 用途 | 验证方式 |
| --- | --- | --- |
| Codex 图像理解 | 诊断、局部检查、对照原图 | 实际查看目标图片 |
| Codex 内置图像生成/编辑 | 授权范围内的 AI 编辑、背景补全、效果素材 | 检查生成结果并保存选用文件 |
| PhotoCraft MCP | 可编辑图层、蒙版、调整与合成 | 发现实际 schema，完成保存与重开 |
| PhotoCraft CLI / 控制通道 | MCP 不可用时，使用本机明确支持的接口 | 查看可信可执行文件的帮助与版本 |
| skills | 诊断与修图方法、提示词和质量约束 | 阅读当前安装版本的 SKILL.md |

PhotoCraft 项目及接口说明以 [上游仓库](https://github.com/storytold/photocraft) 为准；上游支持 CLI、JSON 控制通道与 MCP，但实际安装版本的命令和参数必须现场核对。不要从相似名称的下载站安装程序。

## 最小接入验证

1. 发现当前会话的 PhotoCraft MCP 工具；未发现则定位本机已有安装，读取版本及 `--help`，不扫描或公开整份私有配置。
2. 在 `workspace/` 建立临时测试文档，添加一个图层或调整层，保存为该版本支持的分层工程，并导出小图。
3. 重新打开工程和导出图，验证图层可编辑与像素结果。CLI 独立进程与桌面当前文档不一定共享状态，应确认操作目标。
4. 接入状态、实际路径、版本、测试结果及失败原因记入 `workspace/local-environment.md`；不把该记录复制到公开文档。

当前仓库不携带可直接使用的 MCP 配置，也不预设 MCP 工具名称。尚未执行上述回环时，只能标记“未验证”。不要为了补齐接口擅自安装第三方服务或修改用户全局配置。

## 本项目使用的接入方式

使用 PhotoCraft 自带的 `photocraft-cli mcp`，通过 STDIO 在独立的无界面会话中编辑。它与桌面已经打开的文档不共享状态。配置由用户授权后写入本机 Codex，机器路径和备份保留在私有目录，不提交到仓库。

参考配置命令（路径为占位符）：

```powershell
codex mcp add photocraft -- '<PhotoCraft安装目录>/photocraft-cli.exe' mcp --automation-read-root '<工作区>/workspace' --automation-write-root '<工作区>/workspace'
codex mcp get photocraft
```

该方式只授予私有任务根目录读写能力。每次处理外部照片时，先检查原图哈希，将源文件以不重新编码的方式复制到任务目录，并记录副本哈希；MCP 打开副本、锁定底层，在原生画布上添加独立效果图层。导出到任务目录后检查，再通过文件复制将最终图片写到原图目录的 `aifix/`。不为方便读写而开放整块磁盘，不对原图执行保存。

工具参数按当前 `tools/list` 与 `command_list` 发现。PhotoCraft 0.9.0 的本机验证应覆盖 `doc_open`、`doc_place`、图层命令、`doc_save`、`doc_inspect`、PNG 导出及工程重开。`render_preview` 是有尺寸上限的预览，不能用它替代原生分辨率成片导出。

已有聊天不一定即时加载新增的 MCP；配置后需在 MCP 设置重启该服务器或重新加载 Codex，再核对当前聊天的工具列表。独立 MCP 协议验证成功与当前聊天已获得工具是两个不同状态。

Codex 配置方式参见 [官方 MCP 文档](https://learn.chatgpt.com/docs/extend/mcp?surface=cli)。如需后续接管桌面实时文档，可按 [PhotoCraft 控制协议](https://github.com/storytold/photocraft/blob/main/docs/control-protocol.md)配置带本地令牌的 bridge；这不是当前默认模式。

## 推荐技能

- `retouch-cosplay-photo`：场照诊断、背景处理、人物精修及角色氛围。
- `portrait-retouch`：需要更细致单人面部诊断时使用。
- `imagegen`：内置生成/编辑工具的工作流。
- `gpt-image-2`：用户需要该模型的提示词设计或参数研究时使用。

技能按名称发现，不在仓库写个人机器上的安装路径。未安装时说明缺失，只在用户要求安装时执行安装。使用本项目不会自动获得任何外部软件、skill 或云服务的授权。
