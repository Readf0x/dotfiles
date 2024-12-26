# INSTRUCTIONS
- add host definition in `hosts/flake-module.nix` & `hosts/<USER>@<HOSTNAME>/`
- `nix profile install '.#packages.<SYSTEM ARCH>.noto-math'`
- `sudo nixos-rebuild switch --flake . && home-manager switch --flake .`
