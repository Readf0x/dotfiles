#!/usr/bin/env zsh

if [[ $(git fetch) -eq "" ]]; then
  nix flake update && \
  ./switch.sh && \
  ./global/scripts/nix-clean
else
  print "Repo is not up to date."
fi

