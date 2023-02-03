#!/bin/bash

set -e

SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
BASE_IMAGE="nextcloud"

function error {
  echo "Error in script: $(caller)."
  exit 1
}

function build_image() {
    local tag="$1"
    local baseImage="$BASE_IMAGE:$tag"
    local image="r0wi/${BASE_IMAGE}-extended:${tag}"
    echo "Building $image"
    docker build --build-arg BASE_IMAGE="$baseImage" -t "$image" "$SCRIPT_PATH"
}

function push_image() {
    local tag="$1"
    local image="r0wi/${BASE_IMAGE}-extended:${tag}"
    echo "Pushing $image"
    docker push "$image"
}

trap error ERR

# Parse script args
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -b|--build)
            BUILD="true"
            shift
            ;;
        -p|--push)
            PUSH="true"
            shift
            ;;
        -t|--base-tag)
            BASE_TAG="$2"
            if [ -z "$BASE_TAG" ]; then
                echo "No base tag specified. Use -t to specify a base tag."
                exit 1
            fi
            shift
            shift
            ;;
        *)
            echo "Unknown argument: $key"
            exit 1
            ;;
    esac
done

if [ "$BUILD" = "false" ] && [ "$PUSH" = "false" ]; then
    echo "Nothing to do. Use -b or -p to build or push images."
    exit 1
fi

# This is the case if get_base_tags.sh did not find any base
# images which have been touched within the last 14 days. It will
# then just print ["none-found"]. In that case 
# it's ok to just skip the build and don't let the GH actions fail.
if [ "$BASE_TAG" = "none-found" ] && [ "$CI" = "true" ]; then
    echo "[WARNING] No matching base tags found, skipping build."
    exit 0
fi

# Build / push single image
if [ "$BUILD" = "true" ]; then
    build_image "$BASE_TAG"
fi
if [ "$PUSH" = "true" ]; then
    push_image "$BASE_TAG"
fi