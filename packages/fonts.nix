{ pkgs }: pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "Fonts";
  version = "1.0";

  src = ./fonts;

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 --target $out/share/fonts/truetype ./*.ttf
    runHook postInstall
  '';
})
