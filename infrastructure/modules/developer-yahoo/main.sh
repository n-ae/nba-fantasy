#!/bin/sh

tunnel_url=$1
raw_cookie_value=$2
csrf=$3
current_unix_epoch=$(date +%s)
cookie_value=$(echo ${raw_cookie_value} | sed -e "s/{unix_epoch}/${current_unix_epoch}/g")

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
        "https://n-ae.github.io/nba-fantasy/",
        "https://n-ae.github.io",
        "https://nba-fantasy.pages.dev",
        "'${tunnel_url}'"
    ],
    "csrf": "'${csrf}'"
}'
)

if [ "$result" != "200" ]; then
    echo "Error: $result"
    exit 1
fi

# Safely produce a JSON object containing the result value.
# jq will ensure that the value is properly quoted
# and escaped to produce a valid JSON string.
# jq -n --arg result "$result" '{"result":$result}'
