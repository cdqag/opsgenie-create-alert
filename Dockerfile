# Copyright (c) CDQ AG
# Licensed under the MIT License

FROM alpine:3.19@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b

LABEL org.opencontainers.image.authors="Marek Sierociński" \
    org.opencontainers.image.url="https://github.com/cdqag/opsgenie-create-alert" \
    org.opencontainers.image.source="https://github.com/cdqag/opsgenie-create-alert" \
    org.opencontainers.image.documentation="https://github.com/cdqag/opsgenie-create-alert" \
    org.opencontainers.image.licenses="MIT"

RUN apk --update add bash curl jq

COPY ["entrypoint.sh", "LICENSE", "/"]
ENTRYPOINT ["/entrypoint.sh"]
