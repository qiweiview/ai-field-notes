#!/usr/bin/env python3
import sys
import json
import os
import subprocess

# 256 / ANSI 配色定义（对齐参考图 1 风格）
CYAN = "\033[38;5;51m"
YELLOW = "\033[38;5;221m"
MAGENTA = "\033[38;5;205m"
MUTED_LABEL = "\033[38;5;248m"
MUTED_DIV = "\033[38;5;240m"
MUTED_TIME = "\033[38;5;244m"

# Context 绿色系
GREEN_FILL = "\033[38;5;114m"
GREEN_EMPTY = "\033[38;5;238m"
GREEN_TEXT = "\033[38;5;114m"

# Quota / Usage 紫蓝色系
PURPLE_FILL = "\033[38;5;147m"
PURPLE_EMPTY = "\033[38;5;238m"
PURPLE_TEXT = "\033[38;5;147m"

RESET = "\033[0m"

def make_bar(pct, width=8, fill_color=GREEN_FILL, empty_color=GREEN_EMPTY):
    try:
        pct = max(0.0, min(100.0, float(pct)))
    except (ValueError, TypeError):
        pct = 0.0
    filled = int(round((pct / 100.0) * width))
    if pct > 0 and filled == 0:
        filled = 1
    empty = max(0, width - filled)
    return f"{fill_color}{'█' * filled}{empty_color}{'░' * empty}{RESET}"

def fmt_time(seconds):
    try:
        seconds = float(seconds)
    except (ValueError, TypeError):
        return "0m"
    if seconds <= 0:
        return "0m"
    days = int(seconds // 86400)
    hours = int((seconds % 86400) // 3600)
    mins = int((seconds % 3600) // 60)
    if days > 0:
        return f"{days}d {hours}h"
    elif hours > 0:
        return f"{hours}h {mins}m"
    return f"{mins}m"

def main():
    try:
        raw = sys.stdin.read()
        if not raw.strip():
            return
        data = json.loads(raw)
        if not isinstance(data, dict):
            return
    except Exception:
        return

    try:
        # 1. 模型与推理强度
        model_info = data.get("model")
        if isinstance(model_info, dict):
            raw_name = model_info.get("display_name") or model_info.get("id") or "Gemini"
            effort = model_info.get("effort") or data.get("reasoning_effort") or ""
        elif isinstance(model_info, str):
            raw_name = model_info
            effort = data.get("reasoning_effort") or ""
        else:
            raw_name = "Gemini"
            effort = data.get("reasoning_effort") or ""

        model_name = str(raw_name).split(" (")[0]

        # 2. 目录与 Git 分支
        cwd = data.get("cwd")
        if not cwd:
            ws = data.get("workspace")
            if isinstance(ws, dict):
                cwd = ws.get("project_dir")
        if not cwd:
            cwd = os.getcwd()

        dirname = os.path.basename(str(cwd).rstrip("/")) or "/"
        git_str = ""
        try:
            res = subprocess.run(
                ["git", "status", "--porcelain", "-b"],
                cwd=cwd,
                capture_output=True,
                text=True,
                timeout=0.4
            )
            if res.returncode == 0:
                lines = res.stdout.splitlines()
                if lines:
                    branch = lines[0].split("...")[0].replace("## ", "").strip()
                    dirty = "*" if len(lines) > 1 else ""
                    git_str = f" {MAGENTA}git:({branch}{dirty}){RESET}"
        except Exception:
            pass

        # 3. 上下文进度条与百分比
        cw = data.get("context_window")
        used_pct = 0.0
        if isinstance(cw, dict):
            used_pct = cw.get("used_percentage") or 0.0
        try:
            used_pct = float(used_pct)
        except (ValueError, TypeError):
            used_pct = 0.0

        ctx_bar = make_bar(used_pct, width=8, fill_color=GREEN_FILL, empty_color=GREEN_EMPTY)
        ctx_part = f"{MUTED_LABEL}Context{RESET} {ctx_bar} {GREEN_TEXT}{used_pct:.0f}%{RESET}"

        # 第一行：[Model (effort)] | dirname git:(branch) | Context
        model_part = f"{CYAN}[{model_name}" + (f" · {effort}" if effort else "") + f"]{RESET}"
        dir_part = f"{YELLOW}{dirname}{RESET}{git_str}"
        line1 = f"{model_part} {MUTED_DIV}|{RESET} {dir_part} {MUTED_DIV}|{RESET} {ctx_part}"

        # 4. 配额 Usage (Gemini 5h / Gemini Weekly / Argon Weekly)
        quota = data.get("quota")
        if not isinstance(quota, dict):
            quota = {}

        def fmt_quota(label, bucket):
            if not isinstance(bucket, dict):
                return None
            rem = bucket.get("remaining_fraction")
            if rem is None:
                return None
            try:
                rem_f = float(rem)
                used_q_pct = max(0.0, (1.0 - rem_f) * 100.0)
                q_bar = make_bar(used_q_pct, width=8, fill_color=PURPLE_FILL, empty_color=PURPLE_EMPTY)
                reset_sec = bucket.get("reset_in_seconds") or 0
                reset_str = f" {MUTED_TIME}(resets in {fmt_time(reset_sec)}){RESET}" if reset_sec else ""
                return f"{MUTED_LABEL}{label}{RESET} {q_bar} {PURPLE_TEXT}{used_q_pct:.0f}%{RESET}{reset_str}"
            except (ValueError, TypeError):
                return None

        line2_parts = []
        for label, key in [
            ("5h", "gemini-5h"),
            ("Gemini Weekly", "gemini-weekly"),
            ("Argon Weekly", "gemini-argon-wtu-weekly"),
        ]:
            part = fmt_quota(label, quota.get(key))
            if part:
                line2_parts.append(part)

        line2 = f" {MUTED_DIV}|{RESET} ".join(line2_parts)

        print(line1)
        if line2:
            print(line2)
    except Exception:
        try:
            print("[Gemini] | " + os.path.basename(os.getcwd()))
        except Exception:
            pass

if __name__ == "__main__":
    main()
