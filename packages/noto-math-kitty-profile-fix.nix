{ pkgs }: pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "noto-math";
  version = "69";

  src = ./.;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/fonts/noto
    cp ${pkgs.noto-fonts}/share/fonts/noto/NotoSansMath-Regular.otf $out/share/fonts/noto
  '';
})
