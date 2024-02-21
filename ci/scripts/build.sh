#!/usr/bin/env sh

set -eu

SOURCE_DATE_EPOCH=$(date +%s)
export SOURCE_DATE_EPOCH

buildah --storage-driver=vfs build \
        --format oci \
        --timestamp "$SOURCE_DATE_EPOCH" \
        --build-arg SOURCE_DATE_EPOCH="$SOURCE_DATE_EPOCH" \
        --build-arg GIT_COMMIT_SHA="$CI_COMMIT_SHA" \
        --build-arg JB_VERSION="$JB_VERSION" \
        --build-arg JSONNET_GO_VERSION="$JSONNET_GO_VERSION" \
        --arch "$ARCH" \
        -t "${CI_REGISTRY_IMAGE}:${IMAGE_TAG}-${ARCH}" \
        .

buildah --storage-driver=vfs inspect \
        "${CI_REGISTRY_IMAGE}:${IMAGE_TAG}-${ARCH}"

buildah --storage-driver=vfs push \
        "${CI_REGISTRY_IMAGE}:${IMAGE_TAG}-${ARCH}"
