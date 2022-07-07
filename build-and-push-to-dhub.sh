#!/usr/bin/env bash

if [[ $# -eq 0 ]]
  then
    echo "Please specify the project as relative path to this root. Ex: web-builder"
    exit 1;
fi

if [ -z "$TAG" ]; then
  echo "Missing required environment variable TAG";
  exit 1;
fi

docker_target_platform=${DOCKER_TARGET_PLATFORM:-linux/amd64}
dhuname=${DBUNAME:-kristijorgji}
pname=$1

cd "$1"

set -e

docker logout
docker login docker.io

im="${dhuname}/${pname}"
rim="${im}:${TAG}"

echo -e "will build docker image $im for target platform ${docker_target_platform}"
docker buildx build . \
  --platform "${docker_target_platform}" --output type=docker \
  -t "$im"

echo -e "docker tag $im:latest $rim"
docker tag "$im:latest" "$rim"

echo -e "docker push $rim"
docker push "$rim"

read -p "Do you want to delete local image now (y/n)? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo -e "docker rmi $rim"
    docker rmi "$rim";
fi

cd -
