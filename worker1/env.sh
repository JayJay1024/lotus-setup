#!/bin/bash

ROOT_PATH=`pwd`
REPO_PATH=${ROOT_PATH}/repo
DATA_PATH=${ROOT_PATH}/data

export WORKER_PATH=${REPO_PATH}

cd ../miner/repo
REPO_PATH_MINER=`pwd`
cd ${ROOT_PATH}
export LOTUS_STORAGE_PATH=${REPO_PATH_MINER}
