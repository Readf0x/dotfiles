#!/usr/bin/env zsh

nix flake update && \
./switch.sh && \
./global/scripts/nix-clean

