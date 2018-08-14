FROM    ubuntu:trusty

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

RUN     apt-get -qq update && \
        apt-get -qq upgrade && \
        apt-get -qq install varnish && \
        apt-get -qq autoremove && \
        apt-get -qq autoclean && \
        rm -rf /tmp/* /var/cache/apt/*

COPY    ../bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

EXPOSE  8080

CMD     ["/usr/local/bin/docker-entrypoint"]
