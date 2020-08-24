#!/bin/bash

set -euo pipefail
# set -euxo pipefail

clear
source ./env.sh


lotus-worker run --listen=127.0.0.1:6001 --addpiece=true --precommit1=false --precommit2=true --commit=false 2>&1 | tee -a ${DATA_PATH}/worker.log
