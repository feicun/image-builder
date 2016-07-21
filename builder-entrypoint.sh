#!/bin/bash
set -e
set -x

tag=$1
url=$2
branch=$3
public_key=$4
private_key=$5

mkdir /root/.ssh

# Create public key file
pubdest=/root/.ssh/id_rsa.pub
touch "$pubdest"
if [ -f "$pubdest" ]
then
    echo "$public_key" > "$pubdest"
fi
chmod 600 $pubdest

# Create authorized key file
authdest=/root/.ssh/authorized_keys
touch "$authdest"
if [ -f "$authdest" ]
then
    echo "$public_key" > "$authdest"
fi
chmod 600 $authdest

# Create private key file
privdest=/root/.ssh/id_rsa
touch "$privdest"
if [ -f "$privdest" ]
then
    echo "$private_key" > "$privdest"
fi
chmod 600 $privdest

# Add ssh key to ssh-agent
eval "$(ssh-agent -s)"
ssh-add /root/.ssh/id_rsa

# Use expect to run docker build and docker push
expect /root/build-process.sh $tag $url $branch
