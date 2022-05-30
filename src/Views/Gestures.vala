/*
 * Copyright 2011-2021 elementary, Inc. (https://elementary.io)
 *           2020 José Expósito <jose.exposito89@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA.
 */

public class MouseTouchpad.GesturesView : Granite.SimpleSettingsPage {
    public GesturesView () {
        Object (
            icon_name: "mouse-touchpad-gestures",
            title: _("Gestures")
        );
    }

    construct {
        var horizontal_swipe_header = new Granite.HeaderLabel (_("Swipe Horizontally"));

        var three_swipe_horizontal_label = new Gtk.Label (_("Three fingers:"));

        var three_swipe_horizontal_combo = new Gtk.ComboBoxText () {
            hexpand = true
        };
        three_swipe_horizontal_combo.append ("none", _("Do nothing"));
        three_swipe_horizontal_combo.append ("switch-to-workspace", _("Switch to workspace"));

        var four_swipe_horizontal_label = new Gtk.Label (_("Four fingers:"));

        var four_swipe_horizontal_combo = new Gtk.ComboBoxText ();
        four_swipe_horizontal_combo.append ("none", _("Do nothing"));
        four_swipe_horizontal_combo.append ("switch-to-workspace", _("Switch to workspace"));

        var swipe_up_header = new Granite.HeaderLabel (_("Swipe Up")) {
            margin_top = 12
        };

        var three_swipe_up_label = new Gtk.Label (_("Three fingers:"));

        var three_swipe_up_combo = new Gtk.ComboBoxText ();
        three_swipe_up_combo.append ("none", _("Do nothing"));
        three_swipe_up_combo.append ("multitasking-view", _("Multitasking View"));

        var four_swipe_up_label = new Gtk.Label (_("Four fingers:"));

        var four_swipe_up_combo = new Gtk.ComboBoxText ();
        four_swipe_up_combo.append ("none", _("Do nothing"));
        four_swipe_up_combo.append ("multitasking-view", _("Multitasking View"));

        var pinch_header = new Granite.HeaderLabel (_("Pinch")) {
            margin_top = 12
        };

        var three_pinch_label = new Gtk.Label (_("Three fingers:"));

        var three_pinch_combo = new Gtk.ComboBoxText ();
        three_pinch_combo.append ("none", _("Do nothing"));
        three_pinch_combo.append ("zoom", _("Zoom"));

        var four_pinch_label = new Gtk.Label (_("Four fingers:"));

        var four_pinch_combo = new Gtk.ComboBoxText ();
        four_pinch_combo.append ("none", _("Do nothing"));
        four_pinch_combo.append ("zoom", _("Zoom"));

        content_area.attach (horizontal_swipe_header, 0, 0, 2);
        content_area.attach (three_swipe_horizontal_label, 0, 1);
        content_area.attach (three_swipe_horizontal_combo, 1, 1);
        content_area.attach (four_swipe_horizontal_label, 0, 2);
        content_area.attach (four_swipe_horizontal_combo, 1, 2);
        content_area.attach (swipe_up_header, 0, 3, 2);
        content_area.attach (three_swipe_up_label, 0, 4);
        content_area.attach (three_swipe_up_combo, 1, 4);
        content_area.attach (four_swipe_up_label, 0, 5);
        content_area.attach (four_swipe_up_combo, 1, 5);
        content_area.attach (pinch_header, 0, 6, 2);
        content_area.attach (three_pinch_label, 0, 7);
        content_area.attach (three_pinch_combo, 1, 7);
        content_area.attach (four_pinch_label, 0, 8);
        content_area.attach (four_pinch_combo, 1, 8);

        var glib_settings = new GLib.Settings ("io.elementary.desktop.wm.gestures");
        glib_settings.bind ("three-finger-swipe-horizontal", three_swipe_horizontal_combo, "active-id", GLib.SettingsBindFlags.DEFAULT);
        glib_settings.bind ("four-finger-swipe-horizontal", four_swipe_horizontal_combo, "active-id", GLib.SettingsBindFlags.DEFAULT);
        glib_settings.bind ("three-finger-swipe-up", three_swipe_up_combo, "active-id", GLib.SettingsBindFlags.DEFAULT);
        glib_settings.bind ("four-finger-swipe-up", four_swipe_up_combo, "active-id", GLib.SettingsBindFlags.DEFAULT);
        glib_settings.bind ("three-finger-pinch", three_pinch_combo, "active-id", GLib.SettingsBindFlags.DEFAULT);
        glib_settings.bind ("four-finger-pinch", four_pinch_combo, "active-id", GLib.SettingsBindFlags.DEFAULT);

        var touchegg_settings = new ToucheggSettings ();
        touchegg_settings.parse_config ();

        if (!touchegg_settings.errors) {
            three_swipe_up_combo.append ("toggle-maximized", _("Toggle maximized"));
            four_swipe_up_combo.append ("toggle-maximized", _("Toggle maximized"));

            touchegg_settings.set_maximize_settings (
                glib_settings.get_string ("three-finger-swipe-up") == "toggle-maximized", 3
            );

            touchegg_settings.set_maximize_settings (
                glib_settings.get_string ("four-finger-swipe-up") == "toggle-maximized", 4
            );

            glib_settings.changed["three-finger-swipe-up"].connect (() => {
                touchegg_settings.set_maximize_settings (
                    glib_settings.get_string ("three-finger-swipe-up") == "toggle-maximized", 3
                );
            });

            glib_settings.changed["four-finger-swipe-up"].connect (() => {
                touchegg_settings.set_maximize_settings (
                    glib_settings.get_string ("four-finger-swipe-up") == "toggle-maximized", 4
                );
            });
        }
    }
}
