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

namespace MouseTouchpad {
    public class Plug : Switchboard.Plug {
        private Backend.MouseSettings mouse_settings;
        private Backend.TouchpadSettings touchpad_settings;

        private Gtk.ScrolledWindow scrolled;

        private General general_view;
        private Mouse mouse_view;
        private Touchpad touchpad_view;

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
                load_settings ();

                general_view = new General (mouse_settings);
                mouse_view = new Mouse (mouse_settings);
                touchpad_view = new Touchpad (touchpad_settings);

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

                var stack = new Gtk.Stack ();
                stack.margin = 12;
                stack.add_titled (general_view, "general", _("General"));
                stack.add_titled (mouse_view, "mouse", _("Mouse"));
                stack.add_titled (touchpad_view, "touchpad", _("Touchpad"));

                // TODO: Decide what to do about visibility of tabs without the proper hardware
                var switcher = new Gtk.StackSwitcher ();
                switcher.halign = Gtk.Align.CENTER;
                switcher.homogeneous = true;
                switcher.margin = 12;
                switcher.stack = stack;

                var main_grid = new Gtk.Grid ();
                main_grid.halign = Gtk.Align.CENTER;
                main_grid.attach (switcher, 0, 0);
                main_grid.attach (stack, 0, 1);

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

        // TODO: Update to switch to the right tabs, like Pantheon Shell plug
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
                mouse_view.no_show_all = false;
                mouse_view.show_all ();
            } else {
                mouse_view.no_show_all = true;
                mouse_view.hide ();
            }
        }

        private bool has_mouse (Gdk.DeviceManager manager) {
            foreach (var device in manager.list_devices (Gdk.DeviceType.SLAVE)) {
                if (
                    device.get_source () == Gdk.InputSource.MOUSE &&
                    !device.get_name ().has_prefix ("Virtual core")
                ) {
                    return true;
                }
            }

            return false;
        }
    }
}

public Switchboard.Plug get_plug (Module module) {
    debug ("Activating Mouse-Touchpad plug");

    var plug = new MouseTouchpad.Plug ();

    return plug;
}

