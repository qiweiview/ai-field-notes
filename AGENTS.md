# Coding Agent Guidelines & Commit Constraints

> **CRITICAL SECURITY NOTICE**:  
> **This repository is PUBLIC (`https://github.com/qiweiview/ai-field-notes`).**  
> All AI coding assistants, agents, and contributors must strictly enforce the **Zero Sensitive Data Policy**. Once committed or pushed to a public repository, credentials and sensitive data are immediately exposed and compromised.

---

## 1. Prime Directives for Coding Agents

Every AI Coding Agent (e.g., Antigravity, Cursor, Claude Code, GitHub Copilot) operating in this repository MUST comply with the following non-negotiable rules:

### 1.1 Zero Sensitive Data (严格禁止敏感数据)
**NEVER** generate, write, commit, or log sensitive information, including but not limited to:
- **API Keys & Secrets**: OpenAI, Anthropic, Gemini, AWS, Azure, GCP, GitHub Personal Access Tokens, HuggingFace tokens, etc.
- **Authentication Credentials**: Passwords, hashes, private keys (`.pem`, `.key`, `id_rsa`), certificates, JWT secrets, OAuth tokens.
- **Database & Service URLs**: Connection strings containing usernames, passwords, or production hosts.
- **Internal Network Information**: Private IP ranges (e.g., `10.x.x.x`, `172.16-31.x.x`, `192.168.x.x`), internal VPN/VPC domains, internal company URLs.
- **Personally Identifiable Information (PII)**: Real names, phone numbers, email addresses, identity numbers.

### 1.2 Configuration & Secret Handling
- **Environment Variables**: Always read credentials from environment variables (e.g., `process.env.XXX` in Node.js, `os.environ.get("XXX")` in Python).
- **Templates Only**: Sensitive configuration keys must only be documented in [`.env.example`](file:///Users/liuqiwei/IdeaProjects/ai-field-notes/.env.example) using obvious placeholder values (e.g., `your_api_key_here`, `placeholder_token`).
- **No Hardcoded Defaults**: Fallback defaults in code must NEVER default to real or semi-real keys. Use empty strings or throw informative configuration errors when required environment variables are absent.
- **Test Data**: Unit tests and mocks must use dummy synthetic values (e.g., `sk-dummy-mock-token-00000000000000000000`).

---

## 2. Code Commit & Git Operations Constraints

When staging files, crafting commit messages, or executing Git commands:

### 2.1 Pre-Commit Self-Inspection (提交前自审)
Before issuing `git commit`:
1. Check changed and staged files:
   ```bash
   git status
   git diff --staged
   ```
2. Verify that no file in the staging area contains:
   - Newly added secret strings or tokens.
   - Any un-ignored `.env`, `.pem`, `.key`, or credential files.
   - IDE configuration files (`.idea/`, `.vscode/`) or OS files (`.DS_Store`).
3. **NEVER** use `git commit --no-verify` or bypass pre-commit security hooks.

### 2.2 Commit Message Standards (Conventional Commits)
All commit messages must adhere to the Conventional Commits specification:
```text
<type>(<scope>): <short summary>

[optional body describing why and what changed]

[optional footer(s)]
```

Allowed `<type>` values:
- `feat`: A new feature or major capability
- `fix`: A bug fix
- `docs`: Documentation updates only
- `style`: Formatting, missing semicolons, etc. (no code change)
- `refactor`: Refactoring code without changing public behavior or fixing bugs
- `perf`: Performance improvement
- `test`: Adding or updating tests
- `chore`: Maintenance tasks, dependencies, build/CI configuration
- `ci`: CI/CD pipeline changes

**Rules for Commit Messages**:
- Use imperative mood in the summary (e.g., `feat: add rate limiter`, NOT `added rate limiter`).
- Keep the summary line under 72 characters.
- In multilingual contexts, English or clear Chinese is acceptable, but be concise and consistent.
- **NEVER** include sensitive tokens, passwords, or internal URLs in commit messages or pull request descriptions.

### 2.3 Push & Branching Policy
- Do not run `git push` without explicit user instruction.
- Protect the `main` branch. Development should typically happen on feature branches (e.g., `feat/...`, `fix/...`) when collaborating via Pull Requests.

---

## 3. Emergency Protocol: In Case of Accidental Leak

If any sensitive data is accidentally added or detected in a commit:
1. **Immediate Revocation**: The leaked credential must be revoked/rotated immediately at the provider console.
2. **Do Not Simply "Delete in Next Commit"**: Git retains full historical records. A subsequent commit deleting the secret leaves it visible in Git history.
3. **History Rewriting**:
   - If not pushed: `git reset --soft HEAD~1` and remove the secret before re-committing.
   - If pushed to remote: Consult the repository owner immediately and use `git filter-repo` or `BFG Repo-Cleaner` to purge the secret from the entire commit tree, then force-push and invalidate all compromised secrets.
