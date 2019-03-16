ARG     BASE_IMAGE_VERSION="${BASE_IMAGE_VERSION:-trusty}"

FROM    ubuntu:${BASE_IMAGE_VERSION}

LABEL   maintainer="https://github.com/Hermsi1337"

ARG     VARNISH_VERSION="${VARNISH_VERSION:-3.0.5-2ubuntu0.1}"

ENV     VARNISH_PORT="8080" \
        VARNISH_RAM_STORAGE="128M" \
        VARNISH_VCL_PATH="/etc/varnish/default.vcl" \
        VARNISH_VCL_CONTENT="" \
        VARNISH_VCL_DEFAULT_BACKEND="localhost:80" \
        VARNISHD_ADDITIONAL_OPTS="" \
        VARNISHLOG="false" \
        VARNISHLOG_OPTS="" \
        VARNISH_VERSION="${VARNISH_VERSION}"
ENV     VARNISHD_DEFAULT_OPTS="-a :${VARNISH_PORT} -s default=malloc,${VARNISH_RAM_STORAGE}"

RUN     apt-get -qq update && \
        apt-get -qq upgrade && \
        apt-get -qq install varnish && \
        apt-get -qq autoremove && \
        apt-get -qq autoclean && \
        rm -rf /tmp/* /var/cache/apt/*

COPY    bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

CMD     ["/usr/local/bin/docker-entrypoint"]
