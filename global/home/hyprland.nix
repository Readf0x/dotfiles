{ pkgs, conf, config, lib, lib', ... }: let
  mLib = lib'.monitors;
  color = lib'.color.genFunctions config.lib.stylix.colors;
  inherit (color.hypr) rgb rgba;
  ifPlugin = plugin:
    if builtins.map (f: f.name) config.wayland.windowManager.hyprland.plugins |> builtins.elem plugin.name
    then true
    else false;
  pluginConfig = plugin: val:
    if (ifPlugin plugin)
    then val
    else null;
  font = {
    name = config.stylix.fonts.sansSerif.name;
    size = 11;
  };
in {
  home.packages = [
    pkgs.this.hypr-zoom
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = ["--all"];
    package = null;
    portalPackage = null;
    plugins = with pkgs.hyprlandPlugins; [
      # hyprwinwrap
      hy3
    ];
    settings = let
      music = "global, quickshell";
    in rec {
      #    ____         __              ____    __  __  _             
      #   / __/_ _____ / /____ __ _    / __/__ / /_/ /_(_)__  ___ ____
      #  _\ \/ // (_-</ __/ -_)  ' \  _\ \/ -_) __/ __/ / _ \/ _ `(_-<
      # /___/\_, /___/\__/\__/_/_/_/ /___/\__/\__/\__/_/_//_/\_, /___/
      #     /___/                                           /___/     

      # https://wiki.hyprland.org/Configuring/Monitors/
      monitor = mLib.map (i:
        # "${i.id}, ${mLib.toRes i.res}@${toString i.hz}, ${mLib.toRes' i.pos i.scl}, ${toString i.scl}, transform, ${toString i.rot}${if i.vrr then ", vrr, 1" else ""}${if i.hdr then ", bitdepth, 10" else ""}"
        "${i.id}, ${mLib.toRes i.res}@${toString i.hz}, ${mLib.toRes' i.pos i.scl}, ${toString i.scl}, transform, ${toString i.rot}"
      );

      # https://wiki.hyprland.org/Configuring/Environment-variables/
      env = [
        "HYPRCURSOR_SIZE, 24"
        "HYPRCURSOR_THEME, Bibata-Modern-Ice"
        "SAL_USE_VCLPLUGIN, qt6"
        "KRITA_NO_STYLE_OVERRIDE, 1"
        "REACTION_PATH, ${toString conf.homeDir}/Pictures/Reactions"
      # ] ++ (if lib.lists.any (x: x.hdr) conf.monitors then [
      #   "DXVK_HDR, 1"
      #   "ENABLE_HDR_WSI, 1"
      #   "PROTON_ENABLE_HDR, 1"
      # ] else []);
      ];

      #    __             __                  __  ____        __
      #   / /  ___  ___  / /__  ___ ____  ___/ / / __/__ ___ / /
      #  / /__/ _ \/ _ \/  '_/ / _ `/ _ \/ _  / / _// -_) -_) / 
      # /____/\___/\___/_/\_\  \_,_/_//_/\_,_/ /_/  \__/\__/_/  

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input = {
        follow_mouse = 1;
        # accel_profile = let
        #   points = lib'.bezier.over100 [0 0] [12 6] [2 7] [10 10];
        # in "custom 1 ${with builtins; genList (x: elemAt (lib'.bezier.findX x points) 1 |> toString) 10 |> concatStringsSep " "}";
        touchpad = {
          scroll_factor = 0.35;
          natural_scroll = true;
          disable_while_typing = false;
        };
      };
      device = [
        {
          name = "elan-trackpoint";
          sensitivity = -0.5;
        }
      ];

      # Removed in latest
      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      # gestures = {
      #   workspace_swipe = "on";
      #   workspace_swipe_fingers = 4;
      #   workspace_swipe_distance = 500;
      #   workspace_swipe_min_speed_to_force = 20;
      # };

      # https://wiki.hyprland.org/Configuring/Variables/#general
      general = rec {
        gaps_out = 4;
        gaps_in = gaps_out / 2;
        border_size = 1;
        "col.active_border" = rgb color.fg;
        "col.inactive_border" = "rgba(00000000)";

        layout =
          if (ifPlugin pkgs.hyprlandPlugins.hy3)
          then "hy3"
          else "dwindle";

        allow_tearing = false;
      };

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration = {
        rounding = 4;

        blur = {
          enabled = false;
          size = 3;
          passes = 2;
        };

        shadow = {
          enabled = false;
          range = 7;
          render_power = 3;
          color = rgba "1111119b";
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
        # vrr = lib.lists.any (x: x.vrr) conf.monitors;
        animate_manual_resizes = true;
      };
      # render = if lib.lists.any (x: x.hdr) conf.monitors then {
      #   direct_scanout = 1;
      #   cm_fs_passthrough = 1;
      # } else null;

      xwayland.force_zero_scaling = true;
      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      # experimental.xx_color_management_v4 = lib.lists.any (x: x.hdr) conf.monitors;

      # https://wiki.hyprland.org/Configuring/Animations/
      animations = {
        bezier = "curve, 0.05, 0.9, 0.1, 1";

        animation = [
          "windows, 1, 3, curve, slide"
          "fade, 1, 2, default"
          "workspaces, 1, 2, curve"
          "specialWorkspace, 1, 2, curve, slidevert"
        ];
      };

      group = {
        "col.border_active" = rgb "ffc24b";
        "col.border_inactive" = rgb "464646";
        groupbar = {
          render_titles = false;
          height = 1;
          "col.active" = rgb "ffc24b";
          "col.inactive" = rgba "46464655";
        };
      };

      # https://wiki.hyprland.org/Configuring/Dwindle-Layout/
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      cursor = {
        no_warps = true;
        warp_on_change_workspace = 2;
        zoom_disable_aa = true;
      };

      plugin = {
        # https://github.com/hyprwm/hyprland-plugins/blob/main/hyprbars/README.md
        hyprbars = pluginConfig pkgs.hyprlandPlugins.hyprbars {
          bar_color = rgb color.bg;
          bar_height = 15;
          "col.text" = rgb color.fg;
          bar_text_font = font.name;
          bar_padding = 2;
          bar_text_align = "left";
          bar_precedence_over_border = true;

          hyprbars-button = [
            "${rgb color.bg}, ${font.size}, x, hyprctl dispatch killactive, ${rgb color.fg}"
            "${rgb color.bg}, ${font.size}, f, hyprctl dispatch fullscreen 1, ${rgb color.fg}"
          ];
        };
        # https://github.com/outfoxxed/hy3/blob/master/README.md#config-fields
        hy3 = pluginConfig pkgs.hyprlandPlugins.hy3 {
          tabs = {
            padding = 4;

            border_width = general.border_size;
            radius = decoration.rounding;

            text_font = font.name;
            text_height = font.size;
            text_padding = 4;

            "col.active" = rgb color.bg;
            "col.active.border" = rgb color.fg;
            "col.active.text" = rgb color.fg;

            "col.focused" = rgb color.bg;
            "col.focused.border" = rgb color.fg;
            "col.focused.text" = rgb color.fg;

            "col.inactive" = rgb color.bg;
            "col.inactive.border" = rgb color.bg;
            "col.inactive.text" = rgb color.fg;

            "col.active_alt_monitor" = rgb color.bg;
            "col.active_alt_monitor.border" = rgb color.bg;
            "col.active_alt_monitor.text" = rgb color.fg;

            "col.urgent" = rgb color.bg;
            "col.urgent.border" = rgb color.red;
            "col.urgent.text" = rgb color.red;

            "col.locked" = rgb color.bg;
            "col.locked.border" = rgb color.blue;
            "col.locked.text" = rgb color.blue;

            blur = decoration.blur.enabled;
          };
        };
      };

      #    ___  _         __  
      #   / _ )(_)__  ___/ /__
      #  / _  / / _ \/ _  (_-<
      # /____/_/_//_/\_,_/___/

      # https://wiki.hyprland.org/Configuring/Binds/
      # Vars
      "$mod" = "SUPER";
      "$s" = "SHIFT";
      "$c" = "CTRL";
      "$a" = "ALT";
      "$hyper" = "SHIFT CTRL SUPER ALT";
      "$qs" = "bubbleshell";
      "$browser" = "firefox-esr";

      # [TODO] create vim binds
      bind = let
        prefix = if (ifPlugin pkgs.hyprlandPlugins.hy3) then "hy3:" else "";
      in [
        # IMPORTANT:
        "$hyper, L, exec, xdg-open https://linkedin.com/"

        # Applications
        "$mod, Return, exec, kitty"
        "$mod $a, Return, exec, kitty --config ${toString conf.homeDir}/.config/kitty/safe.conf"
        "$mod $s, Return, exec, kitty fish"
        "$mod, E, exec, dolphin"
        "$mod, W, exec, $browser"
        "$mod $a, W, exec, $browser -P I2P"
        "$mod $s, C, exec, hyprpicker -an"
        ", Print, exec, hyprshot -zsm region -f screenshot_$(date +%Y-%m-%d_%H-%m-%s).png -o ${toString conf.homeDir}/Pictures/Screenshots"
        "$s, Print, exec, hyprshot -zsm window -f screenshot_$(date +%Y-%m-%d_%H-%m-%s).png -o ${toString conf.homeDir}/Pictures/Screenshots"
        "$a, Print, exec, hyprshot -zsm output -f screenshot_$(date +%Y-%m-%d_%H-%m-%s).png -o ${toString conf.homeDir}/Pictures/Screenshots"
        "$mod, F4, exec, wlogout -p layer-shell -b 5 -c 10"
        "$mod, F5, exec, quickshell kill; $qs"
        "$mod, Escape, exec, hyprlock"
        "$mod, D, togglespecialworkspace, dropdown"
        "$mod, K, togglespecialworkspace, KeepassXC"
        "$mod $s, R, exec, ~/Scripts/wallpaper"
        "$mod, N, exec, swaync-client -t"
        "$mod $s, N, exec, swaync-client -C"
        "$mod, Escape, exec, hyprlock"
        "$mod, L, exec, lutris"
        ", XF86Tools, exec, pavucontrol"
        ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
        "$s, XF86Favorites, exec, ~/Scripts/player-info notify"
        "$a, XF86Favorites, exec, notify-send \"Current Battery Level: $(cat /sys/class/power_supply/BAT0/capacity)%\" -t 1000"

        # Media controls
        ", XF86AudioPlay, ${music}:playPause"
        "$mod, F10, ${music}:playPause"
        ", XF86AudioNext, ${music}:next"
        "$mod, End, ${music}:next"
        ", XF86AudioPrev, ${music}:previous"
        "$mod, Home, ${music}:previous"
        ", XF86Favorites, ${music}:nextPlayer"
        "$mod, Insert, ${music}:nextPlayer"
        "$mod $s, H, exec, ~/Scripts/audio"
        ", XF86AudioMute, exec, pactl set-sink-mute $(pactl get-default-sink) toggle"
        "$mod, Delete, exec, pactl set-sink-mute $(pactl get-default-sink) toggle"
        ", XF86AudioMicMute, exec, pactl set-source-mute $(pactl get-default-source) toggle"

        # Window management
        "$mod, Q, killactive,"
        ", F11, fullscreen, 0"
        "$mod, F11, fullscreen, 1"
        # "$mod, F11, exec, $qs ipc call"
        "$mod $s, Space, togglefloating,"
        "$mod $s, Space, ${music}:refreshToplevels"
        "$mod $s, P, pin,"
        "$mod $c, Home, centerwindow,"
        "$a, Tab, focusurgentorlast,"
        "$mod $a, left, swapwindow, l"
        "$mod $a, right, swapwindow, r"
        "$mod $a, up, swapwindow, u"
        "$mod $a, down, swapwindow, d"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
      ] ++ (
        if (ifPlugin pkgs.hyprlandPlugins.hy3) then [
          # Groups
          "$mod, T, hy3:changegroup, toggletab"
          "$mod $s, T, hy3:makegroup, tab"
          "$mod, G, hy3:makegroup, v"
          "$mod $s, G, hy3:makegroup, h"
          # Tabs
          "$mod $a, left, hy3:focustab, l, wrap"
          "$mod $a, right, hy3:focustab, r, wrap"
          # Window movement
          "$mod, left, hy3:movefocus, l, visible"
          "$mod, right, hy3:movefocus, r, visible"
          "$mod, up, hy3:movefocus, u, visible"
          "$mod, down, hy3:movefocus, d, visible"
          "$mod $s, left, hy3:movewindow, l"
          "$mod $s, right, hy3:movewindow, r"
          "$mod $s, up, hy3:movewindow, u"
          "$mod $s, down, hy3:movewindow, d"
        ] else [
          # Window movement
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod $s, left, movewindow, l"
          "$mod $s, right, movewindow, r"
          "$mod $s, up, movewindow, u"
          "$mod $s, down, movewindow, d"
        ]
      ) ++ [
        # [TODO] figure out how to swap windows without resizing
        # "$mod, S, swapwindow"

        "$mod, tab, movecurrentworkspacetomonitor, +1"
        "$mod, mouse_down, workspace, e-1"
        "$mod, mouse_up, workspace, e+1"

        "$mod, R, exec, rofi -show run"
      ] ++ (
        builtins.concatLists (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              toString (x + 1 - (c * 10));
          in [
            "$mod, ${ws}, workspace, ${toString (x + 1)}"
            "$mod SHIFT, ${ws}, ${prefix}movetoworkspace, ${toString (x + 1)}"
          ]
        )
        10)
      );
      binde = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ .10+ -l 1"
        "$s, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ .01+ -l 1"
        "$mod, page_up, exec, wpctl set-volume @DEFAULT_SINK@ .1+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ .10-"
        "$s, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ .01-"
        "$mod, page_down, exec, wpctl set-volume @DEFAULT_SINK@ .1-"

        "$mod $c, left, resizeactive, -60 0"
        "$mod $c, right, resizeactive, 60 0"
        "$mod $c, up, resizeactive, 0 -60"
        "$mod $c, down, resizeactive, 0 60"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      # temp
      bindr = [
        "$mod, Super_L, exec, pkill rofi || rofi -show drun"
        "$mod, mouse:272, ${music}:refreshToplevels"
      ];

      #    ______           __          
      #   / __/ /____ _____/ /___ _____ 
      #  _\ \/ __/ _ `/ __/ __/ // / _ \
      # /___/\__/\_,_/_/  \__/\_,_/ .__/
      #                          /_/    
      exec-once = [
        "clipse -listen"
        "hyprctl setcursor Bibata-Modern-Ice 24"
        "lxqt-policykit-agent"
        # "premid"
        "blueman-applet"
        "kdeconnect-indicator"
        "[workspace special:KeepassXC silent] keepassxc"
        "ping -w 1 discord.com && vesktop --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform-hint=auto"
        "qpwgraph -m"
        # **DO NOT ENABLE**
        # Steam uses a *shit ton* of power. Should only be opening when in use (on mobile devices)
        # "steam -silent"
        "swaync"
        "swww-daemon; sleep 2; wallpaper"
        "$qs"
        "zsh -c '\${$(realpath $(which kdeconnect-cli))%\"bin/kdeconnect-cli\"}libexec/kdeconnectd'"
        # "~/Scripts/start-mpd"
        # "${pkgs.kdePackages.kdeconnect-kde}/libexec/kdeconnectd"
        # "/run/wrappers/bin/gnome-keyring-daemon --start --foreground --components=secrets"
        "plasma-browser-integration-host"
      ];

      #  _      ___         __             ___       __      
      # | | /| / (_)__  ___/ /__ _    __  / _ \__ __/ /__ ___
      # | |/ |/ / / _ \/ _  / _ \ |/|/ / / , _/ // / / -_|_-<
      # |__/|__/_/_//_/\_,_/\___/__,__/ /_/|_|\_,_/_/\__/___/

      # https://wiki.hyprland.org/Configuring/Window-Rules
      workspace = [
        "special:dropdown, on-created-empty:kitty, gapsout:80"
        "special:KeepassXC, gapsout:80"
        "w[t1]s[false], gapsout:0, gapsin:0"
        "f[1]s[false], gapsout:0, gapsin:0"
      ];
      windowrule = [
        "bordersize 0, floating:0, onworkspace:w[t1]s[false]"
        "rounding 0, floating:0, onworkspace:w[t1]s[false]"
        "bordersize 0, floating:0, onworkspace:f[1]s[false]"
        "rounding 0, floating:0, onworkspace:f[1]s[false]"
        # Disallow auto maximize
        "suppressevent maximize activate activatefocus, class:(.*)"
        # Global Opacity
        # "opacity 0.8, class:(.*)"
        # No opacity on videos
        "opacity 1.0, class:^(mpv)$"
        "opacity 1.0, class:^(steam_app_.*)"
        "monitor ${(mLib.getId 0).id}, class:^(steam_app_.*)"
        "fullscreen, class:^(steam_app_.*)"
        "opacity 1.0, class:^(streaming_client)$"
        # Floating borders
        # "bordersize 1, onworkspace:special:dropdown"
        # "bordersize 1, onworkspace:special:KeepassXC"
        # "bordersize 1, floating:1"
        # "rounding 8, onworkspace:special:dropdown"
        # "rounding 8, onworkspace:special:KeepassXC"
        # "rounding 8, floating:1"
        # "noshadow, floating:0"
        # Disable blur on popups
        "noblur, class:^()$, title: ^()$"
        # Auth Window
        "float, title:^(Authentication Required)$"
        "size 327 198, title:^(Authentication Required)$"
        # Pavucontrol
        # "float, class:(pavucontrol)"
        # "size 700 500, class:(pavucontrol)"
        # "move 1208 51, class:(pavucontrol)"
        # "monitor ${(mLib.getId 0).id}, class:(pavucontrol)"
        # "animation slide, class:(pavucontrol)"
        # "opacity 1.0, class:(pavucontrol)"
        # Smile
        "float, class:(smile)"
        # Rofi
        "stayfocused, class:(Rofi)"
        "float, class:(Rofi)"
        # Vivaldi
        "tile, title:( - Vivaldi)$"
        "float, title:^(Vivaldi Settings)"
        # Dunst
        "opacity 0.75, class:(Dunst)"
        # Waydroid
        "fullscreen, class:^([w|W]aydroid.*)"
        # Picture in picture
        "float, title:^(Picture-in-Picture)$"
        "keepaspectratio, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"
        "opacity 1.0, title:^(Picture-in-Picture)$"
        # Gamescope
        "rounding 0, class:(gamescope)"
        "fullscreen, class:(gamescope)"
        "float, class:(gamescope)"
        "opacity 1.0, class:(gamescope)"
        # Steam
        "float, title:(Steam Settings)"
        "minsize 1 1, title:^()$,class:^(steam)$"
        # "center, title:^(Steam)$, class:^()$"
        # "center, class:^(steam)$"
        "monitor ${(mLib.getId 0).id}, class:(steam)"
        "noinitialfocus, title:^(notificationtoasts.*)$"
        # File dialogs
        "float, title:((Open|Save|Select) (File|As|(Background )?Image|Folder|Font.*))"
        "size 900 600, title:((Open|Save|Select) (File|As|(Background )?Image|Folder.*))"
        "center, title:((Open|Save|Select) (File|As|(Background )?Image|Folder|Font.*))"
        "float, class:(org.freedesktop.impl.portal.desktop.kde)"
        "size 900 600, class:(org.freedesktop.impl.portal.desktop.kde)"
        "center, class:(org.freedesktop.impl.portal.desktop.kde)"
        "center, title:( Image)$"
        # LibreOffice
        "size 900 600, class:(soffice)"
        "center, class:(soffice)"
        "float, class:(xdg-desktop-portal-gtk)"
        "size 900 600, class:(xdg-desktop-portal-gtk)"
        "center, class:(xdg-desktop-portal-gtk)"
        "size 239 122, title:^(Go to Page)$"
        "center, class:^()$, title:^(LibreOffice)$"
        # XWaylandVideoBridge
        "opacity 0.0 override 0.0 override, class:^(xwaylandvideobridge)$"
        "noanim, class:^(xwaylandvideobridge)$"
        "nofocus, class:^(xwaylandvideobridge)$"
        "noinitialfocus, class:^(xwaylandvideobridge)$"
        #"workspace special:hell silent, class:^(xwaylandvideobridge)$"
        #"workspace name:music, class:^(YouTube Music)$"
        #"workspace name:music, class:^(Dopamine)$"
        "float, title:^(Layer Select)$"
        "float, class:^(file-.*)"
        # Discord
        "monitor ${(mLib.getId 1).id}, class:^(discord)$"
        "suppressevent activate activatefocus, class:^(discord)$"
        "noinitialfocus, class:^(discord)$"
        "focusonactivate off, class:^(discord)$"
        # "monitor ${(mLib.getId 1).id}, class:^(vesktop)$"
        "workspace 2, class:^(vesktop)$"
        "noinitialfocus, class:^(vesktop)$"
        "focusonactivate off, class:^(vesktop)$"
        # Telegram
        "noanim, title:^(Media viewer)$, class:^(org.telegram.desktop)$"
        "float, title:^(Media viewer)$, class:^(org.telegram.desktop)$"
        "monitor ${(mLib.getId 1).id}, class:^(org.telegram.desktop)$"
        # ScrCpy
        "keepaspectratio, class:^(.scrcpy-wrapped)$"
        "pseudo, class:^(.scrcpy-wrapped)$"
        "opacity 1.0, class:^(.scrcpy-wrapped)$"
        # KDE Connect
        "float, class:^(org.kde.kdeconnect.handler)$"
        # Minecraft
      ] ++ (builtins.concatMap (
        x: [
          "float, title:${x}"
          "opacity 1.0, title:${x}"
          "fullscreen, title:${x}"
          "idleinhibit always, title:${x}"
          "immediate, title:${x}"
          "monitor ${(mLib.getId 0).id}, title:${x}"
        ]) [
          "^(Minecraft.*)"
          "^(BigChadGuys Plus .*)"
          "^(SteamPunk)$"
          "^(GT: New Horizons 2.7.2)$"
          "^(Raspberry Flavoured .*)"
        ]
      ) ++ [
        # Half Life
        "fullscreen, class:^(hl2_linux)$"
        "opacity 1.0, class:^(hl2_linux)$"
        # Kitty
        "float, title:^(cava)$"
        "size 1320 623, title:^(cava)$"
        "center, title:^(cava)$"
        # Calculator
        "float, class:^(org.gnome.Calculator)$"
        # Zenity
        "float, class:(zenity)"
        # Ark
        "float, title:(File Already Exists — Ark)"
        "float, class:^(org.kde.ark)$, title:^(Extracting.* — Ark)"
        # Thunar
        "float, class:(thunar), title:(File Operation Progress|Confirm to replace files)"
        "float, class:(org.kde.polkit-kde-authentication-agent-1)"
        # Yad
        "float, class:(yad)"
        # Vortex
        "tile, title:(Vortex)"
        "workspace special:hell silent, title:(Wine System Tray)"
        "center, class:^(vortex.exe)$, title:^(Open)$"
        # Blender
        "float, title:(Blender Preferences)"
        # Krita
        "noblur, class:(krita)"
        # Screenpen
        "float, class:(python3), initialTitle:(screenpen)"
        "noanim, class:(python3), initialTitle:(screenpen)"
        # FontForge
        "float, class:(fontforge)"
        "tile, class:(fontforge), title:^([^ ]+  [^ ]+\\.[^ ]+ ([^ ]+))$"
        # Blockbench
        "float, class:^(blockbench)$, title:^()$"
        "size 900 600, class:(blockbench), title:^()$"
        "center, class:(blockbench), title:^()$"
        # Zotero
        "float, class:^(Zotero)$, title:^(?!Zotero)"
        "center, class:^(Zotero)$, title:^(?!Zotero)"
        # VLC
        "noblur, class:vlc"
        # Dolphin
        "float, class:^(org.kde.dolphin)$, title:((Creating directory|Progress Dialog|Deleting|Copying|Moving|Compressing a file \\(\\d+%\\)) — Dolphin)"
        "idleinhibit, class:^(org.kde.dolphin)$, title:((Creating directory|Progress Dialog|Deleting|Copying|Moving) — Dolphin)"
        "size 1100 733, class:^(org.kde.dolphin)$, title:^(Configure( Toolbars)? — Dolphin)$"
        # Excalidraw
        "tile, class:^(Chromium)$, title:^(Excalidraw)$"
        # Evolution
        #"workspace name:mail, class:^(evolution)$"
        "noinitialfocus, class:^(evolution)$"
        "float, title:^(?!Mail|Inbox).*$, class:^(evolution)$"
        "size 1000 650, title:^(?!Mail|Inbox).*$, class:^(evolution)$"
        "center, title:^(?!Mail|Inbox).*$, class:^(evolution)$"
        "tile, title:^(Compose Message)$, class:^(evolution)$"
        "float, class:^(evolution-alarm-notify)$"
        "size 500 400, class:^(evolution-alarm-notify)$"
        "center, class:^(evolution-alarm-notify)$"
        "pin, class:^(evolution-alarm-notify)$"
        # Firefox
        "float, title:(Close Firefox)"
        "opacity 1.0, title:.*(YouTube|Twitch|Figma).*, class:^(firefox-esr)$"
        "opacity 1.0, title:.*(YouTube|Twitch|Figma).*, class:^(firefox)$"
        # Figma Linux
        "opacity 1.0, class:^(figma-linux)$"
        # Godot
        "tile, class:(Godot_Engine), title:(Godot)"
        "tile, class:(\\w+), title:(Godot)"
        "opacity 1.0, class:(Godot_Engine), title:(Godot)"
        "opacity 1.0, class:(\\w+), title:(Godot)"
        # Gimp
        "center, title:^(Export Image as), class:^(Gimp-2.10)$"
        "center, title:^(Quit GIMP)$, class:^(Gimp-2.10)$"
        "opacity 1.0, class:^(gimp)"
        "suppressevent activate activatefocus, class:^(gimp)"
        # KeepassXC
        "workspace special:KeepassXC, class:^(org.keepassxc.KeePassXC)$"
        "float, class:^(org.keepassxc.KeePassXC)$, title:^(Generate Password)$"
        # Obsidian
        "suppressevent activatefocus, class:^(obsidian)$"
        # TCG
        "opacity 1.0, class:^(card shop simulator.exe)$"
        # Hexchat
        "center, class:^(Hexchat)$, title:( - HexChat)$"
        # Assassin's Creed IV Black Flag
        "idleinhibit, title:^(Assassin's Creed IV Black Flag)$"
        "idleinhibit, class:^(steam_app_default)$"
        # Dragon Drop
        "center, class:^(Dragon-drop)$"
        # IDEA
        "float, class:^(jetbrains-idea-ce)$, title:^(Welcome to IntelliJ IDEA)$"
        # VOTV
        "fullscreen, class:^(votv-win64-shipping.exe)$"
        "opacity 1.0, class:^(votv-win64-shipping.exe)$"
        # CEMU
        "opacity 1.0, title:^(Cemu 2.5 - .*)$"
        # Virt Manager
        "opacity 1.0, class:^(.virt-manager-wrapped)$, title:^(.* on .*)$"
        # Kdenlive
        "opacity 1.0, class:^(org.kde.kdenlive)$"
        # qView
        "suppressevent fullscreen, class:^(com.interversehq.qView)$"
        # limo
        "float, class:^(limo)$, title:^(New Application|Settings|Install Mod|Add to Group)$"
        # GZDoom
        "float, class:^(gzdoom)$"
        # Photoshop
        "suppressevent activate activatefocus, class:^(Adobe Photoshop 2025)"
        # Hyprland desktop portal
        "float, title:^(Select what to share)$"
      ];
    };
  };
  programs.hyprlock = {
    # [TODO] change to quickshell
    #    __            __     ____                   
    #   / /  ___  ____/ /__  / __/__________ ___ ___ 
    #  / /__/ _ \/ __/  '_/ _\ \/ __/ __/ -_) -_) _ \
    # /____/\___/\__/_/\_\ /___/\__/_/  \__/\__/_//_/

    # https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/
    enable = true;
    settings = {
      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 2;
          blur_size = 3;
        }
      ];
      input-field = [
        {
          monitor = (mLib.getId 0).id;
          size = "800, 30";
          outline_thickness = 2;
          dots_size = 0.33;
          dots_spacing = 0.15;
          dots_center = true;
          dots_rounding = -1;
          outer_color = rgb color.fg;
          inner_color = rgb color.bg2;
          font_color = rgb color.fg;
          fade_on_empty = false;
          fade_timeout = 1000;
          placeholder_text = ''<span foreground="#${color.hash.fg0}" style="italic" font_size="11pt">Input Password...</span>'';
          hide_input = false;
          rounding = 0;
          check_color = rgb color.blue;
          fail_color = rgb color.red;
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          fail_transition = 300;
          capslock_color = -1;
          numlock_color = -1;
          bothlock_color = -1;
          invert_numlock = false;
          swap_font_color = false;
          position = "0, -120";
          halign = "center";
          valign = "center";
        }
      ];
      image = [
        {
          monitor = (mLib.getId 0).id;
          path = "/home/${conf.user}/.face.icon";
          size = 256;
          rounding = 0;
          border_size = 2;
          border_color = rgb color.fg;
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
      label = [
        {
          monitor = (mLib.getId 0).id;
          text = "$USER";
          color = rgb color.fg;
          font_size = 13;
          font_family = "Courier";
          position = "0, -60";
          halign = "center";
          valign = "center";
        }
        {
          monitor = (mLib.getId 0).id;
          text = "cmd[update:1000] date +%I:%M\\ %p";
          color = rgb color.fg;
          font_size = 16;
          font_family = "Courier20";
          position = "-10, -10";
          halign = "right";
          valign = "top";
        }
        {
          monitor = (mLib.getId 0).id;
          text = "cmd[update:60000] date +%D";
          color = rgb color.fg;
          font_size = 13;
          font_family = "Courier";
          position = "-10, -30";
          halign = "right";
          valign = "top";
        }
      ];
    };
  };
  # home.packages = [ pkgs.hypridle ];
  services.hypridle = {
    enable = true;
    # systemdTarget = "hyprland-session.target";
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        unlock_cmd = "pkill -USR1 hyprlock";
        before_sleep_cmd = "loginctl lock-session";
      };
      listener = [
        {
          timeout = 1800;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 2700;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
