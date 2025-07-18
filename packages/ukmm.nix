{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, cmake
, pkg-config
, wrapGAppsHook3
, libglvnd
, libxkbcommon
, openssl
, ...
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ukmm";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "GingerAvalanche";
    repo = "ukmm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jnZJXWni8UpdnEvYff1rtAQPrc3l7c/VLoyLGUrQTU4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vNpKaFMeKO2EM7XQ4rgVRJwgVBQueMrJ5xN8eD3EQNk=";

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    libglvnd
    libxkbcommon
    openssl
  ];

  # Force linking to libEGL, which is always dlopen()ed, and to
  # libwayland-client & libxkbcommon, which is dlopen()ed based on the
  # winit backend.
  NIX_LDFLAGS = [
    "--push-state"
    "--no-as-needed"
    "-lEGL"
    "-lwayland-client"
    "-lxkbcommon"
    "--pop-state"
  ];

  cargoTestFlags = [
    "--all"
  ];

  checkFlags = [
    # Requires a game dump of Breath of the Wild
    "--skip=gui::tasks::tests::remerge"
    "--skip=pack::tests::pack_mod"
    "--skip=project::tests::project_from_mod"
    "--skip=tests::read_meta"
    "--skip=unpack::tests::read_mod"
    "--skip=unpack::tests::unpack_mod"
    "--skip=unpack::tests::unzip_mod"

    # Requires Clear Camera mod
    "--skip=bnp::test_convert"
  ];

  meta = with lib; {
    description = "New mod manager for The Legend of Zelda: Breath of the Wild";
    homepage = "https://github.com/NiceneNerd/ukmm";
    changelog = "https://github.com/NiceneNerd/ukmm/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = platforms.linux;
    broken = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64;
    mainProgram = "ukmm";
  };
})
