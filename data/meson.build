icon_sizes = ['32', '48']

foreach i : icon_sizes
    install_data(
        join_paths('clicking', i + '.svg'),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i, 'apps'),
        rename: 'io.elementary.switchboard.mouse-touchpad-clicking.svg'
    )
    install_data(
        join_paths('clicking', i + '.svg'),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i + '@2', 'apps'),
        rename: 'io.elementary.switchboard.mouse-touchpad-clicking.svg'
    )
endforeach

i18n.merge_file(
    input: 'io.elementary.switchboard.mouse-touchpad.appdata.xml.in',
    output: 'io.elementary.switchboard.mouse-touchpad.appdata.xml',
    po_dir: join_paths(meson.source_root (), 'po', 'extra'),
    install_dir: join_paths(datadir, 'metainfo'),
    install: true
)
