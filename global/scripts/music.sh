#!/usr/bin/env zsh

if [[ $1 == '-h' ]]; then
  echo "usage: $0 [-h] [-d | <name> <url> [--picard]]"
elif [[ $1 != '-d' ]]; then
  local profile="firefox:~/.librewolf/mj60kq4g.default"
  mkdir ~/Music/$1
  cd ~/Music/$1
  yt-dlp -f 'bestaudio[ext=m4a]' --extract-audio --audio-format mp3 --audio-quality 0 --output '%(title)s.%(ext)s' --cookies-from-browser $profile $2
  if [[ $3 == "--picard" ]]; then
    picard -e load ~/Music/"$1"/*.mp3 -e cluster -e scan >/dev/null 2>&1 & disown
  fi
  () {
    notify-send -i Finished -u normal -t 5000 -w "Finished downloading" "Finished downloading $1, please ensure data is correct"
    if [[ $3 == "--picard" ]]; then
      hyprctl dispatch focuswindow class:org.musicbrainz.Picard
    else
      hyprctl dispatch focuswindow pid:$KITTY_PID
    fi
  } &
  read -s -k '?Press any key to continue...'
  ffmpeg -i *([1]) -an -vcodec copy cover.png
fi
cat > ./.directory <<EOF
[Desktop Entry]
Icon=./cover.png

[Dolphin]
SortRole=track
Timestamp=2024,9,10,17,59,39.616
Version=4
ViewMode=1
VisibleRoles=CustomizedDetails,Details_text,Details_track,Details_artist,Details_album,Details_rating,Details_size
EOF