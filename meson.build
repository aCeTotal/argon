project(
  'argon',
  'c', 'cpp',
  version : '0.1.0',
  meson_version: '>= 0.60.0',
  default_options: [
    'warning_level=2',
    'cpp_std=c++23',
  ]
)

# Avhengigheter via pkg-config; i devShell vil pkg-config-wrapper automatisk finne .pc-filene
wayland_server_dep = dependency('wayland-server', required : true)
pixman_dep        = dependency('pixman-1',      required : true)
kay_dep           = dependency('Kay',           required : true)
louvre_dep        = dependency('Louvre',        required : true)

# Lag IncludeDirectories-objekter for egne kilder og Louvre
src_inc    = include_directories('src')
louvre_inc = louvre_dep.include_directories()

executable(
  'argon',
  # Finn alle .cpp og .c under src/
  sources : run_command(
    'find', 'src', '-type', 'f', '-name', '*[.cpp,.c]',
    check : false
  ).stdout().strip().split('\n'),
  include_directories: [ src_inc, louvre_inc ],
  dependencies       : [
    wayland_server_dep,
    pixman_dep,
    kay_dep,
    louvre_dep,
  ],
  install : true
)

