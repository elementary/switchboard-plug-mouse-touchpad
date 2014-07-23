namespace MouseTouchpad {
	public class MousePage : AbstractPage {
        // Pointer speed variables
        Gtk.Label pointer_speed_label;
        Gtk.Label acceleration_label;
        Gtk.Label acceleration_slow_label;
        Gtk.Label acceleration_fast_label;
        Gtk.Scale acceleration_scale;
        Gtk.Label sensitivity_label;
        Gtk.Label sensitivity_low_label;
        Gtk.Label sensitivity_high_label;
        Gtk.Scale sensitivity_scale;

        private MouseSettings mouse_settings;

		public MousePage () {
			mouse_settings = new MouseSettings ();
            // Pointer speed
            pointer_speed_label     = new Gtk.Label (_("<b>Pointer Speed:</b>"));
            acceleration_label      = new Gtk.Label (_("Acceleration:"));
            acceleration_slow_label = new Gtk.Label(_("<i>Slow</i>"));
            acceleration_fast_label = new Gtk.Label(_("<i>Fast</i>"));
            sensitivity_label       = new Gtk.Label (_("Sensitivity:"));
            sensitivity_low_label   = new Gtk.Label(_("<i>Low</i>"));
            sensitivity_high_label  = new Gtk.Label(_("<i>High</i>"));
            acceleration_scale      = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 1, 10, 1);
            sensitivity_scale       = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 1, 10, 1);

            setup_widgets ();
            setup_signals ();

            // Attach widgets
            // Pointer speed
            this.attach (pointer_speed_label,     0, 0, 1, 1);
            this.attach (acceleration_label,      0, 1, 1, 1);
            this.attach (acceleration_slow_label, 1, 1, 1, 1);
            this.attach (acceleration_scale,      2, 1, 3, 1);
            this.attach (acceleration_fast_label, 6, 1, 1, 1);
            this.attach (sensitivity_label,       0, 2, 1, 1);
            this.attach (sensitivity_low_label,   1, 2, 1, 1);
            this.attach (sensitivity_scale,       2, 2, 3, 1);
            this.attach (sensitivity_high_label,  6, 2, 1, 1);
		}

		public override void reset () {

		}

		private void setup_widgets () {
            this.row_spacing        = 12;
            this.column_spacing     = 12;
            this.margin_top         = 12;
            this.margin_bottom      = 12;
            this.column_homogeneous = false;
            this.row_homogeneous    = false;

            // Pointer speed
            pointer_speed_label.halign         = Gtk.Align.START;
            acceleration_label.halign          = Gtk.Align.END;
            sensitivity_label.halign           = Gtk.Align.END;
            pointer_speed_label.use_markup     = true;
            acceleration_fast_label.use_markup = true;
            acceleration_slow_label.use_markup = true;
            sensitivity_high_label.use_markup  = true;
            sensitivity_low_label.use_markup   = true;
            acceleration_scale.draw_value      = false;
            sensitivity_scale.draw_value       = false;
            acceleration_scale.hexpand         = true;
            sensitivity_scale.hexpand          = true;
            acceleration_scale.set_value (mouse_settings.motion_acceleration);
            sensitivity_scale.set_value  (mouse_settings.motion_threshold);

		}

		private void setup_signals () {
            // Pointer Speed
            acceleration_scale.value_changed.connect (() => {
                mouse_settings.motion_acceleration = acceleration_scale.adjustment.value;
            });

            sensitivity_scale.value_changed.connect (() => {
                mouse_settings.motion_threshold = (int) sensitivity_scale.adjustment.value;
            });

            mouse_settings.changed["motion-acceleration"].connect (() => {
                acceleration_scale.adjustment.value = mouse_settings.motion_acceleration;
            });

            mouse_settings.changed["motion-threshold"].connect (() => {
                sensitivity_scale.adjustment.value = mouse_settings.motion_threshold;
            });
		}
	}
}