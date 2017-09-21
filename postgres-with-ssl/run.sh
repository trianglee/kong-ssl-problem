#!/bin/bash

NAME=postgres-with-ssl
TAG=9.4

set -x

docker rm -f $NAME

set -e

docker run \
	-d \
	--name $NAME \
	-e "POSTGRES_USER=kong" \
	-e "POSTGRES_DB=kong" \
	$NAME:$TAG
