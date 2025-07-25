{ pkgs, conf, config, lib, lib', pkgs', ... }: let
  mLib = lib'.monitors;
  monitor = mLib.getId;
  rgb = col: "rgb(${col})";
  rgba = col: "rgba(${col})";
  colors = config.lib.stylix.colors;
  ifPlugin = plugin: val: if builtins.elem plugin.name (builtins.map (f: f.name) config.wayland.windowManager.hyprland.plugins) then val else null;
in {
  home.packages = [
    pkgs'.hypr-zoom
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = ["--all"];
    package = null;
    portalPackage = null;
    plugins = with pkgs.hyprlandPlugins; [
      hyprwinwrap
    ];
    settings = {
      #    ____         __              ____    __  __  _             
      #   / __/_ _____ / /____ __ _    / __/__ / /_/ /_(_)__  ___ ____
      #  _\ \/ // (_-</ __/ -_)  ' \  _\ \/ -_) __/ __/ / _ \/ _ `(_-<
      # /___/\_, /___/\__/\__/_/_/_/ /___/\__/\__/\__/_/_//_/\_, /___/
      #     /___/                                           /___/     

      # https://wiki.hyprland.org/Configuring/Monitors/
      monitor = mLib.map (i:
        "${i.id}, ${mLib.toRes i.res}@${builtins.toString i.hz}, ${mLib.toRes i.pos}, ${builtins.toString i.scl}, transform, ${builtins.toString i.rot}"
      );

      # https://wiki.hyprland.org/Configuring/Environment-variables/
      env = [
        "HYPRCURSOR_SIZE, 24"
        "HYPRCURSOR_THEME, Bibata-Modern-Ice"
        "SAL_USE_VCLPLUGIN, qt6"
        "KRITA_NO_STYLE_OVERRIDE, 1"
      ];

      #    __             __                  __  ____        __
      #   / /  ___  ___  / /__  ___ ____  ___/ / / __/__ ___ / /
      #  / /__/ _ \/ _ \/  '_/ / _ `/ _ \/ _  / / _// -_) -_) / 
      # /____/\___/\___/_/\_\  \_,_/_//_/\_,_/ /_/  \__/\__/_/  

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input = {
        follow_mouse = 1;
        #accel_profile = "custom 1 ${with builtins; concatStringsSep " " (genList (x: toString (x * x)) 5)}";
        accel_profile = let
          points = lib'.bezier.over100 [0 0] [12 6] [2 7] [10 10];
        in "custom 1 ${with builtins; concatStringsSep " " (genList (x: toString (elemAt (lib'.bezier.findX x points) 1)) 10)}";
        touchpad = {
          scroll_factor = 0.1;
          natural_scroll = true;
          disable_while_typing = false;
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      gestures = {
        workspace_swipe = "on";
        workspace_swipe_fingers = 4;
        workspace_swipe_distance = 500;
        workspace_swipe_min_speed_to_force = 20;
      };

      # https://wiki.hyprland.org/Configuring/Variables/#general
      general = {
        gaps_in = 1;
        gaps_out = 2;
        border_size = 2;
        "col.active_border" = rgb "FFF0E7";
        "col.inactive_border" = rgb "FFF0E7";

        layout = "dwindle";

        allow_tearing = false;
      };

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration = {
        rounding = 0;

        blur = {
          enabled = false;
          size = 3;
          passes = 2;
          new_optimizations = "on";
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
      };
      xwayland.force_zero_scaling = true;
      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      experimental.xx_color_management_v4 = lib.lists.any (x: x.hdr) conf.monitors;

      # https://wiki.hyprland.org/Configuring/Animations/
      animations = {
        bezier = "curve, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 0, 6, curve, slide"
          "fade, 0, 4, default"
          "workspaces, 0, 4, curve"
          "specialWorkspace, 0, 4, curve, slidevert"
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
      };

      # https://github.com/hyprwm/hyprland-plugins/blob/main/hyprbars/README.md
      plugin.hyprbars = ifPlugin pkgs.hyprlandPlugins.hyprbars {
        bar_color = rgb colors.base00;
        bar_height = 15;
        "col.text" = rgb colors.base05;
        bar_text_font = "Courier13";
        bar_padding = 2;
        bar_text_align = "left";
        bar_precedence_over_border = true;

        hyprbars-button = [
          "${rgb colors.base00}, 11, , hyprctl dispatch killactive, ${rgb colors.base05}"
          "${rgb colors.base00}, 11, , hyprctl dispatch fullscreen 1, ${rgb colors.base05}"
        ];
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
      "$music" = "neoshell ipc call player";
      "$browser" = "firefox-esr";

      # [TODO] create vim binds
      bind = [
        # IMPORTANT:
        "$hyper, L, exec, xdg-open https://linkedin.com/"

        # Applications
        "$mod, Return, exec, kitty"
        "$mod $s, Return, exec, kitty --config ${builtins.toString conf.homeDir}/.config/kitty/safe.conf"
        "$mod, E, exec, dolphin"
        "$mod, W, exec, $browser"
        "$mod $a, W, exec, $browser -P I2P"
        "$mod $s, C, exec, hyprpicker -an"
        ", Print, exec, hyprshot -zsm region -f screenshot_$(date +%Y-%m-%d_%H-%m-%s).png -o ${builtins.toString conf.homeDir}/Pictures/Screenshots"
        "$s, Print, exec, hyprshot -zsm window -f screenshot_$(date +%Y-%m-%d_%H-%m-%s).png -o ${builtins.toString conf.homeDir}/Pictures/Screenshots"
        "$a, Print, exec, hyprshot -zsm output -f screenshot_$(date +%Y-%m-%d_%H-%m-%s).png -o ${builtins.toString conf.homeDir}/Pictures/Screenshots"
        "$mod, F4, exec, wlogout -p layer-shell -b 5 -c 10"
        "$mod, F5, exec, neoshell kill; neoshell"
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

        # Media controls
        ", XF86AudioPlay, exec, $music playPause"
        "$mod, F10, exec, $music playPause"
        ", XF86AudioNext, exec, $music next"
        "$mod, End, exec, $music next"
        ", XF86AudioPrev, exec, $music previous"
        "$mod, Home, exec, $music previous"
        ", XF86Favorites, exec, $music nextPlayer"
        "$mod, Insert, exec, $music nextPlayer"
        "$mod $s, Insert, exec, neoshell ipc call popup toggleVisible"
        "$s, XF86Favorites, exec, ~/Scripts/player-info notify"
        "$a, XF86Favorites, exec, notify-send \"Current Battery Level: $(cat /sys/class/power_supply/BAT0/capacity)%\" -t 1000"
        "$mod $s, H, exec, ~/Scripts/audio"
        ", XF86AudioMute, exec, pactl set-sink-mute $(pactl get-default-sink) toggle"
        "$mod, Delete, exec, pactl set-sink-mute $(pactl get-default-sink) toggle"
        ", XF86AudioMicMute, exec, pactl set-source-mute $(pactl get-default-source) toggle"

        # Window management
        "$mod, Q, killactive,"
        ", F11, fullscreen, 0"
        "$mod, M, fullscreen, 1"
        "$mod $s, Space, togglefloating,"
        "$mod $s, P, pin,"
        "$mod $c, Home, centerwindow,"
        "$a, Tab, focusurgentorlast,"
        "$mod $a, left, swapwindow, l"
        "$mod $a, right, swapwindow, r"
        "$mod $a, up, swapwindow, u"
        "$mod $a, down, swapwindow, d"
        # Dwindle
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        # Window movement
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod $s, left, movewindow, l"
        "$mod $s, right, movewindow, r"
        "$mod $s, up, movewindow, u"
        "$mod $s, down, movewindow, d"
        # [TODO] figure out how to swap windows without resizing
        # "$mod, S, swapwindow"

        #"$mod, I, workspace, name:info"
        #"$mod, Y, workspace, name:music"
        #"$mod, S, workspace, name:video"
        #"$mod $s, S, movetoworkspace, name:video"
        #"$mod $s, D, workspace, name:discord"
        #"$mod $s, M, workspace, name:mail"

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
              builtins.toString (x + 1 - (c * 10));
          in [
            "$mod, ${ws}, workspace, ${toString (x + 1)}"
            "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ]
        )
        10)
      );
      binde = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ .1+"
        "$mod, page_up, exec, wpctl set-volume @DEFAULT_SINK@ .1+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ .1-"
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
      ];

      #    ______           __          
      #   / __/ /____ _____/ /___ _____ 
      #  _\ \/ __/ _ `/ __/ __/ // / _ \
      # /___/\__/\_,_/_/  \__/\_,_/ .__/
      #                          /_/    
      exec-once = [
        "balooctl6 enable"
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
        "neoshell"
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
        "name:music, monitor:${(monitor 1).id}, on-created-empty:youtube-music"
        "name:discord, monitor:${(monitor 1).id}, on-created-empty:vesktop"
        "name:info, monitor:${(monitor 1).id}, on-created-empty:kitty btop"
        "name:video, monitor:${(monitor 1).id}"
        "name:mail, monitor:${(monitor 1).id}, on-created-empty:evolution"
      ];
      windowrulev2 = [
        # Disallow auto maximize
        "suppressevent maximize activate activatefocus, class:(.*)"
        # Global Opacity
        # "opacity 0.8, class:(.*)"
        # No opacity on videos
        "opacity 1.0, class:^(mpv)$"
        "opacity 1.0, class:^(steam_app_.*)"
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
        "float, class:(pavucontrol)"
        "size 700 500, class:(pavucontrol)"
        "move 1208 51 class:(pavucontrol)"
        "monitor ${(monitor 0).id}, class:(pavucontrol)"
        "animation slide, class:(pavucontrol)"
        "opacity 1.0, class:(pavucontrol)"
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
        "center, title:^(Steam)$, class:^()$"
        "center, class:^(steam)$"
        "monitor ${(monitor 0).id}, class:(steam)"
        "noinitialfocus, title:^(notificationtoasts.*)$"
        # "fullscreen, class:^(steam_app_.*)"
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
        "monitor ${(monitor 1).id}, class:^(discord)$"
        "suppressevent activate activatefocus, class:^(discord)$"
        "noinitialfocus, class:^(discord)$"
        "focusonactivate off, class:^(discord)$"
        # "monitor ${(monitor 1).id}, class:^(vesktop)$"
        "workspace 2, class:^(vesktop)$"
        "noinitialfocus, class:^(vesktop)$"
        "focusonactivate off, class:^(vesktop)$"
        # Telegram
        "noanim, title:^(Media viewer)$, class:^(org.telegram.desktop)$"
        "float, title:^(Media viewer)$, class:^(org.telegram.desktop)$"
        "monitor ${(monitor 1).id}, class:^(org.telegram.desktop)$"
        # ScrCpy
        "keepaspectratio, class:^(.scrcpy-wrapped)$"
        "pseudo, class:^(.scrcpy-wrapped)$"
        "opacity 1.0, class:^(.scrcpy-wrapped)$"
        # KDE Connect
        "float, class:^(org.kde.kdeconnect.handler)$"
        # Minecraft
      ] ++ (builtins.concatMap (
        x: [
          "opacity 1.0, class:${x}"
          "fullscreen, class:${x}"
          "idleinhibit always, class:${x}"
          "immediate, class:${x}"
          "monitor ${(monitor 0).id}, class:${x}"
        ]) [
          "^(Minecraft\\*? 1.\\d+.*)"
          "^(Minecraft\\*? \\d\\d\\w\\d\\d\\w)"
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
        "noborder, class:^(kitty)$, title:^(info)$"
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
        "tile, class:(fontforge), title:^([^ ]+  [^ ]+\.[^ ]+ ([^ ]+))$"
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
        "float, class:^(org.kde.dolphin)$, title:((Creating directory|Progress Dialog|Deleting|Copying|Moving) — Dolphin)"
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
        "bordersize 0, initialTitle:^(Mozilla Firefox)$"
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
      ];
    };
  };
  programs.hyprlock = {
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
          monitor = (monitor 0).id;
          size = "800, 30";
          outline_thickness = 2;
          dots_size = 0.33;
          dots_spacing = 0.15;
          dots_center = true;
          dots_rounding = -1;
          outer_color = rgb "dddddd";
          inner_color = rgb "2c2c2c";
          font_color = rgb "ffffff";
          fade_on_empty = false;
          fade_timeout = 1000;
          placeholder_text = ''<span foreground="##939393" style="italic" font_size="11pt">Input Password...</span>'';
          hide_input = false;
          rounding = 8;
          check_color = rgb "ffd600";
          fail_color = rgb "f44336";
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
          monitor = (monitor 0).id;
          path = "/home/${conf.user}/.face.icon";
          size = 256;
          rounding = -1;
          border_size = 2;
          border_color = rgb "313244";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
      label = [
        {
          monitor = (monitor 0).id;
          text = "$USER";
          color = rgb "dddddd";
          font_size = 13;
          font_family = "Courier";
          position = "0, -60";
          halign = "center";
          valign = "center";
        }
        {
          monitor = (monitor 0).id;
          text = "cmd[update:1000] date +%I:%M\\ %p";
          color = rgb "dddddd";
          font_size = 16;
          font_family = "Courier20";
          position = "-10, -10";
          halign = "right";
          valign = "top";
        }
        {
          monitor = (monitor 0).id;
          text = "cmd[update:60000] date +%D";
          color = rgb "dddddd";
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
