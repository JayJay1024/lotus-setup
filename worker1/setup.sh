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


lotus-worker run --listen=127.0.0.1:6001 --addpiece=true --precommit1=false --precommit2=true --commit=false 2>&1 | tee ${DATA_PATH}/worker.log
