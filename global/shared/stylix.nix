{ pkgs, ... }: {
  stylix = {
    enable = true;
    image = builtins.toPath "${pkgs.bubbleshell.bubble-config}/img/wallpaper.png";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest.yaml";
    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      sansSerif = {
        package = pkgs.bubbleshell.fonts;
        name = "Varela Round";
      };
      monospace = {
        package = pkgs.maple-mono.variable;
        name = "Maple Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        terminal = 11;
      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    polarity = "dark";
  };
}
