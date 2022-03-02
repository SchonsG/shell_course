#!/bin/bash

usage() {
  echo "Usage: ${0} [-nsv] [-f FILE] COMMAND" >&2
  echo 'Executes COMMAND as a single command on every server.' >&2
  echo '  -f FILE  Use FILE for the list of servers. Default: /vagrant/servers' >&2
  echo '  -n       Dry run mode. Display the COMMAND that would have been executed and exit.' >&2
  echo '  -s       Execute the COMMAND using sudo on the remote server.' >&2
  echo '  -v       Verbose mode. Displays the server name before executing COMMAND.' >&2
  exit 1
}

log() {
  local MESSAGE="${@}"
  
  if [[ "${VERBOSE}" = 'true' ]]
  then
    echo "${MESSAGE}"
  fi
}

SERVER_FILE='/vagrant/servers'

# Check if was executed as root.
if [[ "${UID}" -eq '0' ]]
then
  echo 'Do not execute this script as roots. Use the -s option instead.'
  usage
fi

# Check for the options used.
while getopts f:nsv OPTION
do
  case ${OPTION} in
    f) SERVER_FILE="${OPTARG}" ;;
    n) DRY_RUN='true' ;;
    s) SUDO_RUN='true' ;;
    v) VERBOSE='true' ;;
    ?) usage ;; 
  esac
done

# Remove the options while leaving the ramaining arguments.
shift "$(( OPTIND - 1 ))"

if [[ "${#}" -lt 1 ]]
then
  usage
fi

# Anything that remains on the command line is to be treated as a single command.
COMMAND="${@}"

if [[ ! -e ${SERVER_FILE} ]]
then
  echo "Cannot open ${SERVER_FILE}." >&2
  exit 1
fi

for SERVER in $(cat ${SERVER_FILE})
do
  echo ${SERVER}
done

