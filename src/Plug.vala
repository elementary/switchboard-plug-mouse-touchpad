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
    private GesturesView gestures_view;
    private bool show_gestures_view;

    construct {
        show_gestures_view = new ToucheggSettings ().is_installed ();
    }

    public Plug () {
        GLib.Intl.bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
        GLib.Intl.bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");

        var settings = new Gee.TreeMap<string, string?> (null, null);
        settings.set ("input/pointer/clicking", "clicking");
        settings.set ("input/pointer/mouse", "mouse");
        settings.set ("input/pointer/pointing", "pointing");
        settings.set ("input/pointer/touch", "touchpad");
        settings.set ("input/pointer/gestures", "gestures");
        settings.set ("input/pointer", "clicking");
        // deprecated
        settings.set ("input/mouse", null);
        settings.set ("input/touch", "touchpad");

        Object (
            category: Category.HARDWARE,
            code_name: "io.elementary.settings.mouse-touchpad",
            display_name: _("Mouse & Touchpad"),
            description: _("Configure mouse and touchpad"),
            icon: "preferences-desktop-peripherals",
            supported_settings: settings
        );
    }

    public override Gtk.Widget get_widget () {
        if (hpaned == null) {
            Gtk.IconTheme.get_for_display (Gdk.Display.get_default ()).add_resource_path ("/io/elementary/settings/mouse-touchpad");

            clicking_view = new ClickingView ();
            mouse_view = new MouseView ();
            pointing_view = new PointingView ();
            touchpad_view = new TouchpadView ();

            stack = new Gtk.Stack ();
            stack.add_named (clicking_view, "clicking");
            stack.add_named (pointing_view, "pointing");

            if (show_gestures_view) {
                gestures_view = new GesturesView ();
                stack.add_named (gestures_view, "gestures");
            }

            stack.add_named (mouse_view, "mouse");
            stack.add_named (touchpad_view, "touchpad");

            var switcher = new Switchboard.SettingsSidebar (stack) {
                show_title_buttons = true
            };

            hpaned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL) {
                start_child = switcher,
                resize_start_child = false,
                shrink_start_child = false,
                end_child = stack,
                shrink_end_child = false
            };

            var sss = SettingsSchemaSource.get_default ().lookup ("io.elementary.settings", true);
            if (sss != null && sss.has_key ("sidebar-position")) {
                var settings = new Settings ("io.elementary.settings");
                settings.bind ("sidebar-position", hpaned, "position", DEFAULT);
            }
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
            case "gestures":
                stack.set_visible_child_name ("gestures");
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
        search_results.set ("%s → %s".printf (display_name, _("Double-click Speed")), "clicking");
        search_results.set ("%s → %s".printf (display_name, _("Dwell Click")), "clicking");
        search_results.set ("%s → %s".printf (display_name, _("Primary Button")), "clicking");
        search_results.set ("%s → %s".printf (display_name, _("Long-press Secondary Click")), "clicking");
        search_results.set ("%s → %s".printf (display_name, _("Middle Click Paste")), "clicking");

        search_results.set ("%s → %s".printf (display_name, _("Mouse")), "mouse");
        search_results.set ("%s → %s → %s".printf (display_name, _("Mouse"), _("Pointer Speed")), "mouse");
        search_results.set ("%s → %s → %s".printf (display_name, _("Mouse"), _("Pointer Acceleration")), "mouse");
        search_results.set ("%s → %s → %s".printf (display_name, _("Mouse"), _("Natural Scrolling")), "mouse");

        search_results.set ("%s → %s".printf (display_name, _("Pointing")), "pointing");
        search_results.set ("%s → %s".printf (display_name, _("Pointer Size")), "pointing");
        search_results.set ("%s → %s".printf (display_name, _("Reveal Pointer")), "pointing");
        search_results.set ("%s → %s".printf (display_name, _("Control Pointer Using Keypad")), "pointing");

        search_results.set ("%s → %s".printf (display_name, _("Touchpad")), "touchpad");
        search_results.set ("%s → %s → %s".printf (display_name, _("Touchpad"), _("Pointer Speed")), "touchpad");
        search_results.set ("%s → %s → %s".printf (display_name, _("Touchpad"), _("Tap to click")), "touchpad");
        search_results.set ("%s → %s → %s".printf (display_name, _("Touchpad"), _("Double-tap and move to drag")), "touchpad");
        search_results.set ("%s → %s → %s".printf (display_name, _("Touchpad"), _("Physical Secondary Clicking")), "touchpad");
        search_results.set ("%s → %s → %s".printf (display_name, _("Touchpad"), _("Scroll Method")), "touchpad");
        search_results.set ("%s → %s → %s".printf (display_name, _("Touchpad"), _("Natural Scrolling")), "touchpad");
        search_results.set ("%s → %s → %s".printf (display_name, _("Touchpad"), _("Ignore while typing")), "touchpad");
        search_results.set ("%s → %s → %s".printf (display_name, _("Touchpad"), _("Ignore when mouse is connected")), "touchpad");

        if (show_gestures_view) {
            search_results.set ("%s → %s".printf (display_name, _("Gestures")), "gestures");
            search_results.set ("%s → %s → %s".printf (display_name, _("Gestures"), _("Multitasking View")), "gestures");
            search_results.set ("%s → %s → %s".printf (display_name, _("Gestures"), _("Switch Workspaces")), "gestures");
            search_results.set ("%s → %s → %s".printf (display_name, _("Gestures"), _("Maximize Window")), "gestures");
        }

        return search_results;
    }
}

public Switchboard.Plug get_plug (Module module) {
    debug ("Activating Mouse-Touchpad plug");

    var plug = new MouseTouchpad.Plug ();

    return plug;
}
