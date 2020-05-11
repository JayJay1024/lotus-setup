#!/bin/bash

set -euo pipefail

source ./env.sh

# lotus daemon
lotus daemon --bootstrap=false >> ${DATA_DIR}/lotus.log 2>&1 &
DAEMON_PID=$!

# wait for daemon
sleep 2
lotus wait-api

# run miner
lotus-storage-miner run --nosync --enable-gpu-proving=false >> ${DATA_DIR}/miner.log 2>&1 &
MINER_PID=$!

tail -fn 40 ${DATA_DIR}/miner.log

wait $MINER_PID
wait $DAEMON_PID
