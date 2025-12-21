{ pkgs, lib, config, ... }: {
  home.file = {
    ".face.icon".source = ./../img/pfp.png;
    # "Scripts".source = ./../scripts;
    "Scripts/wallpaper" = {
      text = ''
        #!/usr/bin/env sh
        swww img -t none ${pkgs.bubbleshell.bubble-config}/img/wallpaper.png
      '';
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
      Exec=env WAYLAND_DISPLAY= dragon-drop %U
    '';
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
        syntax-theme = base16
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
    ".local/share/nvim/highlights.vim".text = let
      colors = config.lib.stylix.colors;
      color = hx: "#${colors."base${hx}"}";
    in ''
      hi TSVariable guifg=${color "0D"}
      hi TSMethod guifg=${color "0B"}
      hi TSString guifg=${color "09"}
      hi TSKeyword guifg=${color "0F"}
      hi TSFunction guifg=${color "0B"}
      hi TSComment guifg=${color "04"}
      hi LineNr guifg=${color "03"}
      hi NormalFloat guibg=${color "01"}
      hi Pmenu guifg=${color "05"} guibg=${color "01"}
      hi Statement gui=italic cterm=italic
      hi @property.jsonc guifg=${color "0D"} ctermfg=81
      hi TSTag guifg=${color "05"}
      hi @tag.html guifg=${color "05"}
      hi @tag.templ guifg=${color "08"}
      hi htmlTag guifg=${color "05"}
      hi htmlEndTag guifg=${color "05"}
      hi @punctuation.delimiter.jsdoc guifg=${color "05"}
      hi @string.special.templ guifg=${color "05"}
    '';
    "Scripts/.directory".text = ''
      [Desktop Entry]
      Icon=folder-script
    '';
    "Documents/.directory".text = ''
      [Desktop Entry]
      Icon=folder-documents
    '';
    "Downloads/.directory".text = ''
      [Desktop Entry]
      Icon=folder-downloads
    '';
    "Games/.directory".text = ''
      [Desktop Entry]
      Icon=folder-games
    '';
    "Music/.directory".text = ''
      [Desktop Entry]
      Icon=folder-music
    '';
    "Pictures/.directory".text = ''
      [Desktop Entry]
      Icon=folder-pictures
    '';
    "Repos/.directory".text = ''
      [Desktop Entry]
      Icon=folder-git
    '';
    "Videos/.directory".text = ''
      [Desktop Entry]
      Icon=folder-videos
    '';
    ".steam/.directory".text = ''
      [Desktop Entry]
      Icon=folder-steam
    '';
    ".wine/.directory".text = ''
      [Desktop Entry]
      Icon=folder-wine
    '';
  } // (lib.mapAttrs' (n: v: lib.nameValuePair "Scripts/${n}" { source = builtins.toPath "${toString ./..}/scripts/${n}"; }) (builtins.readDir ../scripts));
}
