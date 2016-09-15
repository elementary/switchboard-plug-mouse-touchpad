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

public class MouseTouchpad.Widgets.GeneralSection : Gtk.Grid {
    private Backend.MouseSettings mouse_settings;
    private Backend.DaemonSettings daemon_settings;

    private Granite.Widgets.ModeButton primary_button_switcher;
    private Gtk.Switch reveal_pointer_switch;

    public GeneralSection (Backend.MouseSettings mouse_settings, Backend.DaemonSettings daemon_settings) {
        this.mouse_settings = mouse_settings;
        this.daemon_settings = daemon_settings;

        create_bindings ();
    }

    construct {
        var title_label = new Gtk.Label (_("General"));
        title_label.halign = Gtk.Align.START;
        title_label.get_style_context ().add_class ("h4");

        primary_button_switcher = new Granite.Widgets.ModeButton ();
        primary_button_switcher.append_text (_("Left"));
        primary_button_switcher.append_text (_("Right"));

        reveal_pointer_switch = new Gtk.Switch ();
        reveal_pointer_switch.halign = Gtk.Align.START;
        reveal_pointer_switch.margin_end = 8;     

        var help_icon = new Gtk.Image.from_icon_name ("help-info-symbolic", Gtk.IconSize.BUTTON);
        help_icon.tooltip_text = _("Pressing the control key will highlight the position of the pointer");

        var reveal_pointer_grid = new Gtk.Grid ();
        reveal_pointer_grid.column_spacing = 12;
        reveal_pointer_grid.add (reveal_pointer_switch);
        reveal_pointer_grid.add (help_icon);

        row_spacing = 12;
        column_spacing = 12;
        column_homogeneous = true;

        attach (title_label, 0, 0, 1, 1);
        attach (new SettingLabel (_("Primary Button:")), 0, 1, 1, 1);
        attach (primary_button_switcher, 1, 1, 2, 1);
        attach (new SettingLabel (_("Reveal pointer:")), 0, 2, 1, 1);
        attach (reveal_pointer_grid, 1, 2, 1, 1);
    }

    private void create_bindings () {
        mouse_settings.bind_property ("left-handed",
                                      primary_button_switcher,
                                      "selected",
                                      BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);

        daemon_settings.bind_property ("locate-pointer",
                                      reveal_pointer_switch,
                                      "state",
                                      BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);
    }
}
