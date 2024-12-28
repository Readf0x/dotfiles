#!/usr/bin/env zsh

nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 3d
nix-collect-garbage -d
nix store optimize
