{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      ollama
    ];
  };

  programs = {
    corectrl = {
      enable = true;
      gpuOverclock.enable = true;
    };
  };
}
