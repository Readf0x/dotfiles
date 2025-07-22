{ self, inputs, lib, ... }: let
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
              pkgs' = self.packages.${hosts.${host}.system};
              conf = lib.mergeAttrsList [
                { inherit homeDir host user; }
                config
                { inherit hosts; }
                hosts.${host}
              ];
            };
            modules = buildImports {
              inherit host user;
              modules = [
                inputs.nixvim.homeManagerModules.default
                inputs.stylix.homeModules.stylix
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
              { inherit hosts; }
              { users = concatMapAttrs (user: hosts: { ${user} = hosts.${host}; }) users; }
            ];
          };
          modules = buildImports {
            inherit host;
            user = "sys";
            modules = [
              inputs.stylix.nixosModules.stylix
              # inputs.nixos-06cb-009a-fingerprint-sensor.nixosModules."06cb-009a-fingerprint-sensor"
              inputs.nur.modules.nixos.default
              inputs.grub2-themes.nixosModules.default
            ];
          };
        }
      ) hosts;
  };
in mkConf
