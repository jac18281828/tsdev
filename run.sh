#!/usr/bin/env bash

VERSION=$(date +%s)

docker build . -t tsdev:${VERSION} && \
	docker run --rm -i -t tsdev:${VERSION}
