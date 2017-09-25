#!/bin/bash

docker run \
	--rm \
	--link postgres-no-ssl \
	--link postgres-with-ssl \
	jwilder/dockerize \
	dockerize \
		-timeout 30s \
		-wait tcp://postgres-no-ssl:5432 \
		-wait tcp://postgres-with-ssl:5432
