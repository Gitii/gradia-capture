
<div align="center">
  <img src="https://github.com/user-attachments/assets/03ba0ce8-aa83-4f9e-b829-23a66ec599cc" alt="logo" width="150"/>
  <h1>Gradia Capture</h1>
</div>

<br/>
<div align="center">
  <p style="margin-bottom: 16px;">
    Enhances the GNOME built-in screenshot tool with the annotation features you would expect.
  </p>

  <img width="1920" height="1080" alt="Screenshot From 2026-04-25 10-51-19" src="https://github.com/user-attachments/assets/e1969f03-b07b-4cd3-9b4c-dc6c53d8d402" />
</div>
<br/>

Includes features like annotations, custom saving options and integration with the [Gradia App from Flathub](https://flathub.org/en/apps/be.alexandervanhee.gradia), including OCR text recognition.

> [!IMPORTANT]
>  Unlike the Gradia app, this extension is not part of GNOME Circle.

> [!IMPORTANT]
> The [GNOME Code of Conduct](https://conduct.gnome.org) applies to this project, including this repository.

## Gitii GNOME 46 fork

This fork packages Gradia Capture for **GNOME Shell 46 / Ubuntu 24.04**.
The screenshot preview and preferences APIs are backported from upstream,
and the GNOME 46 PoC has been tried successfully on a desktop.

Download a `.deb` from [Releases](https://github.com/Gitii/gradia-capture/releases)
or the `deb-ubuntu-24.04-gnome-46` artifact of a successful
[Build workflow](https://github.com/Gitii/gradia-capture/actions/workflows/build.yml).
Install the downloaded package with `sudo apt install ./gnome-shell-extension-gradia-capture_*.deb`,
log out and back in, then enable it:

```sh
gnome-extensions enable gradia-integration@alexandervanhee.github.io
```

Press **Print Screen** to open the screenshot overlay and annotation toolbar.
Gradia's Flatpak is optional for editing/OCR integration.

See [Docker build and packaging instructions](packaging/README.md) for local builds,
CI checks, releases and removal.

## Setup from source

### 1. Clone the repository

```bash
git clone https://github.com/Gitii/gradia-capture.git
cd gradia-capture
```

### 2. Build and install

Run the following command from the root directory of the cloned repo:

```bash
./build.sh -i
```

The `-i` flag tells the script to both build the project and install it automatically.
