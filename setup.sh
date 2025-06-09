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

yay -S btop chezmoi chromium fastfetch feh flameshot git gnome-keyring intel-gpu-tools intel-media-driver inter-font kitty libva-utils lightdm lightdm-gtk-greeter lxappearance-gtk3 micro noto-fonts-cjk pavucontrol picom pipewire pipewire-pulse polybar rofi ttf-recursive-nerd xclip xdg-desktop-portal xdg-desktop-portal-gtk xdg-user-dirs zsh zsh-autosuggestions zsh-syntax-highlighting apple_cursor ibus-bamboo python-pywal16 ttf-apple-emoji vesktop-bin yay-bin zsh-theme-powerlevel10k-git

yay -S xorg bspwm sxhkd
