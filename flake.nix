{
  description = "readf0x's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
    };

    stylix.url = "github:danth/stylix/release-24.11";

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    islive = {
      url = "github:readf0x/islive";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    nixos-06cb-009a-fingerprint-sensor = {
      url = "github:ahbnr/nixos-06cb-009a-fingerprint-sensor?ref=24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wallpapers = {
      url = "github:readf0x/wallpapers/neofuturism";
    };

    textfox.url = "github:adriankarlen/textfox";
  };

  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./hosts/flake-module.nix
      ];
      systems = [ "x86_64-linux" ];
      perSystem = { pkgs, lib, system, ... }: {
        packages = {
          # [TODO] fix this ABSOLUTE NIGHTMARE NIGHTMARE NIGHTMARE NIGHTMARE NIGHTMARE NIGHTMARE NIGHTMARE NIGHTMARE NIGHTMARE NIGHTMARE NIGHTMARE
          chili = import ./packages/chili.nix { inherit pkgs; image = builtins.toPath "${inputs.wallpapers.packages.${system}.default}/0.jpg"; hash = "sha256-qUXKgOCMESkvtAZYLMYpmH6CeP/zyJfDD+QiO2WjqUA="; };
          discord-rpc = import ./packages/discord-rpc.nix { inherit pkgs; };
          nvim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
            inherit pkgs;
            module = import ./global/home/nixvim.nix { inherit pkgs; };
          };
          ukmm-fork = import ./packages/ukmm.nix { inherit pkgs; };
          fonts = import ./packages/fonts.nix { inherit pkgs; };
        };
      };
    };
}
