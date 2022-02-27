#!/bin/bash

ARCHIVE_DIR='/archive'

usage() {
  echo "Usage: {0} [OPTION...] USER [USER...]" >&2
  echo 'Disable a local user.' >&2
  echo '  -d  Deletes accounts instead of disabling them.' >&2
  echo '  -r  Removes the home directory associated with the account(s)' >&2
  echo '  -a  Creates an archive of the home directory with the account(s)' >&2
  exit 1
}

# Check if the last command was succefully
check_last_command() {
  local MESSAGE="${@}"

  if [[ "${?}" -ne '0' ]]
  then
    echo "${MESSAGE}" >&2
    exit 1
  fi
}

# Check if is root user
if [[ "${UID}" -ne 0 ]]
  then
    echo 'Plase run wih sudo or as root.' >&2
    exit 1
fi

# Parse the options.
while getopts dra OPTION
do
  case ${OPTION} in
    d) DELETE_USER='true' ;;
    r) REMOVE_OPTION='-r' ;;
    a) ARCHIVE='true' ;;
    ?) usage ;;
  esac
done

shift "$(( OPTIND - 1 ))"

# Chech if no parameters were passed
if [[ "${#}" -lt 1 ]]
then
  usage
fi

for USERNAME in "${@}"
do
  echo "Processing user: ${USERNAME}"

  USERID=$(id -u ${USERNAME})
  if [[ ${USERID} -lt 1000 ]]
  then
    echo 'Systems accounts should be modified by system administrators.' >&2
    exit 1
  fi

  if [[ "${ARCHIVE}" = 'true' ]]
  then
    if [[ ! -d "$ARCHIVE_DIR" ]]
    then
      echo "Creating ${ARCHIVE_DIR} directory"
      mkdir -p ${ARCHIVE_DIR}
      check_last_command "The archive directory ${ARCHIVE_DIR} could not be created." >&2
    fi

    echo "Archiving /home/${USERNAME} to ${ARCHIVE_DIR}/${USERNAME}"
    tar -zcf ${ARCHIVE_DIR}/${USERNAME}.tgz /home/${USERNAME} &> /dev/null
    check_last_command "The archive directory ${ARCHIVE_DIR} could not be created."
  fi

  if [[ "$DELETE_USER" = 'true' ]]
  then
    userdel ${REMOVE_OPTION} ${USERNAME}
    check_last_command 'An error ocurred. Please, report to administrators'
    echo "The account ${USERNAME} was deleted"
  else
    sudo chage -E 0 ${USERNAME}
    check_last_command 'An error ocurred. Please, report to administrators'
    echo "The account ${USERNAME} was disabled"
  fi

  exit 0
done

