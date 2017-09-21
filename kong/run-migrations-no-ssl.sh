#!/bin/bash

DB_CONTAINER=postgres-no-ssl

IMAGE=kong
TAG=latest

set -e
set -x

docker run \
	-it \
	--rm \
	--link $DB_CONTAINER:kong-database \
	-e "KONG_DATABASE=postgres" \
	-e "KONG_PG_HOST=kong-database" \
	$IMAGE:$TAG \
	kong migrations up
