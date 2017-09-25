#!/bin/bash

NAME=postgres
TAG=9.4

if [ -z "$1" -o -z "$2" ] ; then
	echo 'Usage: <postgres-container> <postgres-certificate>'
	exit 1
fi

POSTGRES_CONTAINER=$1
POSTGRES_CERT=$2

set -e
set -x

SCRIPT_DIR=$(dirname "$0")
pushd $SCRIPT_DIR

docker run \
	-it \
	--rm \
	--link $1:postgres \
	-v $(pwd)/$POSTGRES_CERT:/tmp/cert.pem:ro \
	$NAME:$TAG \
	psql -h postgres -U postgres "sslmode=verify-ca sslrootcert=/tmp/cert.pem"
