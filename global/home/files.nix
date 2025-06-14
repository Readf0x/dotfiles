{ pkgs, lib, conf, inputs, ... }: {
  home.file = {
    ".face.icon".source = ./../img/pfp.png;
    ".config/hypr/wallpapers".source = "${inputs.wallpapers.packages.${conf.system}.default}";
    # "Scripts".source = ./../scripts;
    "Scripts/wallpaper" = {
      text = ''
        #!/usr/bin/env zsh
        # local arr=($(find -H "$HOME/.config/hypr/wallpapers" -name '*.jpg'))
      '' + (lib.concatStringsSep "\n" (lib.imap0 (i: v:
        "swww img -t none -o ${v.id} ~/.config/hypr/wallpapers/${builtins.toString i}.jpg"
      ) conf.monitors));
      executable = true;
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
    ".config/bat/config".text = ''
      --theme="base16"
    '';
    # ".ssh/config".text = ''
    #   Host Loki-II
    #     HostName 10.1.11.104
    #   Host Loki-IV
    #     HostName 10.1.11.100
    # '';
    ".reload" = {
      source = "${inputs.neoshell.packages.${conf.system}.default}/bin/neoshell";
      onChange = ''
        pkill quickshell
        ${inputs.neoshell.packages.${conf.system}.default}/bin/neoshell -d
      '';
    };
  } // (lib.mapAttrs' (n: v: lib.nameValuePair "Scripts/${n}" { source = builtins.toPath "${builtins.toString ./..}/scripts/${n}"; }) (builtins.readDir ../scripts));
}
