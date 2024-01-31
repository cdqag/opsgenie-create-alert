FROM alpine:3.19
RUN apk --update add bash curl jq
COPY run.sh /run.sh
ENTRYPOINT ["/run.sh"]
