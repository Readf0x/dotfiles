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
      kimageformats
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

  users.users.${conf.user}.packages = let
    mpvWithScripts = pkgs.mpv.override {
      scripts = with pkgs.mpvScripts; [
        mpris
        uosc
      ];
    };
  in [
    inputs.xdvdfs.packages.${conf.system}.default
    inputs.islive.packages.${conf.system}.default
    inputs.nixpkgs-gimp-3.legacyPackages.${conf.system}.gimp
  ] ++ (with pkgs; [
    # Desktop Applications
    blender-hip
    blockbench
    deluge-gtk
    dopamine
    eog
    evolutionWithPlugins
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
    mpvWithScripts
    networkmanagerapplet
    obsidian
    pavucontrol
    picard
    prismlauncher
    qpwgraph
    rofi
    seahorse
    swaynotificationcenter
    vesktop
    vlc
    xemu
    youtube-music
    zathura

    # CLI tools
    (ani-cli.override {
      mpv = mpvWithScripts;
    })
    bat
    btop
    ffmpeg
    fzf
    gamescope
    grimblast
    hyfetch
    hyperfine
    hyprpicker
    jq
    microfetch
    mpc
    mpd
    mpd-discord-rpc
    mpd-mpris
    ncdu
    ncmpcpp
    nodejs-slim_23
    playerctl
    pokeget-rs
    protontricks
    protonup-qt
    python3
    radeontop
    ranger
    rar
    ripgrep
    swww
    unzip
    vulkan-tools
    wget
    winetricks
    wl-clipboard
    wtype
    xclip
    xdg-utils
    xdragon
    yt-dlp
    zip
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
    monocraft
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
    kdeconnect.enable = true;
  };
}
