#!/bin/bash

set -euo pipefail
# set -euxo pipefail

clear
source ./env.sh

lotus-miner run --api=9001 --nosync --enable-gpu-proving=false 2>&1 | tee -a ${DATA_PATH}/miner.log
