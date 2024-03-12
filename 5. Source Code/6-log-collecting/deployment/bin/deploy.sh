#!/bin/bash

set -e

cd /usr/src

export $(cat .env)
docker stack deploy -c docker-compose.monitoring.yml monitoring
docker stack deploy -c docker-compose.prod.yml posts
