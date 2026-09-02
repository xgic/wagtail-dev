# AI Agent Instructions — XGIC Wagtail Dev

Public repository. Follow https://github.com/xgic/ai for multi-repo standards.

## Product

- **Role:** `*-dev` GHCR producer for `ghcr.io/xgic/wagtail-dev` (FROM official Python/Wagtail/Django pins)
- **Not** the end-user template → https://github.com/xgic/wagtail
- **CMS decision:** [ADR-0006](https://github.com/xgic/ai/blob/main/docs/adr/0006-adopt-wagtail.md)

## Scope

- Publish `ghcr.io/xgic/wagtail-dev` (multi-arch; official Python/Wagtail/Django bases)
- Environment Python pins (`requirements.txt`: Wagtail, psycopg) baked into the image
- Official `postgres` as a Compose service
- Compose-first Dev Container (`dockerComposeFile` + `service`)
- GitHub Release on every final `v*` image line

## Out of scope

- Forking vendor Wagtail/Django images
- Site schema / StreamField models
- Private host defaults
- Payload CMS producer work

## Rules

**Public GitHub writes:** Before `gh issue create|edit`, `gh pr create|edit`, or any public comment on this repository, complete the **mandatory public-safe draft gate** in https://github.com/xgic/ai/blob/main/docs/BASE-STANDARDS-FOR-ORCHESTRATED-REPOS.md.
- Public-safe content only
- Human UI review before merge to `main`
- Dedicated issue-number branches; Conventional Commits
- **Labels required**
- Apache-2.0; root `CODEOWNERS` (`@xgic`)
