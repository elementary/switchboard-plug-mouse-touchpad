/*
 * Copyright (c) 2020 elementary, Inc. (https://elementary.io)
 *               2020 José Expósito <jose.exposito89@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA.
 */

using Xml;
using Xml.XPath;

/**
 * Utility class to configure Touchégg based gestures.
 */
public class MouseTouchpad.ToucheggConfig : GLib.Object {
    public bool errors { get; private set; default = false; }

    public bool maximize_configured { get; private set; default = false; }
    public int maximize_fingers { get; private set; default = -1; }

    public bool tile_configured { get; private set; default = false; }
    public int tile_fingers { get; private set; default = -1; }

    public ToucheggConfig () {
        parse_config ();
    }

    private string get_system_config_path () {
        return Path.build_filename (GLib.Path.DIR_SEPARATOR_S, "usr", "share", "touchegg", "touchegg.conf");
    }

    private string get_user_config_path () {
        return Path.build_filename (GLib.Environment.get_home_dir (), ".config", "touchegg", "touchegg.conf");
    }

    private bool system_config_exists () {
        string path = get_system_config_path ();
        File file = File.new_for_path (path);
        return file.query_exists ();
    }

    private bool user_config_exists () {
        string path = get_user_config_path ();
        File file = File.new_for_path (path);
        return file.query_exists ();
    }

    private void parse_config () {
        string config_path = user_config_exists ()
            ? get_user_config_path ()
            : get_system_config_path ();
        Xml.Doc* doc = Parser.parse_file (config_path);

        if (doc == null) {
            warning (@"Error parsing config \"$(config_path)\"");
            errors = true;
            return;
        }

        Context ctx = new Context (doc);
        if (ctx == null) {
            warning ("Error creating XPath context");
            errors = true;
            delete doc;
            return;
        }

        // Maximize/restore window action
        string maximize_xpath = "//application[@name=\"All\"]/gesture/action[@type=\"MAXIMIZE_RESTORE_WINDOW\"]/..";
        maximize_fingers = get_configured_fingers (ctx, maximize_xpath);
        if (maximize_fingers != -1) {
            maximize_configured = true;
        }

        // Tile window action
        string tile_xpath = "//application[@name=\"All\"]/gesture/action[@type=\"TILE_WINDOW\"]/..";
        tile_fingers = get_configured_fingers (ctx, tile_xpath);
        if (tile_fingers != -1) {
            tile_configured = true;
        }

        delete doc;
    }

    private int get_configured_fingers (Context ctx, string xpath_expression) {
        int fingers = -1;

        Xml.XPath.Object* obj = ctx.eval_expression (xpath_expression);
        if (obj != null) {
            if (obj->nodesetval != null && obj->nodesetval->item (0) != null) {
                Xml.Node* node = obj->nodesetval->item (0);
                bool found = false;
                Xml.Attr* attr = node->properties;

                while (!found || attr != null) {
                    if (attr->name == "fingers") {
                        fingers = int.parse (attr->children->content);
                        found = true;
                    }

                    attr = attr->next;
                }
            }

            delete obj;
        }

        return fingers;
    }
}
