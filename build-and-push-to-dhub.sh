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

dhuname=kristijorgji
pname=$1
cd $1

set -e

docker logout
docker login docker.io

rim="${dhuname}/${pname}:${TAG}"

echo -e "docker build . -t ${dhuname}/${pname}"
docker build . -t "${dhuname}/${pname}"

echo -e "docker tag ${dhuname}/${pname}:latest $rim"
docker tag "${dhuname}/${pname}:latest" "$rim"

echo -e "docker push $rim"
docker push "$rim"

read -p "Do you want to delete local image now (y/n)? " -n 1 -r
if [[ $REPLY =~ ^[Nn]$ ]]
then
    docker rmi "$rim";
fi

cd -
