ARG     VARNISH_VERSION=${VARNISH_VERSION:-6.0.0-r1}
ARG     BASE_IMAGE_VERSION=${BASE_IMAGE_VERSION:-3.8}

FROM    alpine:${BASE_IMAGE_VERSION}

LABEL   maintainer="https://github.com/Hermsi1337"

ENV     VARNISH_PORT="8080" \
        VARNISH_BACKEND_ADDRESS="localhost" \
        VARNISH_BACKEND_PORT="80" \
        VARNISH_RAM_STORAGE="128M" \
        VARNISH_VCL_PATH="/etc/varnish/default.vcl" \
        VARNISH_VCL_CONTENT="" \
        VARNISHD_OPTS="" \
        VARNISHLOG="false" \
        VARNISHLOG_OPTS="" \
        VARNISH_VERSION="${VARNISH_VERSION}"

RUN     apk update && \
        apk upgrade && \
        apk add varnish=${VARNISH_VERSION} && \
        rm -rf /tmp/* /var/cache/apk/*

COPY    bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

CMD     ["/usr/local/bin/docker-entrypoint"]
