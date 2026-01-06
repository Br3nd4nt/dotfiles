#!/usr/bin/env bash

FILE=$1
BASE_DIR="$(dirname "${FILE}")"
FULL_BASENAME="$(basename "${FILE}")"
BASENAME=$"${FULL_BASENAME%.*}"

DIR="${BASE_DIR}/${BASENAME}"
echo "creating folder ${DIR}"
mkdir -p "${DIR}"
echo "extracting images from ${FILE}"
heif-convert -o "${DIR}/${BASENAME}.jpeg" "$FILE"
