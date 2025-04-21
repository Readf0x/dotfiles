{ pkgs, self, conf, lib, inputs, ... }: {
  environment = {
    etc."/xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
    systemPackages = with pkgs; let
      mpvWithScripts = mpv.override {
        scripts = with mpvScripts; [
          mpris
          uosc
        ];
      };
    in [
      inputs.islive.packages.${conf.system}.default
      inputs.quickshell.packages.${conf.system}.default
    ] ++ [
      # Desktop Applications
      blender-hip
      blockbench
      deluge-gtk
      easyeffects
      eog
      gimp
      gnome-font-viewer
      grimblast
      hexchat
      inkscape
      jetbrains.idea-community-bin
      keepassxc
      kitty
      libreoffice-qt6-fresh
      lutris
      mangohud
      mpvWithScripts
      networkmanagerapplet
      obsidian
      pavucontrol
      picard
      premid
      prismlauncher
      qpwgraph
      rofi
      scrcpy
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
      android-tools
      bat
      btop
      clipse
      ffmpeg
      fzf
      gamescope
      git
      grimblast
      hyfetch
      hyperfine
      hyprpicker
      jq
      libnotify
      libsecret
      lxqt.lxqt-policykit
      microfetch
      mpc
      mpd
      mpd-discord-rpc
      mpd-mpris
      ncdu
      ncmpcpp
      neovim
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
      samba
      shared-mime-info
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
      qtstyleplugin-kvantum
      qtsvg
      qtwayland

      # Applications
      ark
      breeze-icons
      dolphin
      dolphin-plugins
      kdegraphics-thumbnailers
      kdenlive
    ]) ++ (with wineWowPackages; [
      stableFull
      fonts
    ]);
  };

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
      plugins = with pkgs.obs-studio-plugins; [
        obs-webkitgtk
      ];
      enableVirtualCamera = true;
    };
    kdeconnect.enable = true;
    virt-manager.enable = true;
  };
}
