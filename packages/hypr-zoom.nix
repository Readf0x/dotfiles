{ buildGoModule
, fetchFromGitHub
}:

buildGoModule {
  name = "hypr-zoom";
  pname = "hypr-zoom";

  src = fetchFromGitHub {
    owner = "FShou";
    repo = "hypr-zoom";

    rev = "235182e574a8a60922142afcc39b924c0f9b6579";
    hash = "sha256-/5nC4iLcDJ+UODLpzuVitQTFdBZtz75ep73RSN37hHE=";

    meta = {
      description = "Smoothly Animated Zoom for Hyprland";
      homepage = "https://github.com/FShou/hypr-zoom";
    };
  };

  vendorHash = "sha256-BCx2hKi6U/MPJlwAmnM4/stiolhYkakpe4EN3e5r6L4=";
}

