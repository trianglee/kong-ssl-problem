#!/bin/bash

DB_CONTAINER=postgres-with-ssl

NAME=kong

# Use environment variables from outside, if provided.
TAG=${TAG:-latest}
PG_HOST=${PG_HOST:-kong-database}
PG_PASSWORD=${PG_PASSWORD:-}
PG_USER=${PG_USER:-kong}
PG_DATABASE=${PG_DATABASE:-kong}

docker run \
	-it \
	--rm \
	--link $DB_CONTAINER:kong-database \
	-e "KONG_DATABASE=postgres" \
	-e "KONG_PG_HOST=${PG_HOST}" \
	-e "KONG_PG_PASSWORD=${PG_PASSWORD}" \
	-e "KONG_PG_USER=${PG_USER}" \
	-e "KONG_PG_DATABASE=${PG_DATABASE}" \
	-e "KONG_PG_SSL=true" \
	$NAME:$TAG \
	kong migrations up
