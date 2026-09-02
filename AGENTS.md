# AI Agent Instructions — XGIC Wagtail Dev

Public repository. Follow https://github.com/xgic/ai for multi-repo standards.

## Product

- **Role:** `*-dev` producer: official image pins + contributor Docker Compose
- **Not** the end-user template → https://github.com/xgic/wagtail
- **CMS decision:** [ADR-0006](https://github.com/xgic/ai/blob/main/docs/adr/0006-adopt-wagtail.md)

## Scope

- Pin official `python` and `postgres` images
- Document `wagtail==8.0` as the pip pin
- Compose-first Dev Container

## Out of scope

- Custom GHCR image until a measured need is recorded
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
