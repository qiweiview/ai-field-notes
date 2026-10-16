# AI Field Notes (ai-field-notes)

AI 实践与探索笔记、Agent 实验及工程化落地方案沉淀仓库。

---

## 📢 重要声明：公开仓库与安全红线 (Public Repository Notice)

> ⚠️ **本项目为公开开源仓库（Public Repository），对任何敏感数据泄露实施零容忍政策！**

为了防止凭据泄露风险，**所有代码贡献者及 AI Coding Agent（包括但不限于 Antigravity、Cursor、Claude Code、GitHub Copilot 等）必须严格遵守以下安全红线**：

1. **绝对禁止提交任何真实敏感数据**：
   - 严禁提交任何平台的 **API Key**（如 OpenAI、Anthropic、Gemini、AWS、GitHub Token 等）。
   - 严禁提交账号密码、数据库连接串、私钥证书（`.pem`, `.key`, `id_rsa` 等）。
   - 严禁提交公司内网域名、内部 IP 地址或个人敏感隐私信息（PII）。
2. **规范化配置管理**：
   - 所有密钥与环境相关配置一律通过环境变量注入。
   - 仓库仅允许提供带有占位符的示例模板 [`.env.example`](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/.env.example)。
   - 本地实际使用的 `.env` 等私密文件已默认加入 [`.gitignore`](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/.gitignore)，严禁强制解除忽略。
3. **测试数据要求**：
   - 单元测试与用例必须使用 Mock 数据或虚构占位符，严禁使用真实 Token 进行测试。

若发现不慎泄漏，请参阅 [SECURITY.md](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/SECURITY.md) 立即执行凭证吊销与 Git 历史擦除程序。

---

## 🤖 Coding Agent 与提交约束

本项目深度集成 AI Coding Agent，为确保 Agent 输出与人类提交的质量与安全，制定了标准化约束规范：

- **Agent 专属系统规则**：
  - [AGENTS.md](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/AGENTS.md)：通用的 AI Coding Agent 行动准则、提交前自审与安全防护要求（统一单一真实源 Single Source of Truth）。
  - [GEMINI.md](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/GEMINI.md)：针对 Antigravity / Gemini 体系的规则指令（指向 AGENTS.md）。
  - [CLAUDE.md](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/CLAUDE.md)：针对 Claude Code / Anthropic 体系的规则指令（指向 AGENTS.md）。
- **提交信息规范**：遵循 [Conventional Commits](https://www.conventionalcommits.org/) 格式（如 `feat:`, `fix:`, `docs:`, `refactor:` 等），禁止在 Commit 信息中携带任何敏感细节。
- **提交前自检流程**：每次在 `git commit` 前执行 `git diff --staged` 审查新增改动，确保无敏感信息。
- **本地防护机制**：已配置开箱即用的轻量 pre-commit 钩子（见 `.githooks/pre-commit`），自动拦截误暂存的密钥与私钥文件。

详细的贡献指引请参阅 [CONTRIBUTING.md](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/CONTRIBUTING.md)。

---

## 🧰 工具与实验索引 (Tools & Experiments)

| 目录/脚本 | 索引说明 |
| :--- | :--- |
| [**`tools/statusline/`**](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/tools/statusline/) | **Antigravity (agy / ahy) 状态栏格式化脚本**：帮助实现 `agy status line` / `ahy status line` 的终端格式化定制展示（实时展示激活模型、推理强度、Git分支、Context占用进度条及 5h/Weekly 动态配额使用率）。 |

---

## 📂 规范文件导航

| 文件 | 作用与说明 |
| :--- | :--- |
| [README.md](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/README.md) | 项目概览、工具索引与安全红线总览 |
| [AGENTS.md](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/AGENTS.md) | Coding Agent 核心规范、代码与提交约束（Single Source of Truth） |
| [GEMINI.md](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/GEMINI.md) | Antigravity / Gemini Agent 规则入口（指向 AGENTS.md） |
| [CLAUDE.md](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/CLAUDE.md) | Claude Code Agent 规则入口（指向 AGENTS.md） |
| [SECURITY.md](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/SECURITY.md) | 安全策略、敏感信息禁止清单与泄露应急处理 |
| [CONTRIBUTING.md](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/CONTRIBUTING.md) | 贡献者与 Agent 协作指南、Git 提交流程与 Hook 启用说明 |
| [.gitignore](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/.gitignore) | 忽略规则（覆盖凭据、私钥、本地环境、IDE 及临时文件） |
| [.env.example](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/.env.example) | 安全环境变量模板（仅含占位符） |
| [.githooks/pre-commit](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/.githooks/pre-commit) | 本地自动拦截敏感数据提交的 Git Hook 脚本 |

---

## 🚀 快速上手 (Quick Start)

### 1. 配置本地开发环境与 Git Hook
```bash
# 激活本地预提交防泄露检查钩子
git config core.hooksPath .githooks
chmod +x .githooks/pre-commit
```

### 2. 配置环境变量
```bash
# 复制模板文件（注意：切勿提交 .env 到 Git！）
cp .env.example .env
# 在本地 .env 中填写您的本地开发配置
```
