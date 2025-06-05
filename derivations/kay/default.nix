{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, skia             # Skia‐biblioteket
, egl              # EGL (pkgs.egl)
, gl               # OpenGL (pkgs.gl)
, glesv2           # OpenGL ES 2 (pkgs.glesv2)
, libxkbcommon     # xkbcommon‐biblioteket
, plutovg          # PlutoVG‐biblioteket
, plutosvg         # PlutoSVG‐biblioteket
, wayland          # for å bygge eksempler som krever Wayland
, xorgproto        # Wayland‐protokoller
}:

stdenv.mkDerivation rec {
  pname    = "kay";
  version  = "1.1.1-1";

  src = fetchFromGitHub {
    owner = "aCeTotal";
    repo  = "Kay";
    rev   = "9e303bc";            # Commit som du vil bygge
    sha256 = "1q2w3e4r5t6y7u8i9o0pabcdefghijk1234567890lmnopqrstu";
    # Husk å bytte ut SHA256 over med det Nix selv rapporterte da du brukte lib.fakeSha256
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  # Legg inn nøyaktige pkg-config-navn for egl, gl og glesv2:
  buildInputs = [
    skia
    egl
    gl
    glesv2
    libxkbcommon
    plutovg
    plutosvg
    wayland
    xorgproto
  ];

  # Slå på eksempler og “marco” i Meson (fjern om du ikke trenger det)
  mesonFlags = [
    "-Dbuild_examples=true"
    "-Dbuild_marco=true"
  ];

  # Meson må peke på roten av repo-et (der meson.build ligger)
  configurePhase = ''
    mkdir -p build
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

  outputs = [ "out" "dev" ];

  meta = {
    description = "C++ GUI toolkit powered by Skia and Yoga";
    homepage    = "https://github.com/aCeTotal/Kay";
    license     = lib.licenses.mit;                 # Juster om lisensen er annerledes
    maintainers = [ lib.maintainers.yournick ];     # Endre til din egen maintainer‐alias
    platforms   = lib.platforms.linux;              # Antar Linux‐only
  };
}

