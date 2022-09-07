# Mouse & Touchpad Settings
[![Translation status](https://l10n.elementary.io/widgets/switchboard/-/switchboard-plug-mouse-touchpad/svg-badge.svg)](https://l10n.elementary.io/engage/switchboard/?utm_source=widget)

![screenshot](data/screenshot-clicking.png?raw=true)

## Building and Installation

You'll need the following dependencies:

* libswitchboard-3-dev
* libgranite-7-dev
* libxml2-dev
* meson
* valac

Run `meson` to configure the build environment and then `ninja` to build

    meson build --prefix=/usr
    cd build
    ninja

To install, use `ninja install`

    ninja install
