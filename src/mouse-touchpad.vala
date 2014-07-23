namespace MouseTouchpad {
    public class Plug : Switchboard.Plug {
        // Main layout variables
        Gtk.Grid          main_grid;
        Gtk.Grid          separator_grid;
        Gtk.Separator     left_separator;
        Gtk.Separator     right_separator;
        Gtk.Stack         pages;
        Gtk.StackSwitcher page_switcher;

        // General settings variables
        Gtk.Label       general_settings_label;
        Gtk.ButtonBox   handed_buttons;
        Gtk.RadioButton left_handed_button;
        Gtk.RadioButton right_handed_button;
        Gtk.Grid        pointer_reveal_grid;
        Gtk.CheckButton pointer_reveal_check;

        // Settings
        MouseSettings mouse_settings;

        public Plug () {
            Object (category: Category.HARDWARE,
                    code_name: "hardware-pantheon-mouse-touchpad",
                    display_name: _("Mouse & Touchpad"),
                    description: _("Set your mouse and touchpad preferences"),
                    icon: "preferences-desktop-peripherals");

            mouse_settings = new MouseSettings ();
        }

        public override Gtk.Widget get_widget () {
            if (main_grid == null) {
                // Initialize variables
                // Main
                main_grid      = new Gtk.Grid ();
                separator_grid = new Gtk.Grid ();
                pages          = new Gtk.Stack ();
                page_switcher  = new Gtk.StackSwitcher ();
                // General
                general_settings_label = new Gtk.Label (_("<b>General:</b>"));
                handed_buttons         = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
                left_handed_button     = new Gtk.RadioButton.with_label (null, _("Left-handed"));
                right_handed_button    = new Gtk.RadioButton.with_label (left_handed_button.get_group(), 
                                                                         _("Right-handed"));
                pointer_reveal_grid    = new Gtk.Grid ();
                pointer_reveal_check   = new Gtk.CheckButton.with_label (_("Pointer Reveal"));
                left_separator         = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
                right_separator        = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);

                setup_widgets ();
                setup_signals ();

                // Attach
                // General
                handed_buttons.add (left_handed_button);
                handed_buttons.add (right_handed_button);
                pointer_reveal_grid.attach (pointer_reveal_check, 0, 0, 1, 1);
                // Separator
                separator_grid.add (left_separator);
                separator_grid.add (page_switcher);
                separator_grid.add (right_separator);
                // Main
                main_grid.attach (general_settings_label, 0, 0, 1, 1);
                main_grid.attach (pointer_reveal_grid,    0, 1, 1, 1);
                main_grid.attach (handed_buttons,         0, 2, 1, 1);
                main_grid.attach (separator_grid,         0, 4, 1, 1);
                main_grid.attach (pages,                  0, 5, 1, 1);
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
            // Grid
            main_grid.margin      = 12;
            main_grid.row_spacing = 12;

            separator_grid.hexpand = true;
            left_separator.hexpand = true;
            right_separator.hexpand = true;

            // Pages
            page_switcher.set_stack(pages);
            page_switcher.halign = Gtk.Align.CENTER;
            pages.add_titled (new MousePage (), "mouse", _("Mouse"));
            pages.add_titled (new TouchpadPage (), "touchpad", _("Touchpad"));

            // General
            general_settings_label.use_markup  = true;
            general_settings_label.halign      = Gtk.Align.START;
            handed_buttons.layout_style        = Gtk.ButtonBoxStyle.START;
            handed_buttons.margin_start        = 12;
            pointer_reveal_grid.margin_start   = 12;
            pointer_reveal_grid.column_spacing = 12;

            left_handed_button.active  = mouse_settings.left_handed;
            right_handed_button.active = !mouse_settings.left_handed;
        }

        private void setup_signals () {
            mouse_settings.changed["left-handed"].connect (() => {
                left_handed_button.active  = mouse_settings.left_handed;
                right_handed_button.active = !mouse_settings.left_handed;
            });

            mouse_settings.changed["locate-pointer"].connect (() => {
                pointer_reveal_check.active = mouse_settings.locate_pointer;
            });

            left_handed_button.notify["active"].connect (() => {
                mouse_settings.left_handed = left_handed_button.active;
            });

            pointer_reveal_check.notify["active"].connect (() => {
                mouse_settings.locate_pointer = pointer_reveal_check.active;
            });
        }
    }
}

public Switchboard.Plug get_plug (Module module) {
    debug ("Activating Mouse-Touchpad plug");
    var plug = new MouseTouchpad.Plug ();
    return plug;
}