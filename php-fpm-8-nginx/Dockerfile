FROM alpine:3.18.3

# ensure www-data user exists
# 82 is the standard uid/gid for "www-data" in Alpine
RUN set -x ; \
  addgroup -g 82 -S www-data ; \
  adduser -u 82 -D -S -G www-data www-data && exit 0 ; exit 1

RUN apk update && apk upgrade;

# Install packages and remove default server definition
RUN apk --no-cache add php82 \
    php82-ctype \
    php82-curl \
    php82-dom \
    php82-exif \
    php82-fileinfo \
    php82-fpm \
    php82-gd \
    php82-iconv \
    php82-intl \
    php82-mbstring \
    php82-mysqli \
    php82-opcache \
    php82-openssl \
    php82-pecl-imagick \
    php82-pecl-redis \
    php82-phar \
    php82-session \
    php82-simplexml \
    php82-soap \
    php82-xml \
    php82-xmlreader \
    php82-zip \
    php82-zlib \
    php82-pdo \
    php82-xmlwriter \
    php82-tokenizer \
    php82-pdo_mysql \
    php82-bcmath \
    php82-gmp \
    nginx supervisor curl tzdata htop mysql-client dcron

RUN mkdir -p /etc/nginx/sites-available && mkdir -p /etc/nginx/sites-enabled && ln -s /etc/nginx/sites-available/site /etc/nginx/sites-enabled/

#RUN rm /etc/nginx/conf.d/default.conf

# Symlink php82 => php
RUN ln -s /usr/bin/php82 /usr/bin/php

# Install PHP tools
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php82/php-fpm.d/www.conf
COPY config/php.ini /etc/php82/conf.d/custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisord.conf

# Setup document root
RUN mkdir -p /var/www/html/app

# Make sure files/folders needed by the processes are accessable when they run under the www-data user
RUN chown -R www-data.www-data /var/www/html/app && \
  chown -R www-data.www-data /run && \
  chown -R www-data.www-data /var/lib/nginx && \
  chown -R www-data.www-data /var/log/nginx

# Switch to use a non-root user from here on
USER www-data

# Expose the port nginx is reachable on
EXPOSE 8080

# Let supervisord start nginx & php-fpm
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

# Configure a healthcheck to validate that everything is up&running
#HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping
