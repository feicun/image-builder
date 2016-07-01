#!/bin/bash
set -e
set -x

DOCKER_BUILD=$@

array=(${DOCKER_BUILD// / })

echo $DOCKER_BUILD
echo ${array[3]}

service docker start
service docker status
$DOCKER_BUILD
docker push ${array[3]}
