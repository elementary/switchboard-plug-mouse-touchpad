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

public class MouseTouchpad.Widgets.Section : Gtk.Grid {
    private Gtk.Label title_label;

    private int row_count = 0;

    public Section (string title) {
        build_ui (title);
    }

    public void add_entry (string option, Gtk.Widget widget, string description = "") {
        int row = row_count++;

        Gtk.Label option_label = new Gtk.Label (option);
        option_label.halign = Gtk.Align.END;

        this.attach (option_label, 0, row, 1, 1);

        if (description == "") {
            this.attach (widget, 1, row, 1, 1);
        } else {
            Gtk.Box widget_container = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            widget_container.hexpand = false;

            Gtk.Image help_icon = new Gtk.Image.from_icon_name ("help-info-symbolic", Gtk.IconSize.BUTTON);
            help_icon.tooltip_text = description;

            widget_container.add (widget);
            widget_container.add (help_icon);

            this.attach (widget_container, 1, row, 1, 1);
        }
    }

    private void build_ui (string title) {
        this.row_spacing = 12;
        this.column_spacing = 12;
        this.column_homogeneous = true;

        title_label = new Gtk.Label (title);
        title_label.halign = Gtk.Align.START;
        title_label.get_style_context ().add_class ("h4");

        this.attach (title_label, 0, row_count++, 2, 1);
    }
}