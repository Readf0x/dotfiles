{ pkgs, ... }: {
  environment = {
    systemPackages = with pkgs; [
      piper
      qemu
    ];
  };

  virtualisation.libvirtd.enable = true;

  programs = {
    corectrl = {
      enable = true;
      gpuOverclock.enable = true;
    };
    virt-manager.enable = true;
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
