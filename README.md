# XGIC Wagtail Dev

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-image-blue?logo=docker&logoColor=white)](https://docs.docker.com/)
[![GHCR](https://img.shields.io/badge/GHCR-wagtail--dev-blue?logo=github)](https://github.com/users/xgic/packages/container/package/wagtail-dev)
[![Release](https://img.shields.io/github/v/release/xgic/wagtail-dev)](https://github.com/xgic/wagtail-dev/releases)
[![CI](https://github.com/xgic/wagtail-dev/actions/workflows/ci.yml/badge.svg)](https://github.com/xgic/wagtail-dev/actions/workflows/ci.yml)

**Dev Container image producer** for professional [Wagtail](https://wagtail.org) development.

This repository builds and publishes the multi-arch image:

```text
ghcr.io/xgic/wagtail-dev
```

Application teams and AI coding agents consume that image through the thin end-user template:

**→ [xgic/wagtail](https://github.com/xgic/wagtail)** (recommended starting point for new Wagtail sites)

Standards: [xgic/ai](https://github.com/xgic/ai) · [ADR-0001](https://github.com/xgic/ai/blob/main/docs/adr/0001-xgic-gitlab-architecture-and-repository-naming.md) · [ADR-0006](https://github.com/xgic/ai/blob/main/docs/adr/0006-adopt-wagtail.md)

---

## Why this repository exists

Wagtail work needs a **reproducible environment**: pinned Python and Wagtail, Postgres, and a single CLI brand for humans and agents. Shipping that as a **published container image**—not a Dockerfile in every site repo—keeps app starts thin.

| Benefit | Outcome |
|---------|---------|
| **Separation of concerns** | Image and CI evolve here; sites start from a thin template |
| **Official bases** | FROM unaltered Python; official Postgres service; do not fork Wagtail/Django images |
| **AI-ready operations** | Modular **XGIC CLI** (`xgic wagtail …`) documented for agents |
| **Open-source rigor** | Apache-2.0, human-reviewed PRs, public-safe docs |

---

## Dual-repo model (ADR-0001)

| Repository | Role | You use it when… |
|------------|------|------------------|
| **This repo** — [wagtail-dev](https://github.com/xgic/wagtail-dev) | `*-dev` **producer**: Dockerfile, Compose, GHCR publish | You improve the image, CI, or container tooling |
| [wagtail](https://github.com/xgic/wagtail) | Clean **end-user template** | You **start or develop a Wagtail site** |

```text
  PyPI: xgic-cli · xgic-dev-cli · xgic-wagtail-cli
                    │  installed into image
                    ▼
  ┌─────────────────────────────┐     publishes      ┌──────────────────────────┐
  │  xgic/wagtail-dev           │ ─────────────────► │ ghcr.io/xgic/wagtail-dev │
  │  (this repository)          │                    └────────────┬─────────────┘
  └─────────────────────────────┘                                 │ Compose service
                                                                  ▼
                                                     ┌──────────────────────────┐
                                                     │  xgic/wagtail            │
                                                     │  (dockerComposeFile +    │
                                                     │   service)               │
                                                     └──────────────────────────┘
```

**Do not** start application schema in this repository. **Do not** copy `requirements.txt` into the template — sites consume the baked image.

### Consumer contract (Docker Compose–first)

Templates **must** reopen via **Docker Compose** attached to the pinned GHCR image service. Standalone `image:` reopen in `devcontainer.json` is **not supported**.

---

## Quick start (contributors)

```bash
docker compose -f .devcontainer/docker-compose.yml config
docker compose -f .devcontainer/docker-compose.yml build
```

Reopen in the Dev Container. Site schema belongs in [xgic/wagtail](https://github.com/xgic/wagtail).

CLI module: [xgic/wagtail-cli](https://github.com/xgic/wagtail-cli)
(`xgic wagtail setup`, `xgic wagtail schema`, `xgic wagtail dev`).
App start uses **PostgreSQL**; do not leave `wagtail start` on SQLite.

---

## Pins

| Component | Pin |
|-----------|-----|
| Python | `python:3.14.6-slim` (Dockerfile FROM) |
| Postgres | `postgres:18-bookworm` (Compose service) |
| Wagtail / psycopg | [`requirements.txt`](requirements.txt) (`wagtail==8.0`, `psycopg[binary]>=3.2`) baked into the image |
| Image | `ghcr.io/xgic/wagtail-dev` (semver on `v*` tags; GitHub Release required) |

---

## XGIC standards

- [BASE-STANDARDS](https://github.com/xgic/ai/blob/main/docs/BASE-STANDARDS-FOR-ORCHESTRATED-REPOS.md)
- [README standards](https://github.com/xgic/ai/blob/main/docs/readme-standards.md)
- [Community health](https://github.com/xgic/ai/blob/main/docs/community-health.md)
- Agents: [AGENTS.md](AGENTS.md)

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Human review in the GitHub UI before merge.

## License

Apache License 2.0. See [LICENSE](LICENSE) and [NOTICE](NOTICE).
