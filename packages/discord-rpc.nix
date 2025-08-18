{ stdenv
, fetchurl
}:

stdenv.mkDerivation {
  pname = "discord-rpc";
  version = "1";

  src = fetchurl {
    url = "https://github.com/mellowagain/rpc-wine/releases/download/1.0.0/rpc-wine.tar.gz";
    hash = "sha256-Drl8mrz3CWNMQTmul0jWxtxAZuHwOrfzrmfThoJlXAc=";
  };

  sourceRoot = "wine-rpc";

  dontBuild = true;

  unpackPhase = ''
    tar xvf $src
    mkdir -p $sourceRoot
    mv bin* $sourceRoot
  '';

  installPhase = ''
    mkdir -p $out/share/winedll/discord-rpc
    cp -r bin* $out/share/winedll/discord-rpc
  '';
}
