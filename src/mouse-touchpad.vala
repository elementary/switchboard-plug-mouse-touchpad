namespace MouseTouchpad {
    public class Plug : Switchboard.Plug {
        // Main layout variables
        Gtk.Grid          main_grid;
        Gtk.Grid          left_grid;
        Gtk.Grid          right_grid;
        Gtk.Stack         pages;
        Gtk.StackSwitcher page_switcher;

        // Scrolling variables
        Gtk.Label  scrolling_label;
        Gtk.Label  natural_scrolling_label;
        Gtk.Switch natural_scrolling_switch;
        Gtk.Label  horizontal_scrolling_label;
        Gtk.Switch horizontal_scrolling_switch;

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

        private MouseSettings    mouse_settings;
        private TouchpadSettings touchpad_settings;

        public Plug () {
            Object (category: Category.HARDWARE,
                    code_name: "hardware-pantheon-mouse-touchpad",
                    display_name: _("Mouse and Touchpad"),
                    description: _("Set your mouse and touchpad preferences"),
                    icon: "preferences-desktop-peripherals");

            mouse_settings = new MouseSettings ();
            touchpad_settings = new TouchpadSettings ();
        }

        public override Gtk.Widget get_widget () {
            if (main_grid == null) {
                // Initialize variables
                main_grid     = new Gtk.Grid ();
                pages         = new Gtk.Stack ();
                page_switcher = new Gtk.StackSwitcher ();
                left_grid     = new Gtk.Grid ();
                right_grid    = new Gtk.Grid ();
                // Scrolling
                scrolling_label             = new Gtk.Label (_("<b>Scrolling:</b>"));
                natural_scrolling_label     = new Gtk.Label (_("Natural Scrolling (move content, not view):"));
                horizontal_scrolling_label  = new Gtk.Label (_("Horizontal Scrolling:"));
                natural_scrolling_switch    = new Gtk.Switch ();
                horizontal_scrolling_switch = new Gtk.Switch ();
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
                // Scrolling
                left_grid.attach (scrolling_label,             0, 0, 1, 1);
                left_grid.attach (natural_scrolling_label,     0, 1, 1, 1);
                left_grid.attach (natural_scrolling_switch,    1, 1, 1, 1);
                left_grid.attach (horizontal_scrolling_label,  0, 2, 1, 1);
                left_grid.attach (horizontal_scrolling_switch, 1, 2, 1, 1);
                // Pointer speed
                right_grid.attach (pointer_speed_label,     0, 0, 1, 1);
                right_grid.attach (acceleration_label,      0, 1, 1, 1);
                right_grid.attach (acceleration_slow_label, 1, 1, 1, 1);
                right_grid.attach (acceleration_scale,      2, 1, 4, 1);
                right_grid.attach (acceleration_fast_label, 6, 1, 1, 1);
                right_grid.attach (sensitivity_label,       0, 2, 1, 1);
                right_grid.attach (sensitivity_low_label,   1, 2, 1, 1);
                right_grid.attach (sensitivity_scale,       2, 2, 4, 1);
                right_grid.attach (sensitivity_high_label,  6, 2, 1, 1);
                // Main
                main_grid.attach (left_grid,  0, 0, 1, 1);
                main_grid.attach (right_grid, 1, 0, 1, 1);
                // main_grid.attach (page_switcher, 0, 1, 1, 1);
                // main_grid.attach (pages, 0, 2, 1, 1);
            }

            main_grid.show_all ();
            return main_grid;
        }

        public override void shown () {
            
        }

        public override void hidden () {
            
        }

        public override void search_callback (string location) {
            
        }

        // 'search' returns results like ("Keyboard → Behavior → Duration", "keyboard<sep>behavior")
        public override async Gee.TreeMap<string, string> search (string search) {
            return new Gee.TreeMap<string, string> (null, null);
        }

        private void setup_widgets () {
            // Grids
            main_grid.row_spacing        = 12;
            main_grid.column_spacing     = 48;
            main_grid.margin             = 12;
            main_grid.column_homogeneous = false;
            main_grid.row_homogeneous    = false;

            left_grid.row_spacing        = 12;
            left_grid.column_spacing     = 6;
            left_grid.margin_top         = 12;
            left_grid.margin_bottom      = 12;
            left_grid.column_homogeneous = false;
            left_grid.row_homogeneous    = false;

            right_grid.row_spacing        = 16;
            right_grid.column_spacing     = 6;
            right_grid.margin_top         = 12;
            right_grid.margin_bottom      = 12;
            right_grid.column_homogeneous = false;
            right_grid.row_homogeneous    = false;

            // Scrolling
            scrolling_label.halign             = Gtk.Align.START;
            natural_scrolling_label.halign     = Gtk.Align.END;
            horizontal_scrolling_label.halign  = Gtk.Align.END;
            scrolling_label.use_markup         = true;
            natural_scrolling_switch.active    = touchpad_settings.natural_scroll;
            horizontal_scrolling_switch.active = touchpad_settings.horiz_scroll_enabled;

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

            // page_switcher.set_stack(pages);
            // page_switcher.halign = Gtk.Align.CENTER;
            // pages.add_titled(new MousePage ("Testing"), "mouse", _("Mouse"));
            // pages.add_titled(new MousePage ("Pad"), "mouse", _("Touchpad"));
            // pages.add_titled(new MousePage ("Touch"), "mouse", _("Multi-Touch"));

        }

        private void setup_signals () {
            // Scrolling
            touchpad_settings.changed["natural-scroll"].connect (() => {
                natural_scrolling_switch.active = touchpad_settings.natural_scroll;
            });

            touchpad_settings.changed["horiz-scroll-enabled"].connect (() => {
                horizontal_scrolling_switch.active = touchpad_settings.horiz_scroll_enabled;
            });

            natural_scrolling_switch.notify["active"].connect (() => {
                touchpad_settings.natural_scroll = natural_scrolling_switch.active;
            });

            horizontal_scrolling_switch.notify["active"].connect (() => {
                touchpad_settings.horiz_scroll_enabled = horizontal_scrolling_switch.active;
            });

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

public Switchboard.Plug get_plug (Module module) {
    debug ("Activating Mouse-Touchpad plug");
    var plug = new MouseTouchpad.Plug ();
    return plug;
}