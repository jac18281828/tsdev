# Stage 1: Build yamlfmt
FROM golang:1 AS go-builder
# defined from build kit
# DOCKER_BUILDKIT=1 docker build . -t ...
ARG TARGETARCH

# Install yamlfmt
WORKDIR /yamlfmt
RUN go install github.com/google/yamlfmt/cmd/yamlfmt@v0.16.0 && \
    strip $(which yamlfmt) && \
    yamlfmt --version

# Stage 2: TypeScript Development Container
FROM debian:stable-slim

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y -q --no-install-recommends \
    ca-certificates \
    curl \
    git \
    gnupg2 \
    npm \
    ripgrep \
    sudo \
    unzip \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV USER=tsdev    
RUN useradd --create-home -s /bin/bash ${USER}
RUN usermod -a -G sudo ${USER}
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY --chown=${USER}:${USER} --from=go-builder /go/bin/yamlfmt /go/bin/yamlfmt

RUN mkdir -p /usr/local/nvm
ENV NVM_DIR=/usr/local/nvm

ENV NODE_VERSION=v22.15.1
ENV NVM_NODE_PATH=${NVM_DIR}/versions/node/${NODE_VERSION}
ENV NODE_PATH=${NVM_NODE_PATH}/lib/node_modules
ENV PATH=${NVM_NODE_PATH}/bin:${PATH}:/go/bin
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
RUN bash -c ". $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION && nvm use default"


RUN npm install npm -g
RUN npm install yarn -g

# Install Bun
ADD --chown=${USER}:${USER} --chmod=555 https://bun.sh/install /bun/install.sh

USER tsdev

RUN /bun/install.sh && \
    sudo rm -rf /bun

ENV PATH=${PATH}:/home/tsdev/.bun/bin

LABEL \
    org.label-schema.name="tsdev" \
    org.label-schema.description="TypeScript Development Container" \
    org.label-schema.url="https://github.com/jac18281828/tsdev" \
    org.label-schema.vcs-url="git@github.com:jac18281828/tsdev.git" \
    org.label-schema.vendor="John Cairns" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0" \
    org.opencontainers.image.description="TypeScript and Node 18 development container"
