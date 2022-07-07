FROM ubuntu:18.04 as base

ARG BUILD_ENV=prod
ARG WORKDIR=/var/www/html/app

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y software-properties-common \
    && apt-add-repository ppa:ondrej/php \
    && apt-get update \
    && apt-get install -yq --no-install-recommends \
    build-essential \
    apt-utils \
    # Install utils
    curl \
    git \
    unzip \
    python-pip \
    python-setuptools \
    # Install php fpm and libs
    php7.1-cli \
    php7.1-sqlite3 \
    php7.1-bz2 \
    php7.1-curl \
    php7.1-mysql \
    php7.1-mbstring \
    php7.1-mcrypt \
    php7.1-opcache \
    php7.1-xml \
    php7.1-gd \
    php7.1-gmp \
    php7.1-intl \
    php7.1-json \
    php7.1-fpm \
    php7.1-soap \
    php7.1-zip \
    php7.1-bcmath \
    php7.1-dom \
    php-imap \
    php7.1-imap \
    php-bcmath \
    php-mysql \
    php-curl \
    php-imagick \
    php-gd \
    php-xml \
    # Install and configure nginx
    nginx \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/php/ \
    # Install supervisor
    && pip install wheel \
    && pip install supervisor supervisor-stdout

RUN mkdir -p /etc/nginx/sites-available \
    && mkdir -p /etc/nginx/sites-enabled \
    && unlink /etc/nginx/sites-enabled/default \
    && ln -s /etc/nginx/sites-available/site /etc/nginx/sites-enabled/

# Nginx config \
COPY nginx.default.conf /etc/nginx/sites-available/site

# Supervisor config
COPY supervisord.conf /etc/supervisord.conf

WORKDIR ${WORKDIR}

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
