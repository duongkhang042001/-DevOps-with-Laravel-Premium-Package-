#!/bin/bash

set -ex

NAME=$1
DOCKERHUB_USERNAME=$2
DOCKERHUB_TOKEN=$3
SWARM_WORKER_TOKEN=$4
SWARM_MANAGER_IP_PORT=$5
SIZE=${6:-s-2vcpu-2gb}

SSH_FINGERPRINT_DEPLOY=$(doctl compute ssh-key list --no-header | grep "devops-with-laravel-deploy" | awk '{ print $3 }')
SSH_FINGERPRINT_OWN=$(doctl compute ssh-key list --no-header | grep "MacBook Air" | awk '{ print $4 }')

PUBLIC_KEY=$(cat $HOME/.ssh/id_rsa.pub)

OUTPUT=$(doctl compute droplet create --image docker-20-04 --size s-1vcpu-1gb --region nyc1 --ssh-keys $SSH_FINGERPRINT_DEPLOY --ssh-keys $SSH_FINGERPRINT_OWN --no-header $NAME)

DROPLET_ID=$(echo $OUTPUT | awk '{ print $1 }')

sleep 120

doctl projects resources assign 65ae6dcd-91c1-4334-b393-0fc76e45d05f --resource=do:droplet:$DROPLET_ID

sleep 10

SERVER_IP=$(doctl compute droplet get $DROPLET_ID --format PublicIPv4 --no-header)

scp -C -o StrictHostKeyChecking=no -i $HOME/.ssh/id_ed25519 ./provision_node.sh root@$SERVER_IP:./provision_node.sh
ssh -tt -o StrictHostKeyChecking=no -i $HOME/.ssh/id_ed25519 root@$SERVER_IP "chmod +x ./provision_node.sh && ./provision_node.sh \"$PUBLIC_KEY\"" "$DOCKERHUB_USERNAME" "$DOCKERHUB_TOKEN" "$SWARM_WORKER_TOKEN" "$SWARM_MANAGER_IP_PORT"
