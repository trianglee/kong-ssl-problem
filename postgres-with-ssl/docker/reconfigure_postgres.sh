#!/bin/bash

cp /tmp/postgresql.conf /var/lib/postgresql/data/postgresql.conf
cp /tmp/pg_hba.conf     /var/lib/postgresql/data/pg_hba.conf
cp /tmp/cert.pem        /var/lib/postgresql/data/server.crt
cp /tmp/private.pem     /var/lib/postgresql/data/server.key

chown -R postgres: /var/lib/postgresql/data/
chmod 0600 /var/lib/postgresql/data/server.key
