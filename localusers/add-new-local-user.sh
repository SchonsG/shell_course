#!/bin/bash

# Script that adds users to local Linux system.

APPNAME=$(basename ${0})

# Check if it being executed with superuser.
if [[ "${UID}" -ne '0' ]]
then
  echo 'For run this script, is necessary execute with root privileges'
  exit 1
fi

# Check if the arguments were passed.
if [[ "${#}" -eq 0 ]]
then
  echo
  echo "Usage: ${APPNAME} USER_NAME [COMMENT]..."
  echo 'Create an account in your local system with the name of USER_NAME and a comments field of COMMENT.'
  exit 1
fi

# First argument is the user name.
USER_NAME="${1}"

# The second on are the comment.
shift
COMMENT="${@}"

# Creates a new user on the local system.
adduser -c "${COMMENT}" -m ${USER_NAME}

# Verify if the user was created succefully.
if [[ "${?}" -ne 0 ]]
then
  echo 'The adduser command did not execute succesfully.'
  exit 1
fi

# Create a random password
PASSWORD=$(date +%s%N | sha256sum | head -c10)

# Set the password for the user
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# Check to see if passwd command succeeded
if [[ "${?}" -ne 0 ]]
then
  echo 'The password for the account could not be set.'
  exit 1
fi

# Force password change on first login.
passwd -e ${USER_NAME}

# Display informations about the user created. 
echo '---- USER CREATED ----'
echo -e "User name: ${USER_NAME}\nPassword: ${PASSWORD}\nHostname: ${HOSTNAME}"

