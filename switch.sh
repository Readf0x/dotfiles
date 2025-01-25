#!/usr/bin/env zsh

home-manager switch --flake $PWD
sudo nixos-rebuild switch --flake $PWD

