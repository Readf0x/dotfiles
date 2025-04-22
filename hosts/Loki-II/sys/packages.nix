{ pkgs, self, conf, ... }: {
  environment.systemPackages = [
    self.packages.${conf.system}.ukmm-fork
  ] ++ (with pkgs; [
    piper
    qemu
    cemu
    bridge-utils
    distrobox
    distrobox-tui
  ]);

  virtualisation = {
    libvirtd.enable = true;
    docker.enable = false;
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  programs = {
    corectrl = {
      enable = true;
      gpuOverclock.enable = true;
    };
    gamemode = {
      enable = true;
      settings = {
        general.renice = 10;
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          amd_performance_level = "high";
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send --icon=applications-games 'GameMode Started'";
          end = "${pkgs.libnotify}/bin/notify-send --icon=applications-games 'GameMode Ended'";
        };
      };
    };
  };
}
