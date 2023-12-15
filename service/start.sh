#!/bin/bash

addr=$(hostname -I | awk '{print $1}')
addr6=$(ip -6 addr show scope global | grep inet6 | awk '{print $2}' | cut -d "/" -f 1)

readonly regex="^(4|6|all),[0-9]+,[a-zA-Z0-9.-]+,[0-9]+$"

grep -E "${regex}" < /etc/6tunnel/config | while IFS= read -r config
do
  args=(${config//,/ })
  LOCAL_PORT=${args[1]}
  TARGET_HOST=${args[2]}
  TARGET_PORT=${args[3]}

  if [ "${args[0]}" == "4" ]; then
    6tunnel -l "${addr}" -4 "${LOCAL_PORT}" "${TARGET_HOST}" "${TARGET_PORT}"
  elif [ "${args[0]}" == "6" ]; then
    6tunnel -l "${addr6}" -6 "${LOCAL_PORT}" "${TARGET_HOST}" "${TARGET_PORT}"
  elif [ "${args[0]}" == "all" ]; then
    6tunnel -l "${addr}" -4 "${LOCAL_PORT}" "${TARGET_HOST}" "${TARGET_PORT}"
    6tunnel -l "${addr6}" -6 "${LOCAL_PORT}" "${TARGET_HOST}" "${TARGET_PORT}"
  fi
done