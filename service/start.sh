#!/bin/bash

addr=$(ip -6 addr show scope global | grep inet6 | awk '{print $2}' | cut -d "/" -f 1)

readonly regex="^(4|6|all),[0-9]+,[a-zA-Z0-9.-]+,[0-9]+$"

grep -E "${regex}" < /etc/6tunnel/config | while IFS= read -r config
do
  args=(${config//,/ })
  LOCAL_PORT_OPT=""
  if [ "${args[0]}" == "4" ]; then
    LOCAL_PORT_OPT="-4"
  elif [ "${args[0]}" == "6" ]; then
    LOCAL_PORT_OPT="-6"
  fi
  LOCAL_PORT=args[1]
  TARGET_HOST=args[2]
  TARGET_PORT=args[3]
  6tunnel -l "${addr}" "${LOCAL_PORT_OPT}" "${LOCAL_PORT}" "${TARGET_HOST}" "${TARGET_PORT}"
done