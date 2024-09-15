{
  description = "readf0x's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixvim, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages = {
        maple-font = (import ./packages/maple-font.nix { inherit pkgs; });
      };
      homeConfigurations."readf0x" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit self inputs; };
        modules = [ nixvim.homeManagerModules.nixvim ./home/home.nix ];
      };
      # TODO: create configurations programmatically instead of hardcoding them
      nixosConfigurations."Loki-II" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit self inputs; };
        modules = [ ./hosts/Loki-II/system.nix ];
      };
    };
}
