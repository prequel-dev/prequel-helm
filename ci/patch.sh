#!/usr/bin/env bash

set -x

if [ "$#" -eq 1 ]; then
  echo "Usage: $0 <path-to-helm-values> <path-to-version-file>"
  exit 1
fi

VALUES_YAML=$1
VERSION_FILE=$2

function do_client() {
  CLIENT_IMAGES=(
    "provision:prequel-provision"
    "machineid:prequel-machineid"
    "collector:prequel-collector"
    "probes:prequel-probes")

  for image in "${CLIENT_IMAGES[@]}"; do

    IFS=":" read -r name repo <<< "$image"

    echo Current $name tag:
    cat $VALUES_YAML | yq ".$name.image.tag"

    echo New $name tag:
    echo $(cat $VERSION_FILE)

    yq -i ".$name.image.tag = \"$(cat $VERSION_FILE)\"" $VALUES_YAML

  done
}

do_client
