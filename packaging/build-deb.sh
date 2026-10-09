#!/bin/bash
set -euo pipefail

uuid=gradia-integration@alexandervanhee.github.io
package=gnome-shell-extension-gradia-capture
root=/build/package
extension="$root/usr/share/gnome-shell/extensions/$uuid"
docs="$root/usr/share/doc/$package"

gnome-shell --version
[[ "$(gnome-shell --version)" == 'GNOME Shell 46.'* ]]
shellcheck packaging/*.sh
for source in src/*.js; do
    node --input-type=module --check < "$source"
done
glib-compile-schemas --strict --dry-run schemas

install -d "$root/DEBIAN" "$extension/schemas" "$docs" /packages
dpkg --validate-version "$PACKAGE_VERSION"
while IFS= read -r line; do
    case "$line" in
        Version:*) printf 'Version: %s\n' "$PACKAGE_VERSION" ;;
        *) printf '%s\n' "$line" ;;
    esac
done < packaging/control > "$root/DEBIAN/control"
install -m 644 src/*.js src/metadata.json src/stylesheet.css "$extension/"
cp -r icons "$extension/icons"
install -m 644 schemas/*.xml "$extension/schemas/"
glib-compile-schemas --strict "$extension/schemas"
install -m 644 LICENSE "$docs/copyright"
install -m 644 README.md "$docs/README.md"
install -m 644 packaging/README.md "$docs/README.gnome46.md"
find "$root" -type d -exec chmod 755 {} +
find "$root" -type f -exec chmod 644 {} +

dpkg-deb --root-owner-group --build "$root" /packages/
dpkg-deb --info /packages/*.deb
dpkg-deb --contents /packages/*.deb
dpkg -i /packages/*.deb
dbus-run-session -- xvfb-run -a env GSETTINGS_BACKEND=memory GTK_A11Y=none \
    GI_TYPELIB_PATH=/usr/lib/gnome-shell/girepository-1.0 \
    LD_LIBRARY_PATH=/usr/lib/gnome-shell \
    gjs -m packaging/smoke-prefs.js
dpkg --purge "$package"
test ! -e "/usr/share/gnome-shell/extensions/$uuid/metadata.json"
