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
echo "$public_key" > "$pubdest"
chmod 600 $pubdest

# Create authorized key file
#authdest=/root/.ssh/authorized_keys
#touch "$authdest"
#if [ -f "$authdest" ]
#then
#    echo "$public_key" > "$authdest"
#fi
#echo "$public_key" > "$authdest"
#chmod 600 $authdest

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

# 2>&1 redirect git clone output to stdout
git clone -b $branch --single-branch $url ./tmp-gitclone 2>&1

docker build -t $tag -f ./tmp-gitclone/Dockerfile ./tmp-gitclone 2>&1

docker push $tag 2>&1

