{ stdenv
, zsh
, ...
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "install";
  version = "1";

  src = ./installer;

  buildInputs = [ zsh ];

  installPhase = ''
    mkdir -p $out/bin
    cp installer.zsh $out/bin/install
  '';
})

