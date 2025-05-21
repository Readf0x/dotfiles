{ self, inputs, lib, ... }:
let
  os = inputs.nixpkgs;
  hm = inputs.home-manager;

  buildOS = os.lib.nixosSystem;
  buildHM = hm.lib.homeManagerConfiguration;

  mkConf = { hosts, users }: let
    buildImports = { host, user, modules }:
    ( if user == "sys"
        then [../global/sys]
        else [../global/home]
    ) ++ (
      if lib.pathExists ./${host}/${user}
        then [./${host}/${user}]
        else []
    ) ++ modules;
  in {
    homeConfigurations = with lib;
      concatMapAttrs (user: hosts':
        mapAttrs' (host: { homeDir ? /home/${user}, ... }@config: {
          name = "${user}@${host}";
          value = buildHM {
            pkgs = os.legacyPackages.${hosts.${host}.system};
            extraSpecialArgs = rec {
              inherit self inputs;
              unstable = inputs.unstable.legacyPackages.${hosts.${host}.system};
              lib' = import ../lib { inherit lib conf; pkgs = os.legacyPackages.${hosts.${host}.system}; };
              pkgs' = self.packages.${system};
              conf = lib.mergeAttrsList [
                { inherit homeDir host user; }
                config
                hosts.${host}
              ];
            };
            modules = buildImports {
              inherit host user;
              modules = [
                inputs.nixvim.homeManagerModules.default
                inputs.stylix.homeManagerModules.stylix
                inputs.textfox.homeManagerModules.default
                inputs.nur.modules.homeManager.default
              ];
            };
          };
        }) hosts'
      ) users;
    nixosConfigurations = with lib;
      mapAttrs (host: { system, ... }@config:
        buildOS {
          inherit system;
          specialArgs = rec {
            inherit self inputs;
            unstable = inputs.unstable.legacyPackages.${hosts.${host}.system};
            lib' = import ../lib { inherit lib conf; pkgs = os.legacyPackages.${hosts.${host}.system}; };
            pkgs' = self.packages.${system};
            conf = mergeAttrsList [
              { inherit host system; }
              config
              { users = concatMapAttrs (user: hosts: { ${user} = hosts.${host}; }) users; }
            ];
          };
          modules = buildImports {
            inherit host;
            user = "sys";
            modules = [
              inputs.stylix.nixosModules.stylix
              inputs.nixos-06cb-009a-fingerprint-sensor.nixosModules."06cb-009a-fingerprint-sensor"
              inputs.nur.modules.nixos.default
              inputs.grub2-themes.nixosModules.default
            ];
          };
        }
      ) hosts;
  };
in {
  flake = mkConf rec {
    hosts = {
      Loki-II = {
        stateVersion = "24.05";
        system = "x86_64-linux";
        monitors = [
          { id = "DP-2";     res = [ 1920 1080 ]; scl = 1; hz = 60; pos = [ 1920 0 ]; rot = 0; }
          { id = "HDMI-A-1"; res = [ 1920 1080 ]; scl = 1; hz = 60; pos = [ 0    0 ]; rot = 0; }
        ];
      };
      Loki-IV = {
        stateVersion = "24.11";
        system = "x86_64-linux";
        monitors = [
          { id = "eDP-1"; res = [ 1920 1080 ]; scl = 1; hz = 60; pos = [ 0 1080 ]; rot = 0; }
          { id = "HDMI-A-2"; res = [ 1920 1080 ]; scl = 1; hz = 60; pos = [ 0 0 ]; rot = 0; }
        ];
      };
    };
    users = let 
      perHost = with lib; data: listToAttrs (lib.map (a: { name = a; value = data; }) (lib.attrNames hosts));
    in {
      readf0x = lib.recursiveUpdate (perHost {
        admin = true;
        isNormalUser = true;
        shell = "zsh";
        email = "davis.a.forsythe@gmail.com";
        realName = "Jean Forsythe";
        key = "5DA8A55A7FFB950B92BB532C4A48E1852C03CE8A";
      }) {
        Loki-II = {
          pokemon = "buizel";
        };
        Loki-IV = {
          pokemon = "sylveon";
        };
      };
    };
  };
}
