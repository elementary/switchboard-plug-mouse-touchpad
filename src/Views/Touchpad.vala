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

public class MouseTouchpad.TouchpadView : Granite.SimpleSettingsPage {
    private GLib.Settings glib_settings;
    private Gtk.RadioButton areas_click_method_radio;
    private Gtk.RadioButton default_click_method_radio;
    private Gtk.RadioButton disabled_click_method_radio;
    private Gtk.RadioButton multitouch_click_method_radio;

    public TouchpadView () {
        Object (
            icon_name: "input-touchpad",
            title: _("Touchpad")
        );
    }

    construct {
        var pointer_speed_adjustment = new Gtk.Adjustment (0, -1, 1, 0.1, 0, 0);

        var pointer_speed_scale = new Gtk.Scale (Gtk.Orientation.HORIZONTAL, pointer_speed_adjustment) {
            digits = 2,
            draw_value = false,
            hexpand = true
        };
        pointer_speed_scale.add_mark (0, Gtk.PositionType.BOTTOM, null);
        for (double x = -0.75; x < 1; x += 0.25) {
            pointer_speed_scale.add_mark (x, Gtk.PositionType.TOP, null);
        }

        default_click_method_radio = new Gtk.RadioButton.with_label (null, _("Hardware default"));
        multitouch_click_method_radio = new Gtk.RadioButton.with_label_from_widget (default_click_method_radio, _("Multitouch"));
        areas_click_method_radio = new Gtk.RadioButton.with_label_from_widget (default_click_method_radio, _("Touchpad areas"));
        disabled_click_method_radio = new Gtk.RadioButton.with_label_from_widget (default_click_method_radio, _("None"));

        var click_method_label = new SettingLabel (_("Physical clicking:")) {
            margin_top = 24
        };

        var click_method_grid = new Gtk.Grid () {
            column_spacing = 12,
            margin_top = 24
        };
        click_method_grid.add (default_click_method_radio);
        click_method_grid.add (multitouch_click_method_radio);
        click_method_grid.add (areas_click_method_radio);
        click_method_grid.add (disabled_click_method_radio);

        var tap_to_click_switch = new Gtk.Switch () {
            halign = Gtk.Align.START
        };

        var scroll_method_label = new SettingLabel (_("Scroll method:")) {
            margin_top = 24
        };

        var two_finger_scroll_radio = new Gtk.RadioButton.with_label (null, _("Two-finger"));
        var edge_scroll_radio = new Gtk.RadioButton.with_label_from_widget (two_finger_scroll_radio, _("Edge"));

        var scroll_method_grid = new Gtk.Grid () {
            column_spacing = 12,
            margin_top = 24
        };
        scroll_method_grid.add (two_finger_scroll_radio);
        scroll_method_grid.add (edge_scroll_radio);

        var natural_scrolling_label = new SettingLabel (_("Natural scrolling:"));

        var natural_scrolling_switch = new Gtk.Switch () {
            halign = Gtk.Align.START
        };

        var disable_label = new SettingLabel (_("Ignore:")) {
            margin_top = 24
        };

        var disable_while_typing_check = new Gtk.CheckButton.with_label (_("While typing"));
        var disable_with_mouse_check = new Gtk.CheckButton.with_label (_("When mouse is connected"));

        var disable_grid = new Gtk.Grid () {
            column_spacing = 12,
            margin_top = 24
        };
        disable_grid.add (disable_while_typing_check);
        disable_grid.add (disable_with_mouse_check);

        content_area.attach (new SettingLabel (_("Pointer speed:")), 0, 0);
        content_area.attach (pointer_speed_scale, 1, 0);
        content_area.attach (click_method_label, 0, 1);
        content_area.attach (click_method_grid, 1, 1, 2 );
        content_area.attach (new SettingLabel (_("Tap to click:")), 0, 5);
        content_area.attach (tap_to_click_switch, 1, 5);
        content_area.attach (scroll_method_label, 0, 6);
        content_area.attach (scroll_method_grid, 1, 6, 2);
        content_area.attach (natural_scrolling_label, 0, 9);
        content_area.attach (natural_scrolling_switch, 1, 9);
        content_area.attach (disable_label, 0, 10);
        content_area.attach (disable_grid, 1, 10);

        glib_settings = new GLib.Settings ("org.gnome.desktop.peripherals.touchpad");
        glib_settings.bind (
            "disable-while-typing",
            disable_while_typing_check,
            "active",
            GLib.SettingsBindFlags.DEFAULT
        );
        glib_settings.bind (
            "natural-scroll",
            natural_scrolling_switch,
            "active",
            GLib.SettingsBindFlags.DEFAULT
        );
        glib_settings.bind (
            "speed",
            pointer_speed_adjustment,
            "value",
            GLib.SettingsBindFlags.DEFAULT
        );
        glib_settings.bind (
            "tap-to-click",
            tap_to_click_switch,
            "active",
            GLib.SettingsBindFlags.DEFAULT
        );

        glib_settings.bind_with_mapping (
            "send-events", disable_with_mouse_check, "active", GLib.SettingsBindFlags.DEFAULT,
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

        update_click_method ();
        glib_settings.changed["click-method"].connect (update_click_method);

        default_click_method_radio.button_release_event.connect (() => {
            glib_settings.set_string ("click-method", "default");
            return Gdk.EVENT_PROPAGATE;
        });

        multitouch_click_method_radio.button_release_event.connect (() => {
            glib_settings.set_string ("click-method", "fingers");
            return Gdk.EVENT_PROPAGATE;
        });

        areas_click_method_radio.button_release_event.connect (() => {
            glib_settings.set_string ("click-method", "areas");
            return Gdk.EVENT_PROPAGATE;
        });

        disabled_click_method_radio.button_release_event.connect (() => {
            glib_settings.set_string ("click-method", "none");
            return Gdk.EVENT_PROPAGATE;
        });

        /* This exists so that users can select another option if scrolling is
         * disabled from another interface like dconf or Terminal
         */
        var disabled_scroll_radio = new Gtk.RadioButton.from_widget (two_finger_scroll_radio);
        disabled_scroll_radio.toggled.connect (() => {
            natural_scrolling_label.sensitive = !disabled_scroll_radio.active;
            natural_scrolling_switch.sensitive = !disabled_scroll_radio.active;
        });

        two_finger_scroll_radio.button_release_event.connect (() => {
            glib_settings.set_boolean ("edge-scrolling-enabled", false);
            glib_settings.set_boolean ("two-finger-scrolling-enabled", true);
            return Gdk.EVENT_PROPAGATE;
        });

        edge_scroll_radio.button_release_event.connect (() => {
            glib_settings.set_boolean ("edge-scrolling-enabled", true);
            glib_settings.set_boolean ("two-finger-scrolling-enabled", false);
            return Gdk.EVENT_PROPAGATE;
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
            case "none":
                disabled_click_method_radio.active = true;
                break;
            default:
                default_click_method_radio.active = true;
                break;
        }
    }
}
