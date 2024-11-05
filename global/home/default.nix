{ pkgs, conf, lib, self, ... }: {

  nixpkgs = {
    config.allowUnfree = true;
  };

  imports = [
    ./../shared/stylix.nix
    ./hyprland.nix
    ./neovim.nix
    ./terminal.nix
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
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      ".config/hypr/pfp.png".source = ./../img/pfp.png;
      ".config/hypr/wallpapers".source = ./../img/wallpapers;
      "Scripts".source = ./../scripts;
      ".librewolf/${conf.librewolfProfile}/chrome".source = pkgs.fetchFromGitHub {
        owner = "readf0x";
        repo = "Firefox-Mod-Blur";
        rev = "586b9c63466c100d7bcaf8ec4fb12384406cb3cd";
        hash = "sha256-yH4Sqk7yq5WcQHmr4HHf7gBEtGJtk4JBEV0nnj/05vE=";
      };
      ".config/kdeglobals".text = ''
        [General]
        TerminalApplication=kitty

        [Icons]
        Theme=Colloid-Dark

        [KDE]
        ShowDeleteCommand=false

        [KFileDialog Settings]
        Allow Expansion=false
        Automatically select filename extension=true
        Breadcrumb Navigation=true
        Decoration position=0
        LocationCombo Completionmode=5
        PathCombo Completionmode=5
        Show Bookmarks=false
        Show Full Path=false
        Show Inline Previews=true
        Show Preview=false
        Show Speedbar=true
        Show hidden files=false
        Sort by=Date
        Sort directories first=true
        Sort hidden files last=false
        Sort reversed=true
        Speedbar Width=189
        View Style=Detail

        [KShortcutsDialog Settings]
        Dialog Size=692,480

        [PreviewSettings]
        EnableRemoteFolderThumbnail=false
        MaximumRemoteSize=0
      '';
      #".config/xdg-desktop-portal/portals.conf".text = ''
      #  [preferred]
      #  default=hyprland
      #  org.freedesktop.impl.portal.AppChooser=kde
      #  org.freedesktop.impl.portal.DynamicLauncher=kde
      #  org.freedesktop.impl.portal.FileChooser=kde
      #'';
      ".local/share/lutris/runners/xemu/xemu".source = "${pkgs.xemu}/bin/xemu";
    };

    sessionVariables = {
      PATH = "$PATH:$HOME/Scripts";
      WINEDLLPATH = "${self.packages.${conf.system}.discord-rpc}/share/winedll/discord-rpc";
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
      #package = pkgs.colloid-icon-theme;
    };
    # font.name = "Ubuntu";
  };
  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
    style.name = "kvantum";
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
      };
    };
    ags.enable = true;
    hexchat = {
      enable = true;
      channels = {
        Lainchan = {
          autojoin = [ "#questions" "#lainchan" ];
          nickname = "Phaethon";
          nickname2 = "Narcissus";
          realName = "Phaethon";
          userName = "phaethon";
          servers = [ "irc.lainchan.org/6697" ];
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

    home-manager.enable = true;

    waybar.enable = true;
  };

  stylix.targets = {
    kde.enable = false;
    hyprpaper.enable = lib.mkForce false;
    hyprland.enable = false;
    nixvim.enable = false;
    waybar.enable = false;
    #kitty.enable = false;
  };
}
