{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, skia            # for Skia
, egl             # for EGL
, gl              # for OpenGL
, glesv2          # for OpenGL ES 2
, xkbcommon       # for xkbcommon
, plutovg         # for PlutoVG
, plutosvg        # for PlutoSVG
, yoga            # for Yoga
, wayland         # hvis du vil bygge eksempler som krever Wayland
, xorgproto       # for Wayland-protokoller
}:

stdenv.mkDerivation rec {
  pname    = "kay";
  version  = "1.1.1-1";

  src = fetchFromGitHub {
    owner  = "aCeTotal";
    repo   = "Kay";
    rev    = "99d68a3";
    hash   = "sha256-ZdV/KvYnPN4IKU6kbjDhCgcC3TdWqZbNJzDt39ZQ2x8=";
  };

  # Verktøy for å konfigurere og bygge med Meson/Ninja:
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  # Kjøre­tids­avhengigheter (til både Kay-biblioteket og evt. eksempler/Marco):
  buildInputs = [
    skia
    egl
    gl
    glesv2
    xkbcommon
    plutovg
    plutosvg
    yoga
    wayland
    xorgproto
  ];

  # Slå på eksempler og Marco; fjern linjene nedenfor om du ikke trenger dem:
  mesonFlags = [
    "-Dbuild_examples=true"
    "-Dbuild_marco=true"
  ];

  # Vi kjører Meson og Ninja manuelt i de respektive fasene:
  configurePhase = ''
    # Opprett en egen build-dir og pek på roten av repo (der meson.build ligger)
    mkdir build
    meson setup build "${src}" \
      --prefix=$out \
      ${lib.concatStringsSep " " mesonFlags}
  '';

  buildPhase = ''
    ninja -C build
  '';

  installPhase = ''
    ninja -C build install
  '';

  # Hvis du ønsker eget "dev"‐output (headers og .pc), kan du beholde dette:
  outputs = [ "out" "dev" ];

  # Hoved‐metadata for pakken:
  meta = {
    description = "C++ GUI toolkit powered by Skia and Yoga";
    homepage    = "https://github.com/aCeTotal/Kay";
    license     = lib.licenses.mit;                 # Juster hvis Lisensen er annerledes
    maintainers = [ lib.maintainers.yournick ];     # Endre til din Nixpkgs‐alias
    platforms   = lib.platforms.linux;              # Antar Linux‐only
  };
}

