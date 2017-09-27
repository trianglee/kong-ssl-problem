#!/bin/bash

IMAGE=postgres-with-ssl
TAG=9.4

set -e
set -x

SCRIPT_DIR=$(dirname "$0")
pushd $SCRIPT_DIR

openssl req -new -x509 -days 7300 -sha256 -out cert.pem       -keyout private.pem       -subj /C=XX/ST=State/L=Locality/O=Organization/OU=OrgUnit/CN=CommonName -nodes
openssl req -new -x509 -days 7300 -sha256 -out cert-wrong.pem -keyout private-wrong.pem -subj /C=XX/ST=State/L=Locality/O=Organization/OU=OrgUnit/CN=CommonName -nodes

rm private-wrong.pem
mv private.pem docker
cp cert.pem docker

set +e
docker rm -f $IMAGE
docker rmi -f $IMAGE:$TAG
set -e

docker build \
	--force-rm \
	-t $IMAGE:$TAG \
	./docker
