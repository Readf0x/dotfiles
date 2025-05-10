{ pkgs, conf, inputs, lib, ... }: {
  imports = [
    ./../shared/stylix.nix
    ./packages.nix
  ];

  networking = {
    hostName = conf.host;
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
    firewall.enable = false;
    hosts = {
      "10.1.11.104" = [ "Loki-II" "loki2" ];
      "10.1.11.100" = [ "Loki-IV" "loki4" ];
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };
  environment.variables = {
  #  QT_QPA_PLATFORMTHEME = "qt5ct";
  #  QT_STYLE_OVERRIDE = "qt5ct";
    SSH_ASKPASS = lib.mkForce "${pkgs.x11_ssh_askpass}/libexec/ssh-askpass";
  };

  users.users = lib.mapAttrs (
    name: config: {
      isNormalUser = config.isNormalUser;
      extraGroups = [ "networkmanager" ] ++ (
        if config.admin then [ "wheel" ] else []
      );
      shell = pkgs.${config.shell};
    }
  ) conf.users;

  #boot.plymouth = {
  #  themePackages = [(pkgs.adi1090x-plymouth-themes.override {
  #    selected_themes = [ "infinite_seal" ];
  #  })];
  #  enable = true;
  #  theme = "infinite_seal";
  #};

  xdg = {
    menus.enable = true;
    mime = {
      enable = true;
      defaultApplications = {
        "image/svg+xml" = "inkscape.desktop";
        "image/png" = [ "org.gnome.eog.desktop" "gimp.desktop" ];
        "application/x-rar-compressed" = "ark.desktop";
        "application/x-7z-compressed" = "ark.desktop";
        "application/x-tar" = "ark.desktop";
        "application/zip" = "ark.desktop";
        "video/x-msvideo" = "mpv.desktop";
        "video/mp4" = "mpv.desktop";
        "video/mpeg" = "mpv.desktop";
        "video/ogg" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "text/html" = "firefox-esr.desktop";
        "x-scheme-handler/http" = "firefox-esr.desktop";
        "x-scheme-handler/https" = "firefox-esr.desktop";
        "x-scheme-handler/about" = "firefox-esr.desktop";
        "x-scheme-handler/unknown" = "firefox-esr.desktop";
      };
    };
    portal = {
      enable = true;
      config = {
        common = {
          default = [ "hyprland" "kde" ];
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        libsForQt5.xdg-desktop-portal-kde
      ];
    };
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = lib.mkForce "kvantum";
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PrintMotd = true;
      };
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa.enable = true;
    };
    udisks2.enable = true;
    gvfs.enable = true;
    displayManager = {
      defaultSession = "hyprland";
      sddm = {
        enable = true;
        wayland.enable = true;
        theme = let
          chili = pkgs.sddm-chili-theme.override {
            themeConfig = { background = "${inputs.wallpapers.packages.${conf.system}.default}/0.jpg"; };
          };
        in "${chili}/share/sddm/themes/chili";
      };
    };
    #gnome.gnome-keyring.enable = true;
    logind.extraConfig = "HandlePowerKey=ignore";
    i2pd = {
      enable = true;
      address = "127.0.0.1";
      proto = {
        http.enable = true;
        socksProxy.enable = true;
        httpProxy = {
          enable = true;
          outproxy = "http://exit.stormycloud.i2p";
        };
        sam.enable = true;
        i2cp = {
          enable = true;
          address = "127.0.0.1";
          port = 7654;
        };
      };
      outTunnels = {
        i2pcraft = {
          enable = true;
          address = "127.0.0.1";
          port = 25565;
          destination = "abnrfgqqsoy6d3dlc7dzq64c5uir5vd7hxy7s7weo6qvmzigf34a.b32.i2p";
          keys = "i2pcraft.dat";
          inbound.length = 3;
          outbound.length = 3;
        };
      };
    };
    cron.enable = true;
  };

  # https://discourse.nixos.org/t/setting-sddm-profile-picture/49604
  systemd.services = {
    "sddm-avatar" = {
      description = "Service to copy or update users Avatars at startup.";
      wantedBy = [ "multi-user.target" ];
      before = [ "sddm.service" ];
      script = ''
        set -eu
        for user in /home/*; do
          username=$(basename "$user")
          mkdir -p "/var/lib/AccountsService/icons"
          if [ -f "$user/.face.icon" ]; then
            if [ ! -f "/var/lib/AccountsService/icons/$username" ]; then
              cp "$user/.face.icon" "/var/lib/AccountsService/icons/$username"
            else
              if [ "$user/.face.icon" -nt "/var/lib/AccountsService/icons/$username" ]; then
                cp "$user/.face.icon" "/var/lib/AccountsService/icons/$username"
              fi
            fi
          fi
        done
      '';
      serviceConfig = {
        Type = "simple";
        User = "root";
        StandardOutput = "journal+console";
        StandardError = "journal+console";
      };
    };
    sddm = { after = [ "sddm-avatar.service" ]; };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services = {
      #sddm.enableGnomeKeyring = true;
      hyprlock = {};
    };
  };

  environment.etc."motd".text = ''
    ⠀⠀⢮⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀
    ⠀⢘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠠
    ⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇
    ⠀⢸⣿⣿⣿⣿⣿⡿⣽⠇⢸⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠆
    ⠀⠈⠘⢿⣿⡿⢿⣇⣹⠇⠨⢎⣿⢿⣿⣿⡿⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃
    ⠀⠀⠀⢸⣿⡇⣷⣤⣩⡃⠘⠈⢸⠉⡤⣿⣅⡐⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⠆
    ⠀⠀⠀⠈⠃⢿⠘⠛⠛⠃⠀⠀⠀⠀⠀⢿⣤⣉⡓⠻⣿⣿⣿⣿⣿⡳⣿⣿⡿⠀
    ⠀⠀⠀⠀⠀⠈⣆⠀⠐⠀⢀⠀⠀⠀⠀⠈⠛⠿⠛⠁⠁⣿⣿⣿⣏⣽⣿⡟⠇⠀
    ⠀⠀⠀⠀⠀⠀⠈⢦⡀⢀⠯⣤⠀⠀⠀⠀⠀⠀⠀⠀⢨⣿⣿⡿⠿⠿⠻⠁⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⢹⣄⡀⠀⠄⠀⡀⠀⠀⠀⢀⣠⢷⣿⣿⣿⡆⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⢀⣠⣶⣿⣿⠑⢤⣈⣄⣤⣤⢶⣟⠯⠃⢹⣿⣿⣿⣷⣄⠀⠀⠀⠀
    ⠀⢀⣠⣴⣾⣿⣿⣿⣿⡏⢀⣦⣿⡞⠓⠋⠉⠀⠀⠀⢸⣿⣿⣿⣿⣿⣷⣄⠀⠀
    ⣶⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⣿⣿⣷⡀⠂⠄⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣯⣧⡀
    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⢀⠀⣀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶
    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
    𝙻𝚎𝚝'𝚜 𝚊𝚕𝚕 𝚕𝚘𝚟𝚎 𝙻𝚊𝚒𝚗
  '';

  # fileSystems."/tmp" = {
  #   fsType = "tmpfs";
  #   device = "none";
  #   options = [ "size=1G" "mode=777" ];
  # };

  system.stateVersion = conf.stateVersion;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.extraOptions = ''
    download-speed = 25000
  '';

  virtualisation = {
    docker.enable = false;
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };
}
