#!/bin/bash

DB_CONTAINER=postgres-no-ssl

IMAGE=kong

# Use $TAG from outside, if provided.
TAG=${TAG:-latest}

set -e
set -x

docker run \
	-it \
	--rm \
	--link $DB_CONTAINER:kong-database \
	-e "KONG_DATABASE=postgres" \
	-e "KONG_PG_HOST=kong-database" \
	-e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
	-e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
	-e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
	-e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
	-p 8000:8000 \
	-p 8443:8443 \
	-p 8001:8001 \
	-p 8444:8444 \
	$IMAGE:$TAG \
	kong start -vv
