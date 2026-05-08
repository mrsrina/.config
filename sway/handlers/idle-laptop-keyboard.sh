#!/usr/bin/env bash

BUILTIN="1:1:AT_Translated_Set_2_keyboard"
SWAYSOCK="${SWAYSOCK:-/run/user/$(id- u)/sway-ipc.*.sock}"

log() { logger -t kbd-daemon "$*"; }

disable_buitin() {
  swaymsg -s $SWAYSOCK input "$BUILTIN" events disabled
  log "External kebyoard connected - built-in disabled!"
}

enable_builtin() {
  swaymsg -s $SWAYSOCK input "$BUILTIN" events enabled
  log "External kebyoard disconnected - built-in enabled!"
}

log "Started. Watching for keyboard events..."

udevadm monitor --subsystem-match=input --property | while read -r line; do
  if echo "$line" | grep -q "^ACTION=add"; then
    ACTION=add
  elif echo "$line" | grep -q "^ACTION=remove"; then
    ACTION=remove
  fi

  if echo "$line" | grep -q "^ID_INPUT_KEYBOARD=1"; then
    if [[ "$ACTION" == "add" ]]; then
      disable_buitin
    elif [[ "$ACTION" == "remove" ]]; then
      enable_builtin
    fi

    ACTION=""
  fi
done
