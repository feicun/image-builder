#!/bin/bash
set -e
set -x

REGISTRY_HOST=$4
DOCKER_BUILD=$@

echo $REGISTRY_HOST
echo $DOCKER_BUILD

service docker start
service docker status
$DOCKER_BUILD
docker push $REGISTRY_HOST
