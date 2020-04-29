#!/bin/bash

## crontab -e
## add `* * * * * ~/.tmux_scripts/speedtest.sh`
## save!!
## crontab -l to verify

result=$(speedtest -f json)

error=$(jq '.level' ~/.tmux_scripts/speedtest.json)

if [[ $error ]]; then
    exit 1
fi

echo $result > ~/.tmux_scripts/speedtest.json
