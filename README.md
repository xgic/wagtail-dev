# XGIC Wagtail Dev

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

**Wagtail Dev Container image producer.** This `*-dev` repository publishes
`ghcr.io/xgic/wagtail-dev` ([ADR-0001](https://github.com/xgic/ai/blob/main/docs/adr/0001-xgic-gitlab-architecture-and-repository-naming.md)).
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

The producer image is **`ghcr.io/xgic/wagtail-dev`**, built FROM official
Python / Wagtail / Django pins. Official `postgres` remains a Compose
service (not forked). The first GHCR tag is not published yet; the thin
template will pin it when it exists. Do not invent a GHCR tag in the
template before publish.

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
