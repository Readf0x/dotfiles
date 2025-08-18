{ pkgs, conf, lib, self, unstable, ... }: rec {
  imports = [
    ./../shared/stylix.nix
    ./packages.nix
    ./grub.nix
    ./services.nix
  ];

  networking = {
    hostName = conf.host;
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
    firewall.enable = false;
    hosts = lib.mapAttrs' (
      n: v: lib.nameValuePair v.ssh.ip [ n v.ssh.shortname ]
    ) conf.hosts;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };
  environment.variables = {
    SSH_ASKPASS = lib.mkForce "${pkgs.x11_ssh_askpass}/libexec/ssh-askpass";
  };

  users.users = lib.mapAttrs (
    name: config: {
      isNormalUser = config.isNormalUser;
      extraGroups = [ "networkmanager" "video" "syncthing" ] ++ (
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
        "image/png" = [ "com.interversehq.qView.desktop" "gimp.desktop" ];
        "image/jpeg" = [ "com.interversehq.qView.desktop" "gimp.desktop" ];
        "image/bmp" = [ "com.interversehq.qView.desktop" "gimp.desktop" ];
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
        "application/vnd.microsoft.portable-executable" = "wine.desktop";
      };
    };
    portal = {
      enable = true;
      config = {
        common = {
          default = [ "hyprland" "kde" ];
        };
      };
      xdgOpenUsePortal = true;
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

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services = {
      #sddm.enableGnomeKeyring = true;
      hyprlock = {};
    };
  };

  environment.etc = {
    "motd".text = ''
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
    "os-release".text = lib.mkAfter ''
      FLAKE_OWNER="readf0x"
    '';
  };

  system.stateVersion = conf.stateVersion;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
      substituters = [ "https://cache.nixos.org" ];
      extra-substituters = lib.mapAttrsToList (n: v: "http://${builtins.elemAt v 1}:5000") networking.hosts;
      trusted-public-keys = builtins.attrValues (lib.mapAttrs (n: v: v.trusted-public-key) conf.hosts);
      auto-optimise-store = true;
      connect-timeout = 1;
      download-speed = 25000;
      fallback = true;
    };
  };

  virtualisation = {
    docker.enable = false;
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  stylix.targets = {
    grub.enable = false;
  };

  documentation.man.generateCaches = true;

  console = {
    earlySetup = true;
    # Generated font unfortunately looks like ass. Will find a different solution in future.
    # font = "${pkgs.stdenv.mkDerivation (finalAttrs: {
    #   name = "gen-console-font";
    #   noUnpack = true;
    #   FONT = "${unstable.maple-mono.opentype}/share/fonts/opentype/MapleMono-Regular.otf";
    #   nativeBuildInputs = [
    #     self.packages.${conf.system}.otf2psf
    #     self.packages.${conf.system}.generate-set
    #   ];
    #
    #   phases = [ "buildPhase" "installPhase" ];
    #
    #   buildPhase = ''
    #     otf2psf convert $FONT ./maplemono.psf 20
    #   '';
    #   installPhase = ''
    #     mkdir -p $out
    #     cp ./maplemono.psf $out/maplemono.psf
    #     gzip $out/maplemono.psf
    #   '';
    # })}/maplemono.psf.gz";
  };
}
