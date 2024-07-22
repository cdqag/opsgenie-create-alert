# Copyright (c) CDQ AG
# Licensed under the MIT License

FROM alpine:3.20@sha256:0a4eaa0eecf5f8c050e5bba433f58c052be7587ee8af3e8b3910ef9ab5fbe9f5

LABEL org.opencontainers.image.authors="Marek Sierociński" \
    org.opencontainers.image.url="https://github.com/cdqag/opsgenie-create-alert" \
    org.opencontainers.image.source="https://github.com/cdqag/opsgenie-create-alert" \
    org.opencontainers.image.documentation="https://github.com/cdqag/opsgenie-create-alert" \
    org.opencontainers.image.licenses="MIT"

RUN apk --update add bash curl jq

COPY ["entrypoint.sh", "LICENSE", "/"]
ENTRYPOINT ["/entrypoint.sh"]
