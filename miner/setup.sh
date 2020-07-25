#!/bin/bash

set -euo pipefail
# set -euxo pipefail

clear
source ./env.sh

if [ -d ${REPO_PATH} ];then
    rm -rf ${REPO_PATH}
fi
if [ -d ${DATA_PATH} ];then
    rm -rf ${DATA_PATH}
fi
mkdir ${DATA_PATH}

lotus-miner init --genesis-miner --actor=t01000 --sector-size=${SECTOR_SIZE} --pre-sealed-sectors=~/.genesis-sectors --pre-sealed-metadata=~/.genesis-sectors/pre-seal-t01000.json --nosync
lotus-miner run --api=9001 --nosync --enable-gpu-proving=false 2>&1 | tee ${DATA_PATH}/miner.log
