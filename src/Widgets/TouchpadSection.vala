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

public class MouseTouchpad.Widgets.TouchpadSection : Gtk.Grid {
    private Gtk.Switch click_method_switch;

    public Backend.TouchpadSettings touchpad_settings { get; construct; }
    public Backend.TouchpadGestures touchpad_gestures;

    public TouchpadSection (Backend.TouchpadSettings touchpad_settings) {
        Object (touchpad_settings: touchpad_settings);
    }

    construct {
        touchpad_gestures = new Backend.TouchpadGestures ();

        var title_label = new Gtk.Label (_("Touchpad"));
        title_label.xalign = 0;
        title_label.hexpand = true;
        title_label.get_style_context ().add_class ("h4");
        Plug.start_size_group.add_widget (title_label);

        var gestures_label = new Gtk.Label (_("Touchpad Gestures"));
        gestures_label.xalign = 0;
        gestures_label.hexpand = true;
        gestures_label.get_style_context ().add_class ("h4");
        Plug.start_size_group.add_widget (gestures_label);

        var disable_while_typing_switch = new Gtk.Switch ();
        disable_while_typing_switch.halign = Gtk.Align.START;

        var tap_to_click_switch = new Gtk.Switch ();
        tap_to_click_switch.halign = Gtk.Align.START;

        click_method_switch = new Gtk.Switch ();
        click_method_switch.halign = Gtk.Align.START;
        click_method_switch.valign = Gtk.Align.CENTER;

        if (touchpad_settings.click_method == "none") {
            click_method_switch.active = false;
        } else {
            click_method_switch.active = true;
        }

        var click_method_combobox = new Gtk.ComboBoxText ();
        click_method_combobox.hexpand = true;
        click_method_combobox.append ("default", _("Hardware default"));
        click_method_combobox.append ("fingers", _("Multitouch"));
        click_method_combobox.append ("areas", _("Touchpad areas"));

        if (click_method_combobox.active_id == null ) {
            click_method_combobox.active_id = "default";
        }

        var pointer_speed_scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, -1, 1, 0.1);
        pointer_speed_scale.adjustment.value = touchpad_settings.speed;
        pointer_speed_scale.digits = 2;
        pointer_speed_scale.draw_value = false;
        pointer_speed_scale.add_mark (0, Gtk.PositionType.BOTTOM, null);
        Plug.end_size_group.add_widget (pointer_speed_scale);

        var scrolling_combobox = new Gtk.ComboBoxText ();
        scrolling_combobox.append ("two-finger-scrolling", _("Two-finger"));
        scrolling_combobox.append ("edge-scrolling", _("Edge"));
        scrolling_combobox.append ("disabled", _("Disabled"));

        var horizontal_scrolling_switch = new Gtk.Switch ();
        horizontal_scrolling_switch.halign = Gtk.Align.START;

        var natural_scrolling_switch = new Gtk.Switch ();
        natural_scrolling_switch.halign = Gtk.Align.START;


        var enable_gestures = new Gtk.Switch ();
        enable_gestures.halign = Gtk.Align.START;

        var swipe_right = new Gtk.ComboBoxText ();
        swipe_right.append ("super+Left", _("⌘+Left"));
        swipe_right.append ("super+Right", _("⌘+Right"));

        if (swipe_right.active_id == null ) {
            swipe_right.active_id = touchpad_gestures.getCurrentCommand("swipe right");
        }

        var swipe_left = new Gtk.ComboBoxText ();
        swipe_left.append ("super+Right", _("⌘+Right"));
        swipe_left.append ("super+Left", _("⌘+Left"));

        if (swipe_left.active_id == null ) {
            swipe_left.active_id = touchpad_gestures.getCurrentCommand("swipe left");
        }

        var swipe_up = new Gtk.ComboBoxText ();
        swipe_up.append ("super+Down", _("⌘+Down"));
        swipe_up.append ("super+Up", _("⌘+Up"));

        if (swipe_up.active_id == null ) {
            swipe_up.active_id = touchpad_gestures.getCurrentCommand("swipe up");
        }

        var swipe_down = new Gtk.ComboBoxText ();
        swipe_down.append ("super+Up", _("⌘+Up"));
        swipe_down.append ("super+Down", _("⌘+Down"));

        if (swipe_down.active_id == null ) {
            swipe_down.active_id = touchpad_gestures.getCurrentCommand("swipe down");
        }

        row_spacing = 12;
        column_spacing = 12;

        attach (title_label, 0, 0, 1, 1);
        attach (new SettingLabel (_("Pointer speed:")), 0, 1, 1, 1);
        attach (pointer_speed_scale, 1, 1, 2, 1);
        attach (new SettingLabel (_("Tap to click:")), 0, 2, 1, 1);
        attach (tap_to_click_switch, 1, 2, 1, 1);
        attach (new SettingLabel (_("Physical clicking:")), 0, 3, 1, 1);
        attach (click_method_switch, 1, 3, 1, 1);
        attach (click_method_combobox, 2, 3, 1, 1);
        attach (new SettingLabel (_("Scrolling:")), 0, 4, 1, 1);
        attach (scrolling_combobox, 1, 4, 2, 1);
        attach (new SettingLabel (_("Natural scrolling:")), 0, 5, 1, 1);
        attach (natural_scrolling_switch, 1, 5, 1, 1);
        attach (new SettingLabel (_("Disable while typing:")), 0, 6, 1, 1);
        attach (disable_while_typing_switch, 1, 6, 1, 1);
        attach (gestures_label, 0, 7, 1, 1);
        attach (new SettingLabel (_("Enable Gestures:")), 0, 8, 1, 1);
        attach (enable_gestures, 1, 8, 1, 1);
        attach (new SettingLabel (_("Swipe Right:")), 0, 9, 1, 1);
        attach (swipe_right, 1, 9, 1, 1);
        attach (new SettingLabel (_("Swipe Left:")), 0, 10, 1, 1);
        attach (swipe_left, 1, 10, 1, 1);
        attach (new SettingLabel (_("Swipe Up:")), 0, 11, 1, 1);
        attach (swipe_up, 1, 11, 1, 1);
        attach (new SettingLabel (_("Swipe Down:")), 0, 12, 1, 1);
        attach (swipe_down, 1, 12, 1, 1);

        click_method_switch.bind_property ("active", click_method_combobox, "sensitive", BindingFlags.SYNC_CREATE);

        click_method_switch.notify["active"].connect (() => {
            if (click_method_switch.active) {
                touchpad_settings.click_method = click_method_combobox.active_id;
            } else {
                touchpad_settings.click_method = "none";
            }
        });

        var glib_settings = new GLib.Settings ("org.gnome.desktop.peripherals.touchpad");

        if (!glib_settings.get_boolean ("edge-scrolling-enabled") && !glib_settings.get_boolean ("two-finger-scrolling-enabled")) {
            scrolling_combobox.active_id = "disabled";
        } else if (glib_settings.get_boolean ("two-finger-scrolling-enabled")) {
            scrolling_combobox.active_id = "two-finger-scrolling";
        } else {
            scrolling_combobox.active_id = "edge-scrolling";
        }

        scrolling_combobox.changed.connect (() => {
            string active_text = scrolling_combobox.get_active_id ();

            switch (active_text) {
                case "disabled":
                    glib_settings.set_boolean ("edge-scrolling-enabled", false);
                    glib_settings.set_boolean ("two-finger-scrolling-enabled", false);
                    break;
                case "two-finger-scrolling":
                    glib_settings.set_boolean ("edge-scrolling-enabled", false);
                    glib_settings.set_boolean ("two-finger-scrolling-enabled", true);
                    break;
                case "edge-scrolling":
                    glib_settings.set_boolean ("edge-scrolling-enabled", true);
                    glib_settings.set_boolean ("two-finger-scrolling-enabled", false);
                    break;
            }

            horizontal_scrolling_switch.sensitive = active_text != "disabled";
            natural_scrolling_switch.sensitive = active_text != "disabled";
        });

        enable_gestures.notify["active"].connect (() => {
            if (enable_gestures.active) {
                touchpad_gestures.enableGestures ();
            } else {
                touchpad_gestures.disableGestures ();
            }
        });

        swipe_right.changed.connect (() => {
            string active_text = swipe_right.get_active_id ();
            touchpad_gestures.changeSwipeGesture(active_text, "swipe right");
        });

        swipe_left.changed.connect (() => {
            string active_text = swipe_left.get_active_id ();
            touchpad_gestures.changeSwipeGesture(active_text, "swipe left");
        });

        swipe_up.changed.connect (() => {
            string active_text = swipe_up.get_active_id ();
            touchpad_gestures.changeSwipeGesture(active_text, "swipe up");
        });

        swipe_down.changed.connect (() => {
            string active_text = swipe_down.get_active_id ();
            touchpad_gestures.changeSwipeGesture(active_text, "swipe down");
        });


        touchpad_settings.bind_property ("tap-to-click",
                                         tap_to_click_switch,
                                         "state",
                                         BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);

        touchpad_settings.bind_property ("click-method",
                                         click_method_combobox,
                                         "active-id",
                                         BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE,
                                         click_method_transform_func);

        pointer_speed_scale.adjustment.bind_property ("value",
                                                      touchpad_settings,
                                                      "speed",
                                                      BindingFlags.SYNC_CREATE,
                                                      pointer_speed_scale_transform_func);

        touchpad_settings.bind_property ("natural-scroll",
                                         natural_scrolling_switch,
                                         "state",
                                         BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);

        touchpad_settings.bind_property ("disable-while-typing",
                                         disable_while_typing_switch,
                                         "state",
                                         BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);
    }

    private bool click_method_transform_func (Binding binding, Value source_value, ref Value target_value) {
        if (touchpad_settings.click_method == "none") {
            return false;
        }

        target_value = source_value;
        return true;
    }

    private bool pointer_speed_scale_transform_func (Binding binding, Value source_value, ref Value target_value) {
        double val = source_value.get_double ();
        target_value.set_double (val);

        return true;
    }

}
