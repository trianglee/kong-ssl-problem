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
./wait-for-postgres-instances.sh

# Run Kong migrations on both databases.
./kong/run-migrations-no-ssl.sh
RUN_MIGRATIONS=true ./kong/run-with-ssl.sh
