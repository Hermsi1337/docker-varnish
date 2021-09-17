ARG     ALPINE_VERSION="${ALPINE_VERSION:-3.14}"
FROM    alpine:${ALPINE_VERSION}

LABEL   maintainer="https://github.com/Hermsi1337"

ARG     VARNISH_VERSION="${VARNISH_VERSION:-7.0.0}"

ENV     VARNISH_PORT="8080" \
        VARNISH_RAM_STORAGE="128M" \
        VARNISH_VCL_PATH="/etc/varnish/default.vcl" \
        VARNISH_VCL_CONTENT="" \
        VARNISH_VCL_DEFAULT_BACKEND="localhost:80" \
        VARNISHD_ADDITIONAL_OPTS="" \
        VARNISHLOG="false" \
        VARNISHLOG_OPTS="" \
        VARNISH_VERSION="${VARNISH_VERSION}"

RUN     set -x \
        && \
            apk add --no-cache --upgrade --virtual .build-dependencies \
                autoconf \
                automake \
                build-base \
                cpio \
                gzip \
                libedit-dev \
                libtool \
                linux-headers \
                py-docutils \
                $(if [ "$(echo ${VARNISH_VERSION} | cut -d '.' -f 1-2)" = "6.0" ]; then echo "py-sphinx" ; fi ) \
                py3-sphinx \
                tar \
                sudo \
        && \
            apk add --no-cache \
                ca-certificates \
                $(if [ "$(echo ${VARNISH_VERSION} | cut -d '.' -f 1-2)" = "6.0" ]; then echo "pcre-dev" ; fi ) \
                pcre2-dev \
                libunwind-dev \
                gcc \
                libc-dev \
        && \
            cd /tmp && \
            wget -qO- \
                https://github.com/varnishcache/varnish-cache/archive/refs/tags/varnish-${VARNISH_VERSION}.tar.gz \
            | tar -C /tmp --strip-components=1 -xvz \
        && \
            sh autogen.sh && sh configure --with-unwind && make && sudo make install \
        && \
            apk del .build-dependencies && rm -rf /tmp/* /var/cache/*

COPY    bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

CMD     ["/usr/local/bin/docker-entrypoint"]
