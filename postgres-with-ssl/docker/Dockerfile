FROM postgres:9.4

COPY postgresql.conf         /tmp
COPY pg_hba.conf             /tmp

# Self-signed key and certificate -
#COPY private.pem             /tmp
#COPY cert.pem                /tmp

# Chained key and certificate -
COPY key2.pem                /tmp
COPY cert2.pem               /tmp
COPY key3.pem                /tmp
COPY cert3.pem               /tmp

RUN chmod oug+r /tmp/*

COPY reconfigure_postgres.sh /docker-entrypoint-initdb.d/reconfigure_postgres.sh
