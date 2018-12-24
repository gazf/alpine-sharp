# ------------ builder ------------
# base image https://hub.docker.com/_/node/
FROM node:alpine as builder

RUN set -x && \
  apk add vips-dev fftw-dev build-base python --update-cache \
    --repository https://alpine.global.ssl.fastly.net/alpine/edge/testing/ \
    --repository https://alpine.global.ssl.fastly.net/alpine/edge/main

RUN set -x && \
  npm set progress=false && \
  npm config set depth 0 && \
  npm install sharp

# ------------ main ------------
# base image https://hub.docker.com/_/node/
FROM node:alpine

COPY --from=builder node_modules node_modules
COPY test/index.js index.js

RUN set -x && \
  apk add vips fftw --update-cache \
    --repository https://alpine.global.ssl.fastly.net/alpine/edge/testing/ \
    --repository https://alpine.global.ssl.fastly.net/alpine/edge/main \
    libc6-compat && \
  npm install sharp && \
  node . && \
  rm -f index.js

LABEL  maintainer "gazf <gazfff@gmail.com>"
