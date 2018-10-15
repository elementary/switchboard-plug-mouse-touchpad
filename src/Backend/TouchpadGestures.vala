/*
 * Copyright (c) 2011-2015 elementary Developers (https://launchpad.net/elementary)
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

public class MouseTouchpad.Backend.TouchpadGestures {    
    private File conf = File.new_for_path (Environment.get_home_dir () + "/.config/libinput-gestures.conf");
    private string file_string;

    public TouchpadGestures () {
        checkConfigFile ();
        file_string = readFile ();
    }

    private string readFile () {
        string file_string = "";
        try {
            FileInputStream file = conf.read ();
            DataInputStream dis = new DataInputStream (file);
            string line;
            while ((line = dis.read_line ()) != null) {
                file_string = file_string.concat(line + "\n");
            }
        } catch (Error e) {
            warning (e.message);
        }
        return file_string;
    }

    private string getSwipeLine (string file_string, string gesture) {
        string swipe_line = "";
        RegexCompileFlags compile_options = RegexCompileFlags.MULTILINE;
        MatchInfo match_info;
        string regex_string = "^gesture " + gesture + ".*$";
        Regex regex = new Regex (regex_string, compile_options);
        if (regex.match (file_string, 0, out match_info)){
            swipe_line = match_info.fetch (0);
        } else {
            warning ("No gesture line found");
        }
        return swipe_line;
    }

    private void replaceFile (string new_file) {
        try {
            FileOutputStream ostream = conf.replace (null, false, FileCreateFlags.NONE);
            DataOutputStream dostream = new DataOutputStream (ostream);
            dostream.put_string (new_file);
        } catch (Error e) { 
            warning (e.message);
        }

    }

    private void restartLibinputGestures () {
        try {
            Process.spawn_command_line_async ("libinput-gestures-setup restart");
        } catch (Error e) {
            warning (e.message);
        }
    }

    private void checkConfigFile () {
        if (!conf.query_exists ()){
            File old_conf = File.new_for_path ("/etc/libinput-gestures.conf");
            old_conf.copy (conf, 0, null);
        }
    }

    public void enableGestures () {
        try {
            Process.spawn_command_line_async ("libinput-gestures-setup start");
            Process.spawn_command_line_async ("libinput-gestures-setup autostart");
        } catch (Error e) {
            warning (e.message);
        }
    }

    public void disableGestures () {
        try {
            Process.spawn_command_line_async ("libinput-gestures-setup stop");
            Process.spawn_command_line_async ("libinput-gestures-setup autostop");
        } catch (Error e) {
            warning (e.message);
        }
    }

    public string getCurrentCommand (string gesture) {
        string swipe_line = getSwipeLine (file_string, gesture);
        string current_command = swipe_line.split (" ")[4];
        return current_command;
    }

    public void changeSwipeGesture (string new_command, string gesture) {
        try {
            string swipe_line = getSwipeLine (file_string, gesture);
            string current_command = swipe_line.split (" ")[4];
            string new_swipe_line = swipe_line.replace (current_command, new_command);
            string new_file = file_string.replace (swipe_line, new_swipe_line);
            replaceFile (new_file);
            restartLibinputGestures ();
        } catch (Error e){
            warning (e.message);
        }
    }
}
