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

    private string system_config_path;
    private string user_config_dir_path;
    private string user_config_path;

    private const string SETTINGS_XPATH = "//application[@name=\"All\"]";
    private const string MAXIMIZE_3_XPATH = "//application[@name=\"All\"]/gesture[@fingers=\"3\"]/action[@type=\"MAXIMIZE_RESTORE_WINDOW\"]/..";
    private const string MAXIMIZE_4_XPATH = "//application[@name=\"All\"]/gesture[@fingers=\"4\"]/action[@type=\"MAXIMIZE_RESTORE_WINDOW\"]/..";

    public ToucheggSettings () {
        system_config_path = Path.build_filename (GLib.Path.DIR_SEPARATOR_S, "usr", "share", "touchegg", "touchegg.conf");
        user_config_dir_path = Path.build_filename (GLib.Environment.get_home_dir (), ".config", "touchegg");
        user_config_path = Path.build_filename (GLib.Environment.get_home_dir (), ".config", "touchegg", "touchegg.conf");
    }

    public bool is_installed () {
        bool config_installed = File.new_for_path (system_config_path).query_exists ();
        var gala_schema = SettingsSchemaSource.get_default ().lookup ("io.elementary.desktop.wm.gestures", false);
        return config_installed && (gala_schema != null);
    }

    public void set_maximize_settings (bool enabled, int fingers) {
        string xml_settings = build_maximize_xml (fingers);
        string xpath = (fingers == 3) ? MAXIMIZE_3_XPATH : MAXIMIZE_4_XPATH;
        save_config (xpath, enabled, {xml_settings});
    }

    private bool user_config_exists () {
        return File.new_for_path (user_config_path).query_exists ();
    }

    public void parse_config () {
        Xml.Doc* doc = null;

        try {
            string config_path = user_config_exists ()
                ? user_config_path
                : system_config_path;
            doc = Parser.parse_file (config_path);

            if (doc == null) {
                throw new GLib.IOError.FAILED ("Error parsing config: %s", config_path);
            }

            Context ctx = new Context (doc);
            if (ctx == null) {
                throw new GLib.IOError.FAILED ("Error creating XPath context");
            }

            errors = false;
        } catch (GLib.Error e) {
            warning ("Error parsing Touchégg config: %s", e.message);
            errors = true;
        } finally {
            if (doc != null) {
                delete doc;
            }
        }
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
                throw new GLib.IOError.FAILED ("Error parsing config: %s", config_path);
            }

            Context ctx = new Context (doc);
            if (ctx == null) {
                throw new GLib.IOError.FAILED ("Error creating XPath context");
            }

            remove_matching_nodes (ctx, xpath_expression);

            if (enabled) {
                Xml.XPath.Object* obj = ctx.eval_expression (SETTINGS_XPATH);
                if (obj == null) {
                    throw new GLib.IOError.FAILED ("XPath %s not found", SETTINGS_XPATH);
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
            warning ("Error saving Touchégg config: %s", e.message);
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
            throw new GLib.IOError.FAILED ("Error parsing XML string: %s", xml);
        }

        Xml.Node* root = doc->get_root_element ()->doc_copy (node->doc, 1);
        if (root == null) {
            delete doc;
            throw new GLib.IOError.FAILED ("Error getting root element of XML string: %s", xml);
        }

        node->add_child (root);
        delete doc;
    }

    private static string build_maximize_xml (int fingers) {
        return "
            <gesture type=\"SWIPE\" fingers=\"%d\" direction=\"UP\">
                <action type=\"MAXIMIZE_RESTORE_WINDOW\">
                    <animate>true</animate>
                </action>
            </gesture>
        ".printf (fingers);
    }
}
