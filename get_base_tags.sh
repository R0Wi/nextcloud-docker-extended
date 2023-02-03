#!/bin/bash

set -e
shopt -s inherit_errexit

TAGS_URI_BASE="https://hub.docker.com/v2/repositories/library/nextcloud/tags?page_size=1000&name=apache"

function get_docker_tags() {
    declare -a tags
    # Get all apache based images starting with two digits which are
    # updated within the last 14 days. API is paged so iterate over all pages.
    local tagsUri="$TAGS_URI_BASE"
    while [ "$tagsUri" != "null" ]; do
        result="$(curl --silent --get -H "Accept: application/json" $tagsUri)"
        # Filter tags which are updated within the last 14 days
        # Timestamp has structure: "last_updated":"2022-09-20T21:26:08.520696Z"
        tmp_tags="$(echo $result | jq -r '.results[] | select(.last_updated | sub(".[0-9]+Z$"; "Z") | fromdateiso8601 > (now - 1209600)) | select(.name | test ("^\\d\\d")) | .name')"
        for tmp_tag in $tmp_tags; do
            tags+=("$tmp_tag")
        done
        tagsUri="$(echo $result | jq -r '.next')"  
    done
    echo "$(echo "${tags[@]}" | tr ' ' '\n')"
}

# Parse script args
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -t|--text)
            TEXT="true"
            shift
            ;;
        -j|--json)
            JSON="true"
            shift
            ;;
        *)
            echo "Unknown argument: $key"
            exit 1
            ;;
    esac
done

if [ "$TEXT" = "true" ]; then
    get_docker_tags
fi

if [ "$JSON" = "true" ]; then
    txt_tags="$(get_docker_tags)"
    if [ -n "$txt_tags" ]; then
        echo "$txt_tags" | jq -R -s -c 'split("\n")[:-1]'
    else
        echo "[\"none-found\"]"
    fi
fi