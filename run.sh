#!/usr/bin/env bash

VERSION=$(date +%s)
PROJECT=jac18281828/tsdev

docker build . -t ${PROJECT}:${VERSION} && \
	docker run -e FALSE=false --rm -i -t ${PROJECT}:${VERSION}
