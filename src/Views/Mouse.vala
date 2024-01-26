/*
 * Copyright (c) 2011-2018 elementary, Inc. (https://elementary.io)
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

public class MouseTouchpad.MouseView : Switchboard.SettingsPage {
    public MouseView () {
        Object (
            header: _("Devices"),
            icon_name: "input-mouse",
            title: _("Mouse")
        );
    }

    construct {
        var pointer_speed_adjustment = new Gtk.Adjustment (0, -1, 1, 0.1, 0, 0);

        var pointer_speed_scale = new Gtk.Scale (Gtk.Orientation.HORIZONTAL, pointer_speed_adjustment) {
            draw_value = false,
            hexpand = true,
            width_request = 160
        };
        pointer_speed_scale.add_mark (0, Gtk.PositionType.BOTTOM, null);

        for (double x = -0.75; x < 1; x += 0.25) {
            pointer_speed_scale.add_mark (x, Gtk.PositionType.TOP, null);
        }

        var accel_profile_default = new Gtk.CheckButton.with_label (_("Hardware default"));
        var accel_profile_flat = new Gtk.CheckButton.with_label (_("None")) {
            group = accel_profile_default
        };
        var accel_profile_adaptive = new Gtk.CheckButton.with_label (_("Adaptive")) {
            group = accel_profile_default
        };

        var natural_scrolling_switch = new Gtk.Switch () {
            halign = Gtk.Align.START
        };

        var content_area = new Gtk.Grid () {
            column_spacing = 6,
            row_spacing = 12
        };
        content_area.attach (new Gtk.Label (_("Pointer speed:")) { halign = Gtk.Align.END }, 0, 0);
        content_area.attach (pointer_speed_scale, 1, 0);
        content_area.attach (new Gtk.Label (_("Pointer acceleration:")) { halign = Gtk.Align.END }, 0, 1);
        content_area.attach (accel_profile_default, 1, 1);
        content_area.attach (accel_profile_flat, 1, 2);
        content_area.attach (accel_profile_adaptive, 1, 3);
        content_area.attach (new Gtk.Label (_("Natural scrolling:")) { halign = Gtk.Align.END }, 0, 4);
        content_area.attach (natural_scrolling_switch, 1, 4);

        child = content_area;

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
