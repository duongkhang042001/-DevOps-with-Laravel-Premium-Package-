#!/bin/bash

set -e

SSH_KEY=$1
DOCKERHUB_USERNAME=$2
DOCKERHUB_TOKEN=$3
SWARM_TOKEN=$4
SWARM_MANAGER_IP_PORT=$5

useradd -G www-data,root,sudo,docker -u 1000 -d /home/martin martin
mkdir -p /home/martin/.ssh
touch /home/martin/.ssh/authorized_keys
chown -R martin:martin /home/martin
chown -R martin:martin /usr/src
chmod 700 /home/martin/.ssh
chmod 644 /home/martin/.ssh/authorized_keys

if [ -n "$SSH_KEY" ]; then
  echo "$SSH_KEY" >> /home/martin/.ssh/authorized_keys
fi

echo "martin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/martin

docker login -u "$DOCKERHUB_USERNAME" -p "$DOCKERHUB_TOKEN"

ufw allow 2377 && ufw allow 7946 && ufw allow 4789

docker swarm join --token "$SWARM_TOKEN" "$SWARM_MANAGER_IP_PORT"
