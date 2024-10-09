#!/usr/bin/env zsh

if ls ${XDG_RUNTIME_DIR:-${TMPDIR}nvim.${USER}}/nvim.*.0 > /dev/null; then
  servers=(${XDG_RUNTIME_DIR:-${TMPDIR}nvim.${USER}}/nvim.*.0)
  if [[ ${#servers[@]} > 1 ]]; then
    server=$(echo $servers | rofi -sep ' ' -dmenu)
  # elif [[ ${#servers[@]} = 1 ]]; then
  else
    server=$servers
  fi

  if [[ $# > 0 ]]; then
    for file in $@; do
      nvim --headless --server $server --remote $(realpath $file)
    done
  else
    nvim --headless --server $server --remote-send ':lua vim.notify("Ping!")<cr>'
  fi
elif [[ $# > 0 ]]; then
  for file in $@; do
    neovide $(realpath $file)
  done
fi
