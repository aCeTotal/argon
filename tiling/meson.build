
# Samle alle relevante kildefiler i denne mappen
sources = files(
    'App.cpp', 'Client.cpp', 'Compositor.cpp', 'Dock.cpp', 'DockApp.cpp', 'DockItem.cpp', 'Global.cpp', 'InputRect.cpp', 'Keyboard.cpp', 'LayerRole.cpp', 'Output.cpp', 'Pointer.cpp', 'Popup.cpp', 'Seat.cpp', 'SessionLockManager.cpp', 'Surface.cpp', 'TestView.cpp', 'Tooltip.cpp', 'Topbar.cpp', 'Toplevel.cpp', 'ToplevelButton.cpp', 'ToplevelView.cpp', 'Touch.cpp', 'UITextureView.cpp', 'Workspace.cpp', 'main.cpp'
)

# Sett opp kjørbar fil
executable(
    'louvre-views',
    sources,
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
assets = files(
  'common/assets/dock_app.png',
  'common/assets/firefox.png',
  'common/assets/inkscape.png',
  'common/assets/nautilus.png',
  'common/assets/obs.png',
  'common/assets/qtcreator.png',
  'common/assets/terminal.png',
  'common/assets/ui@2x.png',
  'common/assets/vscode.png',
  'common/assets/wallpaper.png',
  'common/assets/weston-terminal.png',
  'common/assets/wofi.png'
)

install_data(
    assets,
    install_dir: ASSETS_INSTALL_PATH
)
