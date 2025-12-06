{ pkgs, stable, lib, working-hyprland, ... }: {
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
      # Desktop Applications
      chatterino7
      easyeffects
      figma-linux
      gimp3-with-plugins
      hyprshot
      inkscape
      keepassxc
      kitty
      libreoffice-qt6-fresh
      limo
      lutris
      mangohud
      mpvWithScripts
      bubbleshell.bubble-shell
      networkmanagerapplet
      pavucontrol
      prismlauncher
      qpwgraph
      qview
      reactions.reactions
      rofi
      scrcpy
      swaynotificationcenter
      this.wl-shimeji
      ungoogled-chromium
      xemu
      youtube-music
      zathura
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

      # CLI tools
      (ani-cli.override { mpv = mpvWithScripts; })
      alejandra
      android-tools
      bat
      borzoi.borzoi
      btop
      cava
      clipse
      delve
      distrobox
      distrobox-tui
      dragon-drop
      fd
      ffmpeg
      file
      fzf
      gdb
      gf
      gh
      go
      grimblast
      grub2
      htmlq
      hyperfine
      hyprpicker
      islive.islive
      jq
      libnotify
      libsecret
      lshw
      microfetch
      mpc
      mpd
      mpd-discord-rpc
      mpd-mpris
      ncdu
      ncmpcpp
      neovim
      nix-output-monitor
      nix-prefetch-github
      nodejs-slim
      playerctl
      podman-compose
      pokeget-rs
      pulseaudio
      python3
      radeontop
      ranger
      rar
      ripgrep
      samba
      shared-mime-info
      stable.lxqt.lxqt-policykit
      streamlink
      swww
      templating-engine.templating-engine
      tmux
      unzip
      uutils-coreutils-noprefix
      valgrind
      vulkan-tools
      wayland-utils
      wget
      winetricks
      wl-clipboard
      wtype
      xclip
      xdg-utils
      xxd
      yt-dlp
      zip
      this.umka
    ] ++ (with libsForQt5; [
      qt5ct
      qtstyleplugins
    ] ++ (with qt5; [
      qtgraphicaleffects
      qtsvg
      qttools
      qtwayland
    ])) ++ (with kdePackages; [
      kcalendarcore
      kimageformats
      kio
      kio-admin
      kio-extras
      kio-fuse
      kservice
      qt6ct
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
      lib.filterAttrs (n: v: ! lib.hasSuffix "-unhinted" n && lib.isDerivation v) pkgs.maple-mono
    ) ++ (with pkgs; [
      pkgs.bubbleshell.fonts
      cantarell-fonts
      noto-fonts
      monocraft
    ]);
  };

  programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;
    };
    hyprland = {
      enable = true;
      package = working-hyprland.hyprland;
      portalPackage = working-hyprland.xdg-desktop-portal-hyprland;
    };
    zsh.enable = true;
    fish.enable = true;
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
        obs-pipewire-audio-capture
      ];
      enableVirtualCamera = true;
    };
    kdeconnect.enable = true;
    virt-manager.enable = true;
    nh = {
      enable = true;
      package = pkgs.nh;
    };
  };
}
