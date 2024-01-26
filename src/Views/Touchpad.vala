/*
 * SPDX-License-Identifier: GPL-2.0-or-later
 * SPDX-FileCopyrightText: 2011-2024 elementary, Inc. (https://elementary.io)
 */

public class MouseTouchpad.TouchpadView : Switchboard.SettingsPage {
    private GLib.Settings glib_settings;
    private Gtk.CheckButton areas_click_method_radio;
    private Gtk.CheckButton multitouch_click_method_radio;
    private Gtk.CheckButton other_click_method_radio;

    public TouchpadView () {
        Object (
            icon_name: "input-touchpad",
            title: _("Touchpad")
        );
    }

    construct {
        var pointer_speed_adjustment = new Gtk.Adjustment (0, -1, 1, 0.1, 0, 0);

        var pointer_speed_scale = new Gtk.Scale (HORIZONTAL, pointer_speed_adjustment) {
            digits = 2,
            draw_value = false,
            hexpand = true
        };
        pointer_speed_scale.add_mark (-1, BOTTOM, _("Slower"));
        pointer_speed_scale.add_mark (0, BOTTOM, null);
        pointer_speed_scale.add_mark (1, BOTTOM, _("Faster"));

        var pointer_speed_header = new Granite.HeaderLabel (_("Pointer Speed")) {
            mnemonic_widget = pointer_speed_scale
        };

        multitouch_click_method_radio = new Gtk.CheckButton ();
        multitouch_click_method_radio.add_css_class ("image-button");

        var multitouch_click_method_label = new Gtk.Label (_("Multitouch"));

        var multitouch_click_method_image = new Gtk.Image.from_icon_name ("touchpad-click-multitouch-symbolic") {
            pixel_size = 32
        };

        var multitouch_click_method_box = new Gtk.Box (VERTICAL, 0);
        multitouch_click_method_box.append (multitouch_click_method_image);
        multitouch_click_method_box.append (multitouch_click_method_label);
        multitouch_click_method_box.set_parent (multitouch_click_method_radio);

        areas_click_method_radio = new Gtk.CheckButton () {
            group = multitouch_click_method_radio
        };
        areas_click_method_radio.add_css_class ("image-button");

        var areas_click_method_label = new Gtk.Label (_("Areas"));
        var areas_click_method_image = new Gtk.Image.from_icon_name ("touchpad-click-areas-symbolic") {
            pixel_size = 32
        };

        var areas_click_method_box = new Gtk.Box (VERTICAL, 0);
        areas_click_method_box.append (areas_click_method_image);
        areas_click_method_box.append (areas_click_method_label);
        areas_click_method_box.set_parent (areas_click_method_radio);

        var click_method_label = new Granite.HeaderLabel (_("Physical Secondary Clicking"));

        var click_method_box = new Gtk.Box (HORIZONTAL, 12);
        click_method_box.append (multitouch_click_method_radio);
        click_method_box.append (areas_click_method_radio);

        var tap_to_click_check = new Gtk.CheckButton.with_label (_("Tap to click")) {
            halign = Gtk.Align.START
        };

        var tap_and_drag_check = new Gtk.CheckButton.with_label (_("Double-tap and move to drag")) {
            halign = Gtk.Align.START
        };

        var tap_box = new Gtk.Box (HORIZONTAL, 24);
        tap_box.append (tap_to_click_check);
        tap_box.append (tap_and_drag_check);

        var scroll_method_label = new Granite.HeaderLabel (_("Scroll Method"));

        var two_finger_scroll_radio = new Gtk.CheckButton ();
        two_finger_scroll_radio.add_css_class ("image-button");

        var two_finger_scroll_label = new Gtk.Label (_("Two-finger"));
        var two_finger_scroll_image = new Gtk.Image.from_icon_name ("touchpad-scroll-two-finger-symbolic") {
            pixel_size = 32
        };

        var two_finger_scroll_box = new Gtk.Box (VERTICAL, 0);
        two_finger_scroll_box.append (two_finger_scroll_image);
        two_finger_scroll_box.append (two_finger_scroll_label);
        two_finger_scroll_box.set_parent (two_finger_scroll_radio);

        var edge_scroll_radio = new Gtk.CheckButton () {
            group = two_finger_scroll_radio
        };
        edge_scroll_radio.add_css_class ("image-button");

        var edge_scroll_label = new Gtk.Label (_("Edge"));
        var edge_scroll_image = new Gtk.Image.from_icon_name ("touchpad-scroll-edge-symbolic") {
            pixel_size = 32
        };

        var edge_scroll_box = new Gtk.Box (VERTICAL, 0);
        edge_scroll_box.append (edge_scroll_image);
        edge_scroll_box.append (edge_scroll_label);
        edge_scroll_box.set_parent (edge_scroll_radio);

        var scroll_method_box = new Gtk.Box (HORIZONTAL, 24);
        scroll_method_box.append (two_finger_scroll_radio);
        scroll_method_box.append (edge_scroll_radio);

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

        var disable_label = new Granite.HeaderLabel (_("Ignore"));

        var disable_while_typing_check = new Gtk.CheckButton.with_label (_("While typing"));
        var disable_with_mouse_check = new Gtk.CheckButton.with_label (_("When mouse is connected"));

        var disable_box = new Gtk.Box (HORIZONTAL, 24);
        disable_box.append (disable_while_typing_check);
        disable_box.append (disable_with_mouse_check);

        var content_box = new Gtk.Box (VERTICAL, 6);
        content_box.append (pointer_speed_header);
        content_box.append (pointer_speed_scale);
        content_box.append (disable_label);
        content_box.append (disable_box);
        content_box.append (new Granite.HeaderLabel (_("Tapping")));
        content_box.append (tap_box);
        content_box.append (click_method_label);
        content_box.append (click_method_box);
        content_box.append (scroll_method_label);
        content_box.append (scroll_method_box);
        content_box.append (natural_scrolling_box);

        child = content_box;

        glib_settings = new GLib.Settings ("org.gnome.desktop.peripherals.touchpad");
        glib_settings.bind (
            "disable-while-typing",
            disable_while_typing_check,
            "active",
            DEFAULT
        );
        glib_settings.bind (
            "natural-scroll",
            natural_scrolling_switch,
            "active",
            DEFAULT
        );
        glib_settings.bind (
            "speed",
            pointer_speed_adjustment,
            "value",
            DEFAULT
        );
        glib_settings.bind (
            "tap-to-click",
            tap_to_click_check,
            "active",
            DEFAULT
        );
        glib_settings.bind (
            "tap-and-drag",
            tap_and_drag_check,
            "active",
            DEFAULT
        );
        tap_to_click_check.bind_property (
            "active",
            tap_and_drag_check,
            "sensitive",
            BindingFlags.SYNC_CREATE
        );

        glib_settings.bind_with_mapping (
            "send-events", disable_with_mouse_check, "active", DEFAULT,
            (value, variant, user_data) => {
                value.set_boolean (variant.get_string () == "disabled-on-external-mouse");
                return true;
            },
            (value, expected_type, user_data) => {
                if (value.get_boolean ()) {
                    return new Variant ("s", "disabled-on-external-mouse");
                } else {
                    return new Variant ("s", "enabled");
                }
            },
            null, null
        );

        /* This exists so that users can select another option if clicking is
         * set from another interface like dconf or Terminal
         */
        other_click_method_radio = new Gtk.CheckButton () {
            group = multitouch_click_method_radio
        };

        update_click_method ();
        glib_settings.changed["click-method"].connect (update_click_method);

        multitouch_click_method_radio.toggled.connect (() => {
            glib_settings.set_string ("click-method", "fingers");
        });

        areas_click_method_radio.toggled.connect (() => {
            glib_settings.set_string ("click-method", "areas");
        });

        /* This exists so that users can select another option if scrolling is
         * disabled from another interface like dconf or Terminal
         */
        var disabled_scroll_radio = new Gtk.CheckButton () {
            group = two_finger_scroll_radio
        };
        disabled_scroll_radio.toggled.connect (() => {
            natural_scrolling_header.sensitive = !disabled_scroll_radio.active;
            natural_scrolling_switch.sensitive = !disabled_scroll_radio.active;
        });

        two_finger_scroll_radio.toggled.connect (() => {
            glib_settings.set_boolean ("edge-scrolling-enabled", false);
            glib_settings.set_boolean ("two-finger-scrolling-enabled", true);
        });

        edge_scroll_radio.toggled.connect (() => {
            glib_settings.set_boolean ("edge-scrolling-enabled", true);
            glib_settings.set_boolean ("two-finger-scrolling-enabled", false);
        });

        var two_finger_scrolling = glib_settings.get_boolean ("two-finger-scrolling-enabled");
        if (!glib_settings.get_boolean ("edge-scrolling-enabled") && !two_finger_scrolling) {
            disabled_scroll_radio.active = true;
        } else if (two_finger_scrolling) {
            two_finger_scroll_radio.active = true;
        } else {
            edge_scroll_radio.active = true;
        }
    }

    private void update_click_method () {
        switch (glib_settings.get_string ("click-method")) {
            case "fingers":
                multitouch_click_method_radio.active = true;
                break;
            case "areas":
                areas_click_method_radio.active = true;
                break;
            default:
                other_click_method_radio.active = true;
                break;
        }
    }
}
