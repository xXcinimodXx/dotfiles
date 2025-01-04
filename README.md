# Dotfiles for Arch Linux

This repository contains my personal dotfiles and configuration files for setting up a minimal and functional Arch Linux environment. The `setup.sh` script automates the installation and configuration of essential packages, themes, and custom settings.

## Features

- **Window Manager**: bspwm with polybar.
- **Terminal**: Kitty with Fira Code Nerd Font.
- **Launcher**: Rofi for quick application launch.
- **Notifications**: Dunst for clean and minimal notifications.
- **File Manager**: Nemo with WhiteSur GTK theme.
- **Audio**: PulseAudio integrated with Polybar.
- **Browser**: Brave browser installed via `yay`.
- **Editor**: Visual Studio Code (VSCode) installed via `yay`.
- **NAS Mount**: Pre-configured `/etc/fstab` entry for NAS.

## Requirements

Ensure the following are installed before running the setup script:
- **git**
- **NetworkManager** (for internet access during setup)

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/xXcinimodXx/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Run the setup script:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

3. Add NAS credentials (if applicable):
   ```bash
   nano ~/.config/auth/nas_credentials
   ```
   Example format:
   ```plaintext
   username=your_username
   password=your_password
   ```

4. Reboot your system to apply all changes:
   ```bash
   sudo reboot
   ```

## Customizations

- **Polybar**: The configuration includes modules for audio control, workspaces, and more.
- **GTK Theme**: WhiteSur GTK theme applied globally for a polished appearance.
- **Dotfiles**: Located in `~/.config` after setup.

## Contributing

Feel free to fork this repository, customize the configurations, and submit pull requests with improvements or fixes.

## License

This repository is licensed under the MIT License:

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.