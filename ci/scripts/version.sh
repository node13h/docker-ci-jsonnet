#!/usr/bin/env sh

set -eu

default_branch_sha=$(git rev-parse "$CI_DEFAULT_BRANCH")
printf 'DEFAULT_BRANCH_SHA=%s\n' "$default_branch_sha"

if [ -n "${IS_TAGGED_RELEASE:-}" ]; then
    if [ "$default_branch_sha" = "$CI_COMMIT_SHA" ]; then
        printf 'IS_LATEST_RELEASE=true\n'
    fi
fi
