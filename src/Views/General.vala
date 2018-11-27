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

public class MouseTouchpad.GeneralView : Gtk.Grid {
    public Backend.MouseSettings mouse_settings { get; construct; }

    public GeneralView (Backend.MouseSettings mouse_settings) {
        Object (mouse_settings: mouse_settings);
    }

    construct {
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

            mouse_settings.bind_property (
                "left-handed",
                primary_button_switcher,
                "selected",
                BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE
            );
        } else {
            primary_button_switcher.append (mouse_right);
            primary_button_switcher.append (mouse_left);

            mouse_settings.bind_property (
                "left-handed",
                primary_button_switcher,
                "selected",
                BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE | BindingFlags.INVERT_BOOLEAN
            );
        }


        var reveal_pointer_switch = new Gtk.Switch ();
        reveal_pointer_switch.halign = Gtk.Align.START;
        reveal_pointer_switch.margin_end = 8;

        var locate_pointer_help = new Gtk.Label (_("Pressing the control key will highlight the position of the pointer"));
        locate_pointer_help.margin_bottom = 18;
        locate_pointer_help.xalign = 0;
        locate_pointer_help.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);

        var hold_label = new SettingLabel (_("Long-press secondary click:"));

        var hold_switch = new Gtk.Switch ();
        hold_switch.halign = Gtk.Align.START;
        hold_switch.margin_end = 8;

        var hold_help = new Gtk.Label (_("Long-pressing and releasing the primary button will secondary click."));
        hold_help.margin_bottom = 18;
        hold_help.xalign = 0;
        hold_help.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);

        var hold_length_label = new SettingLabel (_("Long-press length:"));
        hold_length_label.margin_bottom = 18;

        var hold_scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0.5, 2.0, 0.1);
        hold_scale.draw_value = false;
        hold_scale.hexpand = true;
        hold_scale.margin_bottom = 10;
        hold_scale.width_request = 160;
        hold_scale.add_mark (1.2, Gtk.PositionType.BOTTOM, null);

        row_spacing = 6;
        column_spacing = 12;

        attach (primary_button_label, 0, 0);
        attach (primary_button_switcher, 1, 0, 2, 1);
        attach (new SettingLabel (_("Reveal pointer:")), 0, 1);
        attach (reveal_pointer_switch, 1, 1);
        attach (locate_pointer_help, 1, 2);
        attach (hold_label, 0, 3);
        attach (hold_switch, 1, 3);
        attach (hold_help, 1, 4);
        attach (hold_length_label, 0, 5);
        attach (hold_scale, 1, 5, 2);

        var xsettings_schema = SettingsSchemaSource.get_default ().lookup ("org.gnome.settings-daemon.plugins.xsettings", false);
        if (xsettings_schema != null) {
            var primary_paste_switch = new Gtk.Switch ();
            primary_paste_switch.halign = Gtk.Align.START;
            primary_paste_switch.margin_end = 8;

            var primary_paste_help = new Gtk.Label (_("Middle or three-finger clicking on an input will paste any selected text"));
            primary_paste_help.xalign = 0;
            primary_paste_help.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);

            attach (new SettingLabel (_("Middle click paste:")), 0, 6);
            attach (primary_paste_switch, 1, 6);
            attach (primary_paste_help, 1, 7);

            var xsettings = new GLib.Settings ("org.gnome.settings-daemon.plugins.xsettings");
            primary_paste_switch.notify["active"].connect (() => on_primary_paste_switch_changed (primary_paste_switch, xsettings));

            var current_value = xsettings.get_value ("overrides").lookup_value ("Gtk/EnablePrimaryPaste", VariantType.INT32);
            if (current_value != null) {
                primary_paste_switch.active = current_value.get_int32 () == 1;
            }
        }

        var daemon_settings = new GLib.Settings ("org.gnome.settings-daemon.peripherals.mouse");
        daemon_settings.bind ("locate-pointer", reveal_pointer_switch, "active", GLib.SettingsBindFlags.DEFAULT);

        var a11y_mouse_settings = new GLib.Settings ("org.gnome.desktop.a11y.mouse");
        a11y_mouse_settings.bind ("secondary-click-enabled", hold_switch, "active", GLib.SettingsBindFlags.DEFAULT);
        a11y_mouse_settings.bind ("secondary-click-time", hold_scale.adjustment, "value", GLib.SettingsBindFlags.DEFAULT);

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

