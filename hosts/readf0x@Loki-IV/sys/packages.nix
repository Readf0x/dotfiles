{ pkgs, ... }: {
  users.users.${conf.user}.packages = with pkgs; {
    guvcview
  };
}
