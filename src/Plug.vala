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

public class MouseTouchpad.Plug : Switchboard.Plug {
    private Backend.MouseSettings mouse_settings;
    private Backend.TouchpadSettings touchpad_settings;

    private Gtk.Stack stack;
    private Gtk.ScrolledWindow scrolled;

    private GeneralView general_view;
    private MouseView mouse_view;
    private TouchpadView touchpad_view;

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

            general_view = new GeneralView (mouse_settings);
            mouse_view = new MouseView (mouse_settings);
            touchpad_view = new TouchpadView (touchpad_settings);

            stack = new Gtk.Stack ();
            stack.margin = 12;
            stack.add_titled (general_view, "general", _("General"));
            stack.add_titled (mouse_view, "mouse", _("Mouse"));
            stack.add_titled (touchpad_view, "touchpad", _("Touchpad"));

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
        switch (location) {
            case "mouse":
                stack.set_visible_child_name ("mouse");
                break;
            case "touchpad":
                stack.set_visible_child_name ("touchpad");
                break;
            case "general":
            default:
                stack.set_visible_child_name ("general");
                break;
        }
    }

    /* 'search' returns results like ("Keyboard → Behavior → Duration", "keyboard<sep>behavior") */
    public override async Gee.TreeMap<string, string> search (string search) {
        var search_results = new Gee.TreeMap<string, string> ((GLib.CompareDataFunc<string>)strcmp, (Gee.EqualDataFunc<string>)str_equal);
        search_results.set ("%s → %s".printf (display_name, _("Primary button")), "general");
        search_results.set ("%s → %s".printf (display_name, _("Reveal pointer")), "general");
        search_results.set ("%s → %s".printf (display_name, _("Middle click paste")), "general");
        search_results.set ("%s → %s".printf (display_name, _("Long-press secondary click")), "general");
        search_results.set ("%s → %s".printf (display_name, _("Long-press length")), "general");
        search_results.set ("%s → %s".printf (display_name, _("Middle click paste")), "general");
        search_results.set ("%s → %s".printf (display_name, _("Mouse")), "mouse");
        search_results.set ("%s → %s → %s".printf (display_name, _("Mouse"), _("Pointer speed")), "mouse");
        search_results.set ("%s → %s → %s".printf (display_name, _("Mouse"), _("Pointer acceleration")), "mouse");
        search_results.set ("%s → %s → %s".printf (display_name, _("Mouse"), _("Natural scrolling")), "mouse");
        search_results.set ("%s → %s".printf (display_name, _("Touchpad")), "touchpad");
        search_results.set ("%s → %s → %s".printf (display_name, _("Touchpad"), _("Pointer speed")), "touchpad");
        search_results.set ("%s → %s → %s".printf (display_name, _("Touchpad"), _("Tap to click")), "touchpad");
        search_results.set ("%s → %s → %s".printf (display_name, _("Touchpad"), _("Physical clicking")), "touchpad");
        search_results.set ("%s → %s → %s".printf (display_name, _("Touchpad"), _("Scrolling")), "touchpad");
        search_results.set ("%s → %s → %s".printf (display_name, _("Touchpad"), _("Natural scrolling")), "touchpad");
        search_results.set ("%s → %s → %s".printf (display_name, _("Touchpad"), _("Disable while typing")), "touchpad");
        return search_results;
    }

    private void load_settings () {
        mouse_settings = new Backend.MouseSettings ();
        touchpad_settings = new Backend.TouchpadSettings ();
    }
}

public Switchboard.Plug get_plug (Module module) {
    debug ("Activating Mouse-Touchpad plug");

    var plug = new MouseTouchpad.Plug ();

    return plug;
}

