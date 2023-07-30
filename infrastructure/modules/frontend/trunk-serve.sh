#!/bin/sh

with_back_off() {
    back_off_rate=0
    while
        printf .
        result=$(curl -s -o /dev/null -i -w "%{http_code}" http://localhost:8080)
        seconds=$((2**$back_off_rate))
        back_off_rate=$((back_off_rate + 1))
        # echo $seconds
        sleep $seconds
        # echo $result
        [ "$result" = "000" ]
    do :; done
}

every_10_secs() {
    while
        result=$(curl -s -o /dev/null -i -w "%{http_code}" http://localhost:8080)
        sleep 10
        [ "$result" = "000" ]
    do :; done
}

main() {
    pushd ./../../../frontend
    cargo clean
    trunk serve &>/dev/null &

    printf "Waiting for frontend to start"
    every_10_secs
    popd
}

main
