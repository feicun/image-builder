#!/bin/bash
set -e

tag=$1
url=$2
branch=$3
public_key=$4
private_key=$5

mkdir /root/.ssh

# Create public key file
pubdest=/root/.ssh/id_rsa.pub
touch "$pubdest"
echo "$public_key" > "$pubdest"
chmod 600 $pubdest

# Create private key file
privdest=/root/.ssh/id_rsa
touch "$privdest"
echo "$private_key" > "$privdest"
chmod 600 $privdest

# Add ssh key to ssh-agent
eval "$(ssh-agent -s)"
ssh-add /root/.ssh/id_rsa

sshconfig=/root/.ssh/config
host='Host *'
hostconfig='StrictHostKeyChecking no'
echo "$host" > "$sshconfig"
echo "$hostconfig" > "$sshconfig"

mkdir tmp-gitclone

set -x

git clone -b $branch --single-branch $url ./tmp-gitclone

docker build -t $tag -f ./tmp-gitclone/Dockerfile ./tmp-gitclone

docker push $tag
