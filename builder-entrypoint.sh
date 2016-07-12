#!/bin/bash
set -e
set -x

# DOCKER_BUILD=$@
# Split container command by ' ' to get tag
# array=(${DOCKER_BUILD// / })

# build_cmd=`echo $DOCKER_BUILD|awk -F "-chiwen-" '{print $1}'`
# public_key=`echo $DOCKER_BUILD|awk -F "-chiwen-" '{print $2}'`
# private_key=`echo $DOCKER_BUILD|awk -F "-chiwen-" '{print $3}'`
tag=$1
url=$2
public_key=$3
private_key=$4

# Create public key file
pubdest=/root/.ssh/id_rsa.pub
touch "$pubdest"
if [ -f "$pubdest" ]
then
    echo "$public_key" > "$pubdest"
fi
chmod 600 $pubdest

# Create private key file
privdest=/root/.ssh/id_rsa
touch "$privdest"
if [ -f "$privdest" ]
then
    echo "$private_key" > "$privdest"
fi
chmod 600 $privdest

# sleep 60

service docker start
service docker status
expect build-process.sh $tag $url
docker push $tag
