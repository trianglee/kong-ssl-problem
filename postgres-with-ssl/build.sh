#!/bin/bash

IMAGE=postgres-with-ssl
TAG=9.4

set -e
set -x

SCRIPT_DIR=$(dirname "$0")
pushd $SCRIPT_DIR

# Generate single certificate (no chain) -

#openssl req -new -x509 -days 7300 -sha256 -out cert.pem       -keyout private.pem       -subj /C=XX/ST=State/L=Locality/O=Organization/OU=OrgUnit/CN=CommonName -nodes
#openssl req -new -x509 -days 7300 -sha256 -out cert-wrong.pem -keyout private-wrong.pem -subj /C=XX/ST=State/L=Locality/O=Organization/OU=OrgUnit/CN=CommonName -nodes

#rm private-wrong.pem
#mv private.pem docker
#cp cert.pem docker


# Generate certificate chain -

# Generate keys -
openssl ecparam -out key1.pem -name prime256v1 -genkey
openssl ecparam -out key2.pem -name prime256v1 -genkey
openssl ecparam -out key3.pem -name prime256v1 -genkey

# cert1 - self-signed -
openssl req -key key1.pem -new -x509 -days 7300 -sha256 -out cert1.pem -subj /C=XX/ST=State/L=Locality/O=Organization/OU=OrgUnit/CN=Cert1

# cert2 - signed by cert1 -
openssl req -new -sha256 -key key2.pem -out csr2.pem -subj /C=XX/ST=State/L=Locality/O=Organization/OU=OrgUnit/CN=Cert2
openssl x509 -sha256 -req -in csr2.pem -out cert2.pem -CA cert1.pem -CAkey key1.pem -CAcreateserial -days 1095

# cert3 - signed by cert2 -
openssl req -new -sha256 -key key3.pem -out csr3.pem -subj /C=XX/ST=State/L=Locality/O=Organization/OU=OrgUnit/CN=Cert3
openssl x509 -sha256 -req -in csr3.pem -out cert3.pem -CA cert2.pem -CAkey key2.pem -CAcreateserial -days 1095

# Verify chain -
cat cert2.pem cert1.pem > cert-chain.pem
openssl verify -verbose -CApath no-such-dir -CAfile cert-chain.pem cert3.pem
rm cert-chain.pem

# Copy certificates and keys -
rm key1.pem
mv key2.pem docker
mv key3.pem docker
cp cert2.pem docker
mv cert3.pem docker
rm csr2.pem
rm csr3.pem
rm cert1.srl
rm cert2.srl
cat cert1.pem cert2.pem > cert-1-2-bundle.pem


set +e
docker rm -f $IMAGE
docker rmi -f $IMAGE:$TAG
set -e

docker build \
	--force-rm \
	-t $IMAGE:$TAG \
	./docker
