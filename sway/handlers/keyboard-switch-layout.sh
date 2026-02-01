#!/bin/sh

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

declare -A indices

indices["English (US)"]=0
indices["Portuguese (Brazil)"]=1

declare -A layouts

layouts[0]="us"
layouts[1]="br"

curlayout=$(swaymsg -t get_inputs \
 | jq -r '
   .[] 
   | select(.type=="keyboard") 
   | .xkb_layout_names[.xkb_active_layout_index]
 ' \
 | head -n1)

indicessize=${#indices[@]}
index=$((${indices[$curlayout]} + 1))

if [ $index -ge $indicessize ]; then
  index=0
fi

newlayout=${layouts[$index]}
sway input type:keyboard xkb_layout $newlayout
show_msg $newlayout
