{ self, inputs, lib, ... }: let
  mkConf = import ./mk-conf.nix { inherit self inputs lib; } {
    hm = [
      inputs.nixvim.homeManagerModules.default
      inputs.stylix.homeModules.stylix
      inputs.textfox.homeManagerModules.default
      inputs.nur.modules.homeManager.default
      inputs.integral-prompt.homeManagerModules.default
    ];
    os = [
      inputs.stylix.nixosModules.stylix
      # inputs.nixos-06cb-009a-fingerprint-sensor.nixosModules."06cb-009a-fingerprint-sensor"
      inputs.nur.modules.nixos.default
      inputs.grub2-themes.nixosModules.default
    ];
  };
in {
  flake = mkConf (import ./config.nix).config;
}
