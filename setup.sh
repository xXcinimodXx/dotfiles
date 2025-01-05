#!/bin/bash

echo "Setting up your Arch Linux environment..."

# Step 1: Install X11 and necessary packages
echo "Installing necessary packages..."
if ! sudo pacman -S --needed \
    xorg-server \
    xorg-xrandr \
    xorg-xinit \
    xorg-xsetroot \
    xorg-xinput \
    arandr \
    lxappearance \
    ly \
    slock \
    neofetch \
    bspwm \
    sxhkd \
    polybar \
    pavucontrol \
    kitty \
    rofi \
    flameshot \
    libreoffice-still \
    discord \
    dunst \
    nemo \
    nano \
    gtk3 \
    gtk4 \
    libsecret \
    gnome-keyring \
    seahorse \
    xdg-utils \
    xdg-user-dirs \
    gtk-engine-murrine \
    mesa \
    vulkan-radeon \
    dosfstools \
    exfat-utils \
    ntfs-3g \
    pipewire \
    pipewire-pulse \
    gst-plugins-good \
    gst-plugins-bad \
    gst-libav \
    samba \
    cifs-utils \
    unzip \
    vlc; then
    echo "Error: Failed to install packages. Check ~/setup.log for details."
    exit 1
fi
echo "All packages installed successfully."

# Step 2: Copy .config directory to user's home and set permissions
echo "Copying custom .config directory to $HOME/.config..."
cp -r .config "$HOME/.config"
echo "Setting all files in ~/.config to be executable..."
find "$HOME/.config" -type f -exec chmod +x {} \;

# Step 3: Install yay (AUR helper)
if ! command -v yay &> /dev/null; then
    echo "Installing yay (AUR helper)..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
else
    echo "yay is already installed."
fi

# Step 4: Install Brave browser, VSCode, and other AUR packages using yay
echo "Installing Brave browser, VSCode, and other AUR packages..."
yay -S --noconfirm brave-bin visual-studio-code-bin

# Step 5: Install Fira Code Nerd Font Manually
echo "Installing Fira Code Nerd Font..."
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "FiraCode.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip -o FiraCode.zip
rm FiraCode.zip
fc-cache -fv
echo "Fira Code Nerd Font installed successfully!"

# Step 6: Set up .xinitrc to start bspwm
echo "Configuring ~/.xinitrc..."
cat > ~/.xinitrc <<EOL
exec bspwm
EOL

chmod +x ~/.xinitrc

# Step 7: Enable ly (do not start immediately)
echo "Enabling ly display manager (will start after reboot)..."
sudo systemctl enable ly.service

# Step 8: Update user directories
echo "Updating user directories..."
xdg-user-dirs-update

# Step 9: Install WhiteSur GTK Theme, Cursor, and Icon Theme
echo "Installing WhiteSur GTK Theme, Cursor, and Icon Theme..."
if [ ! -d "/usr/share/themes/WhiteSur" ]; then
    git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1
    cd WhiteSur-gtk-theme
    ./install.sh # Install system-wide
    cd ..
    rm -rf WhiteSur-gtk-theme
else
    echo "WhiteSur GTK Theme is already installed."
fi

if [ ! -d "/usr/share/icons/WhiteSur" ]; then
    git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
    cd WhiteSur-icon-theme
    ./install.sh -a #Install system-wide
    cd ..
    rm -rf WhiteSur-icon-theme
else
    echo "WhiteSur Icon Theme is already installed."
fi

if [ ! -d "/usr/share/icons/WhiteSur-cursors" ]; then
    git clone https://github.com/vinceliuice/WhiteSur-cursors.git
    cd WhiteSur-cursors
    ./install.sh # Install system-wide
    cd ..
    rm -rf WhiteSur-cursors
else
    echo "WhiteSur Cursor Theme is already installed."
fi

# Step 10: Apply WhiteSur GTK Theme using settings.ini
echo "Applying WhiteSur GTK theme globally..."
if [ -f "$HOME/.config/gtk-3.0/settings.ini" ]; then
    echo "Stock settings.ini already copied to ~/.config/gtk-3.0/"
else
    echo "Warning: Stock settings.ini was not found. Please verify the file is included in your repository."
fi

echo "To finalize, open lxappearance to confirm the theme settings if needed."

# Step 11: Configure NAS in /etc/fstab
echo "Configuring NAS mount in /etc/fstab..."
NAS_MOUNT_ENTRY="//192.168.0.186/homes/dominic /mnt/nas-001 cifs credentials=$HOME/.config/auth/nas_credentials,uid=1000,gid=1000,file_mode=0755,dir_mode=0755,_netdev,nofail,x-systemd.automount,mfsymlinks 0 0"

if ! grep -q "$NAS_MOUNT_ENTRY" /etc/fstab; then
    echo "$NAS_MOUNT_ENTRY" | sudo tee -a /etc/fstab > /dev/null
    echo "NAS mount added to /etc/fstab."
else
    echo "NAS mount already exists in /etc/fstab."
fi

if [ ! -d "/mnt/nas-001" ]; then
    sudo mkdir -p /mnt/nas-001
fi

echo "Please add your NAS credentials to: $HOME/.config/auth/nas_credentials"

# Step 12: Completion message
echo "Setup complete! Reboot your system to apply all changes."
rm -rf ~/dotfiles