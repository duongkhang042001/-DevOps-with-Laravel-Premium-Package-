#!/bin/bash

set -e

cd /usr/src

export $(cat .env)
docker stack deploy -c docker-compose.prod.yml posts
#rm .env
