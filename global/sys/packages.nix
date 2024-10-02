{ pkgs, self, conf, lib, ... }: {
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

  users.users.${conf.user}.packages = with pkgs; [
    ### Desktop Applications:
    blender-hip
    dopamine
    eog
    evolutionWithPlugins
    gimp
    gnome-font-viewer
    godot_4
    grimblast
    kdenlive
    libreoffice-qt6-fresh
    mpv
    neovide
    pavucontrol
    picard
    prismlauncher
    seahorse
    swaynotificationcenter
    vesktop
    youtube-music

    ### User Facing CLI tools:
    btop
    grimblast
    hyprpicker
    playerctl
    radeontop
    swww
    wl-clipboard
    xclip
  ] ++ (with libsForQt5; [
    ark
    dolphin
    dolphin-plugins
    kdegraphics-thumbnailers
    breeze-icons
    qt5ct
    qtstyleplugin-kvantum
    qtstyleplugins
  ]) ++ (with kdePackages; [
    qt6ct
    qtstyleplugin-kvantum
  ]);

  fonts.packages = builtins.attrValues (
    lib.filterAttrs (n: v: lib.hasPrefix "maple-font" n) self.packages.${conf.system}
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
