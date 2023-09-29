# php-fpm-8-nginx

A docker images which contains:
* php 8.3, php-fpm
* nginx
* supervisord for nginx and php-fpm
* a couple of the most commonly used php extensions

# Extending the entrypoint

You can add your own `pre` initialisations at the absolute file located at  `/pre-entrypoint.sh`

You need to make sure to copy this file during your image build and have executable +x permissions.
