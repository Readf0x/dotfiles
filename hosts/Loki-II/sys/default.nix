{ pkgs, conf, lib, ... }: {
  nixpkgs.config.rocmSupport = true;
  nixpkgs.config.cudaSupport = false;

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

    # AI BULLSHIT WOO
    ollama = {
      enable = true;
      package = pkgs.ollama-vulkan;
      environmentVariables = {
        # HCC_AMDGPU_TARGET = "gfx1032";
        # OLLAMA_VULKAN = 1;
      };
      # rocmOverrideGfx = "10.3.2";
    };
  };

  systemd.services."libvirtd".path = [ pkgs.passt ];

  users.users = lib.mapAttrs (
    name: config: { extraGroups = [ "gamemode" "libvirtd" "libvirt" "kvm" ]; }
  ) conf.users;

  users.groups.libvirt = {
    gid = null;
    name = "libvirt";
  };
}
