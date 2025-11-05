let
  lib = with builtins; rec {
    recursiveUpdateUntil =
      pred: lhs: rhs:
      let
        f =
          attrPath:
          zipAttrsWith (
            n: values:
            let
              here = attrPath ++ [ n ];
            in
            if length values == 1 || pred here (elemAt values 1) (head values) then
              head values
            else
              f here values
          );
      in
      f [ ] [ rhs lhs ];
    recursiveUpdate =
      lhs: rhs:
      recursiveUpdateUntil (
        path: lhs: rhs:
        !(isAttrs lhs && isAttrs rhs)
      ) lhs rhs;
  };
in rec {
  userPubKeys = { readf0x = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINEOAOBrF4e2jZ0nn4uA4zuczavXOpCisEbcgJ6fjUNv"; };
  config = rec {
    hosts = {
      Loki-II = {
        ssh = {
          ip = "100.125.46.92";
          shortname = "loki2";
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFu5y6mruCS2rA6ihAhJmCV64tAE58eHj35rMt5yEOGO";
        };
        stateVersion = "24.05";
        system = "x86_64-linux";
        monitors = [
          { id = "DP-2";     res = [ 1920 1080 ]; scl = 1; hz = 60; pos = [ 1920 0 ]; rot = 0; hdr = false; }
          { id = "HDMI-A-1"; res = [ 1920 1080 ]; scl = 1; hz = 60; pos = [ 0    0 ]; rot = 0; hdr = false; }
        ];
        trusted-public-key = "Loki2:XXJZyhytus5gu7xvzb/lXiAkJusYgh5eaBBoYYanbg0=";
        remoteBuild = {
          enable = true;
          jobs = 12;
          speedFactor = 2;
        };
      };
      Loki-IV = {
        ssh = {
          ip = "100.112.106.59";
          shortname = "loki4";
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKQ0D5UV2FLgzGJfdo8t8JKdgLt/02A+0nirRoargq1t";
        };
        stateVersion = "24.11";
        system = "x86_64-linux";
        monitors = [
          { id = "eDP-1";    res = [ 1920 1080 ]; scl = 1; hz = 60; pos = [ 0 1080 ]; rot = 0; hdr = false; }
          { id = "HDMI-A-2"; res = [ 1920 1080 ]; scl = 1; hz = 60; pos = [ 0 0    ]; rot = 0; hdr = false; }
        ];
        trusted-public-key = "Loki4:JTKGVJHy2T1xIIjIV48SyCTqk137ayoggWb1gjoCmuQ=";
        remoteBuild.enable = false;
      };
    };
    users = let 
      perHost = data: builtins.attrNames hosts |> map (a: { name = a; value = data; }) |> builtins.listToAttrs;
    in {
      readf0x = lib.recursiveUpdate (perHost {
        admin = true;
        isNormalUser = true;
        shell = "fish";
        email = "davis.a.forsythe@gmail.com";
        realName = "readf0x";
        gpg = "5DA8A55A7FFB950B92BB532C4A48E1852C03CE8A";
        ssh = userPubKeys.readf0x;
      }) {
        Loki-II = {
          pokemon = {
            name = "xerneas";
            form = "active";
          };
        };
        Loki-IV = {
          pokemon = "sylveon";
        };
      };
    };
  };
}
