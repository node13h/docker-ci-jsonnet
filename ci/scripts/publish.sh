#!/usr/bin/env sh

set -eu

buildah_cmd () {
    # For some reason buildah manifest commands do not pick the
    # CONTAINERS_REGISTRIES_CONF variable automatically, like
    # the buildah build and push commands do, hence the need for
    # the --registries-conf CLI argument.
    buildah ${CONTAINERS_REGISTRIES_CONF:+--registries-conf "$CONTAINERS_REGISTRIES_CONF"} "$@"
}

buildah_manifest_push () {
    buildah_cmd manifest push --all "$1" "docker://${2}"
    >&2 printf 'Pushed %s\n' "$2"
}

if [ -n "${IS_TAGGED_RELEASE:-}" ]; then
    PUBLISH_IMAGE_TAG=$(cat VERSION)
else
    PUBLISH_IMAGE_TAG="$IMAGE_TAG"
fi

manifest="${PUBLISH_IMAGE}:${PUBLISH_IMAGE_TAG}"

buildah_cmd manifest create "$manifest"

for arch in amd64 arm64; do
    buildah_cmd manifest add "$manifest" "${CI_REGISTRY_IMAGE}:${IMAGE_TAG}-${arch}"
done

buildah_manifest_push "$manifest" "${PUBLISH_IMAGE}:${PUBLISH_IMAGE_TAG}"

if [ -n "${IS_LATEST_RELEASE:-}" ]; then
    buildah_manifest_push "$manifest" "${PUBLISH_IMAGE}:latest"
fi

if [ -n "${IS_TAGGED_RELEASE:-}" ]; then
    for extra_tag in "$@"; do
        buildah_manifest_push "$manifest" "${PUBLISH_IMAGE}:${extra_tag}"
    done
fi
