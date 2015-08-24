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

public class MouseTouchpad.Widgets.GeneralSection : Section {
    private Backend.MouseSettings mouse_settings;

    private Granite.Widgets.ModeButton primary_button_switcher;
    private Gtk.Switch reveal_pointer_switch;

    public GeneralSection (Backend.MouseSettings mouse_settings) {
        base (_("General"));

        this.mouse_settings = mouse_settings;

        build_ui ();
        create_bindings ();
    }

    private void build_ui () {
        primary_button_switcher = new Granite.Widgets.ModeButton ();
        primary_button_switcher.append_text (_("Left"));
        primary_button_switcher.append_text (_("Right"));

        reveal_pointer_switch = new Gtk.Switch ();
        reveal_pointer_switch.halign = Gtk.Align.START;

        this.add_entry (_("Primary Button:"), primary_button_switcher);
        this.add_entry (_("Reveal pointer:"), reveal_pointer_switch, _("Pressing the control key will highlight the position of the pointer"));
    }

    private void create_bindings () {
        mouse_settings.bind_property ("left-handed",
                                      primary_button_switcher,
                                      "selected",
                                      BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);

        mouse_settings.bind_property ("locate-pointer",
                                      reveal_pointer_switch,
                                      "state",
                                      BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);
    }
}