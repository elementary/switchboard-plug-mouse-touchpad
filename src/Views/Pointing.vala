/*
 * Copyright (c) 2011-2020 elementary, Inc. (https://elementary.io)
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
        var keypad_pointer_switch = new Gtk.Switch () {
            halign = Gtk.Align.START,
            valign = Gtk.Align.CENTER
        };

        var keypad_pointer_adjustment = new Gtk.Adjustment (0, 0, 500, 10, 10, 10);

        var pointer_speed_label = new Gtk.Label (_("Speed:")) {
            halign = Gtk.Align.END
        };

        var pointer_speed_scale = new Gtk.Scale (Gtk.Orientation.HORIZONTAL, keypad_pointer_adjustment) {
            draw_value = false,
            hexpand = true,
            margin_top = 7
        };
        pointer_speed_scale.add_mark (10, Gtk.PositionType.BOTTOM, null);

        var pointer_speed_help = new Gtk.Label (_("This disables both levels of keys on the numeric keypad")) {
            wrap = true,
            xalign = 0
        };
        pointer_speed_help.add_css_class (Granite.STYLE_CLASS_DIM_LABEL);

        var cursor_size_24 = new Gtk.CheckButton () {
            tooltip_text = _("Small")
        };

        var cursor_size_24_image = new Gtk.Image.from_icon_name ("mouse-touchpad-pointing-symbolic") {
            pixel_size = 24
        };
        cursor_size_24_image.set_parent (cursor_size_24);

        var cursor_size_32 = new Gtk.CheckButton () {
            group = cursor_size_24,
            tooltip_text = _("Medium")
        };

        var cursor_size_32_image = new Gtk.Image.from_icon_name ("mouse-touchpad-pointing-symbolic") {
            pixel_size = 32
        };
        cursor_size_32_image.set_parent (cursor_size_32);

        var cursor_size_48 = new Gtk.CheckButton () {
            group = cursor_size_24,
            tooltip_text = _("Large")
        };

        var cursor_size_48_image = new Gtk.Image.from_icon_name ("mouse-touchpad-pointing-symbolic") {
            pixel_size = 48
        };
        cursor_size_48_image.set_parent (cursor_size_48);

        var cursor_size_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 24);
        cursor_size_box.append (cursor_size_24);
        cursor_size_box.append (cursor_size_32);
        cursor_size_box.append (cursor_size_48);

        var locate_pointer_help = new Gtk.Label (
            _("Pressing the control key will highlight the position of the pointer")
        ) {
            margin_bottom = 18,
            wrap = true,
            xalign = 0
        };
        locate_pointer_help.add_css_class (Granite.STYLE_CLASS_DIM_LABEL);

        var reveal_pointer_label = new Gtk.Label (_("Reveal pointer:")) {
            margin_top = 18,
            halign = Gtk.Align.END
        };

        var reveal_pointer_switch = new Gtk.Switch () {
            halign = Gtk.Align.START,
            margin_top = 18
        };

        content_area.row_spacing = 6;

        content_area.attach (new Gtk.Label (_("Pointer size:")) { halign = Gtk.Align.END }, 0, 0);
        content_area.attach (cursor_size_box, 1, 0, 3);

        content_area.attach (reveal_pointer_label, 0, 1);
        content_area.attach (reveal_pointer_switch, 1, 1, 3);
        content_area.attach (locate_pointer_help, 1, 2, 3);

        content_area.attach (new Gtk.Label (_("Control pointer using keypad:")) { halign = Gtk.Align.END }, 0, 3);
        content_area.attach (keypad_pointer_switch, 1, 3);
        content_area.attach (pointer_speed_label, 2, 3);
        content_area.attach (pointer_speed_scale, 3, 3);
        content_area.attach (pointer_speed_help, 1, 4, 3);

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

        var interface_settings = new GLib.Settings ("org.gnome.desktop.interface");
        interface_settings.bind ("locate-pointer", reveal_pointer_switch, "active", GLib.SettingsBindFlags.DEFAULT);

        switch (interface_settings.get_int ("cursor-size")) {
            case 32:
                cursor_size_32.active = true;
                break;
            case 48:
                cursor_size_48.active = true;
                break;
            default:
                cursor_size_24.active = true;
        }

        cursor_size_24.toggled.connect (() => {
            interface_settings.set_int ("cursor-size", 24);
        });

        cursor_size_32.toggled.connect (() => {
            interface_settings.set_int ("cursor-size", 32);
        });

        cursor_size_48.toggled.connect (() => {
            interface_settings.set_int ("cursor-size", 48);
        });
    }
}
