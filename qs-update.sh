#!/usr/bin/env zsh

if nix flake metadata 2>/dev/null | rg -F "$(nix flake show 'github:readf0x/quickshell' 2>/dev/null | head -n 1 | sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g')"; then
  print "already up to date"
else
  commits=("${(@f)$(nix flake update neoshell 2>&1 | rg -o '[0-9a-f]{40}')}")
  git commit -m 'update quickshell' -m "${commits[1]} -> ${commits[2]}"
fi
