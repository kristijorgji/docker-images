FROM kristijorgji/php-fpm-8-nginx:0.02 as base

USER root

# utils
RUN apk add git

# node 8.x,yarn,gulp
ENV ALPINE_MIRROR "https://dl-cdn.alpinelinux.org/alpine"

RUN echo "${ALPINE_MIRROR}/v3.8/main/" >> /etc/apk/repositories

RUN apk add --update nodejs=8.14.0-r0 --repository="${ALPINE_MIRROR}/v3.8/main/"
RUN apk add npm yarn \
    && npm install gulp -g