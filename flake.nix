{
  description = "DevShell for å utvikle Vulkan- og OpenGL-renderer med Louvre";

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

      # Hent din lokale Louvre-derivasjon via callPackage
      louvre = pkgs.callPackage ./derivations/louvre/default.nix {};
    in rec {
      devShells.x86_64-linux.default = pkgs.mkShell {
        name = "louvre-gfx-dev-shell";

        buildInputs = [
          # 1) Din egen Louvre-pakke
          louvre

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
          pkgs.glfw                # En enkel windowing/library for OpenGL/Vulkan
          pkgs.libxkbcommon        # Tastatur-støtte i kombinasjon med GLFW/Wayland
          pkgs.libdrm              # Direct Rendering Manager, ofte brukt for EGL/GBM
          pkgs.egl-wayland         # EGL-overgang for Wayland
          pkgs.glew                # Kan være nyttig for OpenGL-funksjonsoppslag
          # (Evt. legg til andre OpenGL-verktøy her etter behov)

          # 5) Generelle bygge-verktøy (CMake/Meson/Ninja/Pkg-config)
          pkgs.cmake
          pkgs.pkg-config
          pkgs.meson
          pkgs.ninja

          # 6) Kompiler (for C/C++)
          pkgs.gcc                  # eller pkgs.clang om du foretrekker det
        ];

        shellHook = ''
          # Vulkan‐valideringslag
          export VK_LAYER_PATH=${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d

          # Legg OpenGL-libsti i PKG_CONFIG_PATH for å finne .pc-filer
          export PKG_CONFIG_PATH=${pkgs.mesa}/lib/pkgconfig${":$PKG_CONFIG_PATH"}

          echo "🛠️  DevShell klar: Louvre + Vulkan + OpenGL er lastet."
        '';
      };
    };
}

