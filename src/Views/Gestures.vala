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

public class MouseTouchpad.GesturesView : Switchboard.SettingsPage {
    public GesturesView () {
        Object (
            icon: new ThemedIcon ("mouse-touchpad-gestures"),
            title: _("Gestures")
        );
    }

    construct {
        show_end_title_buttons = true;

        var three_swipe_horizontal_combo = new Gtk.ComboBoxText () {
            hexpand = true
        };
        three_swipe_horizontal_combo.append ("none", _("Do nothing"));
        three_swipe_horizontal_combo.append ("switch-to-workspace", _("Switch to workspace"));
        three_swipe_horizontal_combo.append ("move-to-workspace", _("Move active window to workspace"));
        three_swipe_horizontal_combo.append ("switch-windows", _("Cycle windows"));

        var three_swipe_horizontal_label = new Gtk.Label (_("Three fingers:")) {
            halign = END,
            mnemonic_widget = three_swipe_horizontal_combo
        };

        var four_swipe_horizontal_combo = new Gtk.ComboBoxText ();
        four_swipe_horizontal_combo.append ("none", _("Do nothing"));
        four_swipe_horizontal_combo.append ("switch-to-workspace", _("Switch to workspace"));
        four_swipe_horizontal_combo.append ("move-to-workspace", _("Move active window to workspace"));
        four_swipe_horizontal_combo.append ("switch-windows", _("Cycle windows"));

        var four_swipe_horizontal_label = new Gtk.Label (_("Four fingers:")) {
            halign = END,
            mnemonic_widget = four_swipe_horizontal_combo
        };

        var horizontal_swipe_grid = new Gtk.Grid () {
            accessible_role = GROUP,
            column_spacing = 6,
            row_spacing = 12
        };
        horizontal_swipe_grid.attach (three_swipe_horizontal_label, 0, 1);
        horizontal_swipe_grid.attach (three_swipe_horizontal_combo, 1, 1);
        horizontal_swipe_grid.attach (four_swipe_horizontal_label, 0, 2);
        horizontal_swipe_grid.attach (four_swipe_horizontal_combo, 1, 2);

        var horizontal_swipe_header = new Granite.HeaderLabel (_("Swipe Horizontally")) {
            mnemonic_widget = horizontal_swipe_grid
        };

        var three_swipe_up_combo = new Gtk.ComboBoxText () {
            hexpand = true
        };
        three_swipe_up_combo.append ("none", _("Do nothing"));
        three_swipe_up_combo.append ("multitasking-view", _("Multitasking View"));

        var three_swipe_up_label = new Gtk.Label (_("Three fingers:")) {
            halign = END,
            mnemonic_widget = three_swipe_up_combo
        };

        var four_swipe_up_combo = new Gtk.ComboBoxText ();
        four_swipe_up_combo.append ("none", _("Do nothing"));
        four_swipe_up_combo.append ("multitasking-view", _("Multitasking View"));

        var four_swipe_up_label = new Gtk.Label (_("Four fingers:")) {
            halign = END,
            mnemonic_widget = four_swipe_up_combo
        };

        var swipe_up_grid = new Gtk.Grid () {
            accessible_role = GROUP,
            column_spacing = 6,
            row_spacing = 12
        };
        swipe_up_grid.attach (three_swipe_up_label, 0, 4);
        swipe_up_grid.attach (three_swipe_up_combo, 1, 4);
        swipe_up_grid.attach (four_swipe_up_label, 0, 5);
        swipe_up_grid.attach (four_swipe_up_combo, 1, 5);

        var swipe_up_header = new Granite.HeaderLabel (_("Swipe Up")) {
            margin_top = 12,
            mnemonic_widget = swipe_up_grid
        };

        var three_pinch_combo = new Gtk.ComboBoxText () {
            hexpand = true
        };
        three_pinch_combo.append ("none", _("Do nothing"));
        three_pinch_combo.append ("zoom", _("Zoom"));

        var three_pinch_label = new Gtk.Label (_("Three fingers:")) {
            halign = END,
            mnemonic_widget = three_pinch_combo
        };

        var four_pinch_combo = new Gtk.ComboBoxText ();
        four_pinch_combo.append ("none", _("Do nothing"));
        four_pinch_combo.append ("zoom", _("Zoom"));

        var four_pinch_label = new Gtk.Label (_("Four fingers:")) {
            halign = END,
            mnemonic_widget = four_pinch_combo
        };

        var pinch_grid = new Gtk.Grid () {
            accessible_role = GROUP,
            column_spacing = 6,
            row_spacing = 12
        };
        pinch_grid.attach (three_pinch_label, 0, 7);
        pinch_grid.attach (three_pinch_combo, 1, 7);
        pinch_grid.attach (four_pinch_label, 0, 8);
        pinch_grid.attach (four_pinch_combo, 1, 8);

        var pinch_header = new Granite.HeaderLabel (_("Pinch")) {
            margin_top = 12,
            mnemonic_widget = pinch_grid
        };

        var content_area = new Gtk.Box (VERTICAL, 12);
        content_area.append (horizontal_swipe_header);
        content_area.append (horizontal_swipe_grid);
        content_area.append (swipe_up_header);
        content_area.append (swipe_up_grid);
        content_area.append (pinch_header);
        content_area.append (pinch_grid);

        child = content_area;

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
