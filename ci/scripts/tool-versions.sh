#!/usr/bin/env bash

set -euo pipefail

declare -r VER_RE='^([0-9]+)\.([0-9]+)'

for var in "$@"; do
    if ! [[ "${!var}" =~ $VER_RE ]]; then
        >&2 printf 'Invalid version %s\n' "${!var}"
        exit 1
    fi

    printf '%s_MAJOR=%s\n' "$var" "${BASH_REMATCH[1]}"
    printf '%s_MINOR=%s.%s\n' "$var" "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
done
