project(
    'Louvre',
    'cpp',
    version: '0.1.0',
    meson_version: '>= 0.56.0',
    default_options: [
        'warning_level=3',
        'buildtype=release',
        'cpp_std=c++20'
    ]
)

cpp = meson.get_compiler('cpp')

# -------------- DEPENDENCIES --------------

wayland_server_dep  = dependency('wayland-server', version: '>= 1.20.0')
gl_dep              = dependency('gl', version: '>= 1.2')
egl_dep             = dependency('egl', version: '>=1.5')
glesv2_dep          = dependency('glesv2', version: '>= 3.2')
udev_dep            = dependency('libudev', version: '>= 249')
xcursor_dep         = dependency('xcursor', version: '>= 1.2.0')
xkbcommon_dep       = dependency('xkbcommon', version: '>= 1.4.0')
pixman_dep          = dependency('pixman-1', version: '>= 0.40.0')
drm_dep             = dependency('libdrm', version: '>= 2.4.113')
input_dep           = dependency('libinput', version: '>= 1.20.0')
libseat_dep         = dependency('libseat', version: '>= 0.6.4')
srm_dep             = dependency('SRM', version: '>= 0.12.1')
pthread_dep         = cpp.find_library('pthread')
dl_dep              = cpp.find_library('dl')

include_paths = [include_directories('./lib/')]

# -------------- LIBRARY --------------

louvre = library(
    'Louvre',
    sources : files(),  # Ingen felles libkilde spesifisert
    include_directories : include_paths,
    dependencies : [
        wayland_server_dep,
        egl_dep,
        glesv2_dep,
        input_dep,
        udev_dep,
        pthread_dep,
        xcursor_dep,
        xkbcommon_dep,
        pixman_dep,
        dl_dep,
        drm_dep,
        libseat_dep,
        srm_dep
    ],
    install : true
)

louvre_dep = declare_dependency(
    dependencies: [pixman_dep, wayland_server_dep, drm_dep, xkbcommon_dep],
    include_directories : include_paths,
    link_with : louvre
)

# -------------- BACKENDS --------------

subdir('backends/graphic/DRM')
subdir('backends/input/Libinput')

# Wayland backends – bygges hvis tilgjengelige deps
wayland_client_dep  = dependency('wayland-client', version: '>= 1.20.0', required: false)
wayland_egl_dep     = dependency('wayland-egl', version: '>= 18.1.0', required: false)

if wayland_client_dep.found() and wayland_egl_dep.found()
  subdir('backends/graphic/Wayland')
  subdir('backends/input/Wayland')
endif

# -------------- TILING / MAIN --------------

subdir('tiling')

