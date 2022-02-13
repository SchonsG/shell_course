#!/bin/bash

# This script demonstrates I/O redirection.

# Redirect STDOUT to a file.
FILE='/tmp/data'
head -n1 /etc/passwd > ${FILE}

# Redirect SDTIN to a program.
read LINE < ${FILE}
echo "LINE contains: ${LINE}"

