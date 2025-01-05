#!/usr/bin/env zsh

if [[ $1 == '-h' ]]; then
  selection=$(cliphist list | rofi -dmenu -display-columns 2 | sed "s/\t.*//" | tr -d '\n' | cliphist decode)
  echo $selection | wl-copy
  echo $selection | xclip
else
  # check if xclip and wl-clipboard differ
  if [[ $(xclip -o) != $(wl-paste) ]]; then
    if [[ $(hyprctl activewindow -j | jq .xwayland) == true ]]; then
      xclip -o | cliphist store
      xclip -o | wl-copy
    else
      wl-paste | cliphist store
      wl-paste | xclip
    fi
  fi
  # hyprctl -i 0 notify -1 1500 'rgb(ffffff)' "x: $(xclip -o), wl: $(wl-paste)"
fi
