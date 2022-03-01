#!/bin/bash

# Show the IPs with more than 10 login attemps failed.

LIMIT='10'
LOG_FILE="${1}"

if [[ ! -e "$LOG_FILE" ]]
then
  echo "Cannot open ${LOG_FILE}" >&2
  exit 1
fi

# Create csv file to log the result
echo "Count,IP,Location" > result.csv

grep Failed syslog-sample | awk '{print $(NF - 3)}' | sort | uniq -c | sort -nr | while read COUNT IP
do
  if [[ "$COUNT" -gt "${LIMIT}" ]]
  then
    LOCATION=$(geoiplookup ${IP} | awk -F ', ' '{print $2}')
    echo "${COUNT} ${IP} ${LOCATION}" >> result.csv
  fi
done

cat result.csv

