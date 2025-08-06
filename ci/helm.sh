#!/usr/bin/env bash

set -x

CHARTPATH=$1

pushd $CHARTPATH

yq -i '.version |= (split(".") | .[-1] |= ((. tag = "!!int") + 1) | join("."))' ./collector/Chart.yaml
yq -i '.appVersion |= (split(".") | .[-1] |= ((. tag = "!!int") + 1) | join("."))' ./collector/Chart.yaml

NEW_VERSION=$(yq '.version' ./collector/Chart.yaml)

helm package ./collector

popd

cp $CHARTPATH/prequel-collector-$NEW_VERSION.tgz .

helm repo index .