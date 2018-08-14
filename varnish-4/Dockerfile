FROM    alpine:3.6

LABEL   maintainer="https://github.com/Hermsi1337"

ENV     VARNISH_PORT="8080" \
        VARNISH_BACKEND_ADDRESS="localhost" \
        VARNISH_BACKEND_PORT="80" \
        VARNISH_RAM_STORAGE="128M" \
        VARNISH_VCL_PATH="/etc/varnish/default.vcl" \
        VARNISH_VCL_CONTENT="" \
        VARNISHD_OPTS="" \
        VARNISHLOG="false" \
        VARNISHLOG_OPTS=""

RUN     apk update && \
        apk upgrade && \
        apk add varnish && \
        rm -rf /tmp/* /var/cache/apk/*

COPY    ../bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

CMD     ["/usr/local/bin/docker-entrypoint"]
