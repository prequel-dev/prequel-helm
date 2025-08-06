#!/usr/bin/env bash

set -x

if [ "$#" -eq 1 ]; then
  echo "Usage: $0 <path-to-helm-values> <path-to-release-output-yaml>"
  exit 1
fi

VALUES_YAML=$1
REL_OUT=$2

function do_client() {
  CLIENT_IMAGES=(
    "provision:prequel-provision"
    "machineid:prequel-machineid"
    "collector:prequel-collector"
    "probes:prequel-probes")

  for image in "${CLIENT_IMAGES[@]}"; do

    IFS=":" read -r name repo <<< "$image"

    echo Current $name hash:
    cat $VALUES_YAML | yq ".$name.image.tag"

    HASH=$(cat $REL_OUT | yq ".publishedReleaseRepos[] | select(.name==\"$repo\").hash")

    echo New $name hash:
    echo $HASH

     if [[ -z $HASH ]]; then
      echo "Skipping $repo due to empty hash"
    else
      yq -i ".$name.image.tag = \"$HASH\"" $VALUES_YAML
      yq -i ".$name.image.repoName = \"$repo\"" $VALUES_YAML  
    fi

    echo $?

  done
}

do_client
