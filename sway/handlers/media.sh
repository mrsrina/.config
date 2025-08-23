#!/bin/sh

function get_display_percent() {
  curr=$(brightnessctl get)
  max=$(brightnessctl max)
  echo $(echo "scale=2; ($curr / $max) * 100" | bc)
}

function get_volume_percent() {
  echo $(pamixer --get-volume-human)
}

function show_msg() {
  yad \
    --undecorated \
    --no-buttons \
    --fixed \
    --skip-taskbar \
    --no-focus \
    --close-on-unfocus \
    --timeout 1 \
    --borders=10 \
    --text=$1
}

if [ "$OP" = "v0" ]; then
  if pamixer --get-mute | grep -q "true"; then
    pamixer --unmute
  else
    pamixer --mute
  fi

  label=$(get_volume_percent)
  show_msg $label
fi

if [ "$OP" = "v+" ]; then
  if pamixer --get-mute | grep -q "true"; then
    pamixer --unmute
  fi

  pamixer -i $VF
  label=$(get_volume_percent)
  show_msg $label
fi

if [ "$OP" = "v-" ]; then
  if pamixer --get-mute | grep -q "true"; then
    pamixer --unmute
  fi

  pamixer -d $VF
  label=$(get_volume_percent)
  show_msg $label
fi

if [ "$OP" = "d+" ]; then
  brightnessctl set +$BF%
  label="$(get_display_percent)%"
  show_msg $label
fi

if [ "$OP" = "d-" ]; then
  brightnessctl set $BF%-
  percent=$(get_display_percent)
  label="$percent%"
  show_msg $label
fi
