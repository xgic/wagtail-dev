# AI agent instructions — XGIC Wagtail Dev

**Primary context for Grok Build and other coding agents in this
repository.** Read this file before significant work.

Public repository. Multi-repo standards: https://github.com/xgic/ai
Architecture: [ADR-0001](https://github.com/xgic/ai/blob/main/docs/adr/0001-xgic-gitlab-architecture-and-repository-naming.md)
(producer vs template) ·
[ADR-0005](https://github.com/xgic/ai/blob/main/docs/adr/0005-modular-xgic-cli-and-retirement-of-xde.md)
· [ADR-0006](https://github.com/xgic/ai/blob/main/docs/adr/0006-adopt-wagtail.md)
(Wagtail is the default CMS).

## Product

This repository is the **Wagtail Dev Container image producer**
(`ghcr.io/xgic/wagtail-dev`). It does **not** own the CLI
implementation or site schema. End-user sites start from
https://github.com/xgic/wagtail.

| Concern | Package | Repository |
|---------|---------|------------|
| CLI framework | `xgic.cli` | https://github.com/xgic/cli |
| Docker Compose / lifecycle | `xgic.cli.dev` | https://github.com/xgic/dev-cli |
| Wagtail product commands | `xgic.cli.wagtail` | https://github.com/xgic/wagtail-cli |
| End-user template | — | https://github.com/xgic/wagtail |

**Brand:** **XGIC CLI** only in living docs. No supported `xde`
entrypoint.

**Install source:** the image installs **from PyPI** with version pins
(`xgic-cli>=0.2.1`, `xgic-wagtail-cli>=0.1.0`), not from live Git
`main`. See
[python-package-release.md](https://github.com/xgic/ai/blob/main/docs/python-package-release.md).

**Image user:** `vscode` (UID 1000). `devcontainer.json` sets
`remoteUser` to `vscode`. Not Wagtail’s stock `USER wagtail`.

**GitHub Release** is required on every final `v*` image line. Do not
retag published lines.

## Docker Compose–first consumer contract

Supported consumer Dev Container reopen is **Docker Compose** attached
to the pinned GHCR image service—**not** a standalone `image:` in
`devcontainer.json`.

| Piece | Contract |
|-------|----------|
| Attach | `dockerComposeFile` + `service` (exemplar: this repo’s `.devcontainer/`) |
| Image pin (apps) | `image: ghcr.io/xgic/wagtail-dev:<semver>` on the Docker Compose primary service |
| Stable project | Docker Compose `name:` + `composeProjectName` kept aligned |
| Database | Official `postgres` service in the **same** Docker Compose project |

**Anti-pattern:** image-only reopen → Docker’s default `adjective_noun`
container names, Postgres outside the IDE project, CLI /
`composeProjectName` mismatch.

Producer Compose defaults (this repo):

- File: `.devcontainer/docker-compose.yml`
- `name:` / primary service: `xgic-wagtail-dev`
- Postgres: `postgres:18-bookworm`
- Workspace: `/workspace` bind of the repo root
- Forwarded port: **8000** (Wagtail / Django)

Do **not** copy `requirements.txt` into the template. Sites consume the
baked image. Do **not** start application schema in this repository.

## Session startup

Inside the Dev Container (`xgic` is on PATH):

1. `xgic --help`
2. `xgic check`
3. `xgic wagtail setup` — idempotent PostgreSQL site ensure (`wagtail
   start` if missing; `DATABASES` + `django.contrib.postgres` in
   generated `<project>/settings/base.py`). SQLite is not an XGIC
   default.
4. Daily work: `xgic wagtail dev` — wait for PostgreSQL, `migrate
   --noinput`, then `manage.py runserver 0.0.0.0:8000`. Requires a
   site from `setup` (exit 2 if none).
5. Schema IntelliSense: `xgic wagtail schema`

Do **not** reintroduce `initializeCommand` / `postAttachCommand` /
`postStartCommand` / `postCreateCommand` hooks for Git DX.

**Git auth (VS Code best practice):** prefer **HTTPS + host credential
helper**. Never copy host private keys into the image. Do not invent
entrypoint Git DX scripts here unless they already ship in this image.

`dbAdapter` is **postgres** only. Database name and user come from
template `.devcontainer` config / `.env`—not hard-coded in the image.

## Command map (for agents)

| Action | Command |
|--------|---------|
| Help / version | `xgic --help` / `xgic --version` |
| Missing ACTION usage | `xgic wagtail` (full usage, exit 2) |
| Docker Compose up / down | `xgic up` / `xgic down` |
| Health | `xgic check` |
| Generic env status | `xgic env` |
| Ensure site | `xgic wagtail setup` |
| Dev server | `xgic wagtail dev` |
| JSON Schema | `xgic wagtail schema` |
| Module identity | `xgic wagtail info` (`--json` for machines) |

CLI behavior changes belong in
[xgic/wagtail-cli](https://github.com/xgic/wagtail-cli),
[xgic/cli](https://github.com/xgic/cli), or
[xgic/dev-cli](https://github.com/xgic/dev-cli)—not in this producer.

## Out of scope

- Forking vendor Wagtail/Django images
- Site schema / StreamField / content models (empty-site gate on
  https://github.com/xgic/wagtail)
- Thin CLI framework → https://github.com/xgic/cli
- Docker Compose lifecycle implementation → https://github.com/xgic/dev-cli
- Payload CMS producer or `xgic payload` work (Payload is frozen)
- Private host defaults, private tracker IDs, production inventory
- Directus (not an active CMS candidate)
- Retagging published producer `v*` lines
- Moving live production Wagtail into this image or Debian WSL2

## Rules

**Public GitHub writes:** Before `gh issue create|edit`, `gh pr
create|edit`, or any public comment on this repository, complete the
**mandatory public-safe draft gate** in
https://github.com/xgic/ai/blob/main/docs/BASE-STANDARDS-FOR-ORCHESTRATED-REPOS.md
(fictional placeholders only; never name private hosts, private
projects, or private tracker IDs). Optional helper from the hub clone:
`python scripts/public-safe-scan.py path/to/draft.md`.

- Public-safe content only (no private hosts, private tracker IDs,
  internal paths).
- Human UI review before merge to `main`. No agent merge.
- Dedicated issue-number branches; Conventional Commits.
- **Labels required** on issues/PRs; default assignee **`@xgic`** for
  active work unless explicitly unassigned.
- Before close: complete Markdown checklists; confirm labels and
  assignee.
- Python 3.14+; official `python:3.14.6-slim` FROM; Apache-2.0; root
  `CODEOWNERS` (`@xgic`).
- Prefer full `https://github.com/xgic/...` URLs.
- Do **not** reintroduce an in-tree CLI package or `xde` console
  script.
- Do **not** regress consumers to standalone `image:` reopen; keep
  Docker Compose–first.
- Configuration over hard-coding for hosts, credentials, and project
  names.

## Local memory

Temporary status reports only under `.xgic/` (gitignored). Never commit
`.xgic/`.
