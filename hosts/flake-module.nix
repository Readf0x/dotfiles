{ self, inputs, lib, ... }: let
  mkConf = import ./mk-conf.nix { inherit self inputs lib; };
in {
  flake = mkConf rec {
    hosts = {
      Loki-II = {
        stateVersion = "24.05";
        system = "x86_64-linux";
        monitors = [
          { id = "DP-2";     res = [ 1920 1080 ]; scl = 1; hz = 60; pos = [ 1920 0 ]; rot = 0; }
          { id = "HDMI-A-1"; res = [ 1920 1080 ]; scl = 1; hz = 60; pos = [ 0    0 ]; rot = 0; }
        ];
      };
      Loki-IV = {
        stateVersion = "24.11";
        system = "x86_64-linux";
        monitors = [
          { id = "eDP-1"; res = [ 1920 1080 ]; scl = 1; hz = 60; pos = [ 0 1080 ]; rot = 0; }
          { id = "HDMI-A-2"; res = [ 1920 1080 ]; scl = 1; hz = 60; pos = [ 0 0 ]; rot = 0; }
        ];
      };
    };
    users = let 
      perHost = with lib; data: listToAttrs (lib.map (a: { name = a; value = data; }) (lib.attrNames hosts));
    in {
      readf0x = lib.recursiveUpdate (perHost {
        admin = true;
        isNormalUser = true;
        syncthing = true;
        shell = "zsh";
        email = "davis.a.forsythe@gmail.com";
        realName = "readf0x";
        key = "5DA8A55A7FFB950B92BB532C4A48E1852C03CE8A";
      }) {
        Loki-II = {
          pokemon = "buizel";
        };
        Loki-IV = {
          pokemon = "sylveon";
        };
      };
    };
  };
}
