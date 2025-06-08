
# Samle alle relevante kildefiler fra undermapper
sources = files(
    'main.cpp',
)

# Legg til spesifikk felleskode
common_src = files('common/TextRenderer.cpp')

# Samle alle kildefiler rekursivt fra undermapper
subdirs = ['client', 'common', 'core', 'input', 'roles', 'seat', 'ui']
foreach dir : subdirs
    sources += files(join_paths(dir, '*.cpp'))
    sources += files(join_paths(dir, '*.c'))
endforeach

# Sett opp kjørbar fil
executable(
    'louvre-views',
    [sources, common_src],
    dependencies : [
        louvre_dep,
        glesv2_dep,
        wayland_server_dep,
        input_dep,
        fontconfig_dep,
        freetype_dep,
        icuuc_dep
    ],
    install : true
)

# Konfigurer og installer desktop-fil
session_conf = configuration_data()
session_conf.set('LOUVRE_VIEWS_PATH', join_paths(get_option('prefix'), get_option('bindir'), 'louvre-views'))

configure_file(
    input : 'common/assets/louvre.desktop.in',
    output : 'louvre.desktop',
    configuration : session_conf,
    install_dir : join_paths(get_option('prefix'), '/usr/local/share/wayland-sessions')
)

# Konfigurer og installer apps-listen
apps_conf = configuration_data()
apps_conf.set('ASSETS_PATH', ASSETS_INSTALL_PATH)

configure_file(
    input : 'common/assets/apps.list.in',
    output : 'apps.list',
    configuration : apps_conf,
    install_dir : ASSETS_INSTALL_PATH
)

# Installer bilder/ikoner
assets = files('common/assets/*.png')

install_data(
    assets,
    install_dir: ASSETS_INSTALL_PATH
)
