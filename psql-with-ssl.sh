#!/bin/bash

NAME=postgres
TAG=9.4

set -e
set -x

SCRIPT_DIR=$(dirname "$0")
pushd $SCRIPT_DIR

docker run \
	-it \
	--rm \
	--link $1:postgres \
	-v $(pwd)/postgres-with-ssl/cert.pem:/tmp/cert.pem:ro \
	$NAME:$TAG \
	psql -h postgres -U postgres "sslmode=verify-ca sslrootcert=/tmp/cert.pem"
