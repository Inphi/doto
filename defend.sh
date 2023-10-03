#!/usr/bin/env bash

set -euo pipefail

source .env

RPC_URL=$OP_CHALLENGER_L1_ETH_RPC
GAME_FACTORY_ADDRESS=0xad9e5E6b39F55EE7220A3dC21a640B089196a89f

COUNT=$(cast call --rpc-url $RPC_URL $GAME_FACTORY_ADDRESS 'gameCount() returns(uint256)')
((COUNT=COUNT-1))
GAME_INDICES=()
for i in $(seq 0 "${COUNT}")
do
  GAME=$(cast call --rpc-url "${RPC_URL}" "${GAME_FACTORY_ADDRESS}" 'gameAtIndex(uint256) returns(uint8, uint64, address)' "${i}")

  SAVEIFS=$IFS   # Save current IFS (Internal Field Separator)
  IFS=$'\n'      # Change IFS to newline char
  GAME=($GAME) # split the string into an array by the same name
  IFS=$SAVEIFS   # Restore original IFS

  GAME_ADDR="${GAME[2]}"
  CLAIMS=$(cast call --rpc-url "${RPC_URL}" "${GAME_ADDR}" "claimDataLen() returns(uint256)")
  STATUS=$(cast call --rpc-url "${RPC_URL}" "${GAME_ADDR}" "status() return(uint8)" | cast to-dec)
  if [[ "${STATUS}" == "0" ]]
  then
      echo "Found in-progress game at ${i} index"
      GAME_INDICES+=("${i}")
  fi
done

COUNT_INPROGRESS=${#GAME_INDICES[@]}
if [ "$COUNT_INPROGRESS" -eq 0 ]; then
    echo "There are no games in-progress. Exiting"
    exit 0
fi

INDEX=$((RANDOM % COUNT_INPROGRESS))
GAME_INDEX=${GAME_INDICES[$INDEX]}
GAME_ADDR=$(cast call --rpc-url "${RPC_URL}" "${GAME_FACTORY_ADDRESS}" 'gameAtIndex(uint256) returns(uint8, uint64, address)' "${GAME_INDEX}" | awk 'NR==3')

export OP_CHALLENGER_GAME_ALLOWLIST="${GAME_ADDR}"
echo "Starting op-challenger for ${OP_CHALLENGER_GAME_ALLOWLIST}"
docker compose up op-challenger-whitelisted
