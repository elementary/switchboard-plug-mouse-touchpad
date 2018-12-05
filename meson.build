project(
    'mouse-touchpad',
    'vala', 'c',
    version: '2.1.4'
)

gettext_name = meson.project_name() + '-plug'
gnome = import('gnome')
i18n = import('i18n')

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
