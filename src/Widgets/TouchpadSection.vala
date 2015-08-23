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

public class MouseTouchpad.Widgets.TouchpadSection : Section {
    private Backend.TouchpadSettings touchpad_settings;

    private Gtk.Switch disable_while_typing_switch;
    private Gtk.Switch tap_to_click_switch;
    private Gtk.Scale pointer_speed_scale;
    private Gtk.ComboBoxText scrolling_combobox;
    private Gtk.Switch horizontal_scrolling_switch;
    private Gtk.Switch natural_scrolling_switch;

    public TouchpadSection (Backend.TouchpadSettings touchpad_settings) {
        base (_("Touchpad"));

        this.touchpad_settings = touchpad_settings;

        build_ui ();
        create_bindings ();
    }

    private void build_ui () {
        disable_while_typing_switch = new Gtk.Switch ();
        disable_while_typing_switch.halign = Gtk.Align.START;

        tap_to_click_switch = new Gtk.Switch ();
        tap_to_click_switch.halign = Gtk.Align.START;

        pointer_speed_scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 1, 10, 1);
        pointer_speed_scale.digits = 2;
        pointer_speed_scale.draw_value = false;
        pointer_speed_scale.set_size_request (160, -1);

        scrolling_combobox = new Gtk.ComboBoxText ();
        scrolling_combobox.append ("two-finger-scrolling", _("Two-finger"));
        scrolling_combobox.append ("edge-scrolling", _("Edge"));
        scrolling_combobox.append ("disabled", _("Disabled"));

        horizontal_scrolling_switch = new Gtk.Switch ();
        horizontal_scrolling_switch.halign = Gtk.Align.START;

        natural_scrolling_switch = new Gtk.Switch ();
        natural_scrolling_switch.halign = Gtk.Align.START;

        this.add_entry (_("Disable while typing:"), disable_while_typing_switch);
        this.add_entry (_("Tap to click:"), tap_to_click_switch);
        this.add_entry (_("Pointer speed:"), pointer_speed_scale);
        this.add_entry (_("Scrolling:"), scrolling_combobox);
        this.add_entry (_("Horizontal scrolling:"), horizontal_scrolling_switch);
        this.add_entry (_("Natural scrolling:"), natural_scrolling_switch);
    }

    private void create_bindings () {
        touchpad_settings.bind_property ("disable-while-typing",
                                         disable_while_typing_switch,
                                         "state",
                                         BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);

        touchpad_settings.bind_property ("tap-to-click",
                                         tap_to_click_switch,
                                         "state",
                                         BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);

        touchpad_settings.bind_property ("motion-acceleration",
                                         pointer_speed_scale.adjustment,
                                         "value",
                                         BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);

        pointer_speed_scale.adjustment.bind_property ("value",
                                                      touchpad_settings,
                                                      "motion-threshold",
                                                      BindingFlags.SYNC_CREATE,
                                                      pointer_speed_scale_transform_func);

        touchpad_settings.bind_property ("scroll-method",
                                         scrolling_combobox,
                                         "active-id",
                                         BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);

        touchpad_settings.bind_property ("horiz-scroll-enabled",
                                         horizontal_scrolling_switch,
                                         "state",
                                         BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);

        touchpad_settings.bind_property ("natural-scroll",
                                         natural_scrolling_switch,
                                         "state",
                                         BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);
    }

    private bool pointer_speed_scale_transform_func (Binding binding, Value source_value, ref Value target_value) {
        int val = 11 - (int)source_value.get_double ();
        target_value.set_int (val);

        return true;
    }
}