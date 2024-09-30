{ pkgs, user, conf, ... }: {
  imports = [
    ./packages.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  boot.plymouth = {
    themePackages = [(pkgs.adi1090x-plymouth-themes.override {
      selected_themes = [ "infinite_seal" ];
    })];
    enable = true;
    theme = "infinite_seal";
  };

  xdg = {
    menus.enable = true;
    mime.enable = true;
  };

  programs.ssh.askPassword = "";
  services = {
    openssh.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa.enable = true;
    };
    udisks2.enable = true;
    gvfs.enable = true;
    displayManager = {
      defaultSession = "hyprland";
      sddm = {
        enable = true;
        wayland = {
          enable = true;
        };
      };
    };
    gnome.gnome-keyring.enable = true;
    logind.extraConfig = "HandlePowerKey=ignore";
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services = {
      sddm.enableGnomeKeyring = true;
      hyprlock = {};
    };
  };

  system.stateVersion = conf.stateVersion;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
