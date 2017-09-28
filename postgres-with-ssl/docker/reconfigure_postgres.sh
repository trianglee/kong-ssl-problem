#!/bin/bash

cp /tmp/postgresql.conf /var/lib/postgresql/data/postgresql.conf
cp /tmp/pg_hba.conf     /var/lib/postgresql/data/pg_hba.conf

# Self-signed key and certificate -
#cp /tmp/cert.pem        /var/lib/postgresql/data/server.crt
#cp /tmp/private.pem     /var/lib/postgresql/data/server.key

# Chained key and certificate -
# Chain of length 1 -
#cp /tmp/key2.pem        /var/lib/postgresql/data/server.key
#cp /tmp/cert2.pem       /var/lib/postgresql/data/server.crt
# Chain of length 2 -
cp /tmp/key3.pem        /var/lib/postgresql/data/server.key
cp /tmp/cert3.pem       /var/lib/postgresql/data/server.crt

chown -R postgres: /var/lib/postgresql/data/
chmod 0600 /var/lib/postgresql/data/server.key
