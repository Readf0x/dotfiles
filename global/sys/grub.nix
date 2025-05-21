{ lib', inputs, conf, ... }: {
  boot.loader = {
    grub = {
      efiSupport = true;
      useOSProber = true;
      device = "nodev";
    };
    grub2-theme = rec {
      enable = true;
      theme = "vimix";
      customResolution = lib'.monitors.toRes (lib'.monitors.getId 0).res;
      splashImage = lib'.resizeImage {
        image = "${inputs.wallpapers.packages.${conf.system}.default}/boot.jpg";
        size = customResolution;
      };
    };
  };
}
