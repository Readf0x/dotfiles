{ pkgs, self, conf, lib, ... }: {
  environment = {
    etc."/xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
    systemPackages = with pkgs; [
      keepassxc
      libnotify
      libsecret
      lxqt.lxqt-policykit
      neovim
      samba
      shared-mime-info
    ] ++ (with libsForQt5; [
      kio-admin
      kio-extras
      kio-fuse
      kservice
      plasma-workspace
      qtsvg
      qtwayland
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
    obsidian
    pavucontrol
    picard
    prismlauncher
    rofi
    seahorse
    swaynotificationcenter
    vesktop
    youtube-music
    zathura

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
  ]);

  programs = {
    hyprland = {
      enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };
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
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };
  };
}
