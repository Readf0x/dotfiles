{ pkgs, self, conf, lib, inputs, ... }: {
  environment = {
    etc."/xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
    systemPackages = with pkgs; [
      git
      keepassxc
      libnotify
      libsecret
      lxqt.lxqt-policykit
      neovim
      samba
      shared-mime-info
    ] ++ (with libsForQt5; [
      qt5ct
      qtstyleplugin-kvantum
      qtstyleplugins
    ] ++ (with qt5; [
      qtgraphicaleffects
      qtsvg
      qttools
      qtwayland
    ])) ++ (with kdePackages; [
      kio-admin
      kio-extras
      kio-fuse
      kservice
      plasma-workspace
      qt6ct
      qt6gtk2
      qtstyleplugin-kvantum
      qtsvg
      qtwayland
    ]) ++ (with wineWowPackages; [
      waylandFull
      fonts
    ]);
  };

  users.users.${conf.user}.packages = [
    inputs.xdvdfs.packages.${conf.system}.default
    inputs.islive.packages.${conf.system}.default
  ] ++ (with pkgs; [
    # Desktop Applications
    blender-hip
    deluge-gtk
    dopamine
    eog
    evolutionWithPlugins
    gimp
    gnome-font-viewer
    godot_4
    grimblast
    hexchat
    inkscape
    jetbrains.idea-community-bin
    kdenlive
    kitty
    libreoffice-qt6-fresh
    lutris
    mangohud
    mpv
    obsidian
    pavucontrol
    picard
    prismlauncher
    rofi
    seahorse
    swaynotificationcenter
    vesktop
    vlc
    xemu
    youtube-music
    zathura

    # CLI tools
    ani-cli
    btop
    gamescope
    grimblast
    hyprpicker
    mpc
    mpd
    mpd-discord-rpc
    mpd-mpris
    ncdu
    playerctl
    protontricks
    protonup-qt
    radeontop
    rar
    swww
    vimpc
    vulkan-tools
    winetricks
    wl-clipboard
    wtype
    xclip
    xdg-utils
    xdragon
  ] ++ (with kdePackages; [
    ark
    breeze-icons
    dolphin
    dolphin-plugins
    kdegraphics-thumbnailers
  ]));

  fonts.packages = builtins.attrValues (
    lib.filterAttrs (n: v: lib.hasPrefix "maple-font" n) self.packages.${conf.system}
  ) ++ (with pkgs; [
    cantarell-fonts
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
      # Impossible to use protontricks with this setup
      #extraCompatPackages = with pkgs; [
      #  proton-ge-bin
      #];
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
