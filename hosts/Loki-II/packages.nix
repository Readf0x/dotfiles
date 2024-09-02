{ config, pkgs, inputs, ... }:
{
  environment = {
    etc."/xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
    systemPackages = with pkgs; [
      libnotify
      libsecret
      lxqt.lxqt-policykit
      neovim
      samba
      shared-mime-info
      xdg-desktop-portal-gtk
    ] ++ (with libsForQt5; [
      kdf
      kio-admin
      kio-extras
      kio-fuse
      kservice
      kwallet
      kwallet-pam
      plasma-workspace
      qtsvg
      qtwayland
    ]);
  };

  programs = {
    hyprland.enable = true;
    zsh.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
