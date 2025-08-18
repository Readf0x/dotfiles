{ pkgs, conf, config, inputs, ... }: {
  services = {
    openssh = {
      enable = true;
      settings = {
        PrintMotd = true;
      };
    };
    nix-serve = {
      enable = true;
      package = pkgs.nix-serve-ng;
      extraParams = "--priority 60";
      secretKeyFile = "/etc/nix/cache-priv-key.pem";
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa.enable = true;
    };
    udisks2.enable = true;
    gvfs.enable = true;
    displayManager = rec {
      enable = true;
      defaultSession = "hyprland";
      sddm = {
        enable = false;
        wayland.enable = true;
        theme = let
          chili = pkgs.sddm-chili-theme.override {
            themeConfig = { background = "${inputs.wallpapers.packages.${conf.system}.default}/lock.jpg"; };
          };
        in "${chili}/share/sddm/themes/chili";
      };
      ly = {
        enable = true;
      };
      # does *technially* work but does some weird shit
      # execCmd = if ly.enable && kmscon.enable then
      #   lib.mkForce "${pkgs.kmscon}/bin/kmscon -- ${pkgs.ly}/bin/ly"
      # else null;
    };
    #gnome.gnome-keyring.enable = true;
    logind.extraConfig = "HandlePowerKey=ignore";
    i2pd = {
      enable = false;
      address = "127.0.0.1";
      proto = {
        http.enable = true;
        socksProxy.enable = true;
        httpProxy = {
          enable = true;
          outproxy = "http://exit.stormycloud.i2p";
        };
        sam.enable = true;
        i2cp = {
          enable = true;
          address = "127.0.0.1";
          port = 7654;
        };
      };
      outTunnels = {
        i2pcraft = {
          enable = true;
          address = "127.0.0.1";
          port = 25565;
          destination = "abnrfgqqsoy6d3dlc7dzq64c5uir5vd7hxy7s7weo6qvmzigf34a.b32.i2p";
          keys = "i2pcraft.dat";
          inbound.length = 3;
          outbound.length = 3;
        };
      };
    };
    cron.enable = true;
    gpm.enable = true;
    kmscon = {
      enable = true;
      fonts = [ config.stylix.fonts.monospace ];
      hwRender = true;
    };
    flatpak.enable = true;
  };

  # https://discourse.nixos.org/t/setting-sddm-profile-picture/49604
  systemd.services = {
    "sddm-avatar" = {
      description = "Service to copy or update users Avatars at startup.";
      wantedBy = [ "multi-user.target" ];
      before = [ "sddm.service" ];
      script = ''
        set -eu
        for user in /home/*; do
          username=$(basename "$user")
          mkdir -p "/var/lib/AccountsService/icons"
          if [ -f "$user/.face.icon" ]; then
            if [ ! -f "/var/lib/AccountsService/icons/$username" ]; then
              cp "$user/.face.icon" "/var/lib/AccountsService/icons/$username"
            else
              if [ "$user/.face.icon" -nt "/var/lib/AccountsService/icons/$username" ]; then
                cp "$user/.face.icon" "/var/lib/AccountsService/icons/$username"
              fi
            fi
          fi
        done
      '';
      serviceConfig = {
        Type = "simple";
        User = "root";
        StandardOutput = "journal+console";
        StandardError = "journal+console";
      };
    };
    sddm = { after = [ "sddm-avatar.service" ]; };
  };
}
