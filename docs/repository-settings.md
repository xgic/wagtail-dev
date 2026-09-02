# Repository settings (image producer)

Public operational notes for maintainers of
[xgic/wagtail-dev](https://github.com/xgic/wagtail-dev).

## Branch protection

`main` is protected:

| Rule | Intent |
|------|--------|
| No force-push / no deletion of `main` | History integrity |
| Pull request required (1 approval) | Human UI review |
| Linear history | Clean default branch |
| Required status check **Compose config** | Docker Compose–first contract |

Image publish lives on `v*` tags via [Publish GHCR](../.github/workflows/publish.yml). GitHub Release is required for every final semver line.

## Labels

Apply PR labels consistently (`documentation`, `bug`, `enhancement`, `chore`, …).

## Related

- [AGENTS.md](../AGENTS.md)
- [CONTRIBUTING.md](../CONTRIBUTING.md)
- [xgic/ai BASE-STANDARDS](https://github.com/xgic/ai/blob/main/docs/BASE-STANDARDS-FOR-ORCHESTRATED-REPOS.md)
- [README standards (hub)](https://github.com/xgic/ai/blob/main/docs/readme-standards.md)
