#!/bin/sh

tunnel_url=$1
cookie_value=$2
csrf=$3

result=$(
curl -s -o /dev/null -i -w "%{http_code}" --location --request PUT 'https://developer.yahoo.com/apps/vTNpBd74/' \
    --header "cookie: ${cookie_value}" \
    --header 'Content-Type: application/json' \
    --data '{
    "appName": "nbailab",
    "description": "Test",
    "homepage": "",
    "selectedScopes": {
        "fspt": [
            "fspt-w"
        ]
    },
    "namespace": "yahoo",
    "isConfidentialClientType": true,
    "redirectUris": [
        "https://bali-ibrahim.github.io/nba-fantasy/",
        "https://bali-ibrahim.github.io",
        "'${tunnel_url}'"
    ],
    "csrf": "'${csrf}'"
}'
)

# Safely produce a JSON object containing the result value.
# jq will ensure that the value is properly quoted
# and escaped to produce a valid JSON string.
jq -n --arg result "$result" '{"result":$result}'
