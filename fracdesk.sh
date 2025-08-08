#!/bin/bash

PROJECT="FracDesk"
PROJECTLOWER=$(echo "$PROJECT" | tr '[:upper:]' '[:lower:]')
URL="https://raw.githubusercontent.com/dougburks/$PROJECTLOWER/refs/heads/main"

function logo {
	toilet -f mono12 "$PROJECT" | tte rain
}

function welcome {
	toilet -f mono12 "Welcome" | tte rain
	toilet -f mono12 "to" | tte rain
	logo
}

function display {
echo
cat << EOF | $1
###############################################################################
$2
###############################################################################
EOF
echo
}

if ! grep -q "13 (trixie)" /etc/os-release; then
	display "cat" "This script is designed for Debian 13 Cinnamon. Exiting!"
	exit 1
fi

if [ "$UID" -eq 0 ]; then

	display "cat" "Looks like you're running as root.
 
Instead of running as root, you most likely want to 
run this script as a normal user that has sudo privileges.

Press Enter if you are sure you want to continue as root
or Ctrl-c to cancel."

	read input
fi

clear
display "cat" "Welcome to $PROJECT the Fractal Desktop!

Infinite loops spin,
Branches bloom in endless dance,
Nature's code unfolds.
 -- AI, probably

WARNING! This script is totally unsupported!
If it breaks your system, you get to keep both pieces!

Press Enter to continue or Ctrl-c to cancel."
read input

clear

display "cat" "First, this terminal needs more color!"
sudo apt update
sudo apt -y install curl libglib2.0-bin python3-terminaltexteffects toilet
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ foreground-color "'#D3D7CF'"
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ background-color "'#2E3436'"
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ use-theme-colors false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ palette "['#2e3436', '#cc0000', '#4e9a06', '#c4a000', '#3465a4', '#75507b', '#06989a', '#d3d7cf', '#555753', '#ef2929', '#8ae234', '#fce94f', '#729fcf', '#ad7fa8', '#34e2e2', '#eeeeec']"

clear 

logo
echo
if [ $(dpkg -l | grep "^ii  mint-" | wc -l) -eq 0 ]; then
	display "tte waves" "Installing themes"
	MINTLIST="/etc/apt/sources.list.d/mint.list"
	MINTKEY="linuxmint-keyring_2022.06.21_all.deb"
	MINTURL="http://packages.linuxmint.com/pool/main/l/linuxmint-keyring/$MINTKEY"
	echo
	echo "Temporarily adding the following repo:"
	echo
	echo "deb http://packages.linuxmint.com virginia main" | sudo tee -a $MINTLIST
	curl -O $MINTURL
	echo
	sudo dpkg -i $MINTKEY
	echo
	sudo rm -f $MINTKEY
	sudo apt update && sudo apt -y install mint-themes
	echo
	sudo rm -f $MINTLIST
	sudo apt update
	echo
	sudo apt -y purge linuxmint-keyring
fi

if [ ! -f /usr/share/wallpapers/mandelbrot-seahorse-tail.jpg ]; then
	display "tte rain" "Downloading new wallpapers"
	sudo curl $URL/wallpapers/mandelbrot-julia-island.jpg -o /usr/share/wallpapers/mandelbrot-julia-island.jpg
	sudo curl $URL/wallpapers/mandelbrot-seahorse-tail.jpg -o /usr/share/wallpapers/mandelbrot-seahorse-tail.jpg
	sudo curl $URL/wallpapers/mandelbrot-tail-zoom.jpg -o /usr/share/wallpapers/mandelbrot-tail-zoom.jpg
	
	display "tte rain" "Changing wallpaper"
	gsettings set org.cinnamon.desktop.background picture-uri "'file:///usr/share/wallpapers/mandelbrot-seahorse-tail.jpg'"
fi

display "tte rain" "Setting Cinnamon theme"
gsettings set org.cinnamon.theme name "'Mint-Y-Dark-Aqua'"

display "tte rain" "Setting cursor theme"
sudo apt -y install bibata-cursor-theme
gsettings set org.cinnamon.desktop.interface cursor-theme "'Bibata-Modern-Classic'"

display "tte rain" "Setting GTK theme"
gsettings set org.cinnamon.desktop.interface gtk-theme "'Mint-Y-Dark-Aqua'"

display "tte rain" "Setting icon theme"
gsettings set org.cinnamon.desktop.interface icon-theme "'Mint-Y-Sand'"

display "tte rain" "Setting alttab switcher style to coverflow"
gsettings set org.cinnamon alttab-switcher-style "'coverflow'"

display "tte rain" "Configuring alttab switcher for all workspaces"
gsettings set org.cinnamon alttab-switcher-show-all-workspaces true

display "tte rain" "Changing grouped window list to window list"
gsettings set org.cinnamon enabled-applets "$(gsettings get org.cinnamon enabled-applets | sed "s/panel1:left:[0-9]*:grouped-window-list@cinnamon.org:[0-9]*/panel1:left:1:window-list@cinnamon.org:12/")"

display "tte rain" "Enabling workspace switcher"
gsettings set org.cinnamon enabled-applets "$(gsettings get org.cinnamon enabled-applets | sed 's/]$/, "panel1:right:0:workspace-switcher@cinnamon.org:10"]/')"

display "tte rain" "Installing some new apps"
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt -y install alacritty binutils btop chromium curl fzf git gimp golang gvfs-backends htop iperf3 keepassxc neovim openvpn pdftk-java python-is-python3 ripgrep screenfetch vim wget xdotool

display "tte rain" "Setting alacritty as default terminal emulator"
gsettings set org.cinnamon.desktop.default-applications.terminal exec "'alacritty'"

display "tte rain" "Configuring alacritty"
if [ ! -f ~/.local/share/fonts/CaskaydiaMonoNerdFont-Regular.ttf ]; then
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaMono.zip
	unzip CascadiaMono.zip -d ~/.local/share/fonts
	rm -f CascadiaMono.zip
	fc-cache -fv
fi
if [ ! -f ~/.config/alacritty/alacritty.toml ]; then
	mkdir -p ~/.config/alacritty/
	cat << EOF >> ~/.config/alacritty/alacritty.toml
[window]
opacity = 0.97  # Values from 0.0 (fully transparent) to 1.0 (opaque)
[font]
normal = { family = "CaskaydiaMono Nerd Font", style = "Regular" }
bold = { family = "CaskaydiaMono Nerd Font", style = "Bold" }
italic = { family = "CaskaydiaMono Nerd Font", style = "Italic" }
EOF
fi

display "tte rain" "Setting neovim as default vi"
sudo update-alternatives --set vi /usr/bin/nvim

display "tte rain" "Configuring lazyvim"
if [ ! -d ~/.config/nvim ]; then
	git clone https://github.com/LazyVim/starter ~/.config/nvim
	rm -rf ~/.config/nvim/.git
fi

display "tte rain" "Removing unnecessary packages"
sudo apt -y purge brasero firefox* thunderbird firefox* gnome-chess gnome-games goldendict-ng hexchat hoichess pidgin remmina thunderbird transmission* x11vnc
sudo apt -y autoremove

display "tte rain" "Installing all updates"
sudo apt -y dist-upgrade

display "tte rain" "Installation complete!"
echo
screenfetch -N | tte slide --merge
echo
welcome
