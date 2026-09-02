# XGIC Wagtail Dev

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

**Contributor environment and official image pins for Wagtail.** This is the
`*-dev` producer repo ([ADR-0001](https://github.com/xgic/ai/blob/main/docs/adr/0001-xgic-gitlab-architecture-and-repository-naming.md)).
It is **not** the app start.

**App start:** [xgic/wagtail](https://github.com/xgic/wagtail) (GitHub Template).

Standards hub: [xgic/ai](https://github.com/xgic/ai) · Default CMS:
[ADR-0006](https://github.com/xgic/ai/blob/main/docs/adr/0006-adopt-wagtail.md)

---

## Pins (current)

| Component | Pin | Notes |
|-----------|-----|--------|
| Python | `python:3.14-bookworm` | Docker Official Image; ADR-0002 |
| Postgres | `postgres:18-bookworm` | Docker Official Image |
| Wagtail | `wagtail==8.0` | Current feature release; pip into the Python image |
| Django | from Wagtail 8.0 | 5.2 / 6.0 / 6.1 |

There is **no** custom `ghcr.io/xgic/wagtail-dev` image yet. ADR-0006 prefers
official Wagtail/Django images until a measured need for a custom producer.
Do not retag or invent a GHCR pin in the thin template.

---

## Quick start (contributors)

```bash
docker compose -f .devcontainer/docker-compose.yml config
```

Reopen in the Dev Container, then:

```bash
python -m pip install -r requirements.txt
```

Site schema belongs in [xgic/wagtail](https://github.com/xgic/wagtail), not here.

CLI module: [xgic/wagtail-cli](https://github.com/xgic/wagtail-cli) (`xgic wagtail …`).

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Human review in the GitHub UI before merge.

## License

Apache License 2.0. See [LICENSE](LICENSE) and [NOTICE](NOTICE).
