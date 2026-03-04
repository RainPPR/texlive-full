# syntax=docker/dockerfile:1
FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    mkdir -p /etc/dpkg/dpkg.cfg.d; \
    cat > /etc/dpkg/dpkg.cfg.d/01-ci-nodoc <<'EOF'
path-exclude /usr/share/doc/*
path-include /usr/share/doc/*/copyright
path-exclude /usr/share/man/*
path-exclude /usr/share/groff/*
path-exclude /usr/share/info/*
path-exclude /usr/share/lintian/*
path-exclude /usr/share/linda/*
EOF

RUN set -eux; \
  cat > /etc/apt/apt.conf.d/99ci-no-translations <<'EOF'
Acquire::Languages "none";
EOF

RUN set -eux; \
  cat > /etc/apt/apt.conf.d/99ci-gzip-indexes <<'EOF'
Acquire::GzipIndexes "true";
EOF

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    apt-get install -y eatmydata; \
    eatmydata apt-get update && eatmydata apt-get install -y \
    make bash tini tar zstd zip unzip \
    git ca-certificates curl wget \
    ghostscript biber fontconfig texlive-full \
    fonts-noto-cjk fonts-noto-cjk-extra fonts-noto-core fonts-noto-extra \
    fonts-liberation fonts-linuxlibertine; \
    fc-cache -fv; \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["latexmk", "--version"]
