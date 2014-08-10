#!/bin/bash

threadName="";

while getopts "a:d:t:n:m:" optionName; do
case "$optionName" in
a) apiKey=( "$OPTARG" );;
d) deviceIds=( "$OPTARG" );;
n) threadName=( "$OPTARG" );;
t) title=( "$OPTARG" );;
m) message=( "$OPTARG" );;
esac
done


rawurlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  ENCODED="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

rawurlencode "$title $message";

MESSAGE=$ENCODED

rawurlencode "$threadName";

THREAD_ID=$ENCODED

DEVICES=$(echo $deviceIds | tr "," "\n")

for DEVICE in $DEVICES
do
	curl --insecure -i "https://push.panaceamobile.com/json?action=push_public_outbound_message_send&api_key=$apiKey&device_id=$DEVICE&message=$MESSAGE&thread_id=$THREAD_ID"
done



exit 0
