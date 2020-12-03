/*
 * Copyright (c) 2011-2020 elementary, Inc. (https://elementary.io)
 *               2020 José Expósito <jose.exposito89@gmail.com>
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

    private GLib.Settings glib_settings = new GLib.Settings ("io.elementary.desktop.wm.gestures");
    private ToucheggSettings touchegg_settings = new ToucheggSettings ();

    public GesturesView () {
        Object (
            icon_name: "mouse-touchpad-gestures",
            title: _("Gestures")
        );
    }

    construct {
        // Multitasking View
        var multitasking_label = new SettingLabel (_("Multitasking View:"));

        multitasking_switch = new Gtk.Switch () {
            halign = Gtk.Align.START,
            valign = Gtk.Align.CENTER
        };

        multitasking_combobox = new Gtk.ComboBoxText ();
        multitasking_combobox.hexpand = true;
        multitasking_combobox.append ("3", _("Swipe up with three fingers"));
        multitasking_combobox.append ("4", _("Swipe up with four fingers"));

        // Switch between desktops
        var workspaces_label = new SettingLabel (_("Switch Workspaces:"));

        workspaces_switch = new Gtk.Switch () {
            halign = Gtk.Align.START,
            valign = Gtk.Align.CENTER
        };

        workspaces_combobox = new Gtk.ComboBoxText ();
        workspaces_combobox.hexpand = true;
        workspaces_combobox.append ("3", _("Swipe left or right with three fingers"));
        workspaces_combobox.append ("4", _("Swipe left or right with four fingers"));

        // Maximize or restore a window
        maximize_label = new SettingLabel (_("Maximize Window:"));

        maximize_switch = new Gtk.Switch () {
            halign = Gtk.Align.START,
            valign = Gtk.Align.CENTER
        };

        maximize_combobox = new Gtk.ComboBoxText ();
        maximize_combobox.hexpand = true;
        maximize_combobox.append ("3", _("Swipe up with three fingers"));
        maximize_combobox.append ("4", _("Swipe up with four fingers"));

        // Tile a window
        tile_label = new SettingLabel (_("Tile Window:"));

        tile_switch = new Gtk.Switch () {
            halign = Gtk.Align.START,
            valign = Gtk.Align.CENTER
        };

        tile_combobox = new Gtk.ComboBoxText ();
        tile_combobox.hexpand = true;
        tile_combobox.append ("3", _("Swipe left or right with three fingers"));
        tile_combobox.append ("4", _("Swipe left or right with four fingers"));

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

        // Bind the setting listeners
        glib_settings.bind ("multitasking-gesture-enabled", multitasking_switch, "active", GLib.SettingsBindFlags.DEFAULT);
        multitasking_switch.bind_property ("active", multitasking_combobox, "sensitive", BindingFlags.SYNC_CREATE);
        multitasking_combobox.changed.connect (() => update_comboboxes (multitasking_combobox));

        glib_settings.bind ("workspaces-gesture-enabled", workspaces_switch, "active", GLib.SettingsBindFlags.DEFAULT);
        workspaces_switch.bind_property ("active", workspaces_combobox, "sensitive", BindingFlags.SYNC_CREATE);
        workspaces_combobox.changed.connect (() => update_comboboxes (workspaces_combobox));

        maximize_switch.bind_property ("active", maximize_combobox, "sensitive", BindingFlags.SYNC_CREATE);
        maximize_combobox.changed.connect (() => update_comboboxes (maximize_combobox));
        maximize_switch.state_set.connect (() => {
            int fingers = int.parse (maximize_combobox.get_active_id ());
            save_combobox_settings (maximize_combobox, fingers);
            update_ui ();
        });

        tile_switch.bind_property ("active", tile_combobox, "sensitive", BindingFlags.SYNC_CREATE);
        tile_combobox.changed.connect (() => update_comboboxes (tile_combobox));
        tile_switch.state_set.connect (() => {
            int fingers = int.parse (tile_combobox.get_active_id ());
            save_combobox_settings (tile_combobox, fingers);
            update_ui ();
        });
    }

    private void update_comboboxes (Gtk.ComboBoxText combobox) {
        string selection = combobox.get_active_id ();
        int fingers = int.parse (selection);

        var linked_combobox = get_linked_combobox (combobox);
        var linked_fingers = (fingers == 3) ? 4 : 3;

        save_combobox_settings (combobox, fingers);
        if (linked_combobox.get_active_id () == selection) {
            save_combobox_settings (linked_combobox, linked_fingers);
        }

        update_ui ();
    }

    private Gtk.ComboBoxText? get_linked_combobox (Gtk.ComboBoxText combobox) {
        if (combobox == multitasking_combobox) {
            return maximize_combobox;
        }

        if (combobox == workspaces_combobox) {
            return tile_combobox;
        }

        if (combobox == maximize_combobox) {
            return multitasking_combobox;
        }

        if (combobox == tile_combobox) {
            return workspaces_combobox;
        }

        // Unreachable
        return null;
    }

    private void save_combobox_settings (Gtk.ComboBoxText combobox, int fingers) {
        if (combobox == multitasking_combobox) {
            glib_settings.set_int ("multitasking-gesture-fingers", fingers);
            return;
        }

        if (combobox == workspaces_combobox) {
            glib_settings.set_int ("workspaces-gesture-fingers", fingers);
            return;
        }

        if (combobox == maximize_combobox) {
            bool enabled = maximize_switch.active;
            touchegg_settings.set_maximize_settings (enabled, fingers);
            return;
        }

        if (combobox == tile_combobox) {
            bool enabled = tile_switch.active;
            touchegg_settings.set_tile_settings (enabled, fingers);
            return;
        }
    }

    private void update_ui () {
        // Read the current settings
        bool multitasking_enabled = glib_settings.get_boolean ("multitasking-gesture-enabled");
        int multitasking_fingers = glib_settings.get_int ("multitasking-gesture-fingers");

        bool workspaces_enabled = glib_settings.get_boolean ("workspaces-gesture-enabled");
        int workspaces_fingers = glib_settings.get_int ("workspaces-gesture-fingers");

        bool maximize_enabled = touchegg_settings.maximize_enabled;
        int maximize_fingers = touchegg_settings.maximize_fingers;

        bool tile_enabled = touchegg_settings.tile_enabled;
        int tile_fingers = touchegg_settings.tile_fingers;

        // Multitasking
        multitasking_switch.state = multitasking_enabled;
        multitasking_combobox.active = (multitasking_fingers == 3) ? 0 : 1;

        // Workspaces
        workspaces_switch.state = workspaces_enabled;
        workspaces_combobox.active = (workspaces_fingers == 3) ? 0 : 1;

        // Maximize or restore a window
        maximize_label.sensitive = !touchegg_settings.errors;
        maximize_switch.sensitive = !touchegg_settings.errors;
        maximize_combobox.sensitive = !touchegg_settings.errors && maximize_enabled;

        maximize_switch.state = maximize_enabled;
        if (maximize_enabled) {
            maximize_combobox.active = (maximize_fingers == 3) ? 0 : 1;
        } else {
            maximize_combobox.active = (multitasking_fingers == 3) ? 1 : 0;
        }

        // Tile a window
        tile_label.sensitive = !touchegg_settings.errors;
        tile_switch.sensitive = !touchegg_settings.errors;
        tile_combobox.sensitive = !touchegg_settings.errors && tile_enabled;

        tile_switch.state = tile_enabled;
        if (tile_enabled) {
            tile_combobox.active = (tile_fingers == 3) ? 0 : 1;
        } else {
            tile_combobox.active = (workspaces_fingers == 3) ? 1 : 0;
        }
    }
}
