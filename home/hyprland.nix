{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = ["--all"];
    settings = {
      #    ____         __              ____    __  __  _             
      #   / __/_ _____ / /____ __ _    / __/__ / /_/ /_(_)__  ___ ____
      #  _\ \/ // (_-</ __/ -_)  ' \  _\ \/ -_) __/ __/ / _ \/ _ `(_-<
      # /___/\_, /___/\__/\__/_/_/_/ /___/\__/\__/\__/_/_//_/\_, /___/
      #     /___/                                           /___/     

      # https://wiki.hyprland.org/Configuring/Monitors/
      monitor = [
        "DP-2, preferred, 1920x0, auto"
        "HDMI-A-1, preferred, 0x0, auto"
      ];

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
        touchpad = {
          scroll_factor = 0.25;
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
        gaps_in = 5;
        gaps_out = 10;
        border_size = 1;
        "col.active_border" = "rgb(dddddd)";
        "col.inactive_border" = "rgb(464646)";

        layout = "dwindle";

        allow_tearing = false;
      };

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration = {
        rounding = 8;

        blur = {
          enabled = true;
          size = 3;
          passes = 2;
          new_optimizations = "on";
        };

        drop_shadow = true;
        shadow_range = 7;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1111119b)";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
      };
      xwayland.force_zero_scaling = true;

      # https://wiki.hyprland.org/Configuring/Animations/
      animations = {
        bezier = "curve, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 6, curve, slide"
          "fade, 1, 4, default"
          "workspaces, 1, 4, curve"
          "specialWorkspace, 1, 4, curve, slidevert"
        ];
      };

      # https://wiki.hyprland.org/Configuring/Dwindle-Layout/
      dwindle = {
        pseudotile = true;
        preserve_split = true;
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
      # "$music" = "playerctl --player=$(cat /home/readf0x/.config/ags/active.txt)";
      "$music" = "playerctl";
      # "$agsVolume" = ''ags -r "const volume = (await import('file:///tmp/ags/js/main.js')).VolumeWindow; volume.visible = true"'';
      # "$agsBrightness" = ''ags -r "const brightness = (await import('file:///tmp/ags/js/main.js')).BrightnessWindow; brightness.visible = true"'';
      # "$agsActive" = ''ags -r "const active = (await import('file:///tmp/ags/js/main.js')).activeSwitcher; active()"'';

      bind = [
        # IMPORTANT:
        "$hyper, L, exec, xdg-open https://linkedin.com/"

        "$mod, Return, exec, kitty"
        "$mod, E, exec, dolphin"
        "$mod, W, exec, librewolf"
        "$mod $s, C, exec, hyprpicker -an"
        ", Print, exec, grimblast --freeze copysave area ~/Pictures/Screenshots/screenshot_$(date +%Y-%m-%d_%H-%m-%s).png"
        "$s, Print, exec, grimblast --freeze copysave screen ~/Pictures/Screenshots/screenshot_$(date +%Y-%m-%d_%H-%m-%s).png"
        "$mod, F4, exec, wlogout -p layer-shell -b 5 -c 10"
        "$mod, F5, exec, pkill waybar; waybar"
        "$mod, Escape, exec, hyprlock"
        "$mod, D, togglespecialworkspace, dropdown"
        "$mod, R, exec, ~/Scripts/wallpaper.sh"
        "$mod, N, exec, swaync-client -t"
        "$mod $s, N, exec, swaync-client -C"
        "$mod, Escape, exec, hyprlock"
        
        # Media controls
        ", XF86AudioPlay, exec, $music play-pause"
        "$mod, F10, exec, $music play-pause"
        ", XF86AudioNext, exec, $music next"
        "$mod, End, exec, $music next"
        ", XF86AudioPrev, exec, $music previous"
        "$mod, Home, exec, $music previous"
        # TODO: super shift h to swap output devices
        "$mod $s, H, exec, ~/Scripts/audio.sh"

        # Window management
        "$mod, Q, killactive,"
        ", F11, fullscreen, 0"
        "$mod, M, fullscreen, 1"
        "$mod $s, Space, togglefloating,"
        "$mod $s, P, pin,"
        "$mod $c, Home, centerwindow,"
        "$a, Tab, focusurgentorlast,"
        # Dwindle
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        # Window movement
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod $s, left, swapwindow, l"
        "$mod $s, right, swapwindow, r"
        "$mod $s, up, swapwindow, u"
        "$mod $s, down, swapwindow, d"

        "$mod, I, workspace, name:info"
        "$mod, Y, workspace, name:music"
        "$mod, S, workspace, name:video"
        "$mod $s, S, movetoworkspace, name:video"
        "$mod $s, D, workspace, name:discord"
        "$mod $s, M, workspace, name:mail"

        "$mod, tab, movecurrentworkspacetomonitor, +1"
        "$mod, mouse_down, workspace, e-1"
        "$mod, mouse_up, workspace, e+1"
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
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ .05+"
        "$mod, page_up, exec, wpctl set-volume @DEFAULT_SINK@ .05+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ .05-"
        "$mod, page_down, exec, wpctl set-volume @DEFAULT_SINK@ .05-"

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
      # TODO: finish startup
      exec-once = [
        "hyprctl setcursor Bibata-Modern-Ice 24"
        "sleep 20; vesktop"
        "swww-daemon; sleep 2; wallpaper.sh"
        "waybar"
        "swaync"
      ];

      #  _      ___         __             ___       __      
      # | | /| / (_)__  ___/ /__ _    __  / _ \__ __/ /__ ___
      # | |/ |/ / / _ \/ _  / _ \ |/|/ / / , _/ // / / -_|_-<
      # |__/|__/_/_//_/\_,_/\___/__,__/ /_/|_|\_,_/_/\__/___/

      # https://wiki.hyprland.org/Configuring/Window-Rules
      workspace = [
        "special:dropdown, on-created-empty:kitty, gapsout:80"
        "name:music, monitor:HDMI-A-1, on-created-empty:youtube-music"
        "name:discord, monitor:HDMI-A-1, on-created-empty:vesktop"
        "name:info, monitor:HDMI-A-1, on-created-empty:kitty btop"
        "name:video, monitor:HDMI-A-1"
        "name:mail, monitor:HDMI-A-1, on-created-empty:evolution"
      ];
      windowrulev2 = [
        "suppressevent maximize, class:(.*)"
        "noblur, class:^()$, title: ^()$"
        "float, class:(pavucontrol)"
        "size 700 500, class:(pavucontrol)"
        "move 1208 51 class:(pavucontrol)"
        "monitor DP-2, class:(pavucontrol)"
        "stayfocused, class:(pavucontrol)"
        "animation slide, class:(pavucontrol)"
        "opacity 1, class:(pavucontrol)"
        "float, class:(smile)"
        "stayfocused, class:(Rofi)"
        "float, class:(Rofi)"
        "tile, title:( - Vivaldi)$"
        "float, title:^(Vivaldi Settings)"
        "opacity 0.75, class:(Dunst)"
        "fullscreen, class:^([w|W]aydroid.*)"
        "float, title:^(Picture in picture)$"
        "keepaspectratio, title:^(Picture in picture)$"
        "pin, title:^(Picture in picture)$"
        "float, title:^(Picture-in-Picture)$"
        "keepaspectratio, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"
        "rounding 0, class:(gamescope)"
        "fullscreen, class:(gamescope)"
        "float, class:(gamescope)"
        "float, title:(Steam Settings)"
        "minsize 1 1, title:^()$,class:^(steam)$"
        "center, title:^(Steam)$, class:^()$"
        "center, class:^(steam)$"
        "monitor DP-2, class:(steam)"
        "float, title:((Open|Save|Select) File|Select Background Image|Select Folder.*)"
        "size 900 600, title:((Open|Save)|Select File|Select Background Image|Select Folder.*)"
        "center, title:((Open|Save|Select) File|Select Background Image|Select Folder.*)"
        "center, title:( Image)$"
        "size 900 600, class:(soffice)"
        "center, class:(soffice)"
        "float, class:(xdg-desktop-portal-gtk)"
        "size 900 600, class:(xdg-desktop-portal-gtk)"
        "center, class:(xdg-desktop-portal-gtk)"
        "size 239 122, title:^(Go to Page)$"
        "center, class:^()$, title:^(LibreOffice)$"
        "opacity 0.0 override 0.0 override, class:^(xwaylandvideobridge)$"
        "noanim, class:^(xwaylandvideobridge)$"
        "nofocus, class:^(xwaylandvideobridge)$"
        "noinitialfocus, class:^(xwaylandvideobridge)$"
        "workspace special:hell silent, class:^(xwaylandvideobridge)$"
        "workspace name:music, class:^(YouTube Music)$"
        "workspace name:music, class:^(Dopamine)$"
        "float, title:^(Layer Select)$"
        "float, class:^(file-.*)"
        "workspace name:discord, class:^(discord)$"
        "workspace name:discord, class:^(vesktop)$"
        "monitor HDMI-A-1, class:^(org.telegram.desktop)$"
        "noanim, title:^(Media viewer)$, class:^(org.telegram.desktop)$"
        "float, title:^(Media viewer)$, class:^(org.telegram.desktop)$"
        "keepaspectratio, class:^(scrcpy)$"
        "pseudo, class:^(scrcpy)$"
        "float, class:^(org.kde.kdeconnect.handler)$"
        "fullscreen, class:^(Minecraft\\*? 1.\\d+.*)"
        "idleinhibit always, class:^(Minecraft\\*? 1.\\d+.*)"
        "immediate, class:^(Minecraft\\*? 1.\\d+.*)"
        "monitor DP-2, class:^(Minecraft\\*? 1.\\d+.*)"
        "fullscreen, class:^(Minecraft\\*? \\d\\d\\w\\d\\d\\w)"
        "idleinhibit always, class:^(Minecraft\\*? \\d\\d\\w\\d\\d\\w)"
        "immediate, class:^(Minecraft\\*? \\d\\d\\w\\d\\d\\w)"
        "monitor DP-2, class:^(Minecraft\\*? \\d\\d\\w\\d\\d\\w)"
        "float, title:^(Minecraft\\*? 1.\\d+.*)"
        "fullscreen, title:^(Minecraft\\*? 1.\\d+.*)"
        "idleinhibit always, title:^(Minecraft\\*? 1.\\d+.*)"
        "immediate, title:^(Minecraft\\*? 1.\\d+.*)"
        "monitor DP-2, title:^(Minecraft\\*? 1.\\d+.*)"
        "float, title:^(Minecraft\\*? \\d\\d\\w\\d\\d\\w)"
        "fullscreen, title:^(Minecraft\\*? \\d\\d\\w\\d\\d\\w)"
        "idleinhibit always, title:^(Minecraft\\*? \\d\\d\\w\\d\\d\\w)"
        "immediate, title:^(Minecraft\\*? \\d\\d\\w\\d\\d\\w)"
        "monitor DP-2, title:^(Minecraft\\*? \\d\\d\\w\\d\\d\\w)"
        "fullscreen, class:^(BigChadGuys Plus v[0-9.]+)$"
        "idleinhibit always, class:^(BigChadGuys Plus v[0-9.]+)$"
        "immediate, class:^(BigChadGuys Plus v[0-9.]+)$"
        "monitor DP-2, class:^(BigChadGuys Plus v[0-9.]+)$"
        "fullscreen, class:^(SteamPunk)$"
        "idleinhibit always, class:^(SteamPunk)$"
        "immediate, class:^(SteamPunk)$"
        "monitor DP-2, class:^(SteamPunk)$"
        "noborder, class:^(kitty)$, title:^(info)$"
        "float, title:^(cava)$"
        "size 1320 623, title:^(cava)$"
        "center, title:^(cava)$"
        "float, class:^(org.gnome.Calculator)$"
        "float, class:(zenity)"
        "float, title:(File Already Exists — Ark)"
        "float, class:^(org.kde.ark)$, title:^(Extracting.* — Ark)"
        "float, class:(thunar), title:(File Operation Progress|Confirm to replace files)"
        "float, class:(org.kde.polkit-kde-authentication-agent-1)"
        "float, class:(yad)"
        "tile, title:(Vortex)"
        "workspace special:hell silent, title:(Wine System Tray)"
        "center, class:^(vortex.exe)$, title:^(Open)$"
        "float, title:(Blender Preferences)"
        "noblur, class:(krita)"
        "float, class:(python3), initialTitle:(screenpen)"
        "noanim, class:(python3), initialTitle:(screenpen)"
        "tile, class:(fontforge), title:^(?!fontforge)"
        "float, class:^(blockbench)$, title:^()$"
        "size 900 600, class:(blockbench), title:^()$"
        "center, class:(blockbench), title:^()$"
        "float, class:^(Zotero)$, title:^(?!Zotero)"
        "center, class:^(Zotero)$, title:^(?!Zotero)"
        "noblur, class:vlc"
        "float, class:^(org.kde.dolphin)$, title:((Creating directory|Progress Dialog|Deleting|Copying|Moving) — Dolphin)"
        "idleinhibit, class:^(org.kde.dolphin)$, title:((Creating directory|Progress Dialog|Deleting|Copying|Moving) — Dolphin)"
        "tile, class:^(Chromium)$, title:^(Excalidraw)$"
        "workspace name:mail, class:^(evolution)$"
        "noinitialfocus, class:^(evolution)$"
        "float, title:^(?!Mail|Inbox).*$, class:^(evolution)$"
        "size 1000 650, title:^(?!Mail|Inbox).*$, class:^(evolution)$"
        "center, title:^(?!Mail|Inbox).*$, class:^(evolution)$"
        "tile, title:^(Compose Message)$, class:^(evolution)$"
        "float, class:^(evolution-alarm-notify)$"
        "size 500 400, class:^(evolution-alarm-notify)$"
        "center, class:^(evolution-alarm-notify)$"
        "pin, class:^(evolution-alarm-notify)$"
        "opacity 0.9999999, class:^(LibreWolf)$"
        "fullscreen, class:(steam_app_377160), title:(Fallout4)"
        "tile, class:(Godot_Engine), title:(Godot)"
        "tile, class:(\\w+), title:(Godot)"
        "float, title:(Close Firefox)"
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
          monitor = "DP-2";
          size = "800, 30";
          outline_thickness = 2;
          dots_size = 0.33;
          dots_spacing = 0.15;
          dots_center = true;
          dots_rounding = -1;
          outer_color = "rgb(dddddd)";
          inner_color = "rgb(2c2c2c)";
          font_color = "rgb(ffffff)";
          fade_on_empty = false;
          fade_timeout = 1000;
          placeholder_text = ''<span foreground="##a6adc8" style="italic" font_size="11pt">Input Password...</span>'';
          hide_input = false;
          rounding = 8;
          check_color = "rgb(ffd600)";
          fail_color = "rgb(f44336)";
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
          monitor = "DP-2";
          path = "/home/$USER/.config/hypr/pfp.png";
          size = 256;
          rounding = -1;
          border_size = 2;
          border_color = "rgb(313244)";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
      label = [
        {
          monitor = "DP-2";
          text = "$USER";
          color = "rgb(dddddd)";
          font_size = 12;
          font_family = "Ubuntu Nerd Font";
          position = "0, -60";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "DP-2";
          text = "cmd[update:1000] date +%I:%M\\ %p";
          color = "rgb(dddddd)";
          font_size = 25;
          font_family = "Ubuntu Nerd Font";
          position = "-10, -10";
          halign = "right";
          valign = "top";
        }
        {
          monitor = "DP-2";
          text = "cmd[update:60000] date +%D";
          color = "rgb(dddddd)";
          font_size = 12;
          font_family = "Ubuntu Nerd Font";
          position = "-10, -50";
          halign = "right";
          valign = "top";
        }
      ];
    };
  };
}