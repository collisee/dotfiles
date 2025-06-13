if ! grep -q "ILoveCandy" /etc/pacman.conf; then
    sudo sed -i '/^[[:space:]]*#[[:space:]]*Misc options/a\ILoveCandy' /etc/pacman.conf
fi
sudo sed -i 's/^[[:space:]]*#[[:space:]]*Color[[:space:]]*$/Color/' /etc/pacman.conf
sudo sed -i 's/^[[:space:]]*#[[:space:]]*VerbosePkgLists[[:space:]]*$/VerbosePkgLists/' /etc/pacman.conf
sudo sed -i '/\[multilib\]/,/^$/s/^#//' /etc/pacman.conf
sudo sed -i '/^OPTIONS=/s/\(!debug\|debug\)/!debug/' /etc/makepkg.conf

# diff -U 3 --color

sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

yay -S xorg bspwm sxhkd picom feh lightdm lightdm-gtk-greeter polybar rofi\ 
chromium flameshot kitty lxappearance-gtk3 vesktop-bin \
intel-gpu-tools intel-media-driver \
pipewire pipewire-pulse pavucontrol \
xdg-desktop-portal xdg-desktop-portal-gtk xdg-user-dirs gnome-keyring \
zsh zsh-autosuggestions zsh-syntax-highlighting zsh-theme-powerlevel10k-git \
inter-font ttf-apple-emoji noto-fonts-cjk ttf-recursive-nerd \
btop chezmoi apple_cursor ibus-bamboo zram-generator libappindicator-gtk2 libappindicator-gtk3

cat << EOF | sudo tee /etc/X11/xorg.conf.d/40-libinput.conf > /dev/null
 Section "InputClass"
  Identifier "libinput pointer catchall"
  MatchIsPointer "on"
  MatchDevicePath "/dev/input/event*"
  Driver "libinput"
  Option "AccelProfile" "flat"
 EndSection
EOF

cat << EOF | sudo tee /etc/libinput/local-overrides.quirks > /dev/null
[disable libinput debounce]
MatchUdevType=mouse
ModelBouncingKeys=1
EOF

cat << EOF | sudo tee /etc/systemd/zram-generator.conf > /dev/null
[zram0]
zram-size = min(ram / 2, 4096)
compression-algorithm = zstd
EOF
