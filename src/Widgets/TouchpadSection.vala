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
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

public class MouseTouchpad.Widgets.TouchpadSection : Section {
    private Backend.TouchpadSettings touchpad_settings;

    private Gtk.Switch disable_while_typing_switch;
    private Gtk.Switch tap_to_click_switch;
    private Gtk.ComboBoxText click_method_combobox;
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

        click_method_combobox = new Gtk.ComboBoxText ();
        click_method_combobox.append ("default", _("Hardware default"));
        click_method_combobox.append ("fingers", _("Multitouch"));
        click_method_combobox.append ("areas", _("Touchpad areas"));
        click_method_combobox.append ("none", _("No secondary clicking"));

        pointer_speed_scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, -1, 1, 0.1);
        pointer_speed_scale.adjustment.value = touchpad_settings.speed;
        pointer_speed_scale.digits = 2;
        pointer_speed_scale.draw_value = false;
        pointer_speed_scale.add_mark (0, Gtk.PositionType.TOP, null);

        scrolling_combobox = new Gtk.ComboBoxText ();
        scrolling_combobox.append ("two-finger-scrolling", _("Two-finger"));
        scrolling_combobox.append ("edge-scrolling", _("Edge"));
        scrolling_combobox.append ("disabled", _("Disabled"));

        horizontal_scrolling_switch = new Gtk.Switch ();
        horizontal_scrolling_switch.halign = Gtk.Align.START;

        natural_scrolling_switch = new Gtk.Switch ();
        natural_scrolling_switch.halign = Gtk.Align.START;

        add_entry (_("Pointer speed:"), pointer_speed_scale);
        add_entry (_("Tap to click:"), tap_to_click_switch);
        add_entry (_("Physical clicking:"), click_method_combobox);
        add_entry (_("Scrolling:"), scrolling_combobox);
        add_entry (_("Natural scrolling:"), natural_scrolling_switch);
    }

    private void create_bindings () {
        touchpad_settings.bind_property ("scroll-method",
                                         scrolling_combobox,
                                         "active-id",
                                         BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);

        touchpad_settings.bind_property ("tap-to-click",
                                         tap_to_click_switch,
                                         "state",
                                         BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);

        touchpad_settings.bind_property ("click-method",
                                         click_method_combobox,
                                         "active-id",
                                         BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);

        pointer_speed_scale.adjustment.bind_property ("value",
                                                      touchpad_settings,
                                                      "speed",
                                                      BindingFlags.SYNC_CREATE,
                                                      pointer_speed_scale_transform_func);

        touchpad_settings.bind_property ("natural-scroll",
                                         natural_scrolling_switch,
                                         "state",
                                         BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);
    }

    private bool pointer_speed_scale_transform_func (Binding binding, Value source_value, ref Value target_value) {
        double val = source_value.get_double ();
        target_value.set_double (val);

        return true;
    }
}
