#!/usr/bin/env sh

set -eu

if [ -n "${CI_REGISTRY_USER:+notempty}" ]; then
    printf -- '%s' "$CI_REGISTRY_PASSWORD" \
        | buildah login \
                  --username "$CI_REGISTRY_USER" \
                  --password-stdin \
                  "$CI_REGISTRY"
fi
