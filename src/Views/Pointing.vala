/*
 * Copyright (c) 2011-2019 elementary, Inc. (https://elementary.io)
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

public class MouseTouchpad.PointingView : Granite.SimpleSettingsPage {
    public PointingView () {
        Object (
            icon_name: "mouse-touchpad-pointing",
            title: _("Pointing")
        );
    }

    construct {
        var locate_pointer_help = new Gtk.Label (
            _("Pressing the control key will highlight the position of the pointer")
        );
        locate_pointer_help.margin_bottom = 18;
        locate_pointer_help.wrap = true;
        locate_pointer_help.xalign = 0;
        locate_pointer_help.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);

        var reveal_pointer_switch = new Gtk.Switch ();
        reveal_pointer_switch.halign = Gtk.Align.START;

        var keypad_pointer_switch = new Gtk.Switch ();
        keypad_pointer_switch.halign = Gtk.Align.START;

        var keypad_pointer_adjustment = new Gtk.Adjustment (0, 0, 500, 10, 10, 10);

        var pointer_speed_label = new SettingLabel (_("Speed:"));

        var pointer_speed_scale = new Gtk.Scale (Gtk.Orientation.HORIZONTAL, keypad_pointer_adjustment);
        pointer_speed_scale.draw_value = false;
        pointer_speed_scale.hexpand = true;
        pointer_speed_scale.add_mark (10, Gtk.PositionType.TOP, null);

        var pointer_speed_help = new Gtk.Label (_("This disables both levels of keys on the numeric keypad"));

        content_area.row_spacing = 6;

        pointer_speed_help.wrap = true;
        pointer_speed_help.xalign = 0;
        pointer_speed_help.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);

        content_area.attach (new SettingLabel (_("Reveal pointer:")), 0, 0);
        content_area.attach (reveal_pointer_switch, 1, 0, 3);
        content_area.attach (locate_pointer_help, 1, 1, 3);

        content_area.attach (new SettingLabel (_("Control pointer using keypad:")), 0, 2);
        content_area.attach (keypad_pointer_switch, 1, 2);
        content_area.attach (pointer_speed_label, 2, 2);
        content_area.attach (pointer_speed_scale, 3, 2);
        content_area.attach (pointer_speed_help, 1, 3, 3);

        var daemon_settings = new GLib.Settings ("org.gnome.settings-daemon.peripherals.mouse");
        daemon_settings.bind ("locate-pointer", reveal_pointer_switch, "active", GLib.SettingsBindFlags.DEFAULT);

        var a11y_keyboard_settings = new GLib.Settings ("org.gnome.desktop.a11y.keyboard");
        a11y_keyboard_settings.bind (
            "mousekeys-enable",
            keypad_pointer_switch,
            "active",
            GLib.SettingsBindFlags.DEFAULT
        );
        a11y_keyboard_settings.bind (
            "mousekeys-max-speed",
            keypad_pointer_adjustment,
            "value",
            SettingsBindFlags.DEFAULT
        );
        a11y_keyboard_settings.bind (
            "mousekeys-enable",
            pointer_speed_scale,
            "sensitive",
            SettingsBindFlags.GET
        );
        a11y_keyboard_settings.bind (
            "mousekeys-enable",
            pointer_speed_label,
            "sensitive",
            SettingsBindFlags.GET
        );
    }
}
