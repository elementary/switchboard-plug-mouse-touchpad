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
    private Gtk.Stack stack;
    private Gtk.Paned hpaned;

    private ClickingView clicking_view;
    private MouseView mouse_view;
    private PointingView pointing_view;
    private TouchpadView touchpad_view;

    public Plug () {
        var settings = new Gee.TreeMap<string, string?> (null, null);
        settings.set ("input/pointer/clicking", "clicking");
        settings.set ("input/pointer/mouse", "mouse");
        settings.set ("input/pointer/pointing", "pointing");
        settings.set ("input/pointer/touch", "touchpad");
        settings.set ("input/pointer", "clicking");
        // deprecated
        settings.set ("input/mouse", null);
        settings.set ("input/touch", "touchpad");

        Object (
            category: Category.HARDWARE,
            code_name: "io.elementary.switchboard.mouse-touchpad",
            display_name: _("Mouse & Touchpad"),
            description: _("Configure mouse and touchpad"),
            icon: "preferences-desktop-peripherals",
            supported_settings: settings
        );
    }

    public override Gtk.Widget get_widget () {
        if (hpaned == null) {
            weak Gtk.IconTheme default_theme = Gtk.IconTheme.get_default ();
            default_theme.add_resource_path ("/io/elementary/switchboard/mouse-touchpad");

            clicking_view = new ClickingView ();
            mouse_view = new MouseView ();
            pointing_view = new PointingView ();
            touchpad_view = new TouchpadView ();

            stack = new Gtk.Stack ();
            stack.add_named (clicking_view, "clicking");
            stack.add_named (pointing_view, "pointing");
            stack.add_named (mouse_view, "mouse");
            stack.add_named (touchpad_view, "touchpad");

            var switcher = new Granite.SettingsSidebar (stack);

            hpaned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
            hpaned.pack1 (switcher, false, false);
            hpaned.add (stack);
            hpaned.show_all ();
        }

        return hpaned;
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
            case "pointing":
                stack.set_visible_child_name ("pointing");
                break;
            case "touchpad":
                stack.set_visible_child_name ("touchpad");
                break;
            case "clicking":
            default:
                stack.set_visible_child_name ("clicking");
                break;
        }
    }

    /* 'search' returns results like ("Keyboard → Behavior → Duration", "keyboard<sep>behavior") */
    public override async Gee.TreeMap<string, string> search (string search) {
        var search_results = new Gee.TreeMap<string, string> (
            (GLib.CompareDataFunc<string>)strcmp,
            (Gee.EqualDataFunc<string>)str_equal
        );
        search_results.set ("%s → %s".printf (display_name, _("Clicking")), "clicking");
        search_results.set ("%s → %s".printf (display_name, _("Double-click speed")), "clicking");
        search_results.set ("%s → %s".printf (display_name, _("Dwell click")), "clicking");
        search_results.set ("%s → %s".printf (display_name, _("Primary button")), "clicking");
        search_results.set ("%s → %s".printf (display_name, _("Long-press secondary click")), "clicking");
        search_results.set ("%s → %s".printf (display_name, _("Middle click paste")), "clicking");

        search_results.set ("%s → %s".printf (display_name, _("Mouse")), "mouse");
        search_results.set ("%s → %s → %s".printf (display_name, _("Mouse"), _("Pointer speed")), "mouse");
        search_results.set ("%s → %s → %s".printf (display_name, _("Mouse"), _("Pointer acceleration")), "mouse");
        search_results.set ("%s → %s → %s".printf (display_name, _("Mouse"), _("Natural scrolling")), "mouse");

        search_results.set ("%s → %s".printf (display_name, _("Pointing")), "pointing");
        search_results.set ("%s → %s".printf (display_name, _("Pointer size")), "pointing");
        search_results.set ("%s → %s".printf (display_name, _("Reveal pointer")), "pointing");
        search_results.set ("%s → %s".printf (display_name, _("Control pointer using keypad")), "pointing");

        search_results.set ("%s → %s".printf (display_name, _("Touchpad")), "touchpad");
        search_results.set ("%s → %s → %s".printf (display_name, _("Touchpad"), _("Pointer speed")), "touchpad");
        search_results.set ("%s → %s → %s".printf (display_name, _("Touchpad"), _("Tap to click")), "touchpad");
        search_results.set ("%s → %s → %s".printf (display_name, _("Touchpad"), _("Physical clicking")), "touchpad");
        search_results.set ("%s → %s → %s".printf (display_name, _("Touchpad"), _("Scrolling")), "touchpad");
        search_results.set ("%s → %s → %s".printf (display_name, _("Touchpad"), _("Natural scrolling")), "touchpad");
        search_results.set ("%s → %s → %s".printf (display_name, _("Touchpad"), _("Ignore while typing")), "touchpad");
        search_results.set ("%s → %s → %s".printf (display_name, _("Touchpad"), _("Ignore when mouse is connected")), "touchpad");
        return search_results;
    }
}

public Switchboard.Plug get_plug (Module module) {
    debug ("Activating Mouse-Touchpad plug");

    var plug = new MouseTouchpad.Plug ();

    return plug;
}
