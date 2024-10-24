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
    qt5 = {
      enable = true;
      platformTheme = "qt5ct";
      style = {
        name = "kvantum";
      };
    };
  };
  environment.variables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
  };

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
    mime.enable = true;
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

  programs.ssh.askPassword = "";
  services = {
    openssh.enable = true;
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
    # i2pd = {
    #   enable = true;
    #   proto = {
    #     socksProxy = {
    #       enable = true;
    #     };
    #     sam = {
    #       enable = true;
    #     };
    #     i2pControl = {
    #       enable = true;
    #     };
    #     i2cp = {
    #       enable = true;
    #     };
    #   };
    # };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services = {
      #sddm.enableGnomeKeyring = true;
      hyprlock = {};
    };
  };

  system.stateVersion = conf.stateVersion;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
