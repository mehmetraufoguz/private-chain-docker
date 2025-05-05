#!/bin/bash

# Check if data directory exists; if not, initialize it
if [ ! -d "/data/geth" ]; then
    echo "Initializing Geth data directory..."
    geth --datadir /data init /data/genesis.json
fi

# Start the Geth fullnode
geth \
    --datadir /data \
    --syncmode=$SYNCMODE \
    --cache=$CACHE \
    --networkid=$NETWORK_ID \
    --bootnodes=$ENODE \
    --port=$PEER_PORT \
    --snapshot=$SNAPSHOT \
    --ethstats=$ETH_STAT_MACHINE_ID@$ETH_STAT_MACHINE_IP \
    --http \
    --http.addr="0.0.0.0" \
    --http.port=8545 \
    --http.corsdomain="*" \
    --http.vhosts="*" \
    --http.api=$HTTP_API \
    --ipcdisable \
    --authrpc.port=$AUTH_PORT \
    --gcmode=$GC_MODE
