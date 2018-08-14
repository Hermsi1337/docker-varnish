#!/usr/bin/env sh

set -e

start_varnishd () {
    FILE="${1}"

    if [ "${VARNISHLOG}" == "true" ]; then
        VARNISHD="$(command -v varnishd)  \
                    ${VARNISHD_OPTS} -a :${VARNISH_PORT} \
                    -s default=malloc,${VARNISH_RAM_STORAGE}"

        VARNISHLOG="exec $(command -v varnishlog) \
                    ${VARNISHLOG_OPTS}"
    else
        VARNISHD="exec $(command -v varnishd)  \
                    -F ${VARNISHD_OPTS} -a :${VARNISH_PORT} \
                    -s default=malloc,${VARNISH_RAM_STORAGE}"
    fi

    ${VARNISHD} -f "${FILE}"

    if [ "${VARNISH_LOG}" == "TRUE" ]; then
        eval "${VARNISHLOG}"
    fi
}

if [ "${VARNISH_BACKEND_ADDRESS}" == "localhost" ] && [ "${VARNISH_BACKEND_PORT}" == "80" ]; then
    echo "You did not configure your backend properly."
    echo "Check the docs, dude!"
    exit 1 # r.i.p.
elif [ ! -s "${VARNISH_VCL_PATH}" ] && [ -z "${VARNISH_VCL_CONTENT}" ]; then
    echo "It seems that vcl ist not mounted propberly."
    echo "${VARNISH_VCL_CUSTOM_PATH}"
    exit 1 # r.i.p.
fi

if [ ! -z "${VARNISH_VCL_CONTENT}" ]; then
    $(command -v echo) "${VARNISH_VCL_CONTENT}" > "${VARNISH_VCL_PATH}"
fi

start_varnishd "${VARNISH_VCL_PATH}"
