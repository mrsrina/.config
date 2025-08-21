#!/bin/sh

while true; do
  UP_OUTPUT=$(upower -i $(upower -e | grep 'BAT'))
  PERCENTAGE=$(echo "$UP_OUTPUT" | grep 'percentage:' | awk '{print $2}')
  ENERGY_RATE=$(echo "$UP_OUTPUT" | grep 'energy-rate:' | awk '{print $2, $3}')

  if echo "$UP_OUTPUT" | grep -q 'state: *discharging'; then
    TIME_INFO=$(echo "$UP_OUTPUT" | grep 'time to empty:' | awk '{print $4, $5}')
  elif echo "$UP_OUTPUT" | grep -q 'state: *charging'; then
    TIME_INFO=$(echo "$UP_OUTPUT" | grep 'time to full:' | awk '{print $4, $5}')
  else
    TIME_INFO="Full"
  fi

  DT_INFO=$(date +'%Y-%m-%d %X')
  printf "| %s - ~%s - %s | %s |\n" "$PERCENTAGE" "$ENERGY_RATE" "$TIME_INFO" "$DT_INFO"
  sleep 60
done
