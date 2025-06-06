project('argon', 'cpp',
  version : '0.1.0',
  default_options : [
    'cpp_std=c++23',        # eller ønsket C++-standard
    'warning_level=3'
  ]
)

# --- 1. Hent inn alle dependencies via pkg-config ---
# Bytt ut navnene under med nøyaktig de pkg-config-pakkenavnene du bruker.
louvre_dep         = dependency('louvre')        # pkg-config: louvre
glesv2_dep         = dependency('glesv2')        # pkg-config: glesv2
wayland_server_dep = dependency('wayland-server') # pkg-config: wayland-server
input_dep          = dependency('libinput')       # pkg-config: libinput
fontconfig_dep     = dependency('fontconfig')     # pkg-config: fontconfig
freetype_dep       = dependency('freetype')       # pkg-config: freetype
icuuc_dep          = dependency('icu-uc')         # pkg-config: icu-uc

src_dir = meson.current_source_dir() / 'src'

sources = []
filelist = file('src')     # denne gir kun et enkelt `file`‐objekt for katalogen
# Bruk "file_glob" dersom tilgjengelig:
sources += file_glob('src/**/*.cpp')
sources += file_glob('src/**/*.c')

common_src = files(
  'src/common/TextRenderer.cpp',
  'src/common/TextRenderer.h'
)

executable(
  'argon',                # navnet på kjørbar fil
  sources + common_src,           # alle kildefilene samlet
  dependencies : [
    louvre_dep,
    glesv2_dep,
    wayland_server_dep,
    input_dep,
    fontconfig_dep,
    freetype_dep,
    icuuc_dep
  ],
  install : true                  # flagg som sier “installer denne binæren”
)

