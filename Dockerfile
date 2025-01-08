# Copyright (c) CDQ AG
# Licensed under the MIT License

FROM alpine:3.21@sha256:56fa17d2a7e7f168a043a2712e63aed1f8543aeafdcee47c58dcffe38ed51099

LABEL org.opencontainers.image.authors="Marek Sierociński" \
    org.opencontainers.image.url="https://github.com/cdqag/opsgenie-create-alert" \
    org.opencontainers.image.source="https://github.com/cdqag/opsgenie-create-alert" \
    org.opencontainers.image.documentation="https://github.com/cdqag/opsgenie-create-alert" \
    org.opencontainers.image.licenses="MIT"

RUN apk --update add bash curl jq

COPY ["entrypoint.sh", "LICENSE", "/"]
ENTRYPOINT ["/entrypoint.sh"]
