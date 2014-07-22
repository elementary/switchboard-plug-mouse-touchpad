namespace MouseTouchpad {
	class MouseSettings : Granite.Services.Settings {
		public double motion_acceleration { get; set; }
		public int motion_threshold       { get; set; }

		public MouseSettings () {
			base ("org.gnome.settings-daemon.peripherals.mouse");
		}

		public void reset_all () {
			schema.reset ("motion-acceleration");
			schema.reset ("motion-threshold");
		}
	}
}