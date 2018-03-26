plug_files = files(
    'mouse-touchpad.vala',
    'Widgets/TouchpadSection.vala',
    'Widgets/SettingLabel.vala',
    'Widgets/MouseSection.vala',
    'Widgets/GeneralSection.vala',
    'Backend/TouchpadSettings.vala',
    'Backend/MouseSettings.vala'
)

switchboard_dep = dependency('switchboard-2.0')

shared_module(
    meson.project_name(),
    plug_files,
    dependencies: [
        dependency('glib-2.0'),
        dependency('gio-2.0'),
        dependency('gobject-2.0'),
        dependency('granite'),
        dependency('gtk+-3.0'),
        switchboard_dep
    ],
    install: true,
    install_dir : join_paths(switchboard_dep.get_pkgconfig_variable('plugsdir'), 'hardware')
)
