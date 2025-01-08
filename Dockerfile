# Copyright (c) CDQ AG
# Licensed under the MIT License

FROM alpine:3.19@sha256:6380aa6b04faa579332d4c9d1f65bd7093012ba6e01d9bbcd5e2d8a4f9fae38f

LABEL org.opencontainers.image.authors="Marek Sierociński" \
    org.opencontainers.image.url="https://github.com/cdqag/opsgenie-create-alert" \
    org.opencontainers.image.source="https://github.com/cdqag/opsgenie-create-alert" \
    org.opencontainers.image.documentation="https://github.com/cdqag/opsgenie-create-alert" \
    org.opencontainers.image.licenses="MIT"

RUN apk --update add bash curl jq

COPY ["entrypoint.sh", "LICENSE", "/"]
ENTRYPOINT ["/entrypoint.sh"]
