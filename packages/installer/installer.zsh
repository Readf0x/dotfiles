#!/usr/bin/env zsh

source /etc/os-release

function pr() {
  print -P $@
}

function gen-config() {
  if ! [[ -v HOSTNAME ]]; then
    pr "%F{1}%BMissing hostname!!!%b%f"
    pr "Please define a hostname: "; read HOSTNAME
  fi
  mkdir -p ./hosts/$HOSTNAME/sys
  nixos-generate-config --dir ./hosts/$HOSTNAME/sys
  rm ./hosts/$HOSTNAME/sys/configuration.nix
  mv ./hosts/$HOSTNAME/sys/hardware-configuration.nix ./hosts/$HOSTNAME/sys/hardware.nix
  cat > ./hosts/$HOSTNAME/sys/default.nix << EOF
{ ... }: {
  imports = [
    ./hardware.nix
  ];
}
EOF
}

function yesno() {
  stty -echo
  pr -n "%F{2}[Y/n]%f "; read -k 1 RESP; [[ "$RESP" != $'\n' ]] && pr $RESP || pr
  stty echo
  case "$RESP" in
    Y|y|$'\n') $@ ;;
    *) ;;
  esac
}
function noyes() {
  stty -echo
  pr -n "%F{2}[y/N]%f "; read -k 1 RESP; [[ "$RESP" != $'\n' ]] && pr $RESP || pr
  stty echo
  case "$RESP" in
    N|n|$'\n') $@ ;;
    *) ;;
  esac
}

function installrepo() {
  sudo mkdir -p /mnt/home/readf0x/Repos/readf0x
  sudo cp -r /tmp/dotfiles /mnt/home/readf0x/Repos/readf0x/dotfiles
}

pr "Please set up the installation drives."
$SHELL -i
while ! [[ -d "/mnt" ]]; do
  pr "%F{1}%BDrive not mounted!%b%f"
  pr "Please ensure setup was completed and drive mounted to /mnt."
  $SHELL -i
done

cd /tmp
git clone https://github.com/readf0x/dotfiles
cd dotfiles
if ! [[ -v HOSTNAME ]] || ! [[ -d "./hosts/$HOSTNAME" ]]; then
  pr "Please create a system definition in %B%F{2}./hosts/flake-module.nix%f%b"
  pr "You may then exit the shell and the system will be built automatically."
  pr "Autogenerate hardware-configuration?"
  yesno gen-config
  $SHELL -i
fi
while ! sudo nixos-install --flake .#$HOSTNAME; do
  pr "Exit script?"
  noyes $SHELL -i
done

pr "Copy this repo?"
yesno installrepo
pr "Chroot into installation?"
yesno sudo nixos-enter

