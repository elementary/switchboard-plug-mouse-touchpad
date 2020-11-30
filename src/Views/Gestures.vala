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
    private Gtk.Switch multitasking_switch;
    private Gtk.ComboBoxText multitasking_combobox;

    private Gtk.Switch workspaces_switch;
    private Gtk.ComboBoxText workspaces_combobox;

    private SettingLabel maximize_label;
    private Gtk.Switch maximize_switch;
    private Gtk.ComboBoxText maximize_combobox;

    private SettingLabel tile_label;
    private Gtk.Switch tile_switch;
    private Gtk.ComboBoxText tile_combobox;

    private ToucheggConfig touchegg_config = new ToucheggConfig ();

    public GesturesView () {
        Object (
            icon_name: "input-touchpad-gesture",
            title: _("Gestures")
        );
    }

    construct {
        // Multitasking View
        var multitasking_label = new SettingLabel (_("Multitasking View:"));

        multitasking_switch = new Gtk.Switch ();
        multitasking_switch.halign = Gtk.Align.START;

        multitasking_combobox = new Gtk.ComboBoxText ();
        multitasking_combobox.hexpand = true;
        multitasking_combobox.append ("three-fingers", _("Swipe up with three fingers"));
        multitasking_combobox.append ("four-fingers", _("Swipe up with four fingers"));

        // Switch between desktops
        var workspaces_label = new SettingLabel (_("Switch Workspaces:"));

        workspaces_switch = new Gtk.Switch ();
        workspaces_switch.halign = Gtk.Align.START;

        workspaces_combobox = new Gtk.ComboBoxText ();
        workspaces_combobox.hexpand = true;
        workspaces_combobox.append ("three-fingers", _("Swipe left or right with three fingers"));
        workspaces_combobox.append ("four-fingers", _("Swipe left or right with four fingers"));

        // Maximize or restore a window
        maximize_label = new SettingLabel (_("Maximize Window:"));

        maximize_switch = new Gtk.Switch ();
        maximize_switch.halign = Gtk.Align.START;

        maximize_combobox = new Gtk.ComboBoxText ();
        maximize_combobox.hexpand = true;
        maximize_combobox.append ("three-fingers", _("Swipe up with three fingers"));
        maximize_combobox.append ("four-fingers", _("Swipe up with four fingers"));

        // Tile a window
        tile_label = new SettingLabel (_("Tile Window:"));

        tile_switch = new Gtk.Switch ();
        tile_switch.halign = Gtk.Align.START;

        tile_combobox = new Gtk.ComboBoxText ();
        tile_combobox.hexpand = true;
        tile_combobox.append ("three-fingers", _("Swipe left or right with three fingers"));
        tile_combobox.append ("four-fingers", _("Swipe left or right with four fingers"));

        // Place the widgets
        content_area.attach (multitasking_label, 0, 0);
        content_area.attach (multitasking_switch, 1, 0);
        content_area.attach (multitasking_combobox, 2, 0);

        content_area.attach (workspaces_label, 0, 1);
        content_area.attach (workspaces_switch, 1, 1);
        content_area.attach (workspaces_combobox, 2, 1);

        content_area.attach (maximize_label, 0, 2);
        content_area.attach (maximize_switch, 1, 2);
        content_area.attach (maximize_combobox, 2, 2);

        content_area.attach (tile_label, 0, 3);
        content_area.attach (tile_switch, 1, 3);
        content_area.attach (tile_combobox, 2, 3);

        // Show the configuration
        update_ui ();
    }

    private void update_ui () {
        // Maximize or restore a window
        maximize_label.sensitive = !touchegg_config.errors;
        maximize_switch.sensitive = !touchegg_config.errors;
        maximize_combobox.sensitive = !touchegg_config.errors;

        maximize_switch.state = touchegg_config.maximize_configured;
        maximize_combobox.active = (touchegg_config.maximize_fingers == 4) ? 1 : 0;
        
        // Tile a window
        tile_label.sensitive = !touchegg_config.errors;
        tile_switch.sensitive = !touchegg_config.errors;
        tile_combobox.sensitive = !touchegg_config.errors;

        tile_switch.state = touchegg_config.tile_configured;
        tile_combobox.active = (touchegg_config.tile_fingers == 4) ? 1 : 0;
    }
}
