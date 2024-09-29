{ pkgs, self, sys', lib, ... }: {
  environment = {
    etc."/xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
    systemPackages = with pkgs; [
      libnotify
      libsecret
      lxqt.lxqt-policykit
      neovim
      samba
      shared-mime-info
      xdg-desktop-portal-hyprland
    ] ++ (with libsForQt5; [
      kio-admin
      kio-extras
      kio-fuse
      kservice
      plasma-workspace
      qtsvg
      qtwayland
      xdg-desktop-portal-kde
    ]);
  };

  #fonts.packages = (
  #  builtins.attrValues self.packages.${sys'}.maple-font
  #) ++ (with pkgs; [
  fonts.packages = builtins.attrValues (
    lib.filterAttrs (n: v: lib.hasPrefix "maple-font" n) self.packages.${sys'}
  ) ++ (with pkgs; [
    cantarell-fonts
    fira-code-nerdfont
    noto-fonts
    ubuntu_font_family
  ]);

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
