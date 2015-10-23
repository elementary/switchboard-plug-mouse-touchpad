/*
 * Copyright (c) 2011-2015 elementary Developers (https://launchpad.net/elementary)
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
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

namespace MouseTouchpad {
    public class Plug : Switchboard.Plug {
        private Backend.MouseSettings mouse_settings;
        private Backend.DaemonSettings daemon_settings;
        private Backend.TouchpadSettings touchpad_settings;

        private Gtk.Grid main_grid;

        private Widgets.GeneralSection general_section;
        private Widgets.MouseSection mouse_section;
        private Widgets.TouchpadSection touchpad_section;

        public Plug () {
            Object (category: Category.HARDWARE,
                    code_name: "pantheon-mouse-touchpad",
                    display_name: _("Mouse & Touchpad"),
                    description: _("Set your mouse and touchpad preferences"),
                    icon: "preferences-desktop-peripherals");
        }

        public override Gtk.Widget get_widget () {
            if (main_grid == null) {
                load_settings ();
                build_ui ();
            }

            return main_grid;
        }

        public override void shown () {
        }

        public override void hidden () {
        }

        public override void search_callback (string location) {
        }

        /* 'search' returns results like ("Keyboard → Behavior → Duration", "keyboard<sep>behavior") */
        public override async Gee.TreeMap<string, string> search (string search) {
            return new Gee.TreeMap<string, string> (null, null);
        }

        private void load_settings () {
            mouse_settings = new Backend.MouseSettings ();
            touchpad_settings = new Backend.TouchpadSettings ();
            daemon_settings = new Backend.DaemonSettings ();
        }

        private void build_ui () {
            main_grid = new Gtk.Grid ();
            main_grid.margin = 12;
            main_grid.row_spacing = 12;
            main_grid.halign = Gtk.Align.CENTER;

            general_section = new Widgets.GeneralSection (mouse_settings, daemon_settings);
            mouse_section = new Widgets.MouseSection (mouse_settings);
            touchpad_section = new Widgets.TouchpadSection (touchpad_settings);

            main_grid.attach (general_section, 0, 0, 1, 1);
            main_grid.attach (mouse_section, 0, 1, 1, 1);
            main_grid.attach (touchpad_section, 0, 2, 1, 1);
            main_grid.show_all ();
        }
    }
}

public Switchboard.Plug get_plug (Module module) {
    debug ("Activating Mouse-Touchpad plug");

    var plug = new MouseTouchpad.Plug ();

    return plug;
}
