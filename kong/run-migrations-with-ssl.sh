#!/bin/bash

DB_CONTAINER=postgres-with-ssl

NAME=kong

# Use $TAG from outside, if provided.
TAG=${TAG:-latest}

docker run \
	-it \
	--rm \
	--link $DB_CONTAINER:kong-database \
	-e "KONG_DATABASE=postgres" \
	-e "KONG_PG_HOST=kong-database" \
	-e "KONG_PG_SSL=true" \
	$NAME:$TAG \
	kong migrations up
