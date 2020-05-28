project(
    'mouse-touchpad',
    'vala', 'c',
    version: '2.4.2'
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

icon_res = gnome.compile_resources(
    'icon-resources',
    join_paths('data', 'io.elementary.switchboard.' + meson.project_name() + '.gresource.xml'),
    source_dir: 'data'
)

subdir('data')
subdir('src')
subdir('po')
