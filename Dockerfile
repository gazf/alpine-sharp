# ------------ builder ------------
# base image https://hub.docker.com/_/node/
FROM node:alpine as builder
COPY package.json package.json

RUN set -x && \
  apk add vips-dev fftw-dev build-base python --update-cache \
    --repository https://alpine.global.ssl.fastly.net/alpine/edge/testing/ \
    --repository https://alpine.global.ssl.fastly.net/alpine/edge/main

RUN set -x && \
  npm set progress=false && \
  npm config set depth 0 && \
  npm install

# ------------ main ------------
# base image https://hub.docker.com/_/node/
FROM node:alpine

COPY --from=builder node_modules node_modules
COPY package.json package.json
COPY test/index.js index.js

RUN set -x && \
  apk --no-cache add ca-certificates wget && \
  wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
  wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk && \
  apk add glibc-2.28-r0.apk

RUN set -x && \
  apk add vips fftw --update-cache \
    --repository https://alpine.global.ssl.fastly.net/alpine/edge/testing/ \
    --repository https://alpine.global.ssl.fastly.net/alpine/edge/main/ && \
  npm install && \
  node . && \
  rm -f index.js

LABEL  maintainer "gazf <gazfff@gmail.com>"
