#!/usr/bin/env bash
#
# Build and push a multi-arch image to Docker Hub via buildx --push.
# Do NOT use plain `docker build` + `docker push` on Apple Silicon — that
# publishes a single-arch arm64 tag and breaks linux/amd64 production hosts.
#
# One-time Mac setup (qemu for cross-arch):
#   docker buildx create --name multiarch --use 2>/dev/null || docker buildx use multiarch
#   docker run --privileged --rm tonistiigi/binfmt --install all
#
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "Please specify the project as relative path to this root. Ex: php-fpm-8-nginx"
  exit 1
fi

if [[ -z "${TAG:-}" ]]; then
  echo "Missing required environment variable TAG"
  exit 1
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Comma-separated platforms for a multi-arch manifest list
docker_target_platform=${DOCKER_TARGET_PLATFORM:-linux/amd64,linux/arm64}
dhuname=${DBUNAME:-kristijorgji}
pname=$1

cd "${repo_root}/${pname}"

docker logout
docker login docker.io

im="${dhuname}/${pname}"
rim="${im}:${TAG}"

echo "will build and push ${rim} for platform(s) ${docker_target_platform}"
docker buildx build . \
  --platform "${docker_target_platform}" \
  -t "${rim}" \
  --push

echo "verify with: docker buildx imagetools inspect ${rim}"
docker buildx imagetools inspect "${rim}"

cd "${repo_root}"
