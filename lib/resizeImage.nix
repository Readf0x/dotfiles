{ lib, pkgs, ... }:

{ image
, size
, name ? "resized-image"
}:

pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = name;
  version = "1.0";

  src = image;

  nativeBuildInputs = [ pkgs.imagemagick ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out
    magick "$src" -resize ${size}^ -gravity center -extent ${size} "$out/${name}.png"
  '';
})
