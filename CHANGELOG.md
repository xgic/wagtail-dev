# Changelog

All notable changes to this project are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project uses [Semantic Versioning](https://semver.org/).

## Unreleased

## [0.1.3] - 2026-09-05

### Added

- Docker-outside-of-Docker: install `docker-ce-cli`, Compose plugin, and
  Buildx plugin (no `dockerd`). Image-owned entrypoint aligns the
  `docker` group to the mounted engine socket GID. Compose exemplar
  mounts `/var/run/docker.sock` and sets `user: "0:0"`.
- Canonical `.devcontainer/create-wagtail-config.json` + JSON Schema
  (same pair as the thin template). `composeProjectName` is
  `xgic-wagtail-dev`.

## [0.1.2] - 2026-09-04

### Changed

- Image Python installs use **uv** (`ghcr.io/astral-sh/uv:0.12.9`)
  instead of pip. `requirements.txt` remains the pin file.
- Apt runtime libraries only (binary wheels for Pillow / psycopg);
  drop `-dev` build packages.
- Install `xgic-cli>=0.2.1` and `xgic-wagtail-cli>=0.1.0` from PyPI
  (no git URL).
- Expand `AGENTS.md` for Grok Build: product table, command map,
  session startup, Docker Compose–first contract, public-safe write
  gate, out-of-scope rules.

### Fixed

- Dev Container GitHub `git pull` / `fetch` / `push`: install
  `openssh-client` and rewrite `git@github.com:` to HTTPS so the
  VS Code host credential helper is used. Do not copy host keys.

## [0.1.1] - 2026-09-03

### Fixed

- Rebuild the producer image so `xgic wagtail setup` includes
  `django.contrib.postgres` in generated `INSTALLED_APPS`
  (https://github.com/xgic/wagtail-cli/pull/13). Wagtail search on
  PostgreSQL needs `SearchVectorField` / `GinIndex`.

## [0.1.0] - 2026-09-03

### Added

- Dev Container producer bootstrap: Dockerfile FROM official Python 3.14,
  Compose, GHCR publish workflow, community health files.
- Install `xgic-wagtail-cli` from git (until PyPI) so `xgic wagtail setup`
  is available in the image.
