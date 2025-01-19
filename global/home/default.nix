{ pkgs, conf, lib, self, ... }: {

  nixpkgs = {
    config.allowUnfree = true;
  };

  imports = [
    ./../shared/stylix.nix
    ./hyprland.nix
    ./nixvim.nix
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
      ".face.icon".source = ./../img/pfp.png;
      ".config/hypr/wallpapers".source = ./../img/wallpapers;
      "Scripts".source = ./../scripts;
      ".librewolf/${conf.librewolfProfile}/chrome".source = pkgs.fetchFromGitHub {
        owner = "readf0x";
        repo = "Firefox-Mod-Blur";
        rev = "ddad9e40fa0d27d7b94e4bb719124f0cc2808137";
        hash = "sha256-Hndp/FEGhzRfMgIIokGgfcY8vcdLD3My97yL0vsITvs=";
      };
      ".local/share/lutris/runners/xemu/xemu".source = "${pkgs.xemu}/bin/xemu";
      ".local/share/kio/servicemenus/dragon.desktop".text = ''
        [Desktop Entry]
        Type=Service
        MimeType=application/octet-stream
        Actions=dragonX

        [Desktop Action dragonX]
        Name=Drag And Drop (X11)
        Icon=edit-move
        Exec=env WAYLAND_DISPLAY= dragon %U
      '';
      ".config/Kvantum/Colloid".source = "${pkgs.colloid-kde}/share/Kvantum/Colloid";
      ".config/mpd/mpd.conf".text = ''
        music_directory "~/Music"
        playlist_directory "~/.mpd/playlists"
        db_file "~/.mpd/database"
        log_file "~/.mpd/log"
        pid_file "~/.mpd/pid"
        state_file "~/.mpd/state"
        sticker_file "~/.mpd/sticker.sql"
      '';
      ".gitconfig".text = ''
        [delta]
          # author: https://github.com/anthony-halim
          dark = true
          syntax-theme = Nord
          file-added-label = [+]
          file-copied-label = [==]
          file-modified-label = [*]
          file-removed-label = [-]
          file-renamed-label = [->]
          file-style = omit
          hunk-header-decoration-style = 
          hunk-header-file-style = blue italic
          hunk-header-line-number-style = yellow box bold
          hunk-header-style = file line-number syntax bold italic
          plus-style = green
          plus-emph-style = black green
          minus-style = red
          minus-emph-style = black red
          line-numbers = true
          line-numbers-minus-style = red
          line-numbers-plus-style = green
          line-numbers-left-format = "{nm} "
          line-numbers-right-format = "{np} "
          line-numbers-left-style = cyan
          line-numbers-right-style = cyan
          line-numbers-zero-style = blue dim
          zero-style = syntax
          whitespace-error-style = black bold
          blame-code-style = syntax
          blame-format = "{author:<18} {commit:<6} {timestamp:<15}"
          blame-palette = brightcyan cyan cyan
          merge-conflict-begin-symbol = ~
          merge-conflict-end-symbol = ~
          merge-conflict-ours-diff-header-style = yellow bold
          merge-conflict-ours-diff-header-decoration-style = blue box
          merge-conflict-theirs-diff-header-style = yellow bold
          merge-conflict-theirs-diff-header-decoration-style = blue box
      '';
    };

    sessionVariables = {
      PATH = "$PATH:$HOME/Scripts";
      WINEDLLPATH = "${self.packages.${conf.system}.discord-rpc}/share/winedll/discord-rpc";
      LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.kdePackages.qtbase ] + ":$LD_LIBRARY_PATH";
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

    waybar.enable = true;
  };

  stylix.targets = {
    kde.enable = false;
    hyprpaper.enable = lib.mkForce false;
    hyprland.enable = false;
    nixvim.enable = false;
    waybar.enable = false;
    #kitty.enable = false;
    hyprlock.enable = false;
  };
}
