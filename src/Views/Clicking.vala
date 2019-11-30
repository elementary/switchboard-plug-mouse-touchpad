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

public class MouseTouchpad.ClickingView : Granite.SimpleSettingsPage {
    public ClickingView () {
        Object (
            header: _("Behavior"),
            icon_name: "mouse-touchpad-clicking",
            title: _("Clicking")
        );
    }

    construct {
        var mouse_settings = new GLib.Settings ("org.gnome.desktop.peripherals.mouse");

        var primary_button_label = new SettingLabel (_("Primary button:"));
        primary_button_label.margin_bottom = 18;

        var mouse_left = new Gtk.Image.from_icon_name ("mouse-left-symbolic", Gtk.IconSize.DND);
        mouse_left.tooltip_text = _("Left");

        var mouse_right = new Gtk.Image.from_icon_name ("mouse-right-symbolic", Gtk.IconSize.DND);
        mouse_right.tooltip_text = _("Right");

        var primary_button_switcher = new Granite.Widgets.ModeButton ();
        primary_button_switcher.halign = Gtk.Align.START;
        primary_button_switcher.margin_bottom = 18;
        primary_button_switcher.width_request = 256;

        if (Gtk.StateFlags.DIR_LTR in get_state_flags ()) {
            primary_button_switcher.append (mouse_left);
            primary_button_switcher.append (mouse_right);

            mouse_settings.bind_with_mapping (
                "left-handed",
                primary_button_switcher,
                "selected",
                GLib.SettingsBindFlags.DEFAULT,
                (value, variant) => {
                    GLib.return_val_if_fail (variant.is_of_type (GLib.VariantType.BOOLEAN), false);
                    value.set_int (variant.get_boolean () ? 1 : 0);
                    return true;
                },
                (value, expected_type) => {
                    GLib.return_val_if_fail (expected_type.equal (GLib.VariantType.BOOLEAN), null);
                    return new GLib.Variant.boolean (value.get_int () == 1);
                },
                null, null
            );
        } else {
            primary_button_switcher.append (mouse_right);
            primary_button_switcher.append (mouse_left);

            mouse_settings.bind_with_mapping (
                "left-handed",
                primary_button_switcher,
                "selected",
                GLib.SettingsBindFlags.DEFAULT,
                (value, variant) => {
                    GLib.return_val_if_fail (variant.is_of_type (GLib.VariantType.BOOLEAN), false);
                    value.set_int (variant.get_boolean () ? 0 : 1);
                    return true;
                },
                (value, expected_type) => {
                    GLib.return_val_if_fail (expected_type.equal (GLib.VariantType.BOOLEAN), null);
                    return new GLib.Variant.boolean (value.get_int () == 0);
                },
                null, null
            );
        }

        var hold_label = new SettingLabel (_("Long-press secondary click:"));

        var hold_switch = new Gtk.Switch ();
        hold_switch.halign = Gtk.Align.START;

        var hold_help = new Gtk.Label (_("Long-pressing and releasing the primary button will secondary click"));
        hold_help.margin_bottom = 18;
        hold_help.wrap = true;
        hold_help.xalign = 0;
        hold_help.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);

        var hold_length_label = new SettingLabel (_("Length:"));

        var hold_scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0.5, 2.0, 0.1);
        hold_scale.draw_value = false;
        hold_scale.hexpand = true;
        hold_scale.width_request = 160;
        hold_scale.add_mark (1.2, Gtk.PositionType.TOP, null);

        var double_click_speed_adjustment = new Gtk.Adjustment (400, 100, 1000, 0.1, 0.1, 0.1);

        var double_click_speed_scale = new Gtk.Scale (Gtk.Orientation.HORIZONTAL, double_click_speed_adjustment);
        double_click_speed_scale.draw_value = false;
        double_click_speed_scale.add_mark (400, Gtk.PositionType.TOP, null);
        double_click_speed_scale.width_request = 250;

        var double_click_speed_help = new Gtk.Label (_("How quickly two clicks in a row will be treated as a double-click"));
        double_click_speed_help.margin_bottom = 18;

        double_click_speed_help.wrap = true;
        double_click_speed_help.xalign = 0;
        double_click_speed_help.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);

        content_area.row_spacing = 6;

        content_area.attach (primary_button_label, 0, 0);
        content_area.attach (primary_button_switcher, 1, 0, 3);

        content_area.attach (new SettingLabel (_("Double-click speed:")), 0, 1);
        content_area.attach (double_click_speed_scale, 1, 1, 3);
        content_area.attach (double_click_speed_help, 1, 2, 3);

        content_area.attach (hold_label, 0, 3);
        content_area.attach (hold_switch, 1, 3);
        content_area.attach (hold_length_label, 2, 3);
        content_area.attach (hold_scale, 3, 3);
        content_area. attach (hold_help, 1, 4, 3);

        var xsettings_schema = SettingsSchemaSource.get_default ().lookup (
            "org.gnome.settings-daemon.plugins.xsettings",
            true
        );

        if (xsettings_schema != null) {
            var primary_paste_switch = new Gtk.Switch ();
            primary_paste_switch.halign = Gtk.Align.START;

            var primary_paste_help = new Gtk.Label (
                _("Middle or three-finger clicking on an input will paste any selected text")
            );
            primary_paste_help.margin_bottom = 18;
            primary_paste_help.wrap = true;
            primary_paste_help.xalign = 0;
            primary_paste_help.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);

            content_area.attach (new SettingLabel (_("Middle click paste:")), 0, 5);
            content_area.attach (primary_paste_switch, 1, 5);
            content_area.attach (primary_paste_help, 1, 6, 3);

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

        var daemon_settings = new GLib.Settings ("org.gnome.settings-daemon.peripherals.mouse");
        daemon_settings.bind ("double-click", double_click_speed_adjustment, "value", SettingsBindFlags.DEFAULT);

        var a11y_mouse_settings = new GLib.Settings ("org.gnome.desktop.a11y.mouse");
        a11y_mouse_settings.bind (
            "secondary-click-enabled",
            hold_switch,
            "active",
            GLib.SettingsBindFlags.DEFAULT
        );
        a11y_mouse_settings.bind (
            "secondary-click-time",
            hold_scale.adjustment,
            "value",
            GLib.SettingsBindFlags.DEFAULT
        );

        hold_switch.bind_property ("active", hold_length_label, "sensitive", BindingFlags.SYNC_CREATE);
        hold_switch.bind_property ("active", hold_scale, "sensitive", BindingFlags.SYNC_CREATE);
    }

    private void on_primary_paste_switch_changed (Gtk.Switch switch, GLib.Settings xsettings) {
        var overrides = xsettings.get_value ("overrides");
        var dict = new VariantDict (overrides);
        dict.insert_value ("Gtk/EnablePrimaryPaste", new Variant.int32 (switch.active ? 1 : 0));

        overrides = dict.end ();
        xsettings.set_value ("overrides", overrides);
    }
}
