{ pkgs, unstable, conf, inputs, ... }: {
  stylix = {
    enable = true;
    image = builtins.toPath "${inputs.wallpapers.packages.${conf.system}.default}/89875190_p0.jpg";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tender.yaml";
    fonts = {
      serif = {
        package = pkgs.google-fonts;
        name = "Bitter";
      };
      sansSerif = {
        package = pkgs.ubuntu_font_family;
        name = "Ubuntu";
      };
      monospace = {
        package = unstable.maple-mono.variable;
        name = "Maple Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
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

    targets = {
      nixvim.enable = false;
      gtk.enable = false;
    };

    polarity = "dark";
  };
}
