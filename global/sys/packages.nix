{ pkgs, stable, lib, ... }: {
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
      gimp3-with-plugins
      hyprshot
      keepassxc
      kitty
      libreoffice-qt6-fresh
      limo
      lutris
      mangohud
      mpvWithScripts
      neofuturism-shell
      networkmanagerapplet
      pavucontrol
      prismlauncher
      qpwgraph
      qview
      rofi
      scrcpy
      swaynotificationcenter
      ungoogled-chromium
      figma-linux
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
      wl-shimeji
      xemu
      youtube-music
      zathura

      # CLI tools
      (ani-cli.override { mpv = mpvWithScripts; })
      alejandra
      android-tools
      bat
      btop
      cava
      clipse
      delve
      distrobox
      distrobox-tui
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
      # hyfetch
      hyperfine
      hyprpicker
      islive
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
      swww
      templating-engine
      tmux
      unzip
      uutils-coreutils-noprefix
      vulkan-tools
      wayland-utils
      wget
      winetricks
      wl-clipboard
      wtype
      xclip
      xdg-utils
      xdragon
      xxd
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
      lib.filterAttrs (n: v: ! lib.hasSuffix "-unhinted" n && lib.isDerivation v) pkgs.maple-mono
    ) ++ (with pkgs; [
      pkgs.courier
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
