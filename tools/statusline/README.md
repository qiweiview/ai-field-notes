# Antigravity (agy / ahy) Status Line 格式化脚本

该脚本用于实现 **Antigravity CLI (agy / ahy)** 底部状态栏（Status Line）的定制化格式展示与终端美化。

---

## 🌟 功能特性

1. **模型与推理强度展示**：实时提取当前激活的 LLM 模型名与 Reasoning Effort（如 `[Gemini 2.5 Pro · high]`）。
2. **工作目录与 Git 状态感知**：自动显示当前工作目录 basename 及所在的 Git 分支名与修改脏标记（例如 `ai-field-notes git:(main*)`）。
3. **上下文窗口占用可视化**：以 ANSI 彩色进度条与百分比形式直观显示当前会话 Context Window 的使用量。
4. **配额用量监控 (Quota Usage)**：
   - Gemini 5h 动态配额使用进度条与重置倒计时。
   - Gemini Weekly 周度配额监控。
   - Argon Weekly 配额监控。

---

## 🖥 终端渲染示意

```text
[Gemini 2.5 Pro · high] | ai-field-notes git:(main*) | Context ████░░░░ 50%
5h ██░░░░░░ 25% (resets in 2h 15m) | Gemini Weekly █░░░░░░░ 10% (resets in 4d 8h)
```

---

## 🔧 使用与配置方法

### 1. 配置给 Antigravity CLI (agy / ahy)

在 `~/.gemini/antigravity-cli/settings.json`（或项目级配置）中配置 `status_line` 或状态栏脚本执行路径：

```json
{
  "status_line_command": "/Users/liuqiwei/IdeaProjects/ai-field-notes/tools/statusline/statusline.sh"
}
```
*(或者复制到 `~/.gemini/antigravity-cli/statusline.sh`)*

### 2. 本地直接测试

可通过管道传入模拟 JSON 数据进行格式化测试：

```bash
echo '{
  "model": {"display_name": "Gemini 2.5 Pro", "effort": "high"},
  "cwd": "'"$PWD"'",
  "context_window": {"used_percentage": 42.5},
  "quota": {
    "gemini-5h": {"remaining_fraction": 0.75, "reset_in_seconds": 7200},
    "gemini-weekly": {"remaining_fraction": 0.90, "reset_in_seconds": 259200}
  }
}' | ./tools/statusline/statusline.sh
```
