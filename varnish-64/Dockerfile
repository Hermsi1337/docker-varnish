FROM    alpine:3.12

LABEL   maintainer="https://github.com/Hermsi1337"

ARG     VARNISH_VERSION="${VARNISH_VERSION:-6.4.0-r0}"

ENV     VARNISH_PORT="8080" \
        VARNISH_RAM_STORAGE="128M" \
        VARNISH_VCL_PATH="/etc/varnish/default.vcl" \
        VARNISH_VCL_CONTENT="" \
        VARNISH_VCL_DEFAULT_BACKEND="localhost:80" \
        VARNISHD_ADDITIONAL_OPTS="" \
        VARNISHLOG="false" \
        VARNISHLOG_OPTS="" \
        VARNISH_VERSION="${VARNISH_VERSION}"

RUN     set -x && \
        apk add --no-cache --upgrade varnish=${VARNISH_VERSION} && \
        rm -rf /tmp/* /var/cache/apk/*

COPY    bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

CMD     ["/usr/local/bin/docker-entrypoint"]
