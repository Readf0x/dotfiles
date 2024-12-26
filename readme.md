# INSTRUCTIONS
- add host definition in `hosts/flake-module.nix` & `hosts/<USER>@<HOSTNAME>/`
- `nix profile install '.#packages.x86_64-linux.noto-math'`
- `sudo nixos-rebuild switch --flake . && home-manager switch --flake .`
