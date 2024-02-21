#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )

DEST_DIR="$1"
FILENAME="$2"

mkdir -p "$DEST_DIR"

while read -r name checksum url; do
    [ "$name" = "$FILENAME" ] || continue

    wget -q -O "${DEST_DIR%/}/${name}" "$url"

    actual_checksum=$(sha256sum "${DEST_DIR%/}/${name}" | cut -f 1 -d ' ')

    if [ "$checksum" != "$actual_checksum" ]; then
        >&2 printf '%s checksum mismatch! Expected %s, got %s\n' \
            "$name" "$checksum" "$actual_checksum"
        exit 1
    fi
done < "${SCRIPT_DIR%/}/binaries.txt"
