# ghcr.io/xgic/wagtail-dev — Dev Container producer image.
# FROM official Python; do not fork Wagtail/Django vendor images.
# Official Postgres remains a Compose service in this repo and the template.

FROM python:3.14.6-slim

# Official uv image (https://docs.astral.sh/uv/guides/integration/docker/).
COPY --from=ghcr.io/astral-sh/uv:0.12.9 /uv /usr/local/bin/uv

LABEL org.opencontainers.image.title="wagtail-dev" \
      org.opencontainers.image.description="XGIC Wagtail Dev Container producer image (ghcr.io/xgic/wagtail-dev). Official Python/Wagtail/Django bases; companion to the xgic/wagtail template." \
      org.opencontainers.image.url="https://github.com/xgic/wagtail-dev" \
      org.opencontainers.image.documentation="https://github.com/xgic/wagtail-dev#readme" \
      org.opencontainers.image.source="https://github.com/xgic/wagtail-dev" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.vendor="XGIC"

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_SYSTEM_PYTHON=1 \
    PATH="/home/vscode/.local/bin:${PATH}"

# git is present on the official Python image; openssh-client is not.
# GitHub remotes use HTTPS + the VS Code host credential helper (insteadOf).
# openssh-client remains for non-GitHub SSH remotes. Do not copy host keys.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        libjpeg62-turbo \
        libpq5 \
        libwebp7 \
        openssh-client \
        zlib1g \
    && rm -rf /var/lib/apt/lists/* \
    && git config --system --add url.https://github.com/.insteadOf git@github.com: \
    && useradd --create-home --uid 1000 --shell /bin/bash vscode

WORKDIR /workspace

COPY requirements.txt /tmp/requirements.txt
RUN uv pip install --system --no-cache -r /tmp/requirements.txt \
    && uv pip install --system --no-cache \
        "xgic-cli>=0.2.1" \
        "xgic-dev-cli" \
        "xgic-wagtail-cli>=0.1.0" \
    && rm /tmp/requirements.txt

USER vscode
WORKDIR /workspace

CMD ["sleep", "infinity"]
