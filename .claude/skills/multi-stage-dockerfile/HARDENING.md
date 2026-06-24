# Hardening Report: github.com/github/awesome-copilot/skills/multi-stage-dockerfile

| Field | Value |
|---|---|
| Upstream SHA | `cf4347e88c2e40a9aabe5801748ec6bf924c09be` |
| Hardened at | 2026-06-13T05:10:43Z |
| Files processed | 2 |
| .md files (clean after harden) | 1 |
| .md files (attempts exhausted) | 0 |
| Non-.md files (copied verbatim) | 1 |
| Scanner findings addressed | 0 (0 applied) |

## Markdown files

### `SKILL.md`

- Status: **clean**
- Attempts used: 3
- Engine findings + fixes applied:

  | Attempt | Rule | Severity | Finding |
  |---|---|---|---|
  | 1 | `minimal-permissions` | high | The provided skill definition is incomplete. It does not contain an `allowed-tools` list, which is required to determine if any unnecessary tools are included. |
  | 2 | `description-triggers` | medium | The skill description clearly explains its function—creating optimized multi-stage Dockerfiles—and details the best practices it follows. However, it does not specify any trigger conditions for when or why it should be invoked. |

## Verbatim files

- `LICENSE`
