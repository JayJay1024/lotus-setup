#!/bin/bash

set -euo pipefail
# set -euxo pipefail

ROOT_DIR=`pwd`
SECTOR_SIZE=2048
# SECTOR_SIZE=536870912
DATA_DIR=${ROOT_DIR}/data_dir

cd ../lotus-node1
NODE1_ROOT_DIR=`pwd`
NODE1_DATA_DIR=${NODE1_ROOT_DIR}/data_dir
cd ${ROOT_DIR}

clear
if [ -d ${DATA_DIR} ];then
    rm -rvf ${DATA_DIR}
fi

mkdir ${DATA_DIR}
source ./env.sh

# lotus daemon
lotus daemon --api=4321 --genesis=${NODE1_DATA_DIR}/dev.gen --bootstrap=false > ${DATA_DIR}/lotus.log 2>&1 &
DAEMON_PID=$!

# wait for daemon
sleep 2
lotus wait-api

# connect node1
NODE1_P2PS=`LOTUS_PATH=${NODE1_DATA_DIR}/repo-lotus lotus net listen`
NODE1_P2P_ARR=(`echo $NODE1_P2PS | tr '\n' ' '`)
lotus net connect ${NODE1_P2P_ARR[1]}

# send coin
WALLET=`lotus wallet new bls`
LOTUS_PATH=${NODE1_DATA_DIR}/repo-lotus lotus send ${WALLET} 200

# wait coin (2 minutes)
for ((i=1; i<24; i++))
do
    BALANCE=`lotus wallet balance`
    echo "Balance: ${BALANCE}"
    if [ $BALANCE != 0 ];then
        break
    else
        sleep 5
    fi
done

# init miner
lotus-storage-miner init --sector-size=${SECTOR_SIZE}

# run miner
lotus-storage-miner run --api=5433 --enable-gpu-proving=false > ${DATA_DIR}/miner.log 2>&1 &
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
