{ pkgs, ... }:
pkgs.appimageTools.wrapType2 rec {
  pname = "dopamine";
  version = "3.0.0-preview.33";

  src = pkgs.fetchurl {
    url = "https://github.com/digimezzo/dopamine/releases/download/v${version}/Dopamine-${version}.AppImage";
    hash = "sha256-W8XkXnsP0AqYV0wznKe1dbPm2VuhoZWl03G7hib/uxE=";
  };

  extraInstallCommands =
    let
      contents = pkgs.appimageTools.extract { inherit pname version src; };
    in
    ''
      install -Dm644 ${contents}/dopamine.desktop $out/share/applications/dopamine.desktop
      substituteInPlace $out/share/applications/dopamine.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=dopamine'
      cp -r ${contents}/usr/share/icons $out/share
    '';
}
