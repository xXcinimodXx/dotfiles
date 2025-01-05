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
    ly \
    slock \
    bspwm \
    sxhkd \
    polybar \
    pavucontrol \
    kitty \
    rofi \
    flameshot \
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

# Step 5: Install Complete Nerd Fonts
echo "Installing Nerd Fonts Complete..."
yay -S --noconfirm nerd-fonts-complete

# Refresh font cache
fc-cache -fv

echo "Nerd Fonts Complete installed successfully. You now have access to all Nerd Fonts!"

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

# Step 9: Install WhiteSur GTK Theme
echo "Installing WhiteSur GTK Theme..."
if [ ! -d "/usr/share/themes/WhiteSur" ]; then
    git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
    cd WhiteSur-gtk-theme
    ./install.sh -a  # Install system-wide
    cd ..
    rm -rf WhiteSur-gtk-theme
else
    echo "WhiteSur GTK Theme is already installed."
fi

# Step 10: Apply WhiteSur GTK Theme globally
echo "Applying WhiteSur GTK theme globally..."
cat > ~/.gtkrc-2.0 <<EOL
gtk-theme-name="WhiteSur"
gtk-icon-theme-name="Adwaita"
gtk-font-name="FiraCode Nerd Font 10"
gtk-cursor-theme-name="Adwaita"
EOL

mkdir -p ~/.config/gtk-3.0
cat > ~/.config/gtk-3.0/settings.ini <<EOL
[Settings]
gtk-theme-name=WhiteSur
gtk-icon-theme-name=Adwaita
gtk-cursor-theme-name=Adwaita
gtk-font-name=FiraCode Nerd Font 10
EOL

echo "WhiteSur GTK theme applied globally."

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
