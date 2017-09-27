#!/bin/bash

DB_CONTAINER=postgres-with-ssl

IMAGE=kong

# Use environment variables from outside, if provided.
TAG=${TAG:-latest}
PG_HOST=${PG_HOST:-kong-database}
PG_PASSWORD=${PG_PASSWORD:-}
PG_USER=${PG_USER:-kong}
PG_DATABASE=${PG_DATABASE:-kong}
CERT_PEM=${CERT_PEM:-../postgres-with-ssl/cert.pem}
SSL_VERIFY=${SSL_VERIFY:-false}

set -e
set -x

SCRIPT_DIR=$(dirname "$0")
pushd $SCRIPT_DIR

docker run \
	-ti \
	--rm \
	--link $DB_CONTAINER:kong-database \
	-v $(pwd)/$CERT_PEM:/tmp/cert.pem:ro \
	-e "KONG_DATABASE=postgres" \
	-e "KONG_PG_HOST=${PG_HOST}" \
	-e "KONG_PG_DATABASE=${PG_DATABASE}" \
	-e "KONG_PG_USER=${PG_USER}" \
	-e "KONG_PG_PASSWORD=${PG_PASSWORD}" \
	-e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
	-e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
	-e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
	-e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
	-e "KONG_PG_SSL=true" \
	-e "KONG_PG_SSL_VERIFY=${SSL_VERIFY}" \
	-e "KONG_LUA_SSL_TRUSTED_CERTIFICATE=/tmp/cert.pem" \
	-e "KONG_NGINX_WORKER_PROCESSES=1" \
	-p 8000:8000 \
	-p 8443:8443 \
	-p 8001:8001 \
	-p 8444:8444 \
	$IMAGE:$TAG \
	kong start -vv
