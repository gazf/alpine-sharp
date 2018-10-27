# ------------ builder ------------
# base image https://hub.docker.com/_/node/
FROM node:alpine as builder

RUN set -x && \
  apk add \
    --no-cache --update \
    --repository https://dl-3.alpinelinux.org/alpine/edge/testing \
    --repository https://dl-3.alpinelinux.org/alpine/edge/main \
    libtool build-base automake autoconf nasm vips-dev fftw-dev gcc g++ make libc6-compat

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
  apk add \
    --no-cache --update \
    --repository https://dl-3.alpinelinux.org/alpine/edge/testing \
    --repository https://dl-3.alpinelinux.org/alpine/edge/main \
    vips fftw libc6-compat && \
  npm install && \
  node . && \
  rm -f index.js

LABEL  maintainer "gazf <gazfff@gmail.com>"
