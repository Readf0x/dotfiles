{ pkgs, conf, lib, inputs, unstable, ... }: {
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
      # inputs.quickshell.packages.${conf.system}.default
      inputs.neoshell.packages.${conf.system}.default
      unstable.figma-linux
    ] ++ [
      # Desktop Applications
      blender-hip
      blockbench
      chatterino7
      easyeffects
      gimp3-with-plugins
      hexchat
      hyprshot
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
      prismlauncher
      qpwgraph
      qview
      rofi
      rssguard
      scrcpy
      swaynotificationcenter
      (vesktop.overrideAttrs (prev: {
        desktopItems = makeDesktopItem {
          name = "vesktop";
          desktopName = "Vesktop";
          exec = "vesktop --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform-hint=auto %U";
          icon = "vesktop";
          startupWMClass = "Vesktop";
          genericName = "Internet Messenger";
          keywords = [
            "discord"
            "vencord"
            "electron"
            "chat"
          ];
          categories = [
            "Network"
            "InstantMessaging"
            "Chat"
          ];
        };
      }))
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
      cava
      clipse
      distrobox
      distrobox-tui
      ffmpeg
      fzf
      gamescope
      grimblast
      grub2
      hyfetch
      hyperfine
      hyprpicker
      jq
      libnotify
      libsecret
      lshw
      lxqt.lxqt-policykit
      microfetch
      mpc
      mpd
      mpd-discord-rpc
      mpd-mpris
      ncdu
      ncmpcpp
      neovim
      nodejs-slim
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
      kcalendarcore
      kimageformats
      kio-admin
      kio-extras
      kio-fuse
      kservice
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
      korganizer
      ktorrent
    ]) ++ (with wineWowPackages; [
      stableFull
      fonts
    ]);
  };

  fonts = {
    packages = builtins.attrValues (
      lib.filterAttrs (n: v: ! lib.hasSuffix "-unhinted" n && lib.isDerivation v) unstable.maple-mono
    ) ++ (with pkgs; [
      inputs.neoshell.packages.${conf.system}.courier
      cantarell-fonts
      # makes gimp 3 take 100x longer to open
      # Fuck it, we'll wait
      noto-fonts
      # noto-fonts-cjk-sans
      monocraft
    ]);
    fontconfig.defaultFonts.sansSerif = [ "Mead Icons" ];
    fontconfig.defaultFonts.emoji = [ "Mead Icons" ];
    fontconfig.defaultFonts.serif = [ "Mead Icons" ];
    fontconfig.defaultFonts.monospace = [ "Mead Icons" ];
  };

  programs = {
    git.enable = true;
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
    nh.enable = true;
  };
}
