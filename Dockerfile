# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
# FROM phusion/baseimage:0.9.18

# Use phusion/baseimage-docker's init system.
# CMD ["/sbin/my_init"]

# Use official ubuntu as baseimage to reduce builder image's size
FROM ubuntu:trusty

# ...put your own build instructions here...
RUN apt-get update -y && \
apt-get install -y apt-transport-https ca-certificates software-properties-common curl git-core
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list && \
apt-get update -y && \
apt-get install -y docker docker-engine=1.11.0-0~trusty

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh /root/entrypoint.sh
COPY build-process.sh /root/build-process.sh
RUN chmod +x /root/entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]
