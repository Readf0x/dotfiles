#!/usr/bin/env bash
swww img -t grow --transition-pos 0.75,0.75 --transition-bezier .54,.92,.54,.16 --transition-duration 1 --transition-fps 60 --transition-step 255 --resize crop -o DP-2 "$(find -H "$HOME/.config/hypr/wallpapers" -type f \( -name "*.jpg" \) -print0 | shuf -zn1)";
sleep 0.75
swww img -t grow --transition-pos 1.75,0.75 --transition-bezier 0,0,1,1 --transition-duration 0.5 --transition-fps 60 --transition-step 255 --resize crop -o HDMI-A-1 "$(find -H "$HOME/.config/hypr/wallpapers" -type f \( -name "*.jpg" \) -print0 | shuf -zn1)";
