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
	public class TouchpadPage : AbstractPage {
		/* ---- Layout variables ---- */

        // Pointer Speed
        Gtk.Grid pointer_speed_grid;
        Gtk.Grid pointer_scale_grid;

        // General
        Gtk.Grid general_grid;

        // Scrolling
        Gtk.Grid scrolling_grid;
        Gtk.Grid scrolling_label_grid;

        /* ---- Widget Variables ---- */

        // Pointer speed variables
        Gtk.Label pointer_speed_label;
        Gtk.Label acceleration_slow_label;
        Gtk.Label acceleration_fast_label;
        Gtk.Scale acceleration_scale;

        // General variables
        Gtk.Label       general_label;
        Gtk.CheckButton disable_while_typing_check;
        Gtk.CheckButton tap_to_click_check;

        // Scrolling variables
        Gtk.Label       scrolling_label;
        Gtk.Switch      scrolling_switch;
        Gtk.CheckButton natural_scrolling_check;
        Gtk.CheckButton horizontal_scrolling_check;
        Gtk.CheckButton scrolling_two_finger_radio;


        private TouchpadSettings touchpad_settings;
        private string previous_scroll_method;

		public TouchpadPage () {
            touchpad_settings    = new TouchpadSettings ();
            /* ---- Init Grids ---- */

            scrolling_grid       = new Gtk.Grid ();
            scrolling_label_grid = new Gtk.Grid ();
            general_grid         = new Gtk.Grid ();
            pointer_speed_grid   = new Gtk.Grid ();
            pointer_scale_grid   = new Gtk.Grid ();

            /* ---- Init Widgets ---- */

            // Pointer speed
            pointer_speed_label     = new Gtk.Label (_("<b>Pointer Speed:</b>"));
            acceleration_slow_label = new Gtk.Label(_("<i>Slow</i>"));
            acceleration_fast_label = new Gtk.Label(_("<i>Fast</i>"));
            acceleration_scale      = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 1, 10, 1);

            //General
            general_label              = new Gtk.Label (_("<b>General:</b>"));
            disable_while_typing_check = new Gtk.CheckButton.with_label (_("Disable while typing"));
            tap_to_click_check         = new Gtk.CheckButton.with_label (_("Tap to click"));

            // Scrolling
            scrolling_label            = new Gtk.Label (_("<b>Scrolling:</b>"));
            scrolling_switch           = new Gtk.Switch ();
            natural_scrolling_check    = new Gtk.CheckButton.with_label (_("Natural scrolling"));
            horizontal_scrolling_check = new Gtk.CheckButton.with_label (_("Horizontal scrolling"));
            scrolling_two_finger_radio = new Gtk.CheckButton.with_label (_("Two finger scrolling"));

            setup_widgets ();
            setup_signals ();

            /* ---- Attach widgets ---- */

            // Pointer speed
            pointer_scale_grid.attach (acceleration_slow_label, 0, 1, 1, 1);
            pointer_scale_grid.attach (acceleration_scale,      1, 1, 3, 1);
            pointer_scale_grid.attach (acceleration_fast_label, 4, 1, 1, 1);
            pointer_speed_grid.attach (pointer_speed_label,     0, 0, 1, 1);
            pointer_speed_grid.attach (pointer_scale_grid,      0, 1, 1, 1);

            // General
            general_grid.attach(disable_while_typing_check, 0, 0, 1, 1);
            general_grid.attach(tap_to_click_check,         0, 1, 1, 1);

            // Scrolling
            scrolling_label_grid.attach (scrolling_label,      0, 0, 1, 1);
            scrolling_label_grid.attach (scrolling_switch,     1, 0, 1, 1);
            scrolling_grid.attach (natural_scrolling_check,    0, 0, 1, 1);
            scrolling_grid.attach (horizontal_scrolling_check, 0, 1, 1, 1);
            scrolling_grid.attach (scrolling_two_finger_radio, 0, 2, 1, 1);

            // Main
            this.attach (pointer_speed_grid,   0, 0, 2, 1);
            this.attach (general_label,        0, 1, 1, 1);
            this.attach (general_grid,         0, 2, 1, 1);
            this.attach (scrolling_label_grid, 1, 1, 1, 1);
            this.attach (scrolling_grid,       1, 2, 1, 1);
		}

		public override void reset () {

		}

		private void setup_widgets () {
            /* ---- Grids ---- */

            // Pointer Speed
            pointer_scale_grid.row_spacing        = 12;
            pointer_scale_grid.column_spacing     = 12;
            pointer_scale_grid.margin_top         = 12;
            pointer_scale_grid.margin_start       = 12;
            pointer_scale_grid.column_homogeneous = false;
            pointer_scale_grid.row_homogeneous    = false;
            pointer_speed_grid.row_spacing        = 12;
            pointer_speed_grid.column_spacing     = 12;
            pointer_speed_grid.column_homogeneous = false;
            pointer_speed_grid.row_homogeneous    = false;

            //General
            general_grid.margin_start       = 12;
            general_grid.row_spacing        = 12;
            general_grid.column_spacing     = 12;
            general_grid.column_homogeneous = false;
            general_grid.row_homogeneous    = false;

            //Scrolling
            scrolling_grid.margin_start       = 12;
            scrolling_grid.row_spacing        = 12;
            scrolling_grid.column_spacing     = 12;
            scrolling_grid.column_homogeneous = false;
            scrolling_grid.row_homogeneous    = false;
            scrolling_label_grid.hexpand      = false;
            scrolling_label_grid.column_homogeneous = false;
            scrolling_label_grid.column_spacing = 12;

            /* ---- Widgets ---- */

            // Pointer speed
            pointer_speed_label.halign         = Gtk.Align.START;
            pointer_speed_label.use_markup     = true;
            acceleration_fast_label.use_markup = true;
            acceleration_slow_label.use_markup = true;
            acceleration_scale.draw_value      = false;
            acceleration_scale.hexpand         = true;
            acceleration_scale.set_value (touchpad_settings.motion_acceleration);

            // General
            general_label.halign              = Gtk.Align.START;
            general_label.use_markup          = true;
            tap_to_click_check.active         = touchpad_settings.tap_to_click;
            disable_while_typing_check.active = touchpad_settings.disable_while_typing;
            
            // Scrolling
            scrolling_label.halign            = Gtk.Align.START;
            scrolling_label.use_markup        = true;
            natural_scrolling_check.active    = touchpad_settings.natural_scroll;
            horizontal_scrolling_check.active = touchpad_settings.horiz_scroll_enabled;

            var scroll_method = touchpad_settings.scroll_method;
            if (scroll_method == TouchpadSettings.SCROLL_METHOD_DISABLED) {
                scrolling_switch.active              = false;
                scrolling_two_finger_radio.sensitive = false;
                natural_scrolling_check.sensitive    = false;
                horizontal_scrolling_check.sensitive = false;
                previous_scroll_method = TouchpadSettings.SCROLL_METHOD_EDGE;
            }
            else if (scroll_method == TouchpadSettings.SCROLL_METHOD_EDGE) {
                scrolling_switch.active           = true;
                scrolling_two_finger_radio.active = false;
            }
            else if (scroll_method == TouchpadSettings.SCROLL_METHOD_TWO_FINGER) {
                scrolling_switch.active           = true;
                scrolling_two_finger_radio.active = true;
            }
		}

		private void setup_signals () {
            // Pointer Speed
            acceleration_scale.value_changed.connect (() => {
                touchpad_settings.motion_acceleration = acceleration_scale.adjustment.value;
                touchpad_settings.motion_threshold    = (int) (11 - acceleration_scale.adjustment.value);
            });

            touchpad_settings.changed["motion-acceleration"].connect (() => {
                acceleration_scale.adjustment.value = touchpad_settings.motion_acceleration;
            });

            //General
            touchpad_settings.changed["disable-while-typing"].connect (() => {
                disable_while_typing_check.active = touchpad_settings.disable_while_typing;
            });

            touchpad_settings.changed["tap-to-click"].connect (() => {
                tap_to_click_check.active = touchpad_settings.tap_to_click;
            });

            disable_while_typing_check.notify["active"].connect (() => {
                touchpad_settings.disable_while_typing = disable_while_typing_check.active;
            });

            tap_to_click_check.notify["active"].connect (() => {
                touchpad_settings.tap_to_click = tap_to_click_check.active;
            });

            // Scrolling
            touchpad_settings.changed["natural-scroll"].connect (() => {
                natural_scrolling_check.active = touchpad_settings.natural_scroll;
            });

            touchpad_settings.changed["horiz-scroll-enabled"].connect (() => {
                horizontal_scrolling_check.active = touchpad_settings.horiz_scroll_enabled;
            });

            touchpad_settings.changed["scroll-method"].connect (() => {
                var scroll_method = touchpad_settings.scroll_method;
                if (scroll_method == TouchpadSettings.SCROLL_METHOD_DISABLED) 
                    scrolling_switch.active = false;
                else if (scroll_method == TouchpadSettings.SCROLL_METHOD_EDGE) {
                    scrolling_switch.active           = true;
                    scrolling_two_finger_radio.active = false;
                }
                else {
                    scrolling_switch.active           = true;
                    scrolling_two_finger_radio.active = true;
                }
            });

            natural_scrolling_check.notify["active"].connect (() => {
                touchpad_settings.natural_scroll = natural_scrolling_check.active;
            });

            horizontal_scrolling_check.notify["active"].connect (() => {
                touchpad_settings.horiz_scroll_enabled = horizontal_scrolling_check.active;
            });

            scrolling_switch.notify["active"].connect (() => {
                var active = scrolling_switch.active;
                scrolling_two_finger_radio.sensitive = active;
                natural_scrolling_check.sensitive    = active;
                horizontal_scrolling_check.sensitive = active;

                if (!active) {
                    if (scrolling_two_finger_radio.active)
                        previous_scroll_method = TouchpadSettings.SCROLL_METHOD_TWO_FINGER;
                    else 
                        previous_scroll_method = TouchpadSettings.SCROLL_METHOD_EDGE;
                    touchpad_settings.scroll_method = TouchpadSettings.SCROLL_METHOD_DISABLED;
                }
                else {
                    touchpad_settings.scroll_method = previous_scroll_method;
                    if (previous_scroll_method == TouchpadSettings.SCROLL_METHOD_EDGE)
                        scrolling_two_finger_radio.active = false;
                    else
                        scrolling_two_finger_radio.active = true;
                }
            });

            scrolling_two_finger_radio.notify["active"].connect (() => {
                if (scrolling_two_finger_radio.active)
                    touchpad_settings.scroll_method = TouchpadSettings.SCROLL_METHOD_TWO_FINGER;
                else 
                    touchpad_settings.scroll_method = TouchpadSettings.SCROLL_METHOD_EDGE;

            });
	   }
	}
}