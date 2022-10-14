#! /bin/bash
# Start and/or update existing services.

set -e
set -a

source .env

services="nimbus geth"

if [ "$ENABLE_MEVBOOST" != "" ]; then
    NIMBUS_MEVBOOST_FLAGS="--payload-builder --payload-builder-url=http://mevboost:18550"
    services="nimbus geth mevboost"
fi

if [ "$#" -eq 1 ]; then
    services=$@
fi

docker-compose pull
docker-compose stop $services && yes | docker-compose rm -v $services
docker-compose up --remove-orphans -d ${services}
