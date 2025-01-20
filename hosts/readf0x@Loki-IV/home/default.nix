{ lib, ... }: {
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
}
