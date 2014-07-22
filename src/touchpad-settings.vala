namespace MouseTouchpad {
	class TouchpadSettings : Granite.Services.Settings {
		public bool natural_scroll       { get; set; }
		public bool horiz_scroll_enabled { get; set; }

		public TouchpadSettings () {
			base ("org.gnome.settings-daemon.peripherals.touchpad");
		}

		public void reset_all () {
			
		}
	}
}