#!/bin/sh

command=${1}
result=$(${command})

# Safely produce a JSON object containing the result value.
# jq will ensure that the value is properly quoted
# and escaped to produce a valid JSON string.
jq -n --arg result "$result" '{"result":$result}'
