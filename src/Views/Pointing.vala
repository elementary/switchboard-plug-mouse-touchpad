/*
 * SPDX-License-Identifier: GPL-2.0-or-later
 * SPDX-FileCopyrightText: 2011-2024 elementary, Inc. (https://elementary.io)
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
            halign = END,
            valign = CENTER
        };

        var keypad_pointer_header = new Granite.HeaderLabel (_("Control Pointer Using Keypad")) {
            secondary_text = _("This disables both levels of keys on the numeric keypad"),
            mnemonic_widget = keypad_pointer_switch
        };

        var keypad_pointer_adjustment = new Gtk.Adjustment (0, 0, 1000, 10, 10, 10);

        var pointer_speed_scale = new Gtk.Scale (HORIZONTAL, keypad_pointer_adjustment) {
            hexpand = true
        };
        pointer_speed_scale.add_mark (0, BOTTOM, _("Slower"));
        pointer_speed_scale.add_mark (100, BOTTOM, null);
        pointer_speed_scale.add_mark (990, BOTTOM, _("Faster"));

        var cursor_size_24 = new Gtk.CheckButton () {
            tooltip_text = _("Small")
        };
        cursor_size_24.add_css_class ("image-button");

        var cursor_size_24_image = new Gtk.Image.from_icon_name ("mouse-touchpad-pointing-symbolic") {
            pixel_size = 24
        };
        cursor_size_24_image.set_parent (cursor_size_24);

        var cursor_size_32 = new Gtk.CheckButton () {
            group = cursor_size_24,
            tooltip_text = _("Medium")
        };
        cursor_size_32.add_css_class ("image-button");

        var cursor_size_32_image = new Gtk.Image.from_icon_name ("mouse-touchpad-pointing-symbolic") {
            pixel_size = 32
        };
        cursor_size_32_image.set_parent (cursor_size_32);

        var cursor_size_48 = new Gtk.CheckButton () {
            group = cursor_size_24,
            tooltip_text = _("Large")
        };
        cursor_size_48.add_css_class ("image-button");

        var cursor_size_48_image = new Gtk.Image.from_icon_name ("mouse-touchpad-pointing-symbolic") {
            pixel_size = 48
        };
        cursor_size_48_image.set_parent (cursor_size_48);

        var cursor_size_box = new Gtk.Box (HORIZONTAL, 24);
        cursor_size_box.append (cursor_size_24);
        cursor_size_box.append (cursor_size_32);
        cursor_size_box.append (cursor_size_48);

        var reveal_pointer_switch = new Gtk.Switch () {
            halign = END,
            valign = CENTER
        };

        var reveal_pointer_label = new Granite.HeaderLabel (_("Reveal Pointer")) {
            mnemonic_widget = reveal_pointer_switch,
            secondary_text = _("Pressing the control key will highlight the position of the pointer")
        };

        content_area.row_spacing = 6;

        content_area.attach (new Granite.HeaderLabel (_("Pointer Size")), 0, 0);
        content_area.attach (cursor_size_box, 0, 1);

        content_area.attach (reveal_pointer_label, 0, 2);
        content_area.attach (reveal_pointer_switch, 1, 2);

        content_area.attach (keypad_pointer_header, 0, 3);
        content_area.attach (keypad_pointer_switch, 1, 3);
        content_area.attach (pointer_speed_scale, 0, 4, 2);

        var a11y_keyboard_settings = new GLib.Settings ("org.gnome.desktop.a11y.keyboard");
        a11y_keyboard_settings.bind (
            "mousekeys-enable",
            keypad_pointer_switch,
            "active",
            DEFAULT
        );
        a11y_keyboard_settings.bind (
            "mousekeys-max-speed",
            keypad_pointer_adjustment,
            "value",
            DEFAULT
        );
        a11y_keyboard_settings.bind (
            "mousekeys-enable",
            pointer_speed_scale,
            "sensitive",
            GET
        );

        var interface_settings = new GLib.Settings ("org.gnome.desktop.interface");
        interface_settings.bind ("locate-pointer", reveal_pointer_switch, "active", DEFAULT);

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
