#!/bin/bash

NAME=postgres-no-ssl
IMAGE=postgres
TAG=9.4

set -x

docker rm -f $NAME

set -e

docker run \
	-d \
	--name $NAME \
	-e "POSTGRES_USER=kong" \
	-e "POSTGRES_DB=kong" \
	$IMAGE:$TAG


#	-p 5432:5432 \
