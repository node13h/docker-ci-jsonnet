#!/usr/bin/env sh

set -eu

SOURCE_DATE_EPOCH=$(date +%s)
export SOURCE_DATE_EPOCH

# Buildah sets TARGETARCH to native arch regardless of --arch
# hence the explicit TARGETARCH build arg.
# TODO: Create GitHub issue.
buildah --storage-driver=vfs build \
        --format oci \
        --timestamp "$SOURCE_DATE_EPOCH" \
        --build-arg SOURCE_DATE_EPOCH="$SOURCE_DATE_EPOCH" \
        --build-arg GIT_COMMIT_SHA="$CI_COMMIT_SHA" \
        --build-arg JB_VERSION="$JB_VERSION" \
        --build-arg JSONNET_GO_VERSION="$JSONNET_GO_VERSION" \
        --build-arg TARGETARCH="$ARCH" \
        --arch "$ARCH" \
        -t "${CI_REGISTRY_IMAGE}:${VERSION_SEMVER}-${ARCH}" \
        .

buildah --storage-driver=vfs inspect \
        "${CI_REGISTRY_IMAGE}:${VERSION_SEMVER}-${ARCH}"

buildah --storage-driver=vfs push \
        "${CI_REGISTRY_IMAGE}:${VERSION_SEMVER}-${ARCH}"
