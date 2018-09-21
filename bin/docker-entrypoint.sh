#!/usr/bin/env sh

set -e

VARNISHLOG="$($(command -v echo) '${VARNISHLOG}' | $(command -v tr) '[:upper:]' '[:lower:]')"

start_varnishd () {
    FILE="${1}"

    if [ "${VARNISHLOG}" == "true" ]; then
        VARNISHD="$(command -v varnishd)  \
                    ${VARNISHD_OPTS} -a :${VARNISH_PORT} \
                    -s default=malloc,${VARNISH_RAM_STORAGE}"

        VARNISHD_LOG="exec $(command -v varnishlog) \
                    ${VARNISHLOG_OPTS}"
    else
        VARNISHD="exec $(command -v varnishd)  \
                    -F ${VARNISHD_OPTS} -a :${VARNISH_PORT} \
                    -s default=malloc,${VARNISH_RAM_STORAGE}"
    fi

    ${VARNISHD} -f "${FILE}"

    if [ "${VARNISHLOG}" == "true" ]; then
        eval "${VARNISHD_LOG}"
    fi
}

if [ ! -s "${VARNISH_VCL_PATH}" ] && [ -z "${VARNISH_VCL_CONTENT}" ]; then
    echo "It seems that vcl ist not mounted propberly."
    echo "${VARNISH_VCL_CUSTOM_PATH}"
    exit 1 # r.i.p.
fi

if [ -n "${VARNISH_VCL_CONTENT}" ]; then
    $(command -v echo) "${VARNISH_VCL_CONTENT}" > "${VARNISH_VCL_PATH}"
fi

start_varnishd "${VARNISH_VCL_PATH}"
