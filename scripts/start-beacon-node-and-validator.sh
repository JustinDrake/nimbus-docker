#!/bin/bash

set +H

if [ "$IMPORT_LAUNCHPAD_KEYSTORES" != "" ]; then
  echo "${KEYSTORE_PWD}" | exec ~/nimbus-eth2/build/nimbus_beacon_node deposits import /var/lib/nimbus/validator_keys
fi

if [ "$ENABLE_METRICS" != "" ]; then
  METRICS_PARAMS="--metrics --metrics-address=0.0.0.0 --metrics-port=8008"
fi

if [ "$ENABLE_RPC" != "" ]; then
  RPC_PARAMS="--rpc --rpc-address=0.0.0.0 --rpc-port=9190"
fi

SUBSCRIBE_ALL_SUBNETS_PARAM="--subscribe-all-subnets"

if [ "$DISABLE_SUBSCRIBE_ALL_SUBNETS" != "" ]; then
  SUBSCRIBE_ALL_SUBNETS_PARAM=""
fi

if [ "$VOTING_ETH1_NODE_BACKUP" != "" ]; then
  VOTING_ETH1_NODE_BACKUP_PARAM="--web3-url=${VOTING_ETH1_NODE_BACKUP}"
fi

if [ "$GRAFFITI" != "" ]; then
  GRAFFITI_PARAM="--graffiti=${GRAFFITI}"
fi

if [ "$SUGGESTED_FEE_RECIPIENT" == "" ]; then
  echo "No fee recipient address set. Make sure to provide a valid address by setting SUGGESTED_FEE_RECIPIENT environment variable."
  exit 1
else
  FEE_RECIPIENT_PARAM=--suggested-fee-recipient=${SUGGESTED_FEE_RECIPIENT}
fi

if [ "$TRUSTED_NODE_SYNC_URL" != "" ]; then
  TRUSTED_NODE_SYNC_PARAMS="--trusted-node-url=${TRUSTED_NODE_SYNC_URL} --backfill=false"

  ~/nimbus-eth2/build/nimbus_beacon_node trustedNodeSync \
  --network=$NETWORK \
  --data-dir=/var/lib/nimbus \
  $TRUSTED_NODE_SYNC_PARAMS
fi

exec ~/nimbus-eth2/build/nimbus_beacon_node \
  --network=$NETWORK \
  --tcp-port=9000 \
  --udp-port=9000 \
  --web3-url=$VOTING_ETH1_NODE \
  $VOTING_ETH1_NODE_BACKUP_PARAM \
  --data-dir="/var/lib/nimbus" \
  --jwt-secret="/secrets/jwtsecret" \
  $FEE_RECIPIENT_PARAM \
  $METRICS_PARAMS \
  $RPC_PARAMS \
  $SUBSCRIBE_ALL_SUBNETS_PARAM \
  $GRAFFITI_PARAM
