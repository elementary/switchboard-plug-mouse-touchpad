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
public class MouseTouchpad.ToucheggSettings : GLib.Object {
    public bool errors { get; private set; default = false; }

    public bool maximize_enabled { get; private set; default = false; }
    public int maximize_fingers { get; private set; default = -1; }

    public bool tile_enabled { get; private set; default = false; }
    public int tile_fingers { get; private set; default = -1; }

    private string system_config_path = Path.build_filename (GLib.Path.DIR_SEPARATOR_S, "usr", "share", "touchegg", "touchegg.conf");
    private string user_config_dir_path = Path.build_filename (GLib.Environment.get_home_dir (), ".config", "touchegg");
    private string user_config_path = Path.build_filename (GLib.Environment.get_home_dir (), ".config", "touchegg", "touchegg.conf");

    private const string SETTINGS_XPATH = "//application[@name=\"All\"]";
    private const string MAXIMIZE_XPATH = "//application[@name=\"All\"]/gesture/action[@type=\"MAXIMIZE_RESTORE_WINDOW\"]/..";
    private const string TILE_XPATH = "//application[@name=\"All\"]/gesture/action[@type=\"TILE_WINDOW\"]/..";


    public ToucheggSettings () {
        parse_config ();
    }

    public void set_maximize_settings (bool enabled, int fingers) {
        string xml_settings = build_maximize_xml (fingers);
        save_config (MAXIMIZE_XPATH, enabled, {xml_settings});

        if (!errors) {
            maximize_enabled = enabled;
            maximize_fingers = fingers;
        } else {
            maximize_enabled = false;
        }
    }

    public void set_tile_settings (bool enabled, int fingers) {
        string tile_left_xml = build_tile_left_xml (fingers);
        string tile_right_xml = build_tile_right_xml (fingers);
        save_config (TILE_XPATH, enabled, {tile_left_xml, tile_right_xml});

        if (!errors) {
            tile_enabled = enabled;
            tile_fingers = fingers;
        } else {
            tile_enabled = false;
        }
    }

    private bool user_config_exists () {
        string path = user_config_path;
        File file = File.new_for_path (path);
        return file.query_exists ();
    }

    private void parse_config () {
        Xml.Doc* doc = null;

        try {
            string config_path = user_config_exists ()
                ? user_config_path
                : system_config_path;
            doc = Parser.parse_file (config_path);

            if (doc == null) {
                throw new GLib.IOError.FAILED (@"Error parsing config \"$(config_path)\"");
            }

            Context ctx = new Context (doc);
            if (ctx == null) {
                throw new GLib.IOError.FAILED ("Error creating XPath context");
            }

            // Maximize/restore window action
            maximize_fingers = get_configured_fingers (ctx, MAXIMIZE_XPATH);
            if (maximize_fingers != -1) {
                maximize_enabled = true;
            }

            // Tile window action
            tile_fingers = get_configured_fingers (ctx, TILE_XPATH);
            if (tile_fingers != -1) {
                tile_enabled = true;
            }

            errors = false;
        } catch (GLib.Error e) {
            warning (@"Error parsing Touchégg config: $(e.message)");
            errors = true;
        } finally {
            if (doc != null) {
                delete doc;
            }
        }
    }

    private static int get_configured_fingers (Context ctx, string xpath_expression) {
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

    private void save_config (string xpath_expression, bool enabled, string[] xml_settings) {
        Xml.Doc* doc = null;

        try {
            if (!user_config_exists ()) {
                DirUtils.create_with_parents (user_config_dir_path, 0775);
                File system_config_file = File.new_for_path (system_config_path);
                File home_config_file = File.new_for_path (user_config_path);
                system_config_file.copy (home_config_file, GLib.FileCopyFlags.NONE);
            }

            string config_path = user_config_path;
            doc = Parser.parse_file (config_path);

            if (doc == null) {
                throw new GLib.IOError.FAILED (@"Error parsing config \"$(config_path)\"");
            }

            Context ctx = new Context (doc);
            if (ctx == null) {
                throw new GLib.IOError.FAILED ("Error creating XPath context");
            }

            remove_matching_nodes (ctx, xpath_expression);

            if (enabled) {
                Xml.XPath.Object* obj = ctx.eval_expression (SETTINGS_XPATH);
                if (obj == null) {
                    throw new GLib.IOError.FAILED (@"XPath $(SETTINGS_XPATH) not found");
                }

                if (obj->nodesetval != null && obj->nodesetval->item (0) != null) {
                    Xml.Node* node = obj->nodesetval->item (0);
                    foreach (var xml in xml_settings) {
                        append_xml (node, xml);
                    }
                }

                delete obj;
            }

            doc->save_file (config_path);
            errors = false;
        } catch (GLib.Error e) {
            warning (@"Error saving Touchégg config: $(e.message)");
            errors = true;
        } finally {
            if (doc != null) {
                delete doc;
            }
        }
    }

    private static void remove_matching_nodes (Context ctx, string xpath_expression) {
        bool done = false;
        while (!done) {
            Xml.XPath.Object* obj = ctx.eval_expression (xpath_expression);
            if (obj != null) {
                if (obj->nodesetval != null && obj->nodesetval->item (0) != null) {
                    Xml.Node* node = obj->nodesetval->item (0);
                    node->unlink ();
                    delete node;
                } else {
                    done = true;
                }

                delete obj;
            } else {
                done = true;
            }
        }
    }

    private static void append_xml (Xml.Node* node, string xml) throws GLib.IOError.FAILED {
        Xml.Doc* doc = Parser.read_memory (xml, xml.length);
        if (doc == null) {
            throw new GLib.IOError.FAILED (@"Error parsing XML string: \"$(xml)\"");
        }

        Xml.Node* root = doc->get_root_element ()->doc_copy (node->doc, 1);
        if (root == null) {
            delete doc;
            throw new GLib.IOError.FAILED (@"Error getting root element of XML string: \"$(xml)\"");
        }

        node->add_child (root);
        delete doc;
    }

    private static string build_maximize_xml (int fingers) {
        return @"
            <gesture type=\"SWIPE\" fingers=\"$(fingers)\" direction=\"UP\">
                <action type=\"MAXIMIZE_RESTORE_WINDOW\">
                    <animate>true</animate>
                </action>
            </gesture>
        ";
    }

    private static string build_tile_left_xml (int fingers) {
        return @"
            <gesture type=\"SWIPE\" fingers=\"$(fingers)\" direction=\"LEFT\">
                <action type=\"TILE_WINDOW\">
                    <direction>left</direction>
                    <animate>true</animate>
                </action>
            </gesture>
        ";
    }

    private static string build_tile_right_xml (int fingers) {
        return @"
            <gesture type=\"SWIPE\" fingers=\"$(fingers)\" direction=\"RIGHT\">
                <action type=\"TILE_WINDOW\">
                <direction>right</direction>
                <animate>true</animate>
                </action>
            </gesture>
        ";
    }
}
