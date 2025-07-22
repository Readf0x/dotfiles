{ self, inputs, lib, ... }: let
  mkConf = import ./mk-conf.nix { inherit self inputs lib; };
in {
  flake = mkConf (import ./config.nix).config;
}
