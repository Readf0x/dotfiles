{ self, conf, ... }: let
  TCG = "/mnt/Games/Games/TCG.Card.Shop.Simulator.v0.47.3";
in {
  xdg.desktopEntries = {
    tcg = {
      name = "TCG Card Shop Simulator";
      exec = "gamescope -W 1920 -H 1080 -r 60 -- wine ${TCG}/Card\\ Shop\\ Simulator.exe";
      categories = [ "Game" ];
      icon = "${TCG}/TCG.png";
    };
    ukmm = {
      name = "UKMM";
      comment = "Starts U-King Mod Manager";
      exec = "${self.packages.${conf.system}.ukmm-fork}/bin/ukmm %u";
      mimeType = [ "x-scheme-handler/bcml" ];
    };
  };
  home.sessionVariables.OLLAMA_MODELS = "/mnt/Games/ollama";
  wayland.windowManager.hyprland.settings.exec-once = [ "steam -silent" ];
}

