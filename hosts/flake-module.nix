{ self, inputs, lib, ... }: 
let
  mkConf = name: { system, ... }@conf:
  let 
    userAndHost = lib.splitString "@" name;
    user = builtins.elemAt userAndHost 0;
    host = builtins.elemAt userAndHost 1;
    specialArgs = { inherit self inputs conf user host; sys' = system; };
    module = x: y: (if builtins.pathExists ./${host}/${x} then [
      ./${host}/${x}
    ] else []) ++ [ ./../global/${x} ] ++ y;
  in {
    homeConfigurations.${name} = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = module "home" [ inputs.nixvim.homeManagerModules.nixvim ];
      extraSpecialArgs = specialArgs;
    };
    nixosConfigurations.${host} = inputs.nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules = module "sys" [];
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
      key = "00FF693537C65B9895A6BEE52EE5F4672ED57EA4";
    };
  };
in {
  flake = with lib; foldl' recursiveUpdate {} (attrValues configs);
}
