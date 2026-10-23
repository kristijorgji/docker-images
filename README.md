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

| Folder                                  | Docker Hub image                 | Runtime                         | Purpose                                             |
|-----------------------------------------|----------------------------------|---------------------------------|-----------------------------------------------------|
| [php-fpm-8-nginx](php-fpm-8-nginx/)     | `kristijorgji/php-fpm-8-nginx`   | PHP 8.5.12 / Alpine 3.24 (`0.0.9`) | PHP-FPM + nginx + supervisord for API/payments apps |
| [web-builder](web-builder/)             | `kristijorgji/web-builder`       | PHP 8.5.12 + Alpine 3.24 Node (`0.0.3`) | PHP and JS build helper                       |
| [wordpress-php-7.1](wordpress-php-7.1/) | `kristijorgji/wordpress-php-7.1` | PHP 7.1.33-80 / Ubuntu 24.04 (`0.0.1`) | Legacy WordPress stack                     |

See [php-fpm-8-nginx/README.md](php-fpm-8-nginx/README.md) for FPM listen address (`127.0.0.1:9000`), port **8080**, extension list, and `/pre-entrypoint.sh`.

## How to build and push to Docker Hub

Publish **only** via this script (multi-arch `buildx --push`). Never `docker build` + `docker push` from a Mac 
— that overwrites the Hub tag with a single **arm64** manifest and breaks amd64 production.

One-time builder setup on Apple Silicon:

```shell
docker buildx create --name multiarch --use 2>/dev/null || docker buildx use multiarch
docker run --privileged --rm tonistiigi/binfmt --install all
```

```shell
project=php-fpm-8-nginx
TAG=0.0.9 bash build-and-push-to-dhub.sh "$project"
```

`project` must be the name of one of the folders in this repository.

After push, confirm a **manifest list** with both platforms:

```shell
docker buildx imagetools inspect kristijorgji/php-fpm-8-nginx:0.0.9
# expect linux/amd64 and linux/arm64

docker pull --platform linux/amd64 kristijorgji/php-fpm-8-nginx:0.0.9
cid=$(docker create --platform linux/amd64 --entrypoint /bin/true kristijorgji/php-fpm-8-nginx:0.0.9)
docker cp "$cid:/bin/busybox" /tmp/bb-amd64 && docker rm -f "$cid"
file /tmp/bb-amd64
# expect x86-64, not aarch64
```

## Environment variables

| Variable                 | Required | Description                                             |
|--------------------------|----------|---------------------------------------------------------|
| `TAG`                    | yes      | Tag to push (e.g. `0.0.9`)                              |
| `DOCKER_TARGET_PLATFORM` | no       | Defaults to `linux/amd64,linux/arm64` (comma-separated) |
| `DBUNAME`                | no       | Docker Hub username; defaults to `kristijorgji`         |

## Extension / PHP bump policy

When bumping the PHP minor/major in `php-fpm-8-nginx`:

1. Keep the **full extension matrix** from the previous tag (bcmath, curl, gd, imagick, redis, pdo_mysql, soap, sockets, …).
2. Prefer Alpine community `phpXX` / `phpXX-pecl-*` packages over ad-hoc `pecl install`.
3. After build, confirm with `php -m` that every required module loads.
4. Publish the new tag with the multi-arch script **before** updating consumers.

## Local smoke test (php-fpm-8-nginx)

Local `docker build` is for smoke only on your machine. **Do not push** that image to Hub.

```bash
docker build -t kristijorgji/php-fpm-8-nginx:0.0.9-local ./php-fpm-8-nginx
docker run --rm --entrypoint php kristijorgji/php-fpm-8-nginx:0.0.9-local -v
docker run --rm --entrypoint php kristijorgji/php-fpm-8-nginx:0.0.9-local -m
docker run --rm --entrypoint php-fpm85 kristijorgji/php-fpm-8-nginx:0.0.9-local -t
```

## Changelog highlights

### wordpress-php-7.1 `0.0.1`

- Ubuntu **18.04 → 24.04** so the image can install Ondrej's PHP 7.1 security rebuild
- PHP **7.1.33-80** (`7.1.33-80+ubuntu24.04.1+deb.sury.org+1`), the 2026-10-21 rebuild for CVE-2026-109618 and CVE-2026-109619
- Supervisor comes from Ubuntu instead of `pip`
- `php7.1-dom` is provided by `php7.1-xml`. Noble has no `php7.1-imagick` package, so Imagick is not in this tag

### web-builder `0.0.3`

- Base image **`php-fpm-8-nginx:0.02` → `0.0.9`** (PHP 8.5.12)
- Node **8.14 / Alpine 3.8 → Alpine 3.24** `nodejs`, `npm`, and `yarn`

### php-fpm-8-nginx `0.0.9`

- PHP **8.5.9 → 8.5.12** (`php85=8.5.12-r0` and matching core modules)
- Fixes CVE-2026-109618 and CVE-2026-109619
- Same Alpine 3.24 extension matrix as `0.0.8`
- Must be published as **multi-arch** (`linux/amd64` + `linux/arm64`)

### php-fpm-8-nginx `0.0.8`

- Alpine **3.18 → 3.24**
- PHP **8.2 → 8.5** (`php85` packages, `/etc/php85`, `php-fpm85`)
- Extension parity with `0.0.7` plus **`php85-pecl-imap`**
- Explicit `php85-sockets` and `php85-mysqlnd`
- Must be published as **multi-arch** (`linux/amd64` + `linux/arm64`)
