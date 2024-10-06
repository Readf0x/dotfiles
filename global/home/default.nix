{ pkgs, conf, ... }: { nixpkgs = {
    config.allowUnfree = true;
  };

  imports = [
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
      ".librewolf/${conf.librewolfProfile}/chrome".source = pkgs.fetchFromGitHub {
        owner = "readf0x";
        repo = "Firefox-Mod-Blur";
        rev = "586b9c63466c100d7bcaf8ec4fb12384406cb3cd";
        hash = "sha256-yH4Sqk7yq5WcQHmr4HHf7gBEtGJtk4JBEV0nnj/05vE=";
      };
    };

    sessionVariables = {
      PATH = "$PATH:$HOME/Scripts";
    };

    pointerCursor = {
      gtk.enable = true;
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
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
    font.name = "Ubuntu";
  };
  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
  };

  xdg = {
    userDirs = {
      enable = true;
      desktop = null;
      publicShare = null;
    };
    desktopEntries = {
      # obsidian = {
      #   categories = [ "Office" ];
      #   comment = "Knowledge Base";
      #   exec = "obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland %u";
      #   icon = "obsidian";
      #   mimeType = [ "x-scheme-handler/obsidian" ];
      #   name = "Obsidian";
      #   type = "Application";
      # };
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
    obs-studio = {
      enable = true;
    };
    zathura = {
      enable = true;
    };
    rofi = {
      enable = true;
      theme = "${pkgs.rofi}/share/rofi/themes/Adapta-Nokto.rasi";
    };
    ags.enable = true;

    home-manager.enable = true;

    waybar.enable = true;
  };
}