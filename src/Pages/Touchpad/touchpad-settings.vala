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
	class TouchpadSettings : Granite.Services.Settings {
		public static string SCROLL_METHOD_DISABLED   = "disabled";
		public static string SCROLL_METHOD_EDGE       = "edge-scrolling";
		public static string SCROLL_METHOD_TWO_FINGER = "two-finger-scrolling";

		public bool   natural_scroll       { get; set; }
		public bool   horiz_scroll_enabled { get; set; }
		public bool   tap_to_click         { get; set; }
		public bool   disable_while_typing { get; set; }
		public double motion_acceleration  { get; set; }
		public int    motion_threshold     { get; set; }
		public string scroll_method        { get; set; }

		public TouchpadSettings () {
			base ("org.gnome.settings-daemon.peripherals.touchpad");
		}

		// public void reset_all () {
		// 	schema.reset ("natural-scroll");
		// 	schema.reset ("horiz_scroll-enabled");
		// 	schema.reset ("tab-to-click");
		// 	schema.reset ("disable_while_typeing");
		// 	schema.reset ("motion_acceleration");
		// 	schema.reset ("motion_threshold");
		// 	schema.reset ("scroll_method");
		// }
	}
}