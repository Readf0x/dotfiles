{
  lib,
  fetchFromGitHub,
  stdenv,
  makeWrapper,
  pkg-config,
  which,
  python3,
  wayland,
  wayland-scanner,
  wayland-protocols,
  libarchive,
  uthash
}: stdenv.mkDerivation (finalAttrs: {
  name = "wl-shimeji";
  pname = "shimejictl";
  version = "";

  src = fetchFromGitHub {
    owner = "CluelessCatBurger";
    repo = "wl_shimeji";
    rev = "9ad350f23d2121a4717f6215b32221d77543e0ca";
    hash = "sha256-ME/Mbasi6DfJ0N9OX3imy9VPrZhgHwBn271+TbUDT3M=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    wayland-protocols
    wayland-scanner
    libarchive
    uthash
    pkg-config
    which
    python3
    makeWrapper
  ];
  buildInputs = [
    wayland
    libarchive.lib
  ];

  outputs = [ "out" "dev" ];

  buildPhase = ''
    make
  '';
  installPhase = let
    python = python3.withPackages (ps: with ps; [ pillow ]);
  in ''
    DESTDIR=$out PREFIX="" make install
    mkdir -p $dev
    mv $out/include $dev
    cat <<EOF > $out/share/systemd/user/wl_shimeji.service
    [Unit]
    Description=wl_shimeji's overlay daemon

    [Service]
    Type=simple
    ExecStart=$out/bin/shimeji-overlayd
    EOF
    wrapProgram $out/bin/shimejictl \
      --set PYTHONPATH "${python}/lib/python3.11/site-packages" \
      --set XDG_CURRENT_DESKTOP "" \
      --prefix PATH : ${lib.makeBinPath [ python ]}
  '';

  meta = {
    description = "Shimeji reimplementation for Wayland in C";
    homepage = "https://github.com/CluelessCatBurger/wl_shimeji/";
    license = lib.licenses.gpl2;
  };
})
