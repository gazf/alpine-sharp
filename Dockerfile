LABEL  maintainer "gazf <gazfff@gmail.com>"

# ------------ builder ------------
# base image https://hub.docker.com/_/node/
FROM node:alpine as builder

RUN set -x && \
  apk add \
    --no-cache --update \
    --repository http://dl-3.alpinelinux.org/alpine/edge/testing \
    libtool automake autoconf nasm vips-dev fftw-dev gcc g++ make libc6-compat

RUN set -x && \
  npm set progress=false && \
  npm config set depth 0 && \
  npm install sharp

# ------------ main ------------
# base image https://hub.docker.com/_/node/
FROM node:alpine

COPY --from=builder node_modules node_modules

RUN set -x && \
  apk add \
    --no-cache --update \
    --repository http://dl-3.alpinelinux.org/alpine/edge/testing \
    vips fftw libc6-compat
