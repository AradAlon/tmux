#!/bin/bash

kibiTogibi=1049000

totalMem=$(free | tail +2 | head -n1 | tr -s ' ' | cut -d ' ' -f2)
usedMem=$(free | tail +2 | head -n1 | tr -s ' ' | cut -d ' ' -f3)
sharedMem=$(free | tail +2 | head -n1 | tr -s ' ' | cut -d ' ' -f5)

allUsedMem=$((usedMem + sharedMem))

totalSwap=$(free | tail -n1 | tr -s ' ' | cut -d ' ' -f2)
usedSwap=$(free | tail -n1 | tr -s ' ' | cut -d ' ' -f3)


totalMem=$(awk "BEGIN {print $totalMem/$kibiTogibi}")
allUsedMem=$(awk "BEGIN {print $allUsedMem/$kibiTogibi}")
totalSwap=$(awk "BEGIN {print $totalSwap/$kibiTogibi}")
usedSwap=$(awk "BEGIN {print $usedSwap/$kibiTogibi}")

echo $allUsedMem $totalMem $usedSwap $totalSwap | awk '{ printf("RAM %.2fG/%.2fG  Swp %.2fG/%.2fG", $1, $2, $3, $4) }'