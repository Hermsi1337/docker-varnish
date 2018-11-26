#!/usr/bin/env bash

set -e

exact_base_version() {

    unset FILE
    FILE="${1}"
    
    grep -i "BASE_IMAGE" "${FILE}" | cut -d '=' -f 2

}

get_meta_release() {

    unset OS_VER
    OS_VER="${1}"

    if [[ "${OS_VER}" == "trusty" ]]; then
        echo "3.0.5-2ubuntu0.1"
    elif [[ "${OS_VER}" == "edge" ]]; then
        echo "$(w3m -dump "https://pkgs.alpinelinux.org/packages?name=varnish&branch=${OS_VER}" | grep -m 1 "x86" | awk '{print $2}')"
    else
        echo "$(w3m -dump "https://pkgs.alpinelinux.org/packages?name=varnish&branch=v${OS_VER}" | grep -m 1 "x86" | awk '{print $2}')"
    fi

}

for VARNISH_VERSION_DIR in varnish-*; do

    echo "# # # # # # # # # # # # # # # #"
    echo "Building..."
    echo "...${VARNISH_VERSION_DIR}"

    unset FULL_VARNISH_VERSION_PATH
    FULL_VARNISH_VERSION_PATH="${TRAVIS_BUILD_DIR}/${VARNISH_VERSION_DIR}"

    unset VERSION_FILE
    VERSION_FILE="${FULL_VARNISH_VERSION_PATH}/exact_versions"

    unset BASE_IMAGE_VERSION
    BASE_IMAGE_VERSION="$(exact_base_version "${VERSION_FILE}")"

    unset META_RELEASE_TAG
    META_RELEASE_TAG="$(get_meta_release "${BASE_IMAGE_VERSION}")"

    unset PATCH_RELEASE_TAG
    PATCH_RELEASE_TAG="${META_RELEASE_TAG%-*}"

    unset MINOR_RELEASE_TAG
    MINOR_RELEASE_TAG="${PATCH_RELEASE_TAG%.*}"

    unset MAJOR_RELEASE_TAG
    MAJOR_RELEASE_TAG="${MINOR_RELEASE_TAG%.*}"

    echo "...${META_RELEASE_TAG}"
    echo "...${PATCH_RELEASE_TAG}"
    echo "...${MINOR_RELEASE_TAG}"
    echo "...${MAJOR_RELEASE_TAG}"
    echo "# # # # # # # # # # # # # # # #"

    docker build \
        --no-cache \
        --pull \
        --quiet \
        --build-arg VARNISH_VERSION="${META_RELEASE_TAG}" \
        --build-arg BASE_IMAGE_VERSION="${BASE_IMAGE_VERSION}" \
        --tag "${IMAGE_NAME}:${MAJOR_RELEASE_TAG}" \
        --tag "${IMAGE_NAME}:${MINOR_RELEASE_TAG}" \
        --tag "${IMAGE_NAME}:${PATCH_RELEASE_TAG}" \
        --tag "${IMAGE_NAME}:${META_RELEASE_TAG}" \
        --tag "${IMAGE_NAME}:stable" \
        --tag "${IMAGE_NAME}:latest" \
        --file "${FULL_VARNISH_VERSION_PATH}/Dockerfile" \
        "${TRAVIS_BUILD_DIR}"

    if [[ "${TRAVIS_BRANCH}" == "master" ]] && [[ "${TRAVIS_PULL_REQUEST}" == "false" ]]; then

        [[ "${MINOR_RELEASE_TAG}" == "${STABLE_VERSION}" ]] && \
        docker push "${IMAGE_NAME}:stable"
        [[ "${MINOR_RELEASE_TAG}" == "${LATEST_VERSION}" ]] && \
        docker push "${IMAGE_NAME}:latest"
        docker push "${IMAGE_NAME}:${MAJOR_RELEASE_TAG}"
        docker push "${IMAGE_NAME}:${MINOR_RELEASE_TAG}"
        docker push "${IMAGE_NAME}:${PATCH_RELEASE_TAG}"
        docker push "${IMAGE_NAME}:${META_RELEASE_TAG}"

    fi

done