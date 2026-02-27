# syntax=docker/dockerfile:1
FROM python:alpine

RUN --mount=type=cache,target=/var/cache/apk \
    apk add --no-cache \
    make bash tini tar zstd git ca-certificates curl wget \
    ghostscript biber fontconfig texlive-full \
    font-noto-cjk font-noto font-noto-extra font-noto-emoji \
    font-wqy-zenhei font-noto-cjk-extra \
    font-ipa font-ipaex font-dejavu font-unifont \
    font-liberation font-linux-libertine \
    && fc-cache -fv

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["latexmk", "--version"]