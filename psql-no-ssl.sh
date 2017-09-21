#!/bin/bash

IMAGE=postgres
TAG=9.4

set -e
set -x

SCRIPT_DIR=$(dirname "$0")
pushd $SCRIPT_DIR

docker run \
	-it \
	--rm \
	--link $1:postgres \
	$IMAGE:$TAG \
	psql -h postgres -U postgres "sslmode=disable"
