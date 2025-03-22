{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    guvcview
    brightnessctl
    piper
  ];
}
