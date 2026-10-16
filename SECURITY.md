# Security Policy (安全策略)

## 1. Public Repository Notice (公开仓库声明)

`ai-field-notes` 是一个**公开开源仓库**。本项目对代码安全与敏感信息实施严格的零容忍（Zero Tolerance）管理。

---

## 2. Forbidden Sensitive Data (严禁提交的敏感数据)

所有代码贡献者及 AI Coding Agent 在提交代码前，必须确保以下信息未被写入仓库中任何文件（包括代码、注释、测试用例、文档及 Issue/PR）：

| 类别 | 严禁内容示例 |
| :--- | :--- |
| **API 密钥与凭据** | OpenAI / Anthropic / Gemini / AWS / Azure / GCP / GitHub Token / HuggingFace Token 等各类平台密钥 |
| **认证与加密材料** | 数据库密码、系统账号密码、SSH 私钥 (`id_rsa`)、SSL 证书 (`.pem`, `.key`, `.p12`)、JWT 签名密钥 |
| **服务与数据库地址** | 生产/测试环境包含账号密码的连接串 (如 `postgres://user:pass@host:5432/db`) |
| **内网资产信息** | 内部专用 IP 地址段、公司内网域名、内部服务专有路由 |
| **个人隐私数据 (PII)** | 个人手机号、身份证件号、非公开邮箱、真实人名及住址等隐私数据 |

---

## 3. Secret Management Guidelines (凭据管理准则)

1. **统一环境变量注入**：所有凭证与私密配置一律通过环境变量（如 `.env`）在本地注入，禁止硬编码。
2. **模板配置占位符**：示例文件仅保留 [`.env.example`](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/.env.example)，且内部值必须为无意义占位符（例如 `your_api_key_here`）。
3. **版本控制忽略**：任何含有真实配置的文件必须加入 [`.gitignore`](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/.gitignore)。
4. **测试模拟 (Mock)**：编写测试时，严禁使用真实 API Key 发起网络请求或断言真实 Key，必须使用 Mock 数据与虚构字符串。

---

## 4. Leakage Incident Response (泄露应急响应流程)

如果在任何提交中不慎泄露了敏感信息：

1. **立即吊销 (Revoke Immediately)**：
   - 立即登录对应云服务商或平台控制台，将泄露的 Key、Token 或密码作废、重置或吊销。
   - **切记：即使在 Git 中删除文件或回滚，公开仓库一旦推送，第三方抓取器（Scraper）几秒内即可捕获凭证。吊销凭证永远是第一要务！**
2. **重写 Git 提交历史 (Purge Git History)**：
   - 如果尚未推送（Local unpushed）：执行 `git reset --soft HEAD~1`，移除敏感数据并重新提交。
   - 如果已推送至远端（Remote pushed）：使用 `git-filter-repo` 或 `BFG Repo-Cleaner` 清除历史中的全部痕迹，并强制推送到所有分支。
3. **通知仓库维护者**：在安全渠道向仓库所有者同步泄露情况并确认隐患已清除。

---

## 5. Reporting Security Vulnerabilities (安全漏洞反馈)

如果您在本项目中发现了任何安全漏洞或敏感数据泄露风险，请不要公开创建 Issue。请通过仓库所有者指定的私密渠道或 GitHub Security Advisory 进行私密披露。
