# php-fpm-8-nginx

Alpine-based image with PHP-FPM, nginx, and supervisord for Laravel/Lumen-style apps.

## Contents

- **PHP 8.5.12** + php-fpm (`php-fpm85`), pinned for CVE-2026-109618 and CVE-2026-109619
- **nginx** listening on container port **8080**
- **supervisord** starting nginx + php-fpm
- FPM listen: **`127.0.0.1:9000`** (TCP)
- Common PHP extensions (see matrix below)
- Composer + WP-CLI on `PATH` via `php` symlink

## PHP extensions

| Module | Package |
|--------|---------|
| bcmath, ctype, curl, dom, exif, fileinfo, gd, gmp, iconv, intl, mbstring | `php85-*` |
| mysqli, mysqlnd, pdo, pdo_mysql | `php85-*` |
| opcache, openssl, phar, session, simplexml, soap, sockets, sodium, tokenizer | `php85-*` (opcache is built into `php85` on Alpine 3.24) |
| xml, xmlreader, xmlwriter, zip | `php85-*` |
| imagick | `php85-pecl-imagick` |
| redis (+ igbinary/msgpack as deps) | `php85-pecl-redis` |
| imap | `php85-pecl-imap` |

Verify after build:

```bash
docker run --rm --entrypoint php kristijorgji/php-fpm-8-nginx:0.0.9 -v
docker run --rm --entrypoint php kristijorgji/php-fpm-8-nginx:0.0.9 -m
```

## Extending the entrypoint

You can add your own `pre` initialisations at the absolute path `/pre-entrypoint.sh`.

Copy that file during your image build and ensure it has executable `+x` permissions.

## Tags

| Tag | PHP | Alpine |
|-----|-----|--------|
| `0.0.9` | 8.5.12 | 3.24 |
| `0.0.8` | 8.5.9 | 3.24 |
| `0.0.7` | 8.2 | 3.18 |
