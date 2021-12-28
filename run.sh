#!/usr/bin/env bash

VERSION=$(date +%s)

docker build . -t tsdev:${VERSION} && \
	docker run -e FALSE=false --rm -i -t tsdev:${VERSION}
