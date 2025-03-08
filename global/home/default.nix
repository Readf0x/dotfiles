{ pkgs, conf, lib, self, ... }: {

  nixpkgs = {
    config.allowUnfree = true;
  };

  imports = [
    ./../shared/stylix.nix
    ./browser.nix
    ./files.nix
    ./hyprland.nix
    ./terminal.nix
    ./waybar.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = conf.user;
    homeDirectory = conf.homeDir;

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = conf.stateVersion; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = with pkgs; [
      colloid-kde
      fd
    ];

    sessionVariables = {
      PATH = "$PATH:$HOME/Scripts";
      WINEDLLPATH = "${self.packages.${conf.system}.discord-rpc}/share/winedll/discord-rpc";
      LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [ kdePackages.qtbase libGL glfw-wayland-minecraft libpulseaudio openal flite ] + ":$LD_LIBRARY_PATH";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    #pointerCursor = {
    #  gtk.enable = true;
    #  name = "Bibata-Modern-Ice";
    #  package = pkgs.bibata-cursors;
    #  size = 24;
    #};
  };

  gtk = {
    enable = true;
    theme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-gtk-theme;
    };
    iconTheme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-icon-theme;
    };
  };
  qt = {
    platformTheme.name = "qtct";
    style = {
      name = "Kvantum";
      package = pkgs.colloid-kde;
    };
  };

  xdg = {
    userDirs = {
      enable = true;
      desktop = null;
      publicShare = null;
    };
  };

  programs = {
    librewolf = {
      enable = true;
      settings = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.use-xdg-desktop-portal.mime-handler" = 1;
        "svg.context-properties.content.enabled" = true;
        "middlemouse.paste" = false;
      };
    };
    hexchat = {
      enable = true;
      channels = {
        Lainchan = {
          autojoin = [
            "#questions"
            "#lainchan"
            "#programming"
          ];
          nickname = "Phaethon";
          nickname2 = "Narcissus";
          realName = "Phaethon";
          userName = "phaethon";
          servers = [ "irc.lainchan.org/+6697" ];
          options = {
            useGlobalUserInformation = false;
          };
        };
        Libera = {
          servers = [
            "irc.libera.chat"
            "irc.eu.libera.chat"
            "irc.us.libera.chat"
            "irc.au.libera.chat"
            "irc.ea.libera.chat"
            "irc.ipv4.libera.chat"
            "irc.ipv6.libera.chat"
          ];
        };
      };
      settings = {
        irc_nick1 = conf.user;
        irc_nick2 = "readfOx";
        irc_username = conf.user;
        irc_realname = conf.realName;
      };
      overwriteConfigFiles = true;
    };
    rofi.enable = true;

    home-manager.enable = true;

    nixvim = {
      enable = true;
    } // import ./nixvim.nix { inherit pkgs; };
  };

  stylix.targets = {
    kde.enable = false;
    hyprpaper.enable = lib.mkForce false;
    hyprland.enable = false;
    nixvim.enable = false;
    waybar.enable = false;
    #kitty.enable = false;
    hyprlock.enable = false;
    qt.enable = false;
  };
}
