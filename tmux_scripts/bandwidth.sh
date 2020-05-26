#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/helpers.sh"

get_rx() {
  netstat -ie | grep -oP 'RX([[:space:]]packets[[:space:]][[:digit:]]+)?[[:space:]]+bytes[[:space:]]([[:digit:]]+)' | cut -d' ' -f6 | paste -sd+ | bc -l
}

get_tx() {
  netstat -ie | grep -oP 'TX([[:space:]]packets[[:space:]][[:digit:]]+)?[[:space:]]+bytes[[:space:]]([[:digit:]]+)' | cut -d' ' -f6 | paste -sd+ | bc -l
}

echo_bandwidth() {
  echo -n $(get_rx)" "$(get_tx)
}

format_speed() {
  local padding=$(get_tmux_option "@tmux-network-bandwidth-padding" 5)
  numfmt --to=iec --suffix "B/s" --format "%.2f" --padding $padding $1
}

main() {
  local sleep_time=$(get_tmux_option "status-interval")
  # local sleep_time=1
  local old_value=$(get_tmux_option "@network-bandwidth-value")

  if [ -z "$old_value" ]; then
    $(set_tmux_option "@network-bandwidth-value" "-")
    echo -n "Working..."
    return 0
  else
    local first_measure=($(echo_bandwidth))
    sleep $sleep_time
    local second_measure=($(echo_bandwidth))
    local download_speed=$(awk "BEGIN {print ((${second_measure[0]} - ${first_measure[0]})/$sleep_time)}")
    local upload_speed=$(awk "BEGIN {print ((${second_measure[1]} - ${first_measure[1]})/$sleep_time)}")
    $(set_tmux_option "@network-bandwidth-value" "↓$(format_speed $download_speed) • ↑$(format_speed $upload_speed)")
  fi

  # echo -n $(get_tmux_option "@network-bandwidth-value")
}

main