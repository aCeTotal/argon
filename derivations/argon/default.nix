{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, fontconfig
, freetype
, icu
, libGL
, libinput
, wayland
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "argon";
  version = "0.1.1-1";

  src = fetchFromGitHub {
    owner = "aCeTotal";
    repo = "argon";
    rev = "4d53f14";
    hash = "sha256-ZdV/KvYnPN4IKU6kbjDhCgcC3TdWqZbNJzDt39ZQ2x8=";
  };

  # Vi har fjernet sourceRoot, så Meson kjører fra roten av 'source/' der meson.build ligger.

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  # Bare de pakkene som faktisk listes i meson.build som dependencies
  buildInputs = [
    libGL      # glesv2_dep
    wayland    # wayland_server_dep
    libinput   # input_dep
    fontconfig # fontconfig_dep
    freetype   # freetype_dep
    icu        # icuuc_dep
  ];

  configurePhase = ''
    mkdir -p build
    # Viktig: plasser --prefix foran posisjonelle argumenter slik at Meson vet
    # at "build" blir build-dir og "." blir source-dir.
    meson setup --prefix=$out build .
  '';

  buildPhase = ''
    ninja -C build
  '';

  installPhase = ''
    ninja -C build install
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "C++ Wayland compositor and Vulkan renderer";
    homepage = "https://github.com/aCeTotal/argon";
    mainProgram = "argon";
    maintainers = [ lib.maintainers.dblsaiko ];
    platforms = lib.platforms.linux;
  };
}

