{ pkgs, ... }: {
  environment = {
    systemPackages = with pkgs; [
      ollama
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
  };
}
