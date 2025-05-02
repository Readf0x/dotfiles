{ pkgs, unstable, ... }: {
  nixpkgs.config.rocmSupport = true;

  imports = [
    ./drives.nix
    ./hardware.nix
    ./packages.nix
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

  networking = {
    firewall.enable = false;
  }; 
  services = {
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    ratbagd.enable = true;
    blueman.enable = true;
    ollama = {
      enable = true;
      acceleration = "rocm";
      environmentVariables = {
        HCC_AMDGPU_TARGET = "gfx1032";
      };
      rocmOverrideGfx = "10.3.2";
    };
    open-webui = {
      enable = true;
      package = unstable.open-webui;
    };
  };

  systemd.services."libvirtd".path = [ pkgs.passt ];
}
