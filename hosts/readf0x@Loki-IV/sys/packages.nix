{ pkgs, conf, ... }: {
  users.users.${conf.user}.packages = with pkgs; [
    guvcview
    brightnessctl
  ];
}
