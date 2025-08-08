{
  description = "readf0x's dotfiles";

  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./hosts/flake-module.nix
      ];
      systems = [ "x86_64-linux" ];
      perSystem = { pkgs, lib, system, ... }: {
        packages = let
          package = p: import ./packages/${p}.nix pkgs;
        in {
          nvim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
            inherit pkgs;
            module = import ./global/home/nixvim.nix { inherit pkgs inputs; };
          };
          ukmm-fork = package "ukmm";
          discord-rpc = package "discord-rpc";
          hypr-zoom = package "hypr-zoom";
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixvim.url = "github:nix-community/nixvim/nixos-25.05";

    stylix.url = "github:danth/stylix/release-25.05";

    neoshell = {
      url = "github:readf0x/quickshell";
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

    textfox.url = "github:adriankarlen/textfox";

    grub2-themes.url = "github:vinceliuice/grub2-themes";

    integral-prompt = {
      url = "github:readf0x/integral-prompt";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    qtbooru = {
      url = "github:readf0x/qtbooru";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
