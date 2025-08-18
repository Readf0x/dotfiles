{ lib
, rustPlatform
, fetchFromGitHub
}: rustPlatform.buildRustPackage (finalAttrs: rec {
  pname = "otf2psf";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "pcarrin2";
    repo = "otf2psf";
    rev = "10296b40cf2b1ff80d08f55699c3d21ec8693b99";
    hash = "sha256-x+8ZgMLoP0Rchi5aVrn+kIYc2GEFwjvY1zhNXxkIk/0=";
  };

  cargoHash = "sha256-i28KfGXNspoujLPw0PQgYduGDBuJfaRp3bdgvWa1rro=";

  meta = {
    description = "Convert an OTF/TTF font into a Linux-TTY-compatible PSF2 font";
    homepage = "https://github.com/pcarrin2/otf2psf";
    license = lib.licenses.unlicense;
  };
})
