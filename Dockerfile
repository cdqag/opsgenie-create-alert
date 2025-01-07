# Copyright (c) CDQ AG
# Licensed under the MIT License

FROM alpine:3.19@sha256:1269259bb1aaa81d18ea82827bd825a385e2b92d5647e67a332a69633b5a0ea1

LABEL org.opencontainers.image.authors="Marek Sierociński" \
    org.opencontainers.image.url="https://github.com/cdqag/opsgenie-create-alert" \
    org.opencontainers.image.source="https://github.com/cdqag/opsgenie-create-alert" \
    org.opencontainers.image.documentation="https://github.com/cdqag/opsgenie-create-alert" \
    org.opencontainers.image.licenses="MIT"

RUN apk --update add bash curl jq

COPY ["entrypoint.sh", "LICENSE", "/"]
ENTRYPOINT ["/entrypoint.sh"]
