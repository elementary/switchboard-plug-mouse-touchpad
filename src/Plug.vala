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

public class MouseTouchpad.Plug : Switchboard.Plug {
    private Backend.MouseSettings mouse_settings;
    private Backend.TouchpadSettings touchpad_settings;

    private Gtk.ScrolledWindow scrolled;

    private Widgets.GeneralSection general_section;
    private Widgets.MouseSection mouse_section;
    private Widgets.TouchpadSection touchpad_section;

    public static Gtk.SizeGroup end_size_group;
    public static Gtk.SizeGroup start_size_group;

    public Plug () {
        var settings = new Gee.TreeMap<string, string?> (null, null);
        settings.set ("input/mouse", null);
        settings.set ("input/touch", null);
        Object (
            category: Category.HARDWARE,
            code_name: "pantheon-mouse-touchpad",
            display_name: _("Mouse & Touchpad"),
            description: _("Configure mouse and touchpad"),
            icon: "preferences-desktop-peripherals",
            supported_settings: settings
        );
    }

    public override Gtk.Widget get_widget () {
        if (scrolled == null) {
            end_size_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.HORIZONTAL);
            start_size_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.HORIZONTAL);

            load_settings ();

            general_section = new Widgets.GeneralSection (mouse_settings);
            mouse_section = new Widgets.MouseSection (mouse_settings);
            touchpad_section = new Widgets.TouchpadSection (touchpad_settings);

            var display = Gdk.Display.get_default ();
            if (display != null) {
                var manager = Gdk.Display.get_default ().get_device_manager ();
                manager.device_added.connect (() => {
                    update_ui (manager);
                });

                manager.device_removed.connect (() => {
                    update_ui (manager);
                });

                update_ui (manager);
            }

            var main_grid = new Gtk.Grid ();
            main_grid.margin = 12;
            main_grid.row_spacing = 12;
            main_grid.halign = Gtk.Align.CENTER;
            main_grid.attach (general_section, 0, 0, 1, 1);
            main_grid.attach (mouse_section, 0, 1, 1, 1);
            main_grid.attach (touchpad_section, 0, 2, 1, 1);

            scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.add (main_grid);
            scrolled.show_all ();
        }

        return scrolled;
    }

    public override void shown () {
    }

    public override void hidden () {
    }

    public override void search_callback (string location) {
    }

    /* 'search' returns results like ("Keyboard → Behavior → Duration", "keyboard<sep>behavior") */
    public override async Gee.TreeMap<string, string> search (string search) {
        var search_results = new Gee.TreeMap<string, string> ((GLib.CompareDataFunc<string>)strcmp, (Gee.EqualDataFunc<string>)str_equal);
        search_results.set ("%s → %s".printf (display_name, _("Primary button")), "");
        search_results.set ("%s → %s".printf (display_name, _("Reveal pointer")), "");
        search_results.set ("%s → %s".printf (display_name, _("Middle click paste")), "");
        search_results.set ("%s → %s".printf (display_name, _("Long-press secondary click")), "");
        search_results.set ("%s → %s".printf (display_name, _("Pointer speed")), "");
        search_results.set ("%s → %s".printf (display_name, _("Tap to click")), "");
        search_results.set ("%s → %s".printf (display_name, _("Physical clicking")), "");
        search_results.set ("%s → %s".printf (display_name, _("Scrolling")), "");
        search_results.set ("%s → %s".printf (display_name, _("Natural scrolling")), "");
        search_results.set ("%s → %s".printf (display_name, _("Disable while typing")), "");
        return search_results;
    }

    private void load_settings () {
        mouse_settings = new Backend.MouseSettings ();
        touchpad_settings = new Backend.TouchpadSettings ();
    }

    private void update_ui (Gdk.DeviceManager manager) {
        if (has_mouse (manager)) {
            mouse_section.no_show_all = false;
            mouse_section.show_all ();
        } else {
            mouse_section.no_show_all = true;
            mouse_section.hide ();
        }
    }

    private bool has_mouse (Gdk.DeviceManager manager) {
        foreach (var device in manager.list_devices (Gdk.DeviceType.SLAVE)) {
            if (device.get_source () == Gdk.InputSource.MOUSE && !device.get_name ().has_prefix ("Virtual core")) {
                return true;
            }
        }

        return false;
    }
}

public Switchboard.Plug get_plug (Module module) {
    debug ("Activating Mouse-Touchpad plug");

    var plug = new MouseTouchpad.Plug ();

    return plug;
}

