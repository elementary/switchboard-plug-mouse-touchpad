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

		public void reset_all () {
			
		}
	}
}