#!/bin/bash

# This script demonstrates the case statement.
#if [[ "${1}" = 'start' ]]
#  then
#    echo 'Starting.'
#elif [[ "${1}" = 'stop' ]]
#  then
#    echo 'Stoping.'
#elif [[ "${1}" = 'status' ]]
#  then
#    echo 'Status:'
#else
#  echo 'Supply a valid option.' >&2
#  exit 1
#fi

#case "${1}" in
#  start)
#    echo 'Starting.'
#    ;;
#  stop)
#    echo 'Stoping.'
#    ;;
#  status|state|--status|--state)
#    echo 'Status.'
#    ;;
#  *)
#    echo 'Supply a valid option.' >&2
#    exit 1
#    ;;
#esac

case "${1}" in
  start) echo 'Starting.';;
  stop) echo 'Stoping.' ;;
  status) echo 'Status.' ;;
  *)
    echo 'Supply a valid option.' >&2
    exit 1
    ;;
esac

