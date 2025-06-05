{
  description = "DevShell for å utvikle Vulkan-, OpenGL- og Kay-/Louvre-renderere";

  inputs = {
    # Bruk nyeste unstable nixpkgs slik at vi får ferske GPU-pakker
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
  let
    # Importer nixpkgs for x86_64-linux
    pkgs = import nixpkgs {
      system = "x86_64-linux";
    };

    louvre = pkgs.callPackage ./derivations/louvre/default.nix {};
    argon    = pkgs.callPackage ./derivations/argon/default.nix {};

  in rec {
    # Eksporter pakkene slik at du kan gjøre f.eks.
    #   nix build .#louvre
    #   nix build .#kay
    packages.x86_64-linux = {
      louvre = louvre;
      argon    = argon;
    };

    # Sett den samme devShell-enivået for x86_64-linux.
    devShells.x86_64-linux.default = pkgs.mkShell {
      name = "gfx-dev-shell";

      buildInputs = [
        # 1) Dine egne pakker for Louvre og Kay
        louvre
        argon

        # 2) Vulkan-biblioteker
        pkgs.vulkan-loader
        pkgs.vulkan-headers
        pkgs.vulkan-tools
        pkgs.vulkan-validation-layers

        # 3) Shader-verktøy (GLSL→SPIR-V, HLSL osv.)
        pkgs.glslang
        pkgs.spirv-tools
        pkgs.shaderc

        # 4) OpenGL-biblioteker og utviklings-headers
        pkgs.mesa                # Inneholder libGL, EGL, GLX osv.
        pkgs.glfw                # En enkel windowing-library for OpenGL/Vulkan
        pkgs.libxkbcommon        # Tastatur-støtte i kombinasjon med GLFW/Wayland
        pkgs.libdrm              # Direct Rendering Manager, ofte brukt for EGL/GBM
        pkgs.egl-wayland         # EGL-overgang for Wayland
        pkgs.glew                # Kan være nyttig for OpenGL-funksjonsoppslag

        # 5) Wayland- og relaterte utviklingspakker
        pkgs.wayland             # gir wayland-server.pc
        pkgs.pixman              # gir pixman-1.pc

        # 6) Generelle bygge-verktøy (CMake/Meson/Ninja/Pkg-config)
        pkgs.cmake
        pkgs.pkg-config
        pkgs.meson
        pkgs.ninja

        # 7) Kompiler (for C/C++)
        pkgs.gcc                  # eller pkgs.clang om du foretrekker det
      ];

      shellHook = ''
        # Vulkan‐valideringslag
        export VK_LAYER_PATH=${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d

        # Legg OpenGL- og Wayland-libsti i PKG_CONFIG_PATH for å finne .pc-filer
        export PKG_CONFIG_PATH=${pkgs.mesa}/lib/pkgconfig:${pkgs.wayland}/lib/pkgconfig:${pkgs.pixman}/lib/pkgconfig${":$PKG_CONFIG_PATH"}

        echo "🛠️  DevShell klar: Louvre + Kay + Vulkan + OpenGL + Wayland + Pixman er lastet."
      '';
    };
  };
}

