#!/usr/bin/env bash

set -e

exact_version() {

    unset APP
    APP="${1}"
    FILE="${2}"
    
    grep -i "${APP}" "${FILE}" | cut -d '=' -f 2

}

for VARNISH_VERSION_DIR in varnish-*; do

    echo "# # # # # # # # # # # # # # # #"
    echo "Building ${VARNISH_VERSION_DIR}"
    echo "# # # # # # # # # # # # # # # #"

    unset FULL_VARNISH_VERSION_PATH
    FULL_VARNISH_VERSION_PATH="${TRAVIS_BUILD_DIR}/${VARNISH_VERSION_DIR}"

    unset VERSION_FILE
    VERSION_FILE="${FULL_VARNISH_VERSION_PATH}/exact_versions"

    unset EXACT_VARNISH_VERSION
    EXACT_VARNISH_VERSION="$(exact_version VARNISH ${VERSION_FILE})"

    unset MAJOR_RELEASE_TAG
    MAJOR_RELEASE_TAG="${EXACT_VARNISH_VERSION%%.*}"

    unset BASE_IMAGE_VERSION
    BASE_IMAGE_VERSION="$(exact_version BASE_IMAGE ${VERSION_FILE})"

    docker build \
        --pull \
        --build-arg VARNISH_VERSION="${EXACT_VARNISH_VERSION}" \
        --build-arg BASE_IMAGE_VERSION="${BASE_IMAGE_VERSION}" \
        -t "${IMAGE_NAME}:${MAJOR_RELEASE_TAG}" \
        -t "${IMAGE_NAME}:${EXACT_VARNISH_VERSION}" \
        -f "${FULL_VARNISH_VERSION_PATH}/Dockerfile" \
        "${TRAVIS_BUILD_DIR}"

    if [[ "${TRAVIS_BRANCH}" == "master" ]] && [[ "${TRAVIS_PULL_REQUEST}" == "false" ]]; then

        docker push "${IMAGE_NAME}:${MAJOR_RELEASE_TAG}"
        docker push "${IMAGE_NAME}:${EXACT_VARNISH_VERSION}"

    fi

done