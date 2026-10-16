# GitHub 公开发布

仓库只承载匿名化的方法、模板和通用脚本。原图、输出图、工程和任务记录属于私有工作资料。

## 发布前检查

```powershell
git status --short --untracked-files=all
git add AGENTS.md README.md LICENSE .gitignore .gitattributes docs templates scripts
git diff --cached --name-only
git diff --cached
```

检查正文中的绝对路径、账号、密钥、源文件名、EXIF/GPS、人物信息、提示词和截图。所有任务记录放在 `workspace/`，不要强制加入。新增公开文件需修改 `.gitignore` 的明确白名单，并检查其内容。

`git check-ignore -v workspace/example/job.md` 可检查私有路径忽略状态。`.gitignore` 不保护已经跟踪的文件，也不扫描文本中的敏感内容；发布前还需检查历史和提交作者邮箱。提交使用用户选择的公开身份或 GitHub noreply 邮箱，不擅自修改全局 Git 身份。

## 创建公开仓库

待用户明确目标账号和仓库名后，在已登录的 GitHub 环境中创建 public 仓库、提交经过检查的文件并推送。检查最终远程 URL、可见性及公开文件清单。不要将本机工具已安装或 Git 已初始化描述成 GitHub 已发布。

GPL 选择为 `GPL-3.0-or-later`。本仓库不包含或重新授权 PhotoCraft、外部 skills、用户照片或角色素材。贡献者只提交自己有权公开的通用内容。
