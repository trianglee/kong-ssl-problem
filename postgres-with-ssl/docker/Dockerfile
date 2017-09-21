FROM postgres:9.4

COPY postgresql.conf         /tmp
COPY pg_hba.conf             /tmp
COPY private.pem             /tmp
COPY cert.pem                /tmp

RUN chmod oug+r /tmp/*

COPY reconfigure_postgres.sh /docker-entrypoint-initdb.d/reconfigure_postgres.sh
