# GNOME 46 Debian package PoC

Based on upstream commit `f70a2127d0a9acc3c9d4d8198361fc9f4e14818f`.
This build targets GNOME Shell 46 only. It uses the older image upload API
and GTK shortcut labels supported by Ubuntu 24.04.

## Build in Docker

Run from the repository root (fish or bash):

```sh
sudo docker build -f packaging/Dockerfile -t gradia-capture-gnome46-poc .
mkdir -p dist
sudo docker run --rm --user "$(id -u):$(id -g)" -v "$PWD/dist:/out" gradia-capture-gnome46-poc
```

The extension is assembled directly from source; its private GSettings schema
is compiled inside Docker and shipped beside the extension. No package
installation scripts or per-user settings changes are needed.

## Install on a GNOME 46 machine

```sh
sudo apt install ./dist/gnome-shell-extension-gradia-capture_*.deb
```

Log out and back in, then enable it:

```sh
gnome-extensions enable gradia-integration@alexandervanhee.github.io
gnome-extensions prefs gradia-integration@alexandervanhee.github.io
```

An existing user-installed extension with the same UUID takes precedence over
this system package; remove that copy through the Extensions app first.
Gradia's Flatpak is optional and must be installed separately for OCR/editing.

## Desktop validation

Check area, screen and window captures; drawing, text, stamps and undo;
clipboard and PNG output; Save As; previews and preferences; fractional scaling
and multiple monitors; portal screenshots; recording; cancellation; and
disable/re-enable. Container build checks do not establish desktop compatibility.

## CI and releases

The Build workflow runs on pushes to `master`, pull requests, manual dispatches
and `v*` tags. It uses the same Dockerfile as local builds, checks shell scripts
and JavaScript syntax, validates schemas, installs the package, opens both
preferences pages with GJS under Xvfb, and verifies package removal.
Successful builds upload the `.deb` as `deb-ubuntu-24.04-gnome-46`.

`packaging/control` holds the base version. CI snapshots include the UTC build timestamp
and commit SHA and sort below the corresponding release. To build a snapshot
locally, pass `--build-arg PACKAGE_VERSION="$(bash packaging/ci-version.sh)"`
to `docker build`.

To release, update the base version, merge the change, and push a matching tag
(for example `v0.1.0`). The workflow rejects mismatched tags and publishes a
GitHub release with the tested `.deb` attached.

## Remove

```sh
gnome-extensions disable gradia-integration@alexandervanhee.github.io
sudo apt remove gnome-shell-extension-gradia-capture
```
