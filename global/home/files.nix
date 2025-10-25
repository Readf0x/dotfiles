{ pkgs, stable, lib, conf, config, ... }: {
  home.file = {
    ".face.icon".source = ./../img/pfp.png;
    ".config/hypr/wallpapers".source = "${pkgs.wallpapers}";
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
    ".config/Kvantum/Colloid".source = "${stable.colloid-kde}/share/Kvantum/Colloid";
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
    ".config/qt5ct/qt5ct.conf".text = ''
      [Appearance]
      color_scheme_path=/home/readf0x/.config/qt5ct/style-colors.conf
      custom_palette=true
      icon_theme=Colloid-Dark
      standard_dialogs=default
      style=kvantum-dark

      [Fonts]
      fixed="Courier,10,-1,5,50,0,0,0,0,0,Regular"
      general="Ubuntu,10,-1,5,50,0,0,0,0,0,Regular"

      [Interface]
      activate_item_on_single_click=1
      buttonbox_layout=0
      cursor_flash_time=1000
      dialog_buttons_have_icons=1
      double_click_interval=400
      gui_effects=@Invalid()
      keyboard_scheme=2
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      stylesheets=@Invalid()
      toolbutton_style=4
      underline_shortcut=1
      wheel_scroll_lines=3

      [SettingsWindow]
      geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\a\x80\0\0\0\0\0\0\v8\0\0\x4\xf\0\0\a\x80\0\0\0\0\0\0\v?\0\0\x4\x17\0\0\0\0\x2\0\0\0\a\x80\0\0\a\x80\0\0\0\0\0\0\v8\0\0\x4\xf)

      [Troubleshooting]
      force_raster_widgets=1
      ignored_applications=@Invalid()
    '';
    ".config/qt6ct/qt6ct.conf".text = ''
      [Appearance]
      color_scheme_path=/home/readf0x/.config/qt6ct/style-colors.conf
      custom_palette=true
      icon_theme=Colloid-Dark
      standard_dialogs=default
      style=kvantum-dark

      [Fonts]
      fixed="Courier,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"
      general="Ubuntu,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"

      [Interface]
      activate_item_on_single_click=1
      buttonbox_layout=0
      cursor_flash_time=1000
      dialog_buttons_have_icons=1
      double_click_interval=400
      gui_effects=@Invalid()
      keyboard_scheme=2
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      stylesheets=@Invalid()
      toolbutton_style=4
      underline_shortcut=1
      wheel_scroll_lines=3

      [SettingsWindow]
      geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\a\x80\0\0\0\0\0\0\v8\0\0\x4\xf\0\0\a\x80\0\0\0\0\0\0\v8\0\0\x4\xf\0\0\0\0\x2\0\0\0\a\x80\0\0\a\x80\0\0\0\0\0\0\v8\0\0\x4\xf)

      [Troubleshooting]
      force_raster_widgets=1
      ignored_applications=/run/current-system/sw/bin/kdenlive
    '';
    ".config/Vencord/themes/system24-vencord.theme.css".text =
      lib.replaceStrings [
        "@FONT-PRIMARY"
        "@FONT-DISPLAY"
        "@FONT-CODE"

        "@BLACK"
        "@BRIGHT-BLACK"
        "@GREY"
        "@BRIGHTER-GREY"
        "@BRIGHT-GREY"
        "@WHITE"
        "@BRIGHTER-WHITE"
        "@BRIGHT-WHITE"
        "@RED"
        "@ORANGE"
        "@YELLOW"
        "@GREEN"
        "@CYAN"
        "@BLUE"
        "@PURPLE"
        "@MAGENTA"
      ] (
        ([
          "sansSerif"
          "sansSerif"
          "monospace"
        ] |> map (v: config.stylix.fonts.${v}.name))
        ++ ([
          "base00"
          "base01"
          "base02"
          "base03"
          "base04"
          "base05"
          "base06"
          "base07"
          "base08"
          "base09"
          "base0A"
          "base0B"
          "base0C"
          "base0D"
          "base0E"
          "base0F"
        ] |> map (v: "#${config.lib.stylix.colors.${v}}"))
      ) <|
      builtins.readFile ./system24-vencord.theme.css;
    # ".ssh/config".text = ''
    #   Host Loki-II
    #     HostName 10.1.11.104
    #   Host Loki-IV
    #     HostName 10.1.11.100
    # '';
  } // (lib.mapAttrs' (n: v: lib.nameValuePair "Scripts/${n}" { source = builtins.toPath "${builtins.toString ./..}/scripts/${n}"; }) (builtins.readDir ../scripts));
}
