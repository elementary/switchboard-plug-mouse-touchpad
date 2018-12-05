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

public class MouseTouchpad.MouseView : Gtk.Grid {
    public Backend.MouseSettings mouse_settings { get; construct; }

    public MouseView (Backend.MouseSettings mouse_settings) {
        Object (mouse_settings: mouse_settings);
    }

    construct {
        var pointer_speed_scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, -1, 1, 0.1);
        pointer_speed_scale.adjustment.value = mouse_settings.speed;
        pointer_speed_scale.digits = 2;
        pointer_speed_scale.draw_value = false;
        pointer_speed_scale.hexpand = true;
        pointer_speed_scale.set_size_request (160, -1);
        pointer_speed_scale.add_mark (0, Gtk.PositionType.BOTTOM, null);

        var accel_profile_default = new Gtk.RadioButton.with_label (null, _("Hardware default"));
        var accel_profile_flat = new Gtk.RadioButton.with_label_from_widget (accel_profile_default, _("None"));
        var accel_profile_adaptive = new Gtk.RadioButton.with_label_from_widget (accel_profile_default, _("Adaptive"));

        var natural_scrolling_switch = new Gtk.Switch ();
        natural_scrolling_switch.halign = Gtk.Align.START;

        row_spacing = 12;
        column_spacing = 12;

        attach (new SettingLabel (_("Pointer speed:")), 0, 0);
        attach (pointer_speed_scale, 1, 0);
        attach (new SettingLabel (_("Pointer acceleration:")), 0, 1);
        attach (accel_profile_default, 1, 1);
        attach (accel_profile_flat, 1, 2);
        attach (accel_profile_adaptive, 1, 3);
        attach (new SettingLabel (_("Natural scrolling:")), 0, 4);
        attach (natural_scrolling_switch, 1, 4);

        var settings = new GLib.Settings ("org.gnome.desktop.peripherals.mouse");

        pointer_speed_scale.adjustment.bind_property (
            "value",
            mouse_settings,
            "speed",
            BindingFlags.SYNC_CREATE,
            pointer_speed_scale_transform_func
        );

        mouse_settings.bind_property (
            "natural-scroll",
            natural_scrolling_switch,
            "state",
            BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE
        );

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

    private bool pointer_speed_scale_transform_func (Binding binding, Value source_value, ref Value target_value) {
        double val = (double)source_value.get_double ();
        target_value.set_double (val);

        return true;
    }
}

