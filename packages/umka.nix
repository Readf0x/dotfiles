{ stdenv
, fetchFromGitHub
, lib
}: stdenv.mkDerivation (finalAttrs: rec {
  pname = "umka";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "vtereshkov";
    repo = "umka-lang";
    rev = "v${version}";
    hash = "sha256-UerEmJdD0/Hx/Pqw3NI3cZwjkX9lRWqI5rL0GGYKFwc=";
  };

  outputs = [ "out" "dev" ];

  PREFIX = placeholder "out";
  INCLUDEDIR = "${placeholder "dev"}/include";

  meta = {
    description = "A statically typed embeddable scripting language";
    homepage = "https://github.com/vtereshkov/umka-lang";
    license = lib.licenses.bsd2;
  };
})
