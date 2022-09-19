#! /bin/bash
# Start and/or update existing services.

set -e
set -a

source .env

services="nimbus besu"

if [ "$ENABLE_MEVBOOST" != "" ]; then
    NIMBUS_MEVBOOST_FLAGS="--payload-builder --payload-builder-url=http://mevboost:18550"
    services="nimbus besu mevboost"
fi

if [ "$ENABLE_MONITORING" != "" ]; then
    services=""
fi


docker-compose pull
docker-compose up --remove-orphans -d ${services}