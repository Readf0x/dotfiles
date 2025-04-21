#!/usr/bin/env zsh

if [[ $(git rev-list origin/$(git branch --show-current 2>/dev/null) --not HEAD --count) -eq '0' ]]; then
  nix flake update && \
  ./switch.sh && \
  ./global/scripts/nix-clean
else
  print "Repo is not up to date."
fi

