{ self, inputs, lib, ... }: inputModules: let
  os = inputs.nixpkgs;
  hm = inputs.home-manager;

  buildOS = os.lib.nixosSystem;
  buildHM = hm.lib.homeManagerConfiguration;

  mkConf = { hosts, users }: let
    buildImports = { host, user, modules, system }:
    ( if user == "sys"
        then [../global/sys]
        else [../global/home]
    ) ++ (
      if lib.pathExists ./${host}/${user}
        then [./${host}/${user}]
        else []
      ) ++ [
        ({ ... }: {
          nixpkgs.overlays = [
            (final: prev:
              lib.filterAttrs (n: v: n != "nur") inputs
              |> lib.filterAttrs (n: v: lib.hasAttrByPath ["packages" system] v)
              |> lib.concatMapAttrs (n: v: lib.filterAttrs (n': v': n' != "default") { "${n}" = v.packages.${system}; })
            )
            (final: prev: {
              this = self.packages.${system};
            })
          ];
        })
      ] ++ modules;
  in {
    homeConfigurations = with lib;
      concatMapAttrs (user: hosts':
        mapAttrs' (host: { homeDir ? /home/${user}, ... }@config: let
          system = hosts.${host}.system;
        in {
          name = "${user}@${host}";
          value = let
            setup = {
              pkgs = import os { inherit system; };
              extraSpecialArgs = rec {
                inherit self inputs;
                # unstable = import inputs.unstable { inherit system; };
                stable = import inputs.stable { inherit system; };
                working-hyprland = import inputs.nixpkgs-working-hyprland { inherit system; };
                lib' = import ../lib { inherit lib conf pkgs; };
                conf = lib.mergeAttrsList [
                  { inherit homeDir host user; }
                  config
                  { inherit hosts; }
                  hosts.${host}
                ];
              };
              modules = buildImports {
                inherit host user system;
                modules = inputModules.hm;
              };
            };
          # merge extraSpecialArgs into final output so that they'll be available in the repl
          in (buildHM setup) // setup.extraSpecialArgs;
        }) hosts'
      ) users;
    nixosConfigurations = with lib;
      mapAttrs (host: { system, ... }@config:
        buildOS {
          inherit system;
          specialArgs = rec {
            inherit self inputs;
            # unstable = import inputs.unstable { inherit system; };
            stable = import inputs.stable { inherit system; };
            working-hyprland = import inputs.nixpkgs-working-hyprland { inherit system; };
            lib' = import ../lib { inherit lib conf; pkgs = import os { inherit system; }; };
            conf = mergeAttrsList [
              { inherit host system; }
              config
              { inherit hosts; }
              { users = concatMapAttrs (user: hosts: { ${user} = hosts.${host}; }) users; }
            ];
          };
          modules = buildImports {
            inherit host system;
            user = "sys";
            modules = inputModules.os;
          };
        }
      ) hosts;
  };
in mkConf
