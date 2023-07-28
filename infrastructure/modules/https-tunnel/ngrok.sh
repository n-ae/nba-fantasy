nohup ngrok http 8080 &>/dev/null &

script_dir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")


printf "Waiting for ngrok to start"
while
    printf .
    result=$($script_dir/curl.sh | jq -r '.result')
    [ -z "$result" ] || [ "$result" = "null" ]
do :; done
