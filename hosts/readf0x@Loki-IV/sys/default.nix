{ ... }: {
  imports = [
    ./packages.nix
    ./drives.nix
    ./hardware.nix
  ];

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  services = {
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    blueman.enable = true;
    logind = {
      lidSwitch = "lock";
    };
    "06cb-009a-fingerprint-sensor" = {
      enable = true;
      backend = "libfprint-tod";
      calib-data-file = ../fprint/calib-data.bin;
    };
    ollama.enable = true;
  };
}
