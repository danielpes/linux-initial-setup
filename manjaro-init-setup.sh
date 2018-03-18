#!/bin/bash

#### Variables ####

DOWNLOADS_DIR=$HOME/Downloads
REPO=$HOME/git/linux-initial-setup
DATA_DIR=$REPO/data
CONFIG_DIR=$DATA_DIR/config

#### Directories ####

rm -r $HOME/Public $HOME/Templates
mkdir $HOME/apps
mkdir $HOME/config
mkdir $HOME/misc
cd $REPO

#### Instalations ####

# Basic
echo "===> Basic tools..."
sudo pacman -S --noconfirm --needed base-devel yaourt

# System upgrade
echo "===> Upgrading system..."
sudo pacman -Syu

# Install everything yaourt
echo "===> Runnning main yaourt install..."
yaourt -S --noconfirm --needed \
	arc-gtk-theme \
	flashplugin \
	franz \
	gitkraken \
	google-chrome \
	jdk8-openjdk \
	nvm \
	otf-fira-code \
	paper-icon-theme-git \
	pdftk \
	ruby \
	skypeforlinux-stable-bin \
	spotify \
	terminator \
	ttf-google-fonts-git \
	vim \
	visual-studio-code-bin
	

# nvm and node
echo "===> Installing node and npm global packages..."
export NVM_DIR="$HOME/.nvm"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install node

# npm global packages
npm install -g express-generator
npm install -g create-react-app
npm install -g typescript

# Global ruby gems
echo "===> Installing ruby gems..."
sudo gem install sass --no-user-install

# Gnome Extensions
echo "===> Installing extensions..."
mkdir -p $HOME/.local/share/gnome-shell/extensions/
./install-gnome-extension.sh install arc-menu@linxgem33.com
./install-gnome-extension.sh install auto-move-windows@gnome-shell-extensions.gcampax.github.com
./install-gnome-extension.sh install clock-override@gnomeshell.kryogenix.org
./install-gnome-extension.sh install dash-to-panel@jderose9.github.com
./install-gnome-extension.sh install gnome-shell-extensions.gcampax.github.com
./install-gnome-extension.sh install mediaplayer@patapon.info
./install-gnome-extension.sh install nohotcorner@azuri.free.fr
./install-gnome-extension.sh install panel-osd@berend.de.schouwer.gmail.com
./install-gnome-extension.sh install system-monitor@paradoxxx.zero.gmail.com

# Oh-My-Zsh
echo "===> Installing Oh-My-Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# VS Code extensions
code --install-extension dbaeumer.vscode-eslint
code --install-extension eg2.tslint
code --install-extension esbenp.prettier-vscode
code --install-extension robertohuertasm.vscode-icons
code --install-extension xabikos.ReactSnippets
code --install-extension zhuangtongfa.material-theme

#### Remaining Fonts ####

echo "===> Installing remaining fonts..."
mkdir $HOME/.local/share/fonts/
cp $DATA_DIR/fonts/* $HOME/.local/share/fonts/
fc-cache -f

#### Apps Configuration ####

echo "===> Copying configuration files..."

# Git
cp $CONFIG_DIR/git/.gitconfig ~/.gitconfig

# Pure Theme (ZSH)
PURE_DIR=$HOME/.local/share/pure-zsh
mkdir -p $PURE_DIR
cp $DATA_DIR/pure-zsh/* $PURE_DIR/
sudo ln -s "$PURE_DIR/pure.zsh" /usr/share/zsh/site-functions/prompt_pure_setup
sudo ln -s "$PURE_DIR/async.zsh" /usr/share/zsh/site-functions/async

# Zsh / Oh-My-Zsh
cp $CONFIG_DIR/zsh/zshrc $HOME/.zshrc
sudo cp $CONFIG_DIR/zsh/zprofile /etc/zsh/zprofile

# Franz (logo)
sudo cp $DATA_DIR/images/franz-logo.svg /usr/share/franz/logo.svg
sudo sed -i "s/^Icon=.*$/Icon=\/usr\/share\/franz\/logo.svg/" /usr/share/applications/franz.desktop

# Terminator
mkdir ~/.config/terminator/
cp -R $CONFIG_DIR/terminator/* $HOME/.config/terminator/

# Extensions
for p in $CONFIG_DIR/extensions/*/ ; do
    dirname=`basename "$p"`
    echo "===> Configuring extension $dirname..."
    dconf_path="/org/gnome/shell/extensions/$dirname/"
    cat $p/dump.dconf | dconf load $dconf_path
done

# Locale
sudo update-locale LANG="en_CA.UTF-8" LANGUAGE="en_CA.UTF-8" LC_ALL="en_AU.UTF-8"

#### Enviornment Configuration ####

echo "===> Configuring gsettings..."
gsettings set org.gnome.shell enabled-extensions "['user-theme@gnome-shell-extensions.gcampax.github.com', 'mediaplayer@patapon.info', 'system-monitor@paradoxxx.zero.gmail.com', 'dash-to-panel@jderose9.github.com', 'clock-override@gnomeshell.kryogenix.org', 'nohotcorner@azuri.free.fr', 'panel-osd@berend.de.schouwer.gmail.com']"
gsettings set org.gnome.desktop.background primary-color '#000000'
gsettings set org.gnome.desktop.background secondary-color '#000000'
gsettings set org.gnome.desktop.calendar show-weekdate true
gsettings set org.gnome.desktop.datetime automatic-timezone true
gsettings set org.gnome.desktop.default-applications.terminal exec 'terminator'
gsettings set org.gnome.desktop.default-applications.terminal exec-arg '--new-tab'
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface cursor-theme 'Paper'
gsettings set org.gnome.desktop.interface font-name 'Lato 11'
gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Darker'
gsettings set org.gnome.desktop.interface icon-theme 'Paper'
gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Mono 13'
gsettings set org.gnome.desktop.screensaver color-shading-type 'solid'
gsettings set org.gnome.desktop.screensaver picture-options 'wallpaper'
gsettings set org.gnome.desktop.screensaver picture-uri 'resource:///org/gnome/shell/theme/noise-texture.png'
gsettings set org.gnome.desktop.screensaver primary-color '#2e3436'
gsettings set org.gnome.desktop.screensaver secondary-color '#2e3436'
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "['<Shift><Super>w']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "['<Shift><Super>q']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Super>w']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Super>q']"
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Lato 11'
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
gsettings set org.gnome.settings-daemon.plugins.media-keys home '<Super>e'
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal '<Super>t'
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'google-chrome.desktop', 'terminator.desktop', 'spotify.desktop', 'franz.desktop', 'org.gnome.Software.desktop']"

echo "===> Configuring gconf..."
dconf write /org/gnome/shell/extensions/user-theme/name "'Arc-Dark'"


#### Reboot ####
echo ""
echo ""
echo "===================="
echo " Don't forget to update .giconfig!"
echo " Don't forget to add ssh keys and config!"
echo " REBOOT!"
echo "===================="
echo ""
