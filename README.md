# CosplayAIHub

以 Codex / GPT Image、PhotoCraft、MCP 和相关 skills 为基础的 Cosplay 照片精修流程工作区。追求 Pixel Perfect：保留原图像素底层与原生画布，用独立图层、蒙版和调整层完成精修、调色与角色特效。

## 像素与图层约定

原图底层锁定且保持不变，不缩放、裁切、扩边或重采样画布。GPT Image 生成可叠加的特效素材或局部补丁，再交给 PhotoCraft 分层合成，不用 AI 整图结果替换原始照片。保留可重新打开的分层工程。

叠加特效和调色会改变授权区域内的可见像素；未受影响的区域须进行像素差异检查。全局调色属于整幅修改，羽化、光晕和反光也属于实际影响范围。原生尺寸不变与未修改区域保真分别验收。

精确保留未修改像素时优先交付无损 PNG；JPEG 重新编码可能改变整幅像素。色彩转换、位深与导出能力均须实测，不承诺文件字节或元数据与原图一致。

## 工作区结构

```text
AGENTS.md                  给修图 agent 的执行约定
docs/workflow.md           诊断、修图、合成与验收流程
docs/tooling.md            工具接入与最小验证
docs/publishing.md         GitHub 公开发布约定
templates/job.example.md   不含真实信息的任务模板
scripts/New-RetouchJob.ps1  创建本地私有任务目录
workspace/                 私有任务、临时脚本、PSD 等，全部忽略
```

原图存放在工作区外。最终图片写入每张原图旁的 `aifix/`，例如 `<照片目录>/aifix/shot_jpg_base_v001.png`。PSD、蒙版、AI 中间素材和详细日志留在 `workspace/`。原图始终保持不变，已有成片也不覆盖。

## 开始使用

向 Codex 提供原图路径及期望，例如“诊断这张照片”“自然精修并加轻微角色特效”或“仅调整色彩”。Agent 应先阅读 [AGENTS.md](AGENTS.md)。

也可以手动创建任务（以下路径为占位示例）：

```powershell
./scripts/New-RetouchJob.ps1 -SourcePath '<照片目录>/shot.jpg'
```

脚本只检查源文件并创建仓库内的私有任务目录、记录和模板，不改图、不创建成片。实际修图导出时再创建原图旁的 `aifix/`。如果源文件已位于 `aifix/`，脚本会拒绝默认处理，避免递归输出；应选择真正的原图。

工具需要在各自环境中安装和连接。本仓库不附带账号、密钥、软件安装包、私人照片或第三方 skills。PhotoCraft 的接入以本机实测为准，参见 [工具说明](docs/tooling.md)。

## 公开范围

只公开通用流程、匿名模板与可复用脚本。Git 使用文件白名单，新增文件默认忽略。`workspace/` 和图片、RAW、工程、日志、本地配置不应上传。提交仍须检查内容；`.gitignore` 不是隐私扫描器。

公开发布步骤和提交检查见 [发布说明](docs/publishing.md)。

## 协议

本项目自有代码、流程和模板采用 **GNU GPL v3.0 或更新版本（GPL-3.0-or-later）**，见 [LICENSE](LICENSE)。照片、角色素材、第三方软件与技能的权利不在本仓库授权范围内。
