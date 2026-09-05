# ghcr.io/xgic/wagtail-dev — Dev Container producer image.
# FROM official Python; do not fork Wagtail/Django vendor images.
# Official Postgres remains a Compose service in this repo and the template.
# Docker-outside-of-Docker: CLI + Compose plugin only. No dockerd.

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
    APP_USER=vscode \
    PATH="/home/vscode/.local/bin:${PATH}"

# git is present on the official Python image; openssh-client is not.
# GitHub remotes use HTTPS + the VS Code host credential helper (insteadOf).
# openssh-client remains for non-GitHub SSH remotes. Do not copy host keys.
# Docker CLI talks to the host engine via a mounted socket (no DinD).
# Build-time docker GID 994 is a placeholder; the entrypoint aligns it.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        gnupg \
        libjpeg62-turbo \
        libpq5 \
        libwebp7 \
        openssh-client \
        zlib1g \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL \
       https://download.docker.com/linux/debian/gpg \
       -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && printf '%s\n' \
       "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
       > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        docker-buildx-plugin \
        docker-ce-cli \
        docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/* \
    && git config --system --add url.https://github.com/.insteadOf git@github.com: \
    && useradd --create-home --uid 1000 --shell /bin/bash vscode \
    && groupadd -g 994 docker \
    && usermod -aG docker vscode

WORKDIR /workspace

RUN mkdir -p /usr/local/lib/xgic/docker-sock
COPY .devcontainer/scripts/align_docker_sock_gid.py \
     /usr/local/lib/xgic/docker-sock/align_docker_sock_gid.py
COPY .devcontainer/scripts/xgic-devcontainer-entrypoint \
     /usr/local/bin/xgic-devcontainer-entrypoint
RUN chmod 0755 \
        /usr/local/lib/xgic/docker-sock/align_docker_sock_gid.py \
        /usr/local/bin/xgic-devcontainer-entrypoint

COPY requirements.txt /tmp/requirements.txt
RUN uv pip install --system --no-cache -r /tmp/requirements.txt \
    && uv pip install --system --no-cache \
        "xgic-cli>=0.2.1" \
        "xgic-dev-cli>=0.2.1" \
        "xgic-wagtail-cli>=0.1.0" \
    && rm /tmp/requirements.txt

ENTRYPOINT ["/usr/local/bin/xgic-devcontainer-entrypoint"]
USER vscode
WORKDIR /workspace

# Default keep-alive. Compose should set user: "0:0" so the entrypoint
# can align the docker socket GID, then exec this CMD as vscode.
CMD ["sleep", "infinity"]
