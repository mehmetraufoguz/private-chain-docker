#!/bin/bash

# Check if data directory exists; if not, initialize it
if [ ! -d "/data/geth" ]; then
    echo "Initializing Geth data directory..."
    geth --datadir /data init /data/genesis.json
    cp -r /data/keystore /data/geth/keystore
fi

# Start the Geth miner
geth \
    --datadir /data \
    --syncmode=$SYNCMODE \
    --cache=$CACHE \
    --networkid=$NETWORK_ID \
    --bootnodes=$ENODE \
    --port=$PEER_PORT \
    --allow-insecure-unlock \
    --unlock=$ADDRESS \
    --password=/data/node.pwd \
    --mine \
    --miner.etherbase=$ADDRESS \
    --miner.gaslimit=$MINER_GASLIMIT \
    --snapshot=$SNAPSHOT \
    --authrpc.port=$AUTH_PORT \
    --http \
    --http.addr="0.0.0.0" \
    --http.port=8545 \
    --http.corsdomain="*" \
    --http.vhosts="*" \
    --http.api=$HTTP_API \
    --ipcdisable \
    --gcmode=$GC_MODE
