{ pkgs, ... }: {
  environment = {
    systemPackages = with pkgs; [
      ollama
      piper
    ];
  };

  programs = {
    corectrl = {
      enable = true;
      gpuOverclock.enable = true;
    };
  };
}
