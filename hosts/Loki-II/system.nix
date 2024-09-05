{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix
    ./drives.nix
    ./packages.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    rocmSupport = true;
  };

  networking = {
    hostName = "Loki-II";
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
  };

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.readf0x = {
    isNormalUser = true;
    description = "Davis Forsythe";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  xdg = {
    menus.enable = true;
    mime.enable = true;
  };

  programs.ssh.askPassword = "";
  services = {
    openssh.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa.enable = true;
    };
    udisks2.enable = true;
    gvfs.enable = true;
    displayManager = {
      defaultSession = "hyprland";
      sddm = {
        enable = true;
        wayland = {
          enable = true;
        };
      };
    };
    gnome.gnome-keyring.enable = true;
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services = {
      #kwallet.kwallet.enable = true;
      sddm.enableGnomeKeyring = true;
      hyprlock = {};
    };
  };

  system.stateVersion = "24.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
