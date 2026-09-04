# Changelog

All notable changes to this project are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project uses [Semantic Versioning](https://semver.org/).

## Unreleased

### Changed

- Dockerfile sets `PIP_ROOT_USER_ACTION=ignore` so the intentional
  root `pip install` in the image build does not warn. Packages still
  install as root before `USER vscode`. No virtualenv.
- Install `xgic-cli>=0.2.1` and `xgic-wagtail-cli>=0.1.0` from PyPI
  (no git URL). Do not retag `v0.1.0` or `v0.1.1`.

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
