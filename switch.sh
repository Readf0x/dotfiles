#!/usr/bin/env zsh

sudo nixos-rebuild switch --flake $PWD
home-manager switch --flake $PWD

