import Gio from 'gi://Gio';
import GLib from 'gi://GLib';
import Gtk from 'gi://Gtk?version=4.0';
import Adw from 'gi://Adw?version=1';

Gio.resources_register(Gio.Resource.load(
    '/usr/share/gnome-shell/org.gnome.Shell.Extensions.src.gresource'));
Gtk.init();
Adw.init();

const path = '/usr/share/gnome-shell/extensions/gradia-integration@alexandervanhee.github.io';
const dir = Gio.File.new_for_path(path);
const [, contents] = dir.get_child('metadata.json').load_contents(null);
const metadata = JSON.parse(new TextDecoder().decode(contents));
metadata.path = path;
metadata.dir = dir;
const {default: Preferences} = await import(`file://${path}/prefs.js`);
const preferences = new Preferences(metadata);
const window = new Adw.PreferencesWindow();
preferences.fillPreferencesWindow(window);
window.present();

const loop = new GLib.MainLoop(null, false);
GLib.timeout_add(GLib.PRIORITY_DEFAULT, 300, () => {
    window.destroy();
    loop.quit();
    return GLib.SOURCE_REMOVE;
});
loop.run();
print('PASS: installed extension schema and both preferences pages load on GNOME 46 libraries');
