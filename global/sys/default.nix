{ pkgs, conf, self, lib, ... }: {
  imports = [
    ./../shared/stylix.nix
    ./packages.nix
  ];

  networking = {
    hostName = conf.host;
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };
  #environment.variables = {
  #  QT_QPA_PLATFORMTHEME = "qt5ct";
  #  QT_STYLE_OVERRIDE = "qt5ct";
  #};

  users.users.${conf.user} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

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
        "application/zip" = "ark.desktop";
        "video/*" = "mpv.desktop";
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
    style = "kvantum";
  };

  programs.ssh.askPassword = "";
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
        theme = let name = "chili"; in "${self.packages.${conf.system}.${name}}/share/sddm/themes/${name}";
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
          # outproxy = "";
        };
        sam.enable = true;
        i2cp = {
          enable = true;
          address = "127.0.0.1";
          port = 7654;
        };
      };
    };
    cron = {
      enable = true;
      # systemCronJobs = [
      #   "*/15 * * * *  readf0x  if islive caseoh_; then if [ $(notify-send --icon=\"/home/readf0x/Pictures/caseoh.png\" \"CaseOh is live!\" \"C'mon cuh!\" --action=\"WATCH\"=\"Watch Stream\" --action=\"DISMISS\"=\"Dismiss\" --expire-time=2000) == \"WATCH\" ]; then xdg-open \"https://twitch.tv/caseoh_\"; fi; fi"
      # ];
    };
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
}
