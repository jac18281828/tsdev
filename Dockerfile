ARG VERSION=stable-slim
FROM debian:${VERSION}

RUN export DEBIAN_FRONTEND=noninteractive && \
        apt update && \
        apt install -y -q --no-install-recommends \
        npm build-essential git curl ca-certificates apt-transport-https

RUN apt clean
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/local/nvm
ENV NVM_DIR=/usr/local/nvm

ENV NODE_VERSION=v16.13.1

ADD https://raw.githubusercontent.com/creationix/nvm/master/install.sh /usr/local/etc/nvm/install.sh
RUN bash /usr/local/etc/nvm/install.sh && \
        bash -c ". $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION && nvm use default"

ENV NVM_NODE_PATH ${NVM_DIR}/versions/node/${NODE_VERSION}
ENV NODE_PATH ${NVM_NODE_PATH}/lib/node_modules
ENV PATH      ${NVM_NODE_PATH}/bin:$PATH

ARG TYPESCRIPT_VERSION=4.5.4

RUN npm install -g npm@latest
RUN npm install typescript@${TYPESCRIPT_VERSION} -g
RUN npm install eslint -g

ENV TYPESCRIPT_VERSION=${TYPESCRIPT_VERSION}
CMD echo "TypeScript Dev ${TYPESCRIPT_VERSION}"

