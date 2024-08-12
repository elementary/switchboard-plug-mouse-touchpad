/*
 * Copyright 2011-2022 elementary, Inc. (https://elementary.io)
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

public class MouseTouchpad.ClickingView : Switchboard.SettingsPage {
    public ClickingView () {
        Object (
            header: _("Behavior"),
            icon: new ThemedIcon ("mouse-touchpad-clicking"),
            title: _("Clicking")
        );
    }

    construct {
        show_end_title_buttons = true;

        var primary_button_label = new Granite.HeaderLabel (_("Primary Button"));

        var mouse_left = new Gtk.CheckButton () {
            /// TRANSLATORS: Used as "Primary Button: Left"
            tooltip_text = NC_("mouse-button", "Left")
        };
        mouse_left.add_css_class ("image-button");

        var mouse_left_image = new Gtk.Image.from_icon_name ("mouse-left-symbolic") {
            pixel_size = 32
        };
        mouse_left_image.set_parent (mouse_left);

        var mouse_right = new Gtk.CheckButton () {
            group = mouse_left,
            /// TRANSLATORS: Used as "Primary Button: Right";
            tooltip_text = NC_("mouse-button", "Right")
        };
        mouse_right.add_css_class ("image-button");

        var mouse_right_image = new Gtk.Image.from_icon_name ("mouse-right-symbolic") {
            pixel_size = 32
        };
        mouse_right_image.set_parent (mouse_right);

        var primary_button_switcher = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 24) {
            halign = Gtk.Align.START,
            margin_bottom = 12
        };

        if (Gtk.StateFlags.DIR_LTR in get_state_flags ()) {
            primary_button_switcher.append (mouse_left);
            primary_button_switcher.append (mouse_right);
        } else {
            primary_button_switcher.append (mouse_right);
            primary_button_switcher.append (mouse_left);
        }

        var hold_switch = new Gtk.Switch () {
            halign = Gtk.Align.END,
            valign = Gtk.Align.CENTER
        };

        var hold_header = new Granite.HeaderLabel (_("Long-press Secondary Click")) {
            mnemonic_widget = hold_switch,
            secondary_text = _("Long-press and release the primary button to secondary click")
        };

        var hold_scale_adjustment = new Gtk.Adjustment (0, 0.5, 3, 0.1, 0.1, 0.1);

        var hold_scale = new Gtk.Scale (Gtk.Orientation.HORIZONTAL, hold_scale_adjustment) {
            draw_value = false,
            hexpand = true
        };
        hold_scale.add_mark (1.2, Gtk.PositionType.BOTTOM, null);

        var hold_spinbutton = new Gtk.SpinButton (hold_scale_adjustment, 1, 1) {
            width_chars = 10,
            valign = Gtk.Align.START
        };

        var hold_spin_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12) {
            margin_bottom = 12
        };
        hold_spin_box.append (hold_scale);
        hold_spin_box.append (hold_spinbutton);

        var double_click_speed_adjustment = new Gtk.Adjustment (400, 100, 1000, 0.1, 0.1, 0.1);

        var double_click_speed_scale = new Gtk.Scale (Gtk.Orientation.HORIZONTAL, double_click_speed_adjustment) {
            draw_value = false
        };
        double_click_speed_scale.add_mark (400, Gtk.PositionType.BOTTOM, null);

        var double_click_header = new Granite.HeaderLabel (_("Double-click Speed")) {
            mnemonic_widget = double_click_speed_scale,
            secondary_text = _("How quickly two clicks in a row will be treated as a double-click")
        };

        var dwell_click_switch = new Gtk.Switch () {
            halign = Gtk.Align.END,
            valign = Gtk.Align.CENTER
        };

        var dwell_click_header = new Granite.HeaderLabel (_("Dwell Click")) {
            mnemonic_widget = dwell_click_switch,
            secondary_text = _("Hold the pointer still to automatically click")
        };

        var dwell_click_adjustment = new Gtk.Adjustment (0, 0.5, 3, 0.1, 0.1, 0.1);

        var dwell_click_delay_scale = new Gtk.Scale (Gtk.Orientation.HORIZONTAL, dwell_click_adjustment) {
            draw_value = false,
            hexpand = true
        };
        dwell_click_delay_scale.add_mark (1.2, Gtk.PositionType.BOTTOM, null);

        var dwell_click_spinbutton = new Gtk.SpinButton (dwell_click_adjustment, 1, 1) {
            width_chars = 10,
            valign = Gtk.Align.START
        };

        var dwell_click_spin_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12) {
            margin_bottom = 12
        };
        dwell_click_spin_box.append (dwell_click_delay_scale);
        dwell_click_spin_box.append (dwell_click_spinbutton);

        var content_area = new Gtk.Grid () {
            row_spacing = 6
        };

        content_area.attach (primary_button_label, 0, 0, 2);
        content_area.attach (primary_button_switcher, 0, 1, 2);

        content_area.attach (double_click_header, 0, 2, 2);
        content_area.attach (double_click_speed_scale, 0, 3, 2);

        content_area.attach (dwell_click_header, 0, 4);
        content_area.attach (dwell_click_switch, 1, 4);
        content_area.attach (dwell_click_spin_box, 0, 5, 2);

        content_area.attach (hold_header, 0, 6);
        content_area.attach (hold_switch, 1, 6);
        content_area.attach (hold_spin_box, 0, 7, 2);

        child = content_area;

        var xsettings_schema = SettingsSchemaSource.get_default ().lookup (
            "org.gnome.settings-daemon.plugins.xsettings",
            true
        );

        if (xsettings_schema != null) {
            var primary_paste_switch = new Gtk.Switch () {
                halign = Gtk.Align.END,
                valign = Gtk.Align.CENTER
            };

            var primary_paste_header = new Granite.HeaderLabel (_("Middle Click Paste")) {
                mnemonic_widget = primary_paste_switch,
                secondary_text = _("Middle or three-finger click on an input to paste selected text")
            };

            content_area.attach (primary_paste_header, 0, 8);
            content_area.attach (primary_paste_switch, 1, 8);

            var xsettings = new GLib.Settings ("org.gnome.settings-daemon.plugins.xsettings");
            primary_paste_switch.notify["active"].connect (() => {
                on_primary_paste_switch_changed (primary_paste_switch, xsettings);
            });

            var current_value = xsettings.get_value ("overrides").lookup_value (
                "Gtk/EnablePrimaryPaste",
                VariantType.INT32
            );
            if (current_value != null) {
                primary_paste_switch.active = current_value.get_int32 () == 1;
            }
        }

        var a11y_mouse_settings = new GLib.Settings ("org.gnome.desktop.a11y.mouse");
        a11y_mouse_settings.bind (
            "secondary-click-enabled",
            hold_switch,
            "active",
            GLib.SettingsBindFlags.DEFAULT
        );
        a11y_mouse_settings.bind (
            "secondary-click-time",
            hold_scale_adjustment,
            "value",
            GLib.SettingsBindFlags.DEFAULT
        );

        a11y_mouse_settings.bind ("dwell-click-enabled", dwell_click_delay_scale, "sensitive", SettingsBindFlags.GET);
        a11y_mouse_settings.bind ("dwell-click-enabled", dwell_click_spin_box, "sensitive", SettingsBindFlags.GET);
        a11y_mouse_settings.bind ("dwell-click-enabled", dwell_click_switch, "active", SettingsBindFlags.DEFAULT);
        a11y_mouse_settings.bind ("dwell-time", dwell_click_adjustment, "value", SettingsBindFlags.DEFAULT);

        hold_switch.bind_property ("active", hold_scale, "sensitive", BindingFlags.SYNC_CREATE);
        hold_switch.bind_property ("active", hold_spin_box, "sensitive", BindingFlags.SYNC_CREATE);

        var mouse_settings = new GLib.Settings ("org.gnome.desktop.peripherals.mouse");
        mouse_settings.bind ("double-click", double_click_speed_adjustment, "value", SettingsBindFlags.DEFAULT);

        if (mouse_settings.get_boolean ("left-handed")) {
            mouse_right.active = true;
        } else {
            mouse_left.active = true;
        }

        mouse_left.toggled.connect (() => {
            if (mouse_left.active) {
                mouse_settings.set_boolean ("left-handed", false);
            }
        });

        mouse_right.toggled.connect (() => {
            if (mouse_right.active) {
                mouse_settings.set_boolean ("left-handed", true);
            }
        });

        dwell_click_spinbutton.output.connect (() => {
            dwell_click_spinbutton.text = _("%.1f seconds").printf (dwell_click_adjustment.value);
            return true;
        });

        hold_spinbutton.output.connect (() => {
            hold_spinbutton.text = _("%.1f seconds").printf (hold_scale_adjustment.value);
            return true;
        });
    }

    private void on_primary_paste_switch_changed (Gtk.Switch switch, GLib.Settings xsettings) {
        var overrides = xsettings.get_value ("overrides");
        var dict = new VariantDict (overrides);
        dict.insert_value ("Gtk/EnablePrimaryPaste", new Variant.int32 (switch.active ? 1 : 0));

        overrides = dict.end ();
        xsettings.set_value ("overrides", overrides);
    }
}
