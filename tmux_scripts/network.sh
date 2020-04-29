#!/bin/bash

BytesToMegabit=125000
BytesToKilobit=125

if ping -q -c 1 -W 1 8.8.8.8 &>/dev/null; then
    network=$(iw dev | grep ssid | cut -d ' ' -f 2)
    if [[ $network ]]; then
        echo -n $network" "
    else
        echo -n "Ethernet "
    fi

    error=$(jq '.error' ~/.tmux_scripts/speedtest.json)
    download=$(jq '.download.bandwidth' ~/.tmux_scripts/speedtest.json)
    upload=$(jq '.upload.bandwidth' ~/.tmux_scripts/speedtest.json)
    externalIP=$(jq '.interface.externalIp' ~/.tmux_scripts/speedtest.json | sed -e 's/^"//' -e 's/"$//')
    
    if [[ !$error ]]; then 
        if [[ $download -ge 125000 ]]; then
            echo -n "↓"$(($download / $BytesToMegabit))" Mb/s • "
        elif [[ $download -ge 125 ]]; then
            echo -n "↓"$(($download / $BytesToKilobit))" Kb/s • "
        else
            echo -n "↓"$(($download))" B/s • "
        fi

        if [[ $upload -ge 125000 ]]; then
            echo "↑"$(($upload / $BytesToMegabit))" Mb/s  "$externalIP
        elif [[ $upload -ge 125 ]]; then
            echo "↑"$(($upload / $BytesToKilobit))" Kb/s  "$externalIP
        else
            echo "↑"$(($upload))" B/s  "$externalIP
        fi
    fi

else
    echo 'Offline'
fi
