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
    settings.input.sensitivity = "0.4";
  };
  programs.hyprlock.settings.label = [
    {
      monitor = (lib'.monitors.getId 0).id;
      text = "cmd[update:1000] echo \"$(cat /sys/class/power_supply/BAT0/capacity)%\"";
      color = "rgb(dddddd)";
      font_size = 12;
      font_family = "Ubuntu Nerd Font";
      position = "-10, -70";
      halign = "right";
      valign = "top";
    }
  ];
}
