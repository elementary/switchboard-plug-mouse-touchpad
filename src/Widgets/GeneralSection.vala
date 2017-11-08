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
    public Backend.DaemonSettings daemon_settings { get; construct; }
    public Backend.InterfaceSettings interface_settings { get; construct; }

    public GeneralSection (Backend.MouseSettings mouse_settings, Backend.DaemonSettings daemon_settings, Backend.InterfaceSettings interface_settings) {
        Object (mouse_settings: mouse_settings, daemon_settings: daemon_settings, interface_settings: interface_settings);
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

        var primary_paste_switch = new Gtk.Switch ();
        primary_paste_switch.halign = Gtk.Align.START;
        primary_paste_switch.margin_end = 8;

        var locate_pointer_help = new Gtk.Image.from_icon_name ("help-info-symbolic", Gtk.IconSize.BUTTON);
        locate_pointer_help.halign = Gtk.Align.START;
        locate_pointer_help.hexpand = true;
        locate_pointer_help.tooltip_text = _("Pressing the control key will highlight the position of the pointer");

        var primary_paste_help = new Gtk.Image.from_icon_name ("help-info-symbolic", Gtk.IconSize.BUTTON);
        primary_paste_help.halign = Gtk.Align.START;
        primary_paste_help.hexpand = true;
        primary_paste_help.tooltip_text = _("Middle or three-finger clicking on an input will paste any selected text");

        row_spacing = 12;
        column_spacing = 12;

        attach (title_label, 0, 0, 1, 1);
        attach (new SettingLabel (_("Primary button:")), 0, 1, 1, 1);
        attach (primary_button_switcher, 1, 1, 2, 1);
        attach (new SettingLabel (_("Reveal pointer:")), 0, 2, 1, 1);
        attach (reveal_pointer_switch, 1, 2, 1, 1);
        attach (locate_pointer_help, 2, 2, 1, 1);
        attach (new SettingLabel (_("Middle click paste:")), 0, 3, 1, 1);
        attach (primary_paste_switch, 1, 3, 1, 1);
        attach (primary_paste_help, 2, 3, 1, 1);

        mouse_settings.bind_property ("left-handed",
                                      primary_button_switcher,
                                      "selected",
                                      BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);

        daemon_settings.bind_property ("locate-pointer",
                                      reveal_pointer_switch,
                                      "state",
                                      BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);

        interface_settings.bind_property ("gtk-enable-primary-paste",
                                         primary_paste_switch,
                                         "state",
                                         BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);
    }
}
