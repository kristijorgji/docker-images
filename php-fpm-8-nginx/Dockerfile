FROM alpine:3.24

# ensure www-data user exists
# 82 is the standard uid/gid for "www-data" in Alpine
RUN set -x ; \
  addgroup -g 82 -S www-data ; \
  adduser -u 82 -D -S -G www-data www-data && exit 0 ; exit 1

RUN apk update && apk upgrade;

# Install packages and remove default server definition
# Extension parity with 0.0.7 (php82) plus php85-pecl-imap for composer ext-imap.
# Core php85 packages are pinned (CVE-2026-109618, CVE-2026-109619).
# PECL packages stay unpinned; the Alpine 3.24 index builds them against this PHP.
ARG PHP85_VERSION=8.5.12-r0
RUN apk --no-cache add \
    php85=${PHP85_VERSION} \
    php85-bcmath=${PHP85_VERSION} \
    php85-ctype=${PHP85_VERSION} \
    php85-curl=${PHP85_VERSION} \
    php85-dom=${PHP85_VERSION} \
    php85-exif=${PHP85_VERSION} \
    php85-fileinfo=${PHP85_VERSION} \
    php85-fpm=${PHP85_VERSION} \
    php85-gd=${PHP85_VERSION} \
    php85-gmp=${PHP85_VERSION} \
    php85-iconv=${PHP85_VERSION} \
    php85-intl=${PHP85_VERSION} \
    php85-mbstring=${PHP85_VERSION} \
    php85-mysqli=${PHP85_VERSION} \
    php85-mysqlnd=${PHP85_VERSION} \
    php85-openssl=${PHP85_VERSION} \
    php85-pdo=${PHP85_VERSION} \
    php85-pdo_mysql=${PHP85_VERSION} \
    php85-pecl-imagick \
    php85-pecl-imap \
    php85-pecl-redis \
    php85-phar=${PHP85_VERSION} \
    php85-session=${PHP85_VERSION} \
    php85-simplexml=${PHP85_VERSION} \
    php85-soap=${PHP85_VERSION} \
    php85-sockets=${PHP85_VERSION} \
    php85-sodium=${PHP85_VERSION} \
    php85-tokenizer=${PHP85_VERSION} \
    php85-xml=${PHP85_VERSION} \
    php85-xmlreader=${PHP85_VERSION} \
    php85-xmlwriter=${PHP85_VERSION} \
    php85-zip=${PHP85_VERSION} \
    nginx supervisor curl tzdata htop mysql-client dcron

RUN mkdir -p /etc/nginx/sites-available && mkdir -p /etc/nginx/sites-enabled && ln -s /etc/nginx/sites-available/site /etc/nginx/sites-enabled/

# Symlink php85 => php (Alpine may already ship /usr/bin/php)
RUN ln -sf /usr/bin/php85 /usr/bin/php \
    && ln -sf /usr/sbin/php-fpm85 /usr/sbin/php-fpm

# Install PHP tools
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm -f composer-setup.php

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php85/php-fpm.d/www.conf
COPY config/php.ini /etc/php85/conf.d/custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisord.conf

# Setup document root
RUN mkdir -p /var/www/html/app

# Make sure files/folders needed by the processes are accessable when they run under the www-data user
RUN chown -R www-data:www-data /var/www/html/app && \
  chown -R www-data:www-data /run && \
  chown -R www-data:www-data /var/lib/nginx && \
  chown -R www-data:www-data /var/log/nginx

# Switch to use a non-root user from here on
USER www-data

# Expose the port nginx is reachable on
EXPOSE 8080

# Let supervisord start nginx & php-fpm
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

# Configure a healthcheck to validate that everything is up&running
#HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping
