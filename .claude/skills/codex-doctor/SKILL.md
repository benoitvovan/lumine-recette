---
name: codex-doctor
description: Audit local Codex setup without making changes. Use when Codex behaves oddly, MCP tools fail, plugins or skills are missing, automations do not run, a new machine needs verification, or the user says "verifie ma config", "MCP casse", "Codex doctor", "debug Codex", or "setup Codex".
---

# Codex Doctor

Audit the local Codex environment and report actionable findings. This skill is read-only by default: inspect, explain, and propose fixes before changing files.

## Workflow

1. Identify the active Codex home.
   - Prefer `$CODEX_HOME` (or `$env:CODEX_HOME` on Windows) when present.
   - Otherwise use the default per platform (`~/.codex` on macOS/Linux, `%USERPROFILE%\.codex` on Windows).

2. Inspect core files and folders.
   - `config.toml`
   - `skills/`
   - `agents/`
   - `plugins/`
   - `rules/`

3. Check MCP configuration.
   - List the configured MCP servers.
   - Classify each server as HTTP or STDIO.
   - Never print bearer tokens or secret values. Replace them with `<redacted>`.

4. Check skills.
   - List user skills and system skills separately.
   - Flag skills with missing `SKILL.md`, invalid frontmatter, template placeholders, or duplicate names.

5. Check agents.
   - List custom agents under `agents/`.
   - Flag missing required fields: `name`, `description`, `developer_instructions`.
   - Recommend read-only sandbox for explorer/reviewer agents.

6. Check plugins and sync hygiene.
   - Confirm enabled plugins in `config.toml`.
   - Check `.gitignore` excludes secrets, sqlite files, logs, sessions, caches, and real tokens.

7. Report.
   - Start with blocking issues.
   - Then warnings.
   - Then useful confirmations.
   - End with exact commands or file edits to apply, but do not apply them unless the user asks.

## Output Shape

Use this compact format:

```text
Codex Doctor

Blocking
- ...

Warnings
- ...

Healthy
- ...

Suggested fixes
- ...
```
