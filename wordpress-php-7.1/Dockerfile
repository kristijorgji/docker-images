FROM ubuntu:24.04 AS base

ARG BUILD_ENV=prod
ARG WORKDIR=/var/www/html/app

ENV DEBIAN_FRONTEND=noninteractive

# PHP 7.1.33-80 is Ondrej's 2026-10-21 rebuild for CVE-2026-109618 and CVE-2026-109619.
# Upstream did not release 7.1.34. Ubuntu 18.04 is outside that PPA upload, so this image is Noble.
ARG PHP71_VERSION=7.1.33-80+ubuntu24.04.1+deb.sury.org+1

RUN apt-get update \
    && apt-get install -y software-properties-common \
    && apt-add-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -yq --no-install-recommends \
    build-essential \
    apt-utils \
    curl \
    git \
    unzip \
    supervisor \
    "php7.1-cli=${PHP71_VERSION}" \
    "php7.1-sqlite3=${PHP71_VERSION}" \
    "php7.1-bz2=${PHP71_VERSION}" \
    "php7.1-curl=${PHP71_VERSION}" \
    "php7.1-mysql=${PHP71_VERSION}" \
    "php7.1-mbstring=${PHP71_VERSION}" \
    "php7.1-mcrypt=${PHP71_VERSION}" \
    "php7.1-opcache=${PHP71_VERSION}" \
    "php7.1-xml=${PHP71_VERSION}" \
    "php7.1-gd=${PHP71_VERSION}" \
    "php7.1-gmp=${PHP71_VERSION}" \
    "php7.1-intl=${PHP71_VERSION}" \
    "php7.1-json=${PHP71_VERSION}" \
    "php7.1-fpm=${PHP71_VERSION}" \
    "php7.1-soap=${PHP71_VERSION}" \
    "php7.1-zip=${PHP71_VERSION}" \
    "php7.1-bcmath=${PHP71_VERSION}" \
    "php7.1-imap=${PHP71_VERSION}" \
    nginx \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/php/

RUN mkdir -p /etc/nginx/sites-available \
    && mkdir -p /etc/nginx/sites-enabled \
    && unlink /etc/nginx/sites-enabled/default \
    && ln -s /etc/nginx/sites-available/site /etc/nginx/sites-enabled/

COPY nginx.default.conf /etc/nginx/sites-available/site

COPY supervisord.conf /etc/supervisord.conf

WORKDIR ${WORKDIR}

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
