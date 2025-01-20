{ self, inputs, lib, ... }: let
  mkConf = name: let
    split = builtins.elemAt (lib.splitString "@" name);
  in { system, homeDir ? /home/${split 0}, ... }@extra: let
    conf = {
      inherit homeDir system;
      user = split 0;
      host = split 1;
    } // extra;
    specialArgs = let
      lib' = import ./../lib {inherit lib conf;};
    in { inherit self inputs conf lib'; };
    module = x: y: (if builtins.pathExists ./${name}/${x}
    then [./${name}/${x}]
    else []) ++ [ ./../global/${x} ] ++ y;
  in {
    homeConfigurations.${name} = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = module "home" [
        inputs.nixvim.homeManagerModules.default
        inputs.stylix.homeManagerModules.stylix
      ];
      extraSpecialArgs = specialArgs;
    };
    nixosConfigurations.${conf.host} = inputs.nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules = module "sys" [
        inputs.stylix.nixosModules.stylix
      ];
    };
  };

  configs = builtins.mapAttrs mkConf {
    "readf0x@Loki-II" = {
      system = "x86_64-linux";
      monitors = [
        { id = "DP-2";     res = [ 1920 1080 ]; scl = 1; hz = 60; pos = [ 1920 0 ]; rot = 0; }
        { id = "HDMI-A-1"; res = [ 1920 1080 ]; scl = 1; hz = 60; pos = [ 0    0 ]; rot = 0; }
      ];
      stateVersion = "24.05";
      email = "davis.a.forsythe@gmail.com";
      realName = "Davis Forsythe";
      key = "5DA8A55A7FFB950B92BB532C4A48E1852C03CE8A";
      librewolfProfile = "z3s5q0ct.default";
      pokemon = "buizel";
    };
    "readf0x@Loki-IV" = {
      system = "x86_64-linux";
      monitors = [
        { id = "eDP-1"; res = [ 1920 1080 ]; scl = 1; hz = 60; pos = [ 0 0 ]; rot = 0; }
      ];
      stateVersion = "24.11";
      email = "davis.a.forsythe@gmail.com";
      realName = "Davis Forsythe";
      key = "5DA8A55A7FFB950B92BB532C4A48E1852C03CE8A";
      librewolfProfile = "6qar1mkn.default";
      pokemon = "sylveon";
    };
  };
in {
  flake = with lib; foldl' recursiveUpdate {} (attrValues configs);
}
