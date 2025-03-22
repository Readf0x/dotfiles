# INSTRUCTIONS
- add host & user definitions in `hosts/flake-module.nix`, `hosts/<HOSTNAME>/`, & `hosts/<HOSTNAME>/<USERNAME>/`
- `sudo nixos-rebuild switch --flake . && home-manager switch --flake .`
- `init-home`
