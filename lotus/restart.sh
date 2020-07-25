#!/bin/bash

set -euo pipefail
# set -euxo pipefail

clear
source ./env.sh

lotus daemon --api=7001 --bootstrap=false 2>&1 | tee -a ${DATA_PATH}/lotus.log
