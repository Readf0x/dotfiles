{
  description = "readf0x's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        flake-parts.follows = "flake-parts";
      };
    };

    stylix.url = "github:danth/stylix";

    xdvdfs = {
      url = "github:antangelo/xdvdfs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    islive = {
      url = "github:readf0x/islive";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
  };

  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./hosts/flake-module.nix
      ];
      systems = [ "x86_64-linux" ];
      perSystem = { pkgs, lib, ... }: {
        packages = (
          lib.mapAttrs' (name': value: { name = "maple-font-${name'}"; inherit value; }) (import ./packages/maple-font.nix { inherit pkgs; })
        ) // {
          # TODO: fix this ABSOLUTE NIGHTMARE NIGHTMARE NIGHTMARE NIGHTMARE NIGHTMARE NIGHTMARE NIGHTMARE NIGHTMARE NIGHTMARE NIGHTMARE NIGHTMARE
          chili = import ./packages/chili.nix { inherit pkgs; image = ./global/img/wallpapers/89875190_p0.jpg; hash = "sha256-3a1lYwBRrfIvLddG7228PDdNuKSeWCrs2v7zRVdNxiE="; };
          discord-rpc = import ./packages/discord-rpc.nix { inherit pkgs; };
          noto-math-kitty-profile-fix = import ./packages/noto-math-kitty-profile-fix.nix { inherit pkgs; };
        };
      };
    };
}
