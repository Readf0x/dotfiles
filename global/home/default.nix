{ pkgs, conf, lib, self, inputs, config, ... }: rec {

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
    extraActivationPath = with pkgs; [
      openssh
    ];

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
      kdePackages.breeze
      kdePackages.breeze.qt5
      kdePackages.breeze-gtk
      fd
    ];

    sessionVariables = {
      PATH = "$PATH:$HOME/Scripts";
      REPOS = "${toString conf.homeDir}/Repos";
      WINEDLLPATH = "${pkgs.this.discord-rpc}/share/winedll/discord-rpc";
      LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [ kdePackages.qtbase libpulseaudio openal flite ] + ":$LD_LIBRARY_PATH";
      EDITOR = "nvim";
      VISUAL = "nvim";
      SSH_ASKPASS = "${pkgs.x11_ssh_askpass}/libexec/ssh-askpass";
    };
  };

  gtk = {
    enable = true;
    theme = lib.mkIf (!stylix.targets.gtk.enable) {
      name = "Everforest-Dark-B";
      package = pkgs.everforest-gtk-theme;
    };
    iconTheme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-icon-theme;
    };
  };

  xdg = {
    userDirs = {
      enable = true;
      desktop = null;
      publicShare = null;
    };
    desktopEntries = {
      reactions = {
        name = "Siffrin Jail";
        exec = "reactions";
      };
    };
  };

  programs = {
    rofi.enable = true;

    home-manager.enable = true;

    nixvim = {
      enable = true;
    } // import ./nixvim.nix { inherit pkgs self inputs config; };

    mpv = {
      enable = true;
      package = pkgs.mpv.override {
        scripts = with pkgs.mpvScripts; [
          mpris
          uosc
        ];
      };
      config = {
        script-opts = "ytdl_hook-ytdl_path=${pkgs.yt-dlp}/bin/yt-dlp";
        ytdl-format = "bestvideo[height<=?720][fps<=?30][vcodec!=?vp9]+bestaudio/best";
      };
    };
  };

  stylix.targets = {
    hyprpaper.enable = lib.mkForce false;
    hyprland.enable = false;
    nixvim.enable = false;
    waybar.enable = false;
    #kitty.enable = false;
    hyprlock.enable = false;
    gtk = {
      enable = true;
      extraCss = ''
        window {
          background-color: @window_bg_color;
        }
      '';
    };
  };
}
