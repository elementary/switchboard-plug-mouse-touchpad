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

public class MouseTouchpad.GesturesView : Granite.SimpleSettingsPage {
    public GesturesView () {
        Object (
            icon_name: "input-touchpad-gesture",
            title: _("Gestures")
        );
    }

    construct {
        // TODO (José Expósito) Create this widgets in a reusable funtion??

        // Multitasking View
        var multitasking_view_label = new SettingLabel (_("Multitasking View:"));

        var multitasking_view_switch = new Gtk.Switch ();
        multitasking_view_switch.halign = Gtk.Align.START;

        var multitasking_view_combobox = new Gtk.ComboBoxText ();
        multitasking_view_combobox.hexpand = true;
        multitasking_view_combobox.append ("three-fingers", _("Swipe up with three fingers"));
        multitasking_view_combobox.append ("four-fingers", _("Swipe up with four fingers"));
        
        // Switch between desktops
        var change_desktop_label = new SettingLabel (_("Switch Workspaces:"));

        var change_desktop_switch = new Gtk.Switch ();
        change_desktop_switch.halign = Gtk.Align.START;

        var change_desktop_combobox = new Gtk.ComboBoxText ();
        change_desktop_combobox.hexpand = true;
        change_desktop_combobox.append ("three-fingers", _("Swipe left or right with three fingers"));
        change_desktop_combobox.append ("four-fingers", _("Swipe left or right with four fingers"));

        // Maximize or restore a window
        var maximize_label = new SettingLabel (_("Maximize Window:"));

        var maximize_switch = new Gtk.Switch ();
        maximize_switch.halign = Gtk.Align.START;

        var maximize_combobox = new Gtk.ComboBoxText ();
        maximize_combobox.hexpand = true;
        maximize_combobox.append ("three-fingers", _("Swipe up with three fingers"));
        maximize_combobox.append ("four-fingers", _("Swipe up with four fingers"));

        // Tile a window
        var tile_label = new SettingLabel (_("Tile Window:"));

        var tile_switch = new Gtk.Switch ();
        tile_switch.halign = Gtk.Align.START;

        var tile_combobox = new Gtk.ComboBoxText ();
        tile_combobox.hexpand = true;
        tile_combobox.append ("three-fingers", _("Swipe left or right with three fingers"));
        tile_combobox.append ("four-fingers", _("Swipe left or right with four fingers"));

        // Place the widgets
        content_area.attach (multitasking_view_label, 0, 0);
        content_area.attach (multitasking_view_switch, 1, 0);
        content_area.attach (multitasking_view_combobox, 2, 0);

        content_area.attach (change_desktop_label, 0, 1);
        content_area.attach (change_desktop_switch, 1, 1);
        content_area.attach (change_desktop_combobox, 2, 1);

        content_area.attach (maximize_label, 0, 2);
        content_area.attach (maximize_switch, 1, 2);
        content_area.attach (maximize_combobox, 2, 2);

        content_area.attach (tile_label, 0, 3);
        content_area.attach (tile_switch, 1, 3);
        content_area.attach (tile_combobox, 2, 3);
    }
}
