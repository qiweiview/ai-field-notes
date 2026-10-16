# 贡献指南与代码提交规范 (Contributing & Commit Guidelines)

感谢关注并参与 **ai-field-notes**！为了保持公开仓库的质量与安全，所有开发者以及 AI Coding Agent 在贡献代码时均需遵循本指南。

---

## 1. 核心安全红线 (Security Baseline)

> ⚠️ **本项目为公开仓库 (Public Repo)，禁止提交任何敏感数据！**

提交前请严格对照以下清单自查：
- [ ] 代码、测试、文档、注释中没有任何真实 API 密钥、Access Token、密码或证书。
- [ ] 配置文件是否使用环境变量或仅在本地 `.env`（已被 `.gitignore` 忽略）中保存。
- [ ] 是否不小心将 IDE 目录（如 `.idea/`、`.vscode/`）或操作系统缓存（`.DS_Store`）加入暂存区。
- [ ] 详细敏感数据定义请参阅 [SECURITY.md](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/SECURITY.md) 与 [AGENTS.md](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/AGENTS.md)。

---

## 2. 代码提交规范 (Git Commit Standards)

本项目采用 [Conventional Commits](https://www.conventionalcommits.org/) 规范。

### 2.1 提交信息格式

```text
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

### 2.2 允许的 Type 类型

| Type | 适用场景 |
| :--- | :--- |
| `feat` | 新增功能特性 |
| `fix` | 修复缺陷或 Bug |
| `docs` | 仅修改文档（如 README、说明文档等） |
| `style` | 不影响代码运行逻辑的格式化修改（空格、分号等） |
| `refactor` | 代码重构（既不是新功能也不是修复 bug 的代码改动） |
| `perf` | 性能优化 |
| `test` | 增加或修改测试用例 |
| `chore` | 构建流程、依赖更新或辅助工具变动 |
| `ci` | 持续集成相关的配置与脚本修改 |

### 2.3 提交范例
- `feat(agent): add security scanning rule for prompts`
- `fix(parser): handle empty markdown code blocks`
- `docs(readme): add public repository security notice`

---

## 3. 本地安全钩子配置 (Pre-commit Hook)

仓库提供了轻量级防泄露钩子脚本 `.githooks/pre-commit`。每次 `git commit` 时会自动检测暂存区是否含有潜在的敏感凭据。

### 开启钩子方法（任选其一）：

**方法 A：配置 Git 使用项目钩子目录（推荐）**
```bash
git config core.hooksPath .githooks
chmod +x .githooks/pre-commit
```

**方法 B：软链接到 `.git/hooks`**
```bash
ln -sf ../../.githooks/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

---

## 4. 开发与提交流程 (Workflow)

1. **创建分支**：基于 `main` 创建功能分支（例如 `feat/my-feature` 或 `fix/issue-123`）。
2. **本地编码与验证**：编写测试并确保代码风格一致。
3. **暂存与自审**：
   ```bash
   git status
   git diff --staged
   ```
4. **提交代码**：按规范书写 Commit Message。
5. **发起 Pull Request**：详细描述变更目的与自查结果。
