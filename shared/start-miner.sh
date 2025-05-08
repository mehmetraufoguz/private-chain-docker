#!/bin/bash

# Check if data directory exists; if not, initialize it
if [ ! -d "/abc/data/geth" ]; then
    echo "Initializing Geth data directory..."
    /abc/geth --datadir /abc/data init /abc/genesis.json
    cp -r /abc/data/keystore /abc/data/geth/keystore
fi

# Start the Geth miner
/abc/geth \
    --datadir /abc/data \
    --syncmode=$SYNCMODE \
    --cache=$CACHE \
    --networkid=$NETWORK_ID \
    --bootnodes=$ENODE \
    --port=$PEER_PORT \
    --allow-insecure-unlock \
    --unlock=$ADDRESS \
    --password=/abc/data/keystore/node.pwd \
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
