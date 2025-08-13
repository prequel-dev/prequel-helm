#!/usr/bin/env bash

set -x

CHARTPATH=$1
VERSION_FILE=$2
pushd $CHARTPATH

NEW_VERSION=$(cat $VERSION_FILE)

yq -i '.version = "'$NEW_VERSION'"' ./collector/Chart.yaml
yq -i '.appVersion = "'$NEW_VERSION'"' ./collector/Chart.yaml

helm package ./collector

popd

cp $CHARTPATH/prequel-collector-$NEW_VERSION.tgz .

helm repo index .