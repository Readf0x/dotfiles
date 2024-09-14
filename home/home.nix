{ pkgs, self, ... }:

{
  nixpkgs = {
    config.allowUnfree = true;
  };

  imports = [
    ./hyprland.nix
    ./neovim.nix
    ./terminal.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "readf0x";
  home.homeDirectory = "/home/readf0x";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # Custom packages
    self.packages.dopamine
  ] ++ (with pkgs; [
    ### Desktop Applications:
    eog
    evolutionWithPlugins
    gimp
    grimblast
    libreoffice-qt6-fresh
    mpv
    neovide
    picard
    prismlauncher
    seahorse
    swaynotificationcenter
    vesktop
    youtube-music

    ### User Facing CLI tools:
    btop
    grimblast
    hyprpicker
    playerctl
    radeontop
    swww
    wl-clipboard
    xclip

    colloid-kde
  ] ++ (with libsForQt5; [
    ark
    dolphin
    dolphin-plugins
    kdegraphics-thumbnailers
    #kwalletmanager
    breeze-icons
    qt5ct
    qtstyleplugin-kvantum
    qtstyleplugins
  ]) ++ (with kdePackages; [
    qt6ct
    qtstyleplugin-kvantum
  ]));

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/hypr/pfp.png".source = ./pfp.png;
  };

  home.sessionVariables = {
    PATH = "$PATH:$HOME/Scripts";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
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

  xdg.userDirs = {
    enable = true;
    desktop = null;
    publicShare = null;
  };

  programs = {
    librewolf = {
      enable = true;
      settings = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
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

    waybar.enable = true;
  };
}
