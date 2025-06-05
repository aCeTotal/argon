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

  sourceRoot = "${src.name}/src";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  # Kun de Meson-avhengighetene som er nevnt i meson.build
  buildInputs = [
    libGL         # glesv2_dep
    wayland       # wayland_server_dep
    libinput      # input_dep
    fontconfig    # fontconfig_dep
    freetype      # freetype_dep
    icu           # icuuc_dep
  ];

  configurePhase = ''
    mkdir -p build
    meson setup build "${sourceRoot}" \
      --prefix=$out
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
    description = "C++ wayland compositor and Vulkan Renderer";
    homepage = "https://github.com/aCetotal/argon";
    mainProgram = "argon";
    maintainers = [ lib.maintainers.acetotal ];
    platforms = lib.platforms.linux;
  };
}

