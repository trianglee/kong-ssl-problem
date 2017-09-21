#!/bin/bash

set -x
set -e

SCRIPT_DIR=$(dirname "$0")
pushd $SCRIPT_DIR

# Start Postgres database containers with and without SSL.
./postgres-no-ssl/run.sh
./postgres-with-ssl/build.sh
./postgres-with-ssl/run.sh

# Wait for both to become available.
docker run \
	--link postgres-no-ssl \
	--link postgres-with-ssl \
	jwilder/dockerize \
	dockerize \
		-timeout 30s \
		-wait tcp://postgres-no-ssl:5432 \
		-wait tcp://postgres-with-ssl:5432

# Run Kong migrations on both databases.
./kong/run-migrations-no-ssl.sh
./kong/run-migrations-with-ssl.sh
