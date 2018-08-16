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

    unset PATCH_RELEASE_TAG
    PATCH_RELEASE_TAG="$(exact_version VARNISH ${VERSION_FILE})"

    unset MINOR_RELEASE_TAG
    MINOR_RELEASE_TAG="${PATCH_RELEASE_TAG%.*}"

    unset MAJOR_RELEASE_TAG
    MAJOR_RELEASE_TAG="${MINOR_RELEASE_TAG%.*}"

    unset BASE_IMAGE_VERSION
    BASE_IMAGE_VERSION="$(exact_version BASE_IMAGE ${VERSION_FILE})"

    docker build \
        --no-cache \
        --pull \
        --build-arg VARNISH_VERSION="${PATCH_RELEASE_TAG}" \
        --build-arg BASE_IMAGE_VERSION="${BASE_IMAGE_VERSION}" \
        --tag "${IMAGE_NAME}:${MAJOR_RELEASE_TAG}" \
        --tag "${IMAGE_NAME}:${MINOR_RELEASE_TAG}" \
        --tag "${IMAGE_NAME}:${PATCH_RELEASE_TAG}" \
        --file "${FULL_VARNISH_VERSION_PATH}/Dockerfile" \
        "${TRAVIS_BUILD_DIR}"

    if [[ "${TRAVIS_BRANCH}" == "master" ]] && [[ "${TRAVIS_PULL_REQUEST}" == "false" ]]; then

        docker push "${IMAGE_NAME}:${MAJOR_RELEASE_TAG}"
        docker push "${IMAGE_NAME}:${MINOR_RELEASE_TAG}"
        docker push "${IMAGE_NAME}:${PATCH_RELEASE_TAG}"

    fi

done