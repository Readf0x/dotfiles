{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "adi1090x-plymouth-themes";
  version = "1.0";

  src = pkgs.fetchFromGitHub {
    owner = "adi1090x";
    repo = "plymouth-themes";
    rev = "5d8817458d764bff4ff9daae94cf1bbaabf16ede";
    hash = "sha256-e3lRgIBzDkKcWEp5yyRCzQJM6yyTjYC5XmNUZZroDuw=";
  };

  postPatch = ''
    rm LICENSE README.md ubuntu-logo-preview.png showplymouth.sh
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plymouth/themes
    cp -r pack_*/* $out/share/plymouth/themes
    find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;
    runHook postInstall
  '';
}
