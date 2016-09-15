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

public class MouseTouchpad.Widgets.MouseSection : Section {
    private Backend.MouseSettings mouse_settings;

    private Gtk.Scale pointer_speed_scale;
    private Gtk.Switch natural_scrolling_switch;

    public MouseSection (Backend.MouseSettings mouse_settings) {
        base (_("Mouse"));

        this.mouse_settings = mouse_settings;

        build_ui ();
        create_bindings ();
    }

    private void build_ui () {
        pointer_speed_scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, -1, 1, 0.1);
        pointer_speed_scale.adjustment.value = mouse_settings.speed;
        pointer_speed_scale.digits = 2;
        pointer_speed_scale.draw_value = false;
        pointer_speed_scale.set_size_request (160, -1);
        pointer_speed_scale.add_mark (0, Gtk.PositionType.BOTTOM, null);
        natural_scrolling_switch = new Gtk.Switch ();
        natural_scrolling_switch.halign = Gtk.Align.START;

        this.add_entry (_("Pointer speed:"), pointer_speed_scale);
        this.add_entry (_("Natural scrolling:"), natural_scrolling_switch);
    }

    private void create_bindings () {
        pointer_speed_scale.adjustment.bind_property ("value",
                                                      mouse_settings,
                                                      "speed",
                                                      BindingFlags.SYNC_CREATE,
                                                      pointer_speed_scale_transform_func);

        mouse_settings.bind_property ("natural-scroll",
                                      natural_scrolling_switch,
                                      "state",
                                      BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);
    }

    private bool pointer_speed_scale_transform_func (Binding binding, Value source_value, ref Value target_value) {
        double val = (double)source_value.get_double ();
        target_value.set_double (val);

        return true;
    }
}
