#!/bin/bash

set -euo pipefail
# set -euxo pipefail

clear
source ./env.sh


lotus-worker run --address=127.0.0.1:6002 --precommit1=true --precommit2=true --commit=true 2>&1 | tee -a ${DATA_PATH}/worker.log
