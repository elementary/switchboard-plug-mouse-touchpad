plug_files = files(
    'Plug.vala',
    'Views/Clicking.vala',
    'Views/Mouse.vala',
    'Views/Pointing.vala',
    'Views/Touchpad.vala',
    'Views/Gestures.vala',
    'Utils/ToucheggSettings.vala',
)

switchboard_dep = dependency('switchboard-3')
switchboard_plugsdir = switchboard_dep.get_pkgconfig_variable('plugsdir', define_variable: ['libdir', libdir])

shared_module(
    meson.project_name(),
    icon_res,
    plug_files,
    config_file,
    dependencies: [
        dependency('glib-2.0'),
        dependency('gio-2.0'),
        dependency('gobject-2.0'),
        dependency('granite-7', version: '>=7.4.0'),
        dependency('gtk4'),
        dependency('libxml-2.0'),
        switchboard_dep
    ],
    install: true,
    install_dir : join_paths(switchboard_plugsdir, 'hardware')
)
