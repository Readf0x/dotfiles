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
      inputs.templating-engine.packages.${conf.system}.default
      # inputs.quickshell.packages.${conf.system}.default
      inputs.neoshell.packages.${conf.system}.default
      inputs.agenix.packages.${conf.system}.default
      unstable.figma-linux
    ] ++ [
      # Desktop Applications
      chatterino7
      easyeffects
      gimp3-with-plugins
      hyprshot
      keepassxc
      kitty
      libreoffice-qt6-fresh
      lutris
      mangohud
      mpvWithScripts
      networkmanagerapplet
      pavucontrol
      prismlauncher
      qpwgraph
      qview
      rofi
      scrcpy
      ungoogled-chromium
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
      delve
      distrobox
      distrobox-tui
      ffmpeg
      file
      fzf
      gdb
      gf
      go
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
      nix-output-monitor
      nodejs-slim
      playerctl
      podman-compose
      pokeget-rs
      python3
      radeontop
      ranger
      rar
      ripgrep
      samba
      shared-mime-info
      swww
      tmux
      unzip
      uutils-coreutils-noprefix
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
      plasma-browser-integration

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
    # fontconfig.defaultFonts.sansSerif = [ "Mead Icons" ];
    # fontconfig.defaultFonts.emoji = [ "Mead Icons" ];
    # fontconfig.defaultFonts.serif = [ "Mead Icons" ];
    # fontconfig.defaultFonts.monospace = [ "Mead Icons" ];
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
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      protontricks.enable = true;
      extest.enable = true;
    };
    gamescope.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-webkitgtk
        obs-pipewire-audio-capture
      ];
      enableVirtualCamera = true;
    };
    kdeconnect.enable = true;
    virt-manager.enable = true;
    nh.enable = true;
  };
}
