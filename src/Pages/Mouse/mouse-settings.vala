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
	class MouseSettings : Granite.Services.Settings {
		public double motion_acceleration { get; set; }
		public int motion_threshold       { get; set; }
		public bool left_handed           { get; set; }
		public bool locate_pointer        { get; set; }

		public MouseSettings () {
			base ("org.gnome.settings-daemon.peripherals.mouse");
		}

		public void reset_all () {
			schema.reset ("motion-acceleration");
			schema.reset ("motion-threshold");
			schema.reset ("left-handed");
			schema.reset ("locate-pointer");
		}
	}
}