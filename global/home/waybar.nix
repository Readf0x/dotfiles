{ lib', conf, ... }: {
  programs.waybar = {
    enable = true;
    settings.bar = {
      layer = "top";
      position = "top";
      height = 24;
      spacing = 5;
      output = (lib'.monitors.getId 0).id;
      modules-left = [
        "hyprland/workspaces"
        "tray"
      ];
      modules-center = [
        "custom/player"
      ];
      modules-right = [
        "wireplumber"
        "clock"
      ];
      "hyprland/workspaces" = {
        format = "{icon}";
        on-click = "activate";
        icon-size = 50;
        sort-by-number = true;
        all-outputs = true;
      };
      clock = {
        format = "{:%I:%M}";
      };
      wireplumber = {
        format = "󰕾  {volume}%";
        max-volume = 100;
        scroll-step = 5;
      };
      battery = {
        bat = "BAT0";
        interval = 60;
        format = "{icon}   {capacity}%";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
      };
      backlight = {
        format = "󰃟  {percent}%";
      };
      memory = {
        interval = 30;
        format = "  {used:0.1f}G";
      };
      network = {
        format = "";
        format-ethernet = "󰲝  ";
        format-wifi = "{icon}  ";
        format-disconnected = "󰲜  ";
        format-icons = [
          "󰤯"
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
        tooltip-format-wifi = "{essid} ({signalStrength}%)";
        tooltip-format-ethernet = "{ifname}";
        tooltip-format-disconnected = "Disconnected";
      };
      bluetooth = {
        format = "󰂯";
        format-disabled = "󰂲";
        format-connected = "󰂱";
        tooltip-format = "{controller_alias}\t{controller_address}";
        tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
      };
      tray = {
        icon-size = 16;
        spacing = 16;
      };
      "custom/player" = {
        format = "{}";
        exec = "${toString conf.homeDir}/Scripts/player-info";
        interval = 1;
      };
    };
    style = ''
      @define-color foreground #ffffff;
      @define-color foreground-inactive #dedede;
      @define-color background rgba(48, 48, 48, 0.8);
      @define-color background-alt #5e5e5e;

      * {
          font-family: Mononoki Nerd Font;
          font-size: 17px;
          padding: 0;
          margin: 0;
      }

      #waybar {
          color: @foreground;
          background-color: @background;
      }

      #workspaces button {
          padding-left: 0.2em;
          padding-right: 0.2em;
      }

      #workspaces button.empty {
          color: @foreground-inactive;
      }

      #workspaces button.active {
          background-color: @background-alt;
          border-radius: 3px;
      }

      #clock {
        margin-right: 0.3em;
      }

      #wireplumber,
      #backlight,
      #tray,
      #memory,
      #temperature
      #network,
      #bluetooth {
          padding-left: 0.5em;
          padding-right: 0.5em;
      }

      #battery,
      #memory,
      #language,
      #network {
          /* margin-right: 0.8em; */
      }
    '';
  };
}
