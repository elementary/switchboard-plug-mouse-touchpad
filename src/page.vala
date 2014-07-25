/***
  Copyright (C) 2014 Keith Gonyon <kgonyon@gmail.com>
  This program is free software: you can redistribute it and/or modify it
  under the terms of the GNU Lesser General Public License version 3, as published
  by the Free Software Foundation.
  This program is distributed in the hope that it will be useful, but
  WITHOUT ANY WARRANTY; without even the implied warranties of
  MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
  PURPOSE. See the GNU General Public License for more details.
  You should have received a copy of the GNU General Public License along
  with this program. If not, see 
***/
namespace MouseTouchpad {
	public abstract class AbstractPage : Gtk.Grid {
		public AbstractPage () {

            this.row_spacing        = 24;
            this.column_spacing     = 12;
            this.margin_top         = 12;
            this.margin_bottom      = 12;
            this.column_homogeneous = true;
            this.row_homogeneous    = false;
		}

		public abstract void reset ();
	}
}