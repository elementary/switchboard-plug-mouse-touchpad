namespace MouseTouchpad {
	public class MousePage : AbstractPage {
		public MousePage (string label) {

			var test_button = new Gtk.Button ();
			var scroll = new Gtk.ScrolledWindow (null, null);
			scroll.expand = true;
			test_button.label = label;
			this.attach (test_button, 1, 0, 1, 1);
			this.attach (scroll, 0, 1, 1, 1);

		}

		public override void reset () {

		}
	}
}