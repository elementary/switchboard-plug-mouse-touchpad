project(
    'mouse-touchpad',
    'vala', 'c',
    version: '6.1.0'
)

gettext_name = meson.project_name() + '-plug'
gnome = import('gnome')
i18n = import('i18n')

prefix = get_option('prefix')
datadir = join_paths(prefix, get_option('datadir'))
libdir = join_paths(prefix, get_option('libdir'))

add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(gettext_name),
    language:'c'
)

if get_option('gnome_40')
    add_project_arguments(['--define', 'HAS_GNOME_40'], language: 'vala')
endif

icon_res = gnome.compile_resources(
    'icon-resources',
    join_paths('data', 'io.elementary.switchboard.' + meson.project_name() + '.gresource.xml'),
    source_dir: 'data'
)

config_data = configuration_data()
config_data.set_quoted('LOCALEDIR', join_paths(get_option('prefix'), get_option('localedir')))
config_data.set_quoted('GETTEXT_PACKAGE', meson.project_name() + '-plug')
config_file = configure_file(
    input: 'src/Config.vala.in',
    output: '@BASENAME@',
    configuration: config_data
)

subdir('data')
subdir('src')
subdir('po')
