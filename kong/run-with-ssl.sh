#!/bin/bash

DB_CONTAINER=postgres-with-ssl

IMAGE=kong

# Use $TAG from outside, if provided.
TAG=${TAG:-latest}

set -e
set -x

SCRIPT_DIR=$(dirname "$0")
pushd $SCRIPT_DIR

if [ -n "$SSL_VERIFY" ] ; then
	KONG_PG_SSL_VERIFY=$SSL_VERIFY
else
	KONG_PG_SSL_VERIFY=false
fi

docker run \
	-ti \
	--rm \
	--link $DB_CONTAINER:kong-database \
	-v $(pwd)/../postgres-with-ssl/cert.pem:/tmp/cert.pem:ro \
	-e "KONG_DATABASE=postgres" \
	-e "KONG_PG_HOST=kong-database" \
	-e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
	-e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
	-e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
	-e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
	-e "KONG_PG_SSL=true" \
	-e "KONG_PG_SSL_VERIFY=$KONG_PG_SSL_VERIFY" \
	-e "KONG_LUA_SSL_TRUSTED_CERTIFICATE=/tmp/cert.pem" \
	-e "KONG_NGINX_WORKER_PROCESSES=1" \
	-p 8000:8000 \
	-p 8443:8443 \
	-p 8001:8001 \
	-p 8444:8444 \
	$IMAGE:$TAG \
	kong start -vv
