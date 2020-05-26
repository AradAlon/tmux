#!/bin/bash
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/bandwidth.sh"


if ping -q -c 1 -W 1 8.8.8.8 &>/dev/null; then
    network=$(iw dev | grep ssid | cut -d ' ' -f 2)
    if [[ $network ]]; then
        echo -n $network" "
    else
        echo -n "Ethernet "
    fi

    externalIP=$(dig @ns1-1.akamaitech.net ANY whoami.akamai.net +short)
    
    echo -n "$(get_tmux_option "@network-bandwidth-value")  "$externalIP
    # echo "$(main) 
    
else
    echo 'Offline'
fi
