#!/bin/bash

IMAGE=kong
TAG=ssl-verify-fix

set -e
set -x

SCRIPT_DIR=$(dirname "$0")
pushd $SCRIPT_DIR

PR=2908
PR_DIFF=$PR.diff

wget https://patch-diff.githubusercontent.com/raw/Mashape/kong/pull/$PR_DIFF -O docker/patch.diff

set +e
docker rmi -f $IMAGE:$TAG
set -e

docker build ./docker \
	--force-rm \
	-t $IMAGE:$TAG
