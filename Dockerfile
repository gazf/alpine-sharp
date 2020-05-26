# ------------ builder ------------
# base image https://hub.docker.com/_/node/
FROM alpine:edge as builder
COPY package.json package.json

RUN set -x && \
  apk add --update --no-cache nodejs nodejs-npm

RUN set -x && \
  apk add vips-dev fftw-dev build-base python3 --update --no-cache \
    --repository https://alpine.global.ssl.fastly.net/alpine/edge/testing/ \
    --repository https://alpine.global.ssl.fastly.net/alpine/edge/main

RUN set -x && \
  npm set progress=false && \
  npm config set depth 0 && \
  npm install

# ------------ main ------------
# base image https://hub.docker.com/_/node/
FROM alpine:edge

COPY --from=builder node_modules node_modules
COPY package.json package.json
COPY test/index.js index.js

RUN set -x && \
  apk add --update --no-cache nodejs nodejs-npm

RUN set -x && \
  apk add vips fftw --update --no-cache \
    --repository https://alpine.global.ssl.fastly.net/alpine/edge/testing/ \
    --repository https://alpine.global.ssl.fastly.net/alpine/edge/main/ && \
  npm install && \
  node . && \
  rm -f index.js

LABEL  maintainer "gazf <gazfff@gmail.com>"
