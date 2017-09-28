#!/bin/bash

DB_CONTAINER=postgres-with-ssl

IMAGE=kong

set -e
set -x

# Use environment variables from outside, if provided.
TAG=${TAG:-latest}
PG_HOST=${PG_HOST:-kong-database}
PG_PASSWORD=${PG_PASSWORD:-}
PG_USER=${PG_USER:-kong}
PG_DATABASE=${PG_DATABASE:-kong}
CERT_PEM=${CERT_PEM:-../postgres-with-ssl/cert.pem}
SSL_VERIFY=${SSL_VERIFY:-false}

if [ "$RUN_MIGRATIONS" = "true" ] ; then
	CMD="kong migrations up"
else
	CMD="kong start -vv"
fi

SCRIPT_DIR=$(dirname "$0")
pushd $SCRIPT_DIR

docker run \
	--name kong \
	-ti \
	--rm \
	--link $DB_CONTAINER:kong-database \
	-v $(pwd)/$CERT_PEM:/tmp/cert.pem:ro \
	-e "KONG_DATABASE=postgres" \
	-e "KONG_PG_HOST=${PG_HOST}" \
	-e "KONG_PG_DATABASE=${PG_DATABASE}" \
	-e "KONG_PG_USER=${PG_USER}" \
	-e "KONG_PG_PASSWORD=${PG_PASSWORD}" \
	-e "KONG_PG_SSL=true" \
	-e "KONG_PG_SSL_VERIFY=${SSL_VERIFY}" \
	-e "KONG_LUA_SSL_TRUSTED_CERTIFICATE=/tmp/cert.pem" \
	-e "KONG_NGINX_WORKER_PROCESSES=1" \
	-p 8000:8000 \
	-p 8443:8443 \
	-p 8001:8001 \
	-p 8444:8444 \
	$IMAGE:$TAG \
	$CMD
