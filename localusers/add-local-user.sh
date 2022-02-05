#!/bin/bash

# Script that adds users to local Linux system.

# Check if it being executed with superuser.
if [[ "${UID}" -ne '0' ]]
then
  echo 'For run this script, is necessary execute with root privileges'
  exit 1
fi

# Ask for the username who will be used for the account.
read -p 'Username: ' USER_NAME

# Ask for the full name person account.
read -p 'Full name: ' COMMENT

# Ask for the password for the account.
read -p 'Password: ' PASSWORD

# Creates a new user on the local system.
adduser -c "${COMMENT}" -m ${USER_NAME}

# Verify if the user was created succefully.
if [[ "${?}" -ne 0 ]]
then
  echo 'The adduser command did not execute succesfully.'
  exit 1
fi

# Set the password for the user
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# Force password change on first login.
passwd -e ${USER_NAME}

# Display informations about the user created. 
echo '---- USER CREATED ----'
echo -e "User name: ${USER_NAME}\nPassword: ${PASSWORD}\nHostname: $(hostname)"

