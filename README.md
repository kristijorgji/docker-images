# docker-images

A collection of public docker images

# How to build and push to dockerhub

To build and publish a new one, can use the command
```shell
project=wordpress-php-7.1
TAG=0.0.0 bash build-and-push-to-dhub.sh "$project"
```

project needs to be the name of one of the folders here

Supported enviornmental variables for the script above

| Variable                 | required     | Description                                  |
|--------------------------|--------------|----------------------------------------------|
| `Tag`                    | yes          | tag to use for the docker image              |
| `DOCKER_TARGET_PLATFORM` | no           | defaults to linux/amd64                      |
| `DBUNAME`                | no           | Dockerhub username defaults, to kristijorgji | 
