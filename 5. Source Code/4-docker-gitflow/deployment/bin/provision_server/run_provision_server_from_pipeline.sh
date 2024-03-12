#!/bin/bash

set -e

NAME=$1
DOCTL_TOKEN=$2
SSH_KEY_PRIVATE_LOCATION=$3
SIZE=${4:-s-2vcpu-2gb}

wget https://github.com/digitalocean/doctl/releases/download/v1.94.0/doctl-1.94.0-linux-amd64.tar.gz
tar xf ./doctl-1.94.0-linux-amd64.tar.gz
mv ./doctl /usr/local/bin

EXISTING_DROPLET=$(doctl compute droplet list --access-token $DOCTL_TOKEN | grep $NAME)

COUNT=${#EXISTING_DROPLET}

# Droplet already exists
if [ "$COUNT" -gt 0 ]; then
  echo "Droplet already exists"

  SERVER_IP=$(echo $EXISTING_DROPLET | awk '{ print $3 }')

  echo $SERVER_IP

  exit 0
fi

SSH_FINGERPRINT_DEPLOY=$(doctl compute ssh-key list --no-header --access-token $DOCTL_TOKEN | grep "devops-with-laravel-deploy" | awk '{ print $3 }')
SSH_FINGERPRINT_OWN=$(doctl compute ssh-key list --no-header --access-token $DOCTL_TOKEN | grep "MacBook Air" | awk '{ print $4 }')

OUTPUT=$(doctl compute droplet create --image docker-20-04 --size $SIZE --region nyc1 --ssh-keys $SSH_FINGERPRINT_DEPLOY --ssh-keys $SSH_FINGERPRINT_OWN --no-header --access-token $DOCTL_TOKEN $NAME)

DROPLET_ID=$(echo $OUTPUT | awk '{ print $1 }')

sleep 120

doctl projects resources assign cad78098-bfb8-4861-bfb2-e969cee18f16 --resource=do:droplet:$DROPLET_ID --access-token $DOCTL_TOKEN

SERVER_IP=$(doctl compute droplet get $DROPLET_ID --format PublicIPv4 --no-header --access-token $DOCTL_TOKEN)

scp -C -o StrictHostKeyChecking=no -i $SSH_KEY_PRIVATE_LOCATION/id_rsa ./provision_server.sh root@$SERVER_IP:./provision_server.sh
ssh -tt -o StrictHostKeyChecking=no -i $SSH_KEY_PRIVATE_LOCATION/id_rsa root@$SERVER_IP "chmod +x ./provision_server.sh && ./provision_server.sh"

echo $SERVER_IP
