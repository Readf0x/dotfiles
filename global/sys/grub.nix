{ pkgs, lib', ... }: let
  resizeImage = 
    { image
    , size
    , name ? "resized-image"
    }:

    pkgs.stdenv.mkDerivation (finalAttrs: {
      pname = name;
      version = "1.0";

      src = image;

      nativeBuildInputs = with pkgs; [ imagemagick libjpeg libpng ];

      phases = [ "installPhase" ];

      installPhase = ''
        mkdir -p $out
        magick "$src" -resize ${size}^ -gravity center -extent ${size} "$out/${name}.png"
      '';
    });
in {
  boot.loader = {
    grub = {
      efiSupport = true;
      useOSProber = true;
      device = "nodev";
    };
    grub2-theme = rec {
      enable = true;
      theme = "vimix";
      customResolution = lib'.monitors.toRes (lib'.monitors.getId 0).res;
      splashImage = "${resizeImage {
        image = "${pkgs.wallpapers}/boot.jpg";
        size = customResolution;
        name = "boot";
      } }/boot.png";
    };
  };
}
