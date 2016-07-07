#!/bin/bash
set -e
set -x

DOCKER_BUILD=$@
# Split container command by ' ' to get tag
array=(${DOCKER_BUILD// / })
# Split container command by 'sihua'
# to get public key
# array2=(${DOCKER_BUILD//@#@#@#@/ })

build_cmd=`echo $DOCKER_BUILD|awk -F "-chiwen-" '{print $1}'`
public_key=`echo $DOCKER_BUILD|awk -F "-chiwen-" '{print $2}'`
private_key=`echo $DOCKER_BUILD|awk -F "-chiwen-" '{print $3}'`
# echo $DOCKER_BUILD

# Image tag
# echo ${array[3]}

# Public key
# echo ${array2[1]}

# Create public key file
pubdest=/root/.ssh/id_rsa.pub
touch "$pubdest"
if [ -f "$pubdest" ]
then
    echo "$public_key" > "$pubdest"
fi
chmod 400 $pubdest

# Create private key file
privdest=/root/.ssh/id_rsa
touch "$privdest"
if [ -f "$privdest" ]
then
    echo "$private_key" > "$privdest"
fi
chmod 400 $privdest

service docker start
service docker status
$build_cmd
# ${array2[0]}
# # $DOCKER_BUILD
docker push ${array[3]}
