{ lib, lib', ... }: {
  programs = {
    kitty.extraConfig = ''
      font_size 12
    '';
    waybar.settings.bar = {
      modules-right = lib.mkForce [
        "network"
        "battery"
        "wireplumber"
        "clock"
      ];
    };
  };
  wayland.windowManager.hyprland = {
    settings = {
      input.sensitivity = "0.4";
      bind = [
        "$mod, mouse:276, exec, hypr-zoom -duration 250 -steps 30 -target 2"
        "$mod, mouse:275, exec, hypr-zoom -duration 250 -steps 30 -target 1"
      ];
    };
  };
  programs.hyprlock.settings.label = [
    {
      monitor = (lib'.monitors.getId 0).id;
      text = "cmd[update:1000] echo \"$(cat /sys/class/power_supply/BAT0/capacity)%\"";
      color = "rgb(dddddd)";
      font_size = 12;
      font_family = "Courier";
      position = "-10, -50";
      halign = "right";
      valign = "top";
    }
  ];
}
