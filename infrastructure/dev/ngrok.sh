nohup ngrok http 8080 &>/dev/null &

printf "Waiting for ngrok to start"
while
    printf .
    result=$(./curl.sh | jq -r '.result')
    [ -z "$result" ] || [ "$result" = "null" ]
do :; done
