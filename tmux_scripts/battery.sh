#!/bin/bash

upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | cut -d ":" -f2 | tr -d " \t"
