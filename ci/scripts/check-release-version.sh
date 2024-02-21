#!/usr/bin/env sh

set -eu

VERSION=$(cat VERSION)

if [ "$CI_COMMIT_TAG" != "v${VERSION}" ]; then
    printf -- 'VERSION "%s" does not match Git tag "%s"\n' "$VERSION" "$CI_COMMIT_TAG"
    exit 1
fi
