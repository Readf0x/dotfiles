{ stdenv
, zsh
, ...
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "init";
  version = "1";

  src = ../global/scripts;

  buildInputs = [ zsh ];

  installPhase = ''
    mkdir -p $out/bin
    cp init $out/bin/init
  '';
})

