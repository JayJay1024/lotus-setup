#!/bin/bash

set -euo pipefail
# set -euxo pipefail

ROOT_DIR=`pwd`
# sector size
# SECTOR_SIZE=2048
SECTOR_SIZE=536870912
# sector num
SECTOR_NUM=1
# data directory
DATA_DIR=${ROOT_DIR}/data_dir

clear
if [ -d ~/.genesis-sectors ];then
    rm -rfv ~/.genesis-sectors
fi
if [ -d ${DATA_DIR} ];then
    rm -rfv ${DATA_DIR}
fi

mkdir ${DATA_DIR}
source ./env.sh

lotus-seed pre-seal --sector-size ${SECTOR_SIZE} --num-sectors ${SECTOR_NUM} && \
lotus-seed genesis new ${DATA_DIR}/localnet.json && \
lotus-seed genesis add-miner ${DATA_DIR}/localnet.json ~/.genesis-sectors/pre-seal-t01000.json

# lotus daemon
lotus daemon --lotus-make-genesis=${DATA_DIR}/dev.gen --genesis-template=${DATA_DIR}/localnet.json --bootstrap=false > ${DATA_DIR}/lotus.log 2>&1 &
DAEMON_PID=$!

# wait for daemon
sleep 2
lotus wait-api

# init wallet
lotus wallet import ~/.genesis-sectors/pre-seal-t01000.key
lotus wallet set-default `lotus wallet list`  && \
lotus wallet balance

# init miner
lotus-storage-miner init --genesis-miner --actor=t01000 --sector-size=${SECTOR_SIZE} --pre-sealed-sectors=~/.genesis-sectors --pre-sealed-metadata=~/.genesis-sectors/pre-seal-t01000.json --nosync

# run miner
lotus-storage-miner run --nosync --enable-gpu-proving=false > ${DATA_DIR}/miner.log 2>&1 &
MINER_PID=$!

# print info
echo "Balance:"
lotus wallet balance
echo "Peers:"
lotus net peers
echo "Listening:"
lotus net listen
echo "Good job ~"

read
tail -fn 40 ${DATA_DIR}/miner.log

wait $MINER_PID
wait $DAEMON_PID
