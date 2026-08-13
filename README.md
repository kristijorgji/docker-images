# docker-images

Public Docker images used by kristijorgji projects (PHP-FPM/nginx runtimes, builders, legacy WordPress).

## Table of contents

- [Images catalog](#images-catalog)
- [How to build and push to Docker Hub](#how-to-build-and-push-to-docker-hub)
- [Environment variables](#environment-variables)
- [Extension / PHP bump policy](#extension--php-bump-policy)
- [Local smoke test (php-fpm-8-nginx)](#local-smoke-test-php-fpm-8-nginx)
- [Changelog highlights](#changelog-highlights)

## Images catalog

| Folder | Docker Hub image | Runtime | Purpose |
|--------|------------------|---------|---------|
| [php-fpm-8-nginx](php-fpm-8-nginx/) | `kristijorgji/php-fpm-8-nginx` | PHP 8.5 / Alpine 3.24 (`0.0.8`) | PHP-FPM + nginx + supervisord for API/payments apps |
| [web-builder](web-builder/) | `kristijorgji/web-builder` | Node-oriented builder | Frontend/static build helper |
| [wordpress-php-7.1](wordpress-php-7.1/) | `kristijorgji/wordpress-php-7.1` | PHP 7.1 (legacy) | Legacy WordPress stack |

See [php-fpm-8-nginx/README.md](php-fpm-8-nginx/README.md) for FPM listen address (`127.0.0.1:9000`), port **8080**, extension list, and `/pre-entrypoint.sh`.

## How to build and push to Docker Hub

```shell
project=php-fpm-8-nginx
TAG=0.0.8 bash build-and-push-to-dhub.sh "$project"
```

`project` must be the name of one of the folders in this repository.

## Environment variables

| Variable | Required | Description |
|----------|----------|-------------|
| `TAG` | yes | Tag to push (e.g. `0.0.8`) |
| `DOCKER_TARGET_PLATFORM` | no | Defaults to `linux/amd64` |
| `DBUNAME` | no | Docker Hub username; defaults to `kristijorgji` |

## Extension / PHP bump policy

When bumping the PHP minor/major in `php-fpm-8-nginx`:

1. Keep the **full extension matrix** from the previous tag (bcmath, curl, gd, imagick, redis, pdo_mysql, soap, sockets, …).
2. Prefer Alpine community `phpXX` / `phpXX-pecl-*` packages over ad-hoc `pecl install`.
3. After build, confirm with `php -m` that every required module loads.
4. Update consumer `FROM` lines (`single_local`, `single_devops`) to the new tag only after the Hub push succeeds.

## Local smoke test (php-fpm-8-nginx)

```bash
docker build -t kristijorgji/php-fpm-8-nginx:0.0.8 ./php-fpm-8-nginx
docker run --rm --entrypoint php kristijorgji/php-fpm-8-nginx:0.0.8 -v
docker run --rm --entrypoint php kristijorgji/php-fpm-8-nginx:0.0.8 -m
docker run --rm --entrypoint php-fpm85 kristijorgji/php-fpm-8-nginx:0.0.8 -t
```

## Changelog highlights

### php-fpm-8-nginx `0.0.8`

- Alpine **3.18 → 3.24**
- PHP **8.2 → 8.5** (`php85` packages, `/etc/php85`, `php-fpm85`)
- Extension parity with `0.0.7` plus **`php85-pecl-imap`**
- Explicit `php85-sockets` and `php85-mysqlnd`
