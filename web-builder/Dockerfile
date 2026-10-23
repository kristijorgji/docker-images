FROM kristijorgji/php-fpm-8-nginx:0.0.9 AS base

USER root

# Node comes from Alpine 3.24. Node 8.14 only existed in the Alpine 3.8 repo and
# cannot be installed on the PHP 8.5.12 base image.
RUN apk add --no-cache git nodejs npm yarn \
    && npm install -g gulp
