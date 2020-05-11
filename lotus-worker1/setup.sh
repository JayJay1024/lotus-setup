#!/bin/bash

set -euo pipefail
# set -euxo pipefail

ROOT_DIR=`pwd`
# data directory
DATA_DIR=${ROOT_DIR}/data_dir

# connect miner
cd ../lotus-node1/data_dir/repo-miner
MINER_REPO_PATH=`pwd`
cd ${ROOT_DIR}

clear
if [ -d ${DATA_DIR} ];then
    rm -rvf ${DATA_DIR}
fi
mkdir ${DATA_DIR}

export WORKER_PATH=${DATA_DIR}/repo-worker
export LOTUS_STORAGE_PATH=${MINER_REPO_PATH}

lotus-seal-worker run --address=127.0.0.1:7531 --precommit1=true --precommit2=true --commit=true
