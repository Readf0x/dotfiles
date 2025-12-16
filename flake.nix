{
  description = "readf0x's dotfiles";

  outputs = { self, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./hosts/flake-module.nix
      ];
      systems = [ "x86_64-linux" ];
      perSystem = { pkgs, lib, system, ... }: {
        packages = let
          mkSchemeAttrs = (pkgs.callPackage inputs.base16.lib {}).mkSchemeAttrs;
        in {
          nvim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
            inherit pkgs;
            module = import ./global/home/nixvim.nix {
              inherit pkgs inputs self;
              config.lib.stylix.colors = mkSchemeAttrs ./global/shared/mead.yaml;
            };
          };
        } // (
          [
            # "ukmm"
            "discord-rpc"
            "hypr-zoom"
            # "otf2psf"
            "generate-set"
            "wl-shimeji"
            # "installer"
            "tree-sitter-umka"
            "umka"
          ]
          |> map (p:
            pkgs.callPackage (import ./packages/${p}.nix) {}
            |> lib.nameValuePair p
          )
          |> lib.listToAttrs
        );
      };
    };

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-25.05";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixvim.url = "github:nix-community/nixvim";

    stylix.url = "github:danth/stylix";

    # neoshell = {
    #   url = "github:readf0x/quickshell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    bubbleshell = {
      url = "github:readf0x/quickshell/bubble";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    islive = {
      url = "github:readf0x/islive";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    
    templating-engine = {
      url = "github:readf0x/templating-engine";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    tree-sitter-tet = {
      url = "github:readf0x/tree-sitter-tet";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    wallpapers.url = "github:readf0x/wallpapers/neofuturism";

    grub2-themes.url = "github:vinceliuice/grub2-themes";

    integral-prompt = {
      url = "github:readf0x/integral-prompt";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # qtbooru = {
    #   url = "github:readf0x/qtbooru";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    base16.url = "github:SenchoPens/base16.nix";

    reactions = {
      url = "github:readf0x/reactions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    borzoi.url = "github:readf0x/borzoi";
  };
}
