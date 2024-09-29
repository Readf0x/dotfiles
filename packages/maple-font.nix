{ pkgs, ... }: with pkgs; let
  maple-font = { pname, sha256, desc }:
    stdenv.mkDerivation rec{
      inherit pname;
      version = "7.0-beta26";
      src = fetchurl {
        url = "https://github.com/subframe7536/Maple-font/releases/download/v${version}/${pname}.zip";
        inherit sha256;
      };

      # Work around the "unpacker appears to have produced no directories"
      # case that happens when the archive doesn't have a subdirectory.
      sourceRoot = ".";
      nativeBuildInputs = [ unzip ];
      installPhase = ''
        find . -name '*.ttf'    -exec install -Dt $out/share/fonts/truetype {} \;
        find . -name '*.otf'    -exec install -Dt $out/share/fonts/opentype {} \;
        find . -name '*.woff2'  -exec install -Dt $out/share/fonts/woff2 {} \;
      '';

      meta = with lib; {
        homepage = "https://github.com/subframe7536/Maple-font";
        description = ''
          Open source ${desc} font with round corner and ligatures for IDE and command line
        '';
        license = licenses.ofl;
        platforms = platforms.all;
        maintainers = with maintainers; [ oluceps ];
      };
    };

in
{
  NF-CN = maple-font {
    pname = "MapleMono-NF-CN";
    sha256 = "sha256-JIeQEp1FYqkF2FcZazyrrq+PlP2UTadyQ9jbjtEe+Oc=";
    desc = "Nerd Font CN";
  };

  NF = maple-font {
    pname = "MapleMono-NF";
    sha256 = "sha256-Ob7foPHysOJHMlCJun5Euaq0K/v7b+47EXC+8AZw33U=";
    desc = "Nerd Font";
  };

  OTF = maple-font {
    pname = "MapleMono-OTF";
    sha256 = "sha256-1E5/XDASQ73pObGAbijYbsw6AJqHN/WY4HpWpz8wGpM=";
    desc = "OpenType";
  };

  TTF = maple-font {
    pname = "MapleMono-TTF";
    sha256 = "sha256-Yk8Gf2fachz9vUgkcg4AZT7b8ALH9UJ/l8E83DoPiEc=";
    desc = "TrueType";
  };

  Variable = maple-font {
    pname = "MapleMono-Variable";
    sha256 = "sha256-XMuqICVGoNhbDukO+A9NG18yqoKfcWL8jb/hYhbY06U=";
    desc = "Variable";
  };

  Woff2 = maple-font {
    pname = "MapleMono-Woff2";
    sha256 = "sha256-hewNYrZkHtqzCLI65v272IKjXTUSrjYbY1l5fgX3FfE=";
    desc = "Woff2";
  };
}

