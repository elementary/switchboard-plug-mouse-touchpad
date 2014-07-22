namespace MouseTouchpad {
	public abstract class AbstractPage : Gtk.Grid {
		public AbstractPage () {
	        this.row_spacing    = 12;
	        this.column_spacing = 12;
	        this.margin_top     = 12;
	        this.margin_bottom  = 12;
	        this.column_homogeneous = false;
	        this.row_homogeneous    = false;
		}

		public abstract void reset ();
	}
}