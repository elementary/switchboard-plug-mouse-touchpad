/*
 * Copyright (c) 2011-2016 elementary LLC. (https://elementary.io)
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

public class MouseTouchpad.Widgets.GeneralSection : Gtk.Grid {
    public Backend.MouseSettings mouse_settings { get; construct; }

    public GeneralSection (Backend.MouseSettings mouse_settings) {
        Object (mouse_settings: mouse_settings);
    }

    construct {
        var title_label = new Gtk.Label (_("General"));
        title_label.xalign = 0;
        title_label.hexpand = true;
        title_label.get_style_context ().add_class ("h4");
        Plug.start_size_group.add_widget (title_label);

        var primary_button_switcher = new Granite.Widgets.ModeButton ();
        primary_button_switcher.width_request = 256;
        primary_button_switcher.append_text (_("Left"));
        primary_button_switcher.append_text (_("Right"));
        Plug.end_size_group.add_widget (primary_button_switcher);

        var reveal_pointer_switch = new Gtk.Switch ();
        reveal_pointer_switch.halign = Gtk.Align.START;
        reveal_pointer_switch.margin_end = 8;

        var locate_pointer_help = new Gtk.Image.from_icon_name ("help-info-symbolic", Gtk.IconSize.BUTTON);
        locate_pointer_help.halign = Gtk.Align.START;
        locate_pointer_help.hexpand = true;
        locate_pointer_help.tooltip_text = _("Pressing the control key will highlight the position of the pointer");

        var hold_label = new SettingLabel (_("Long-press secondary click:"));

        var hold_switch = new Gtk.Switch ();
        hold_switch.halign = Gtk.Align.START;
        hold_switch.margin_end = 8;

        var hold_help = new Gtk.Image.from_icon_name ("help-info-symbolic", Gtk.IconSize.BUTTON);
        hold_help.halign = Gtk.Align.START;
        hold_help.hexpand = true;
        hold_help.tooltip_text = _("Long-pressing and releasing the primary button will secondary click.");

        var hold_length_label = new SettingLabel (_("Long-press length:"));

        var hold_scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0.5, 2.0, 0.1);
        hold_scale.add_mark (1.2, Gtk.PositionType.BOTTOM, null);
        hold_scale.draw_value = false;
        hold_scale.hexpand = true;
        hold_scale.set_size_request (160, -1);
        Plug.end_size_group.add_widget (hold_scale);

        row_spacing = 12;
        column_spacing = 12;

        attach (title_label, 0, 0, 1, 1);
        attach (new SettingLabel (_("Primary button:")), 0, 1);
        attach (primary_button_switcher, 1, 1, 2, 1);
        attach (new SettingLabel (_("Reveal pointer:")), 0, 2);
        attach (reveal_pointer_switch, 1, 2);
        attach (locate_pointer_help, 2, 2);
        attach (hold_label, 0, 3);
        attach (hold_switch, 1, 3);
        attach (hold_help, 2, 3);
        attach (hold_length_label, 0, 4);
        attach (hold_scale, 1, 4, 2);

        var xsettings_schema = SettingsSchemaSource.get_default ().lookup ("org.gnome.settings-daemon.plugins.xsettings", false);
        if (xsettings_schema != null) {
            var primary_paste_switch = new Gtk.Switch ();
            primary_paste_switch.halign = Gtk.Align.START;
            primary_paste_switch.margin_end = 8;

            var primary_paste_help = new Gtk.Image.from_icon_name ("help-info-symbolic", Gtk.IconSize.BUTTON);
            primary_paste_help.halign = Gtk.Align.START;
            primary_paste_help.hexpand = true;
            primary_paste_help.tooltip_text = _("Middle or three-finger clicking on an input will paste any selected text");

            attach (new SettingLabel (_("Middle click paste:")), 0, 5);
            attach (primary_paste_switch, 1, 5);
            attach (primary_paste_help, 2, 5);

            var xsettings = new GLib.Settings ("org.gnome.settings-daemon.plugins.xsettings");
            primary_paste_switch.notify["active"].connect (() => on_primary_paste_switch_changed (primary_paste_switch, xsettings));

            var current_value = xsettings.get_value ("overrides").lookup_value ("Gtk/EnablePrimaryPaste", VariantType.INT32);
            if (current_value != null) {
                primary_paste_switch.active = current_value.get_int32 () == 1;
            }
        }

        var daemon_settings = new GLib.Settings ("org.gnome.settings-daemon.peripherals.mouse");
        daemon_settings.bind ("locate-pointer", reveal_pointer_switch, "active", GLib.SettingsBindFlags.DEFAULT);

        mouse_settings.bind_property ("left-handed",
                                      primary_button_switcher,
                                      "selected",
                                      BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);

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
