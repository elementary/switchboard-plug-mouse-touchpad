/*
 * SPDX-License-Identifier: GPL-2.0-or-later
 * SPDX-FileCopyrightText: 2011-2024 elementary, Inc. (https://elementary.io)
 */

public class MouseTouchpad.MouseView : Switchboard.SettingsPage {
    public MouseView () {
        Object (
            header: _("Devices"),
            icon: new ThemedIcon ("input-mouse"),
            title: _("Mouse")
        );
    }

    construct {
        var pointer_speed_adjustment = new Gtk.Adjustment (0, -1, 1, 0.1, 0, 0);

        var pointer_speed_scale = new Gtk.Scale (HORIZONTAL, pointer_speed_adjustment) {
            hexpand = true
        };
        pointer_speed_scale.add_mark (-1, BOTTOM, _("Slower"));
        pointer_speed_scale.add_mark (0, BOTTOM, null);
        pointer_speed_scale.add_mark (1, BOTTOM, _("Faster"));

        var pointer_speed_header = new Granite.HeaderLabel (_("Pointer Speed")) {
            mnemonic_widget = pointer_speed_scale
        };

        var accel_profile_default = new Gtk.CheckButton.with_label (_("Hardware default"));
        var accel_profile_flat = new Gtk.CheckButton.with_label (_("None")) {
            group = accel_profile_default
        };
        var accel_profile_adaptive = new Gtk.CheckButton.with_label (_("Adaptive")) {
            group = accel_profile_default
        };

        var natural_scrolling_switch = new Gtk.Switch () {
            halign = END,
            hexpand = true,
            valign = CENTER
        };

        var natural_scrolling_header = new Granite.HeaderLabel (_("Natural Scrolling")) {
            mnemonic_widget = natural_scrolling_switch,
            secondary_text = _("Scrolling moves the content, not the view")
        };

        var natural_scrolling_box = new Gtk.Box (HORIZONTAL, 12) {
            margin_top = 12
        };
        natural_scrolling_box.append (natural_scrolling_header);
        natural_scrolling_box.append (natural_scrolling_switch);

        var content_box = new Gtk.Box (VERTICAL, 6);
        content_box.append (pointer_speed_header);
        content_box.append (pointer_speed_scale);
        content_box.append (new Granite.HeaderLabel (_("Pointer Acceleration")));
        content_box.append (accel_profile_default);
        content_box.append (accel_profile_flat);
        content_box.append (accel_profile_adaptive);
        content_box.append (natural_scrolling_box);

        child = content_box;

        var settings = new GLib.Settings ("org.gnome.desktop.peripherals.mouse");
        settings.bind ("natural-scroll", natural_scrolling_switch, "active", GLib.SettingsBindFlags.DEFAULT);
        settings.bind ("speed", pointer_speed_adjustment, "value", GLib.SettingsBindFlags.DEFAULT);

        switch (settings.get_enum ("accel-profile")) {
            case 1:
                accel_profile_flat.active = true;
                break;
            case 2:
                accel_profile_adaptive.active = true;
                break;
            default:
            case 0:
                accel_profile_default.active = true;
                break;
        }

        accel_profile_default.toggled.connect (() => {
            settings.set_enum ("accel-profile", 0);
        });

        accel_profile_flat.toggled.connect (() => {
            settings.set_enum ("accel-profile", 1);
        });

        accel_profile_adaptive.toggled.connect (() => {
            settings.set_enum ("accel-profile", 2);
        });
    }
}
