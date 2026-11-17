FROM alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf

LABEL org.opencontainers.image.title="bash" \
      org.opencontainers.image.description="Bash with GNU awk, sed, grep, coreutils and bc on Alpine in a non-root image" \
      org.opencontainers.image.vendor="Think-Cube" \
      org.opencontainers.image.authors="contact@thinkcube.dev" \
      org.opencontainers.image.licenses="MIT"

ENV LANG=C.UTF-8

# The upgrade is what lets the weekly rebuild pick up security patches
# while the base image stays pinned by digest.
RUN apk upgrade --no-cache && \
    apk add --no-cache \
        bash \
        bc \
        coreutils \
        gawk \
        grep \
        sed

RUN addgroup -S -g 10001 app && \
    adduser -S -D -u 10001 -G app -s /bin/bash app && \
    install -d -o app -g app /work

WORKDIR /work

USER 10001:10001

CMD ["bash"]
