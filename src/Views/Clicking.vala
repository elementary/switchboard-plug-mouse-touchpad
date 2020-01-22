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

public class MouseTouchpad.ClickingView : Granite.SimpleSettingsPage {
    public ClickingView () {
        Object (
            header: _("Behavior"),
            icon_name: "mouse-touchpad-clicking",
            title: _("Clicking")
        );
    }

    construct {
        var primary_button_label = new SettingLabel (_("Primary button:"));
        primary_button_label.margin_bottom = 18;

        var mouse_left = new Gtk.RadioButton (null);
        mouse_left.image = new Gtk.Image.from_icon_name ("mouse-left-symbolic", Gtk.IconSize.DND);
        mouse_left.tooltip_text = _("Left");

        var mouse_right = new Gtk.RadioButton.from_widget (mouse_left);
        mouse_right.image = new Gtk.Image.from_icon_name ("mouse-right-symbolic", Gtk.IconSize.DND);
        mouse_right.tooltip_text = _("Right");

        var primary_button_switcher = new Gtk.Grid ();
        primary_button_switcher.halign = Gtk.Align.START;
        primary_button_switcher.margin_bottom = 18;
        primary_button_switcher.column_spacing = 24;

        if (Gtk.StateFlags.DIR_LTR in get_state_flags ()) {
            primary_button_switcher.add (mouse_left);
            primary_button_switcher.add (mouse_right);
        } else {
            primary_button_switcher.add (mouse_right);
            primary_button_switcher.add (mouse_left);
        }

        var hold_switch = new Gtk.Switch ();
        hold_switch.halign = Gtk.Align.START;
        hold_switch.valign = Gtk.Align.CENTER;

        var hold_help = new Gtk.Label (_("Long-press and release the primary button to secondary click"));
        hold_help.margin_bottom = 18;
        hold_help.wrap = true;
        hold_help.xalign = 0;
        hold_help.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);

        var hold_scale_adjustment = new Gtk.Adjustment (0, 0.5, 3, 0.1, 0.1, 0.1);

        var hold_scale = new Gtk.Scale (Gtk.Orientation.HORIZONTAL, hold_scale_adjustment);
        hold_scale.draw_value = false;
        hold_scale.hexpand = true;
        hold_scale.add_mark (1.2, Gtk.PositionType.TOP, null);

        var hold_spinbutton = new Gtk.SpinButton (hold_scale_adjustment, 1, 1);

        var hold_units_label = new Gtk.Label (_("seconds"));

        var hold_spin_grid = new Gtk.Grid ();
        hold_spin_grid.column_spacing = 6;
        hold_spin_grid.add (hold_spinbutton);
        hold_spin_grid.add (hold_units_label);

        var double_click_speed_adjustment = new Gtk.Adjustment (400, 100, 1000, 0.1, 0.1, 0.1);

        var double_click_speed_scale = new Gtk.Scale (Gtk.Orientation.HORIZONTAL, double_click_speed_adjustment);
        double_click_speed_scale.draw_value = false;
        double_click_speed_scale.add_mark (400, Gtk.PositionType.TOP, null);

        var double_click_speed_help = new Gtk.Label (_("How quickly two clicks in a row will be treated as a double-click"));
        double_click_speed_help.margin_bottom = 18;
        double_click_speed_help.wrap = true;
        double_click_speed_help.xalign = 0;
        double_click_speed_help.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);

        var dwell_click_switch = new Gtk.Switch ();
        dwell_click_switch.halign = Gtk.Align.START;
        dwell_click_switch.valign = Gtk.Align.CENTER;

        var dwell_click_adjustment = new Gtk.Adjustment (0, 0.5, 3, 0.1, 0.1, 0.1);

        var dwell_click_delay_scale = new Gtk.Scale (Gtk.Orientation.HORIZONTAL, dwell_click_adjustment);
        dwell_click_delay_scale.add_mark (1.2, Gtk.PositionType.TOP, null);
        dwell_click_delay_scale.draw_value = false;

        var dwell_click_spinbutton = new Gtk.SpinButton (dwell_click_adjustment, 1, 1);

        var dwell_click_units_label = new Gtk.Label (_("seconds"));

        var dwell_click_spin_grid = new Gtk.Grid ();
        dwell_click_spin_grid.column_spacing = 6;
        dwell_click_spin_grid.add (dwell_click_spinbutton);
        dwell_click_spin_grid.add (dwell_click_units_label);

        var dwell_click_help = new Gtk.Label (_("Hold the pointer still to automatically click"));
        dwell_click_help.margin_bottom = 18;
        dwell_click_help.wrap = true;
        dwell_click_help.xalign = 0;
        dwell_click_help.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);

        content_area.row_spacing = 6;

        content_area.attach (primary_button_label, 0, 0);
        content_area.attach (primary_button_switcher, 1, 0, 3);

        content_area.attach (new SettingLabel (_("Double-click speed:")), 0, 1);
        content_area.attach (double_click_speed_scale, 1, 1, 3);
        content_area.attach (double_click_speed_help, 1, 2, 3);

        content_area.attach (new SettingLabel (_("Dwell click:")), 0, 3);
        content_area.attach (dwell_click_switch, 1, 3);
        content_area.attach (dwell_click_delay_scale, 2, 3);
        content_area.attach (dwell_click_spin_grid, 3, 3);
        content_area.attach (dwell_click_help, 1, 4, 3);

        content_area.attach (new SettingLabel (_("Long-press secondary click:")), 0, 5);
        content_area.attach (hold_switch, 1, 5);
        content_area.attach (hold_scale, 2, 5);
        content_area.attach (hold_spin_grid, 3, 5);
        content_area.attach (hold_help, 1, 6, 3);

        var xsettings_schema = SettingsSchemaSource.get_default ().lookup (
            "org.gnome.settings-daemon.plugins.xsettings",
            true
        );

        if (xsettings_schema != null) {
            var primary_paste_switch = new Gtk.Switch ();
            primary_paste_switch.halign = Gtk.Align.START;

            var primary_paste_help = new Gtk.Label (
                _("Middle or three-finger click on an input to paste selected text")
            );
            primary_paste_help.margin_bottom = 18;
            primary_paste_help.wrap = true;
            primary_paste_help.xalign = 0;
            primary_paste_help.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);

            content_area.attach (new SettingLabel (_("Middle click paste:")), 0, 7);
            content_area.attach (primary_paste_switch, 1, 7);
            content_area.attach (primary_paste_help, 1, 8, 3);

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
            hold_scale_adjustment,
            "value",
            GLib.SettingsBindFlags.DEFAULT
        );

        a11y_mouse_settings.bind ("dwell-click-enabled", dwell_click_delay_scale, "sensitive", SettingsBindFlags.GET);
        a11y_mouse_settings.bind ("dwell-click-enabled", dwell_click_spin_grid, "sensitive", SettingsBindFlags.GET);
        a11y_mouse_settings.bind ("dwell-click-enabled", dwell_click_switch, "active", SettingsBindFlags.DEFAULT);
        a11y_mouse_settings.bind ("dwell-time", dwell_click_adjustment, "value", SettingsBindFlags.DEFAULT);

        hold_switch.bind_property ("active", hold_scale, "sensitive", BindingFlags.SYNC_CREATE);
        hold_switch.bind_property ("active", hold_spin_grid, "sensitive", BindingFlags.SYNC_CREATE);

        var mouse_settings = new GLib.Settings ("org.gnome.desktop.peripherals.mouse");
        if (mouse_settings.get_boolean ("left-handed")) {
            mouse_right.active = true;
        } else {
            mouse_left.active = true;
        }

        mouse_left.button_release_event.connect (() => {
            mouse_settings.set_boolean ("left-handed", false);
            mouse_left.active = true;
            return Gdk.EVENT_STOP;
        });

        mouse_right.button_release_event.connect (() => {
            mouse_settings.set_boolean ("left-handed", true);
            mouse_right.active = true;
            return Gdk.EVENT_STOP;
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
