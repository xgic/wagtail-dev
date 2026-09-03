# ghcr.io/xgic/wagtail-dev — Dev Container producer image.
# FROM official Python; do not fork Wagtail/Django vendor images.
# Official Postgres remains a Compose service in this repo and the template.

FROM python:3.14.6-slim

LABEL org.opencontainers.image.title="wagtail-dev" \
      org.opencontainers.image.description="XGIC Wagtail Dev Container producer image (ghcr.io/xgic/wagtail-dev). Official Python/Wagtail/Django bases; companion to the xgic/wagtail template." \
      org.opencontainers.image.url="https://github.com/xgic/wagtail-dev" \
      org.opencontainers.image.documentation="https://github.com/xgic/wagtail-dev#readme" \
      org.opencontainers.image.source="https://github.com/xgic/wagtail-dev" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.vendor="XGIC"

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PATH="/home/vscode/.local/bin:${PATH}"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        libjpeg62-turbo-dev \
        libpq-dev \
        libwebp-dev \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --uid 1000 --shell /bin/bash vscode

WORKDIR /workspace

COPY requirements.txt /tmp/requirements.txt
RUN python -m pip install --upgrade pip \
    && python -m pip install --no-cache-dir -r /tmp/requirements.txt \
    && python -m pip install --no-cache-dir \
        "xgic-cli>=0.2.0" \
        "xgic-dev-cli" \
        "xgic-wagtail-cli @ git+https://github.com/xgic/wagtail-cli.git@main" \
    && rm /tmp/requirements.txt

USER vscode
WORKDIR /workspace

CMD ["sleep", "infinity"]
