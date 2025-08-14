#!/usr/bin/env bash

set -x

CHARTPATH=$1
VERSION_FILE=$2
pushd $CHARTPATH

NEW_VERSION=$(cat $VERSION_FILE)

helm package ./collector

popd

cp $CHARTPATH/prequel-collector-$NEW_VERSION.tgz .

helm repo index .