{ ... }: let
  TCG = "/mnt/Games/Games/TCG.Card.Shop.Simulator.v0.47.3";
in {
  xdg.desktopEntries = {
    tcg = {
      name = "TCG Card Shop Simulator";
      exec = "gamescope -W 1920 -H 1080 -r 60 -- wine ${TCG}/Card\\ Shop\\ Simulator.exe";
      categories = [ "Game" ];
      icon = "${TCG}/TCG.png";
    };
  };
}

