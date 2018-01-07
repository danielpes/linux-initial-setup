#!/bin/bash

#### Variables ####

DOWNLOADS_DIR=$HOME/Downloads
REPO=$HOME/git/ubuntu-init
DATA_DIR=$REPO/data
CONFIG_DIR=$DATA_DIR/config

#### Directories ####

echo "===> Preparing home directories..."
rm -r $HOME/Public $HOME/Templates
mkdir $HOME/apps
mkdir $HOME/misc
cd $REPO

#### Instalations ####

# Basic tools
echo "===> Installing basic tools..."
sudo apt-get update
sudo apt-get install -y apt-transport-https build-essential curl terminator vim zsh
sudo apt-get -y upgrade

# Add repositories and keys
echo "===> Adding repositories and keys..."
sudo add-apt-repository "deb http://archive.canonical.com/ubuntu $(lsb_release -sc) partner" # Partners
sudo add-apt-repository -y ppa:snwh/pulp # Paper themes
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg # VS Code		
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg # VS Code
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list # VS Code

# Update apt
sudo apt-get update

# Install everything apt
echo "===> Runnning main apt-get install..."
sudo apt-get install -y \
    adobe-flashplugin \
    arc-theme \
    build-essential \
    code \
    fonts-firacode \
    fonts-inconsolata \
    fonts-lato \
    fonts-open-sans \
    fonts-roboto \
    gconf2 \
    gir1.2-gtop-2.0  \
    gir1.2-networkmanager-1.0 \
    gir1.2-clutter-1.0 \
    libssl-dev \
    nautilus-actions \
    openjdk-8-jdk \
    paper-cursor-theme \
    paper-icon-theme \
    ruby-full

fc-cache -f

# nvm and node
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

# npm global packages
npm install -g express-generator
npm install -g create-react-app
npm install -g typescript

# Global ruby gems
sudo gem install sass --no-user-install

# Gnome Extensions
echo "===> Downloading extensions..."
wget -O $DOWNLOADS_DIR/media-player.zip "https://extensions.gnome.org/download-extension/mediaplayer@patapon.info.shell-extension.zip?version_tag=7663"
wget -O $DOWNLOADS_DIR/system-monitor.zip "https://extensions.gnome.org/download-extension/system-monitor@paradoxxx.zero.gmail.com.shell-extension.zip?version_tag=6808"
wget -O $DOWNLOADS_DIR/panel-osd.zip "https://extensions.gnome.org/download-extension/panel-osd@berend.de.schouwer.gmail.com.shell-extension.zip?version_tag=7569"

mkdir -p "$HOME/.local/share/gnome-shell/extensions/apanel-osd@berend.de.schouwer.gmail.com"
mkdir -p "$HOME/.local/share/gnome-shell/extensions/system-monitor@paradoxxx.zero.gmail.com"
mkdir -p "$HOME/.local/share/gnome-shell/extensions/panel-osd@berend.de.schouwer.gmail.com"

unzip -o $DOWNLOADS_DIR/media-player.zip -d "$HOME/.local/share/gnome-shell/extensions/mediaplayer@patapon.info"
unzip -o $DOWNLOADS_DIR/system-monitor.zip -d "$HOME/.local/share/gnome-shell/extensions/system-monitor@paradoxxx.zero.gmail.com"
unzip -o $DOWNLOADS_DIR/panel-osd.zip -d "$HOME/.local/share/gnome-shell/extensions/panel-osd@berend.de.schouwer.gmail.com"

# Google Chrome
echo "===> Installing Google Chrome..."
wget -O $DOWNLOADS_DIR/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i $DOWNLOADS_DIR/google-chrome.deb

# GitKraken
echo "===> Installing GitKraken..."
wget -O $DOWNLOADS_DIR/gitkraken.deb https://release.gitkraken.com/linux/gitkraken-amd64.deb
sudo dpkg -i $DOWNLOADS_DIR/gitkraken.deb

# Franz 5.0
echo "===> Installing Franz..."
wget -O $DOWNLOADS_DIR/franz.deb https://github.com/meetfranz/franz/releases/download/v5.0.0-beta.14/franz_5.0.0-beta.14_amd64.deb
sudo dpkg -i $DOWNLOADS_DIR/franz.deb

# Spotify
echo "===> Installing Spotify..."
sudo snap install spotify

# JetBrains toolbox
echo "===> Installing JetBrains Toolbox..."
wget -O $DOWNLOADS_DIR/jetbrains-toolbox.tar.gz https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.6.2914.tar.gz
tar -xf $DOWNLOADS_DIR/jetbrains-toolbox-1.6.2914.tar.gz -C $DOWNLOADS_DIR --wildcards --no-anchored 'jetbrains-toolbox' --strip-components 1
$DOWNLOADS_DIR/jetbrains-toolbox

# Oh-My-Zsh
echo "===> Installing Oh-My-Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Final steps
echo "===> Running final steps..."
sudo dpkg --configure -a
sudo apt-get --fix-broken install -y
sudo apt-get -y upgrade

#### Apps Configuration ####

echo "===> Copying configuration files..."

# Pure Theme (ZSH)
PURE_DIR=$HOME/.local/share/pure-zsh
mkdir $PURE_DIR
cp $DATA_DIR/pure-zsh/* $PURE_DIR/
sudo ln -s "$PURE_DIR/async.zsh" /usr/local/share/zsh/site-functions/async
sudo ln -s "$PURE_DIR/pure.zsh" /usr/local/share/zsh/site-functions/pure

# Zsh / Oh-My-Zsh
cp $CONFIG_DIR/zsh/zshrc $HOME/.zshrc
sudo cp $CONFIG_DIR/zsh/zprofile /etc/zsh/zprofile

# Terminator
mkdir ~/.config/terminator/
cp -R $CONFIG_DIR/terminator/* $HOME/.config/terminator/

# VS Code
unzip -o $CONFIG_DIR/vscode/User.zip -d ~/.config/Code/User/

# JetBrains
cp $CONFIG_DIR/intellij.jar $HOME/config/intellij.jar
cp $CONFIG_DIR/webstorm.jar $HOME/config/webstorm.jar

# Extensions
for p in $CONFIG_DIR/extensions/*/ ; do
    dirname=`basename "$p"`
    src_path=$p
    dst_path=$HOME/.local/share/gnome-shell/extensions/$dirname
    echo "copying from $src_path to $dst_path"
    cp $src_path/* $dst_path/
done

#### Fonts ####

echo "===> Installing remaining fonts..."
cp $DATA_DIR/fonts/* $HOME/.local/share/fonts/
fc-cache -f

#### Enviornment Configuration ####

echo "===> Configuring gsettings..."
gsettings set com.ubuntu.update-manager first-run false
gsettings set com.ubuntu.update-manager show-details true
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/Lighthouse_at_sunrise_by_Frenchie_Smalls.jpg'
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
gsettings set org.gnome.desktop.screensaver picture-uri 'file:///usr/share/backgrounds/Planking_is_going_against_the_grain_by_mendhak.jpg'
gsettings set org.gnome.desktop.screensaver primary-color '#000000'
gsettings set org.gnome.desktop.screensaver secondary-color '#000000'
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "['<Shift><Super>w']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "['<Shift><Super>q']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Super>w']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Super>q']"
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Lato 11'
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
gsettings set org.gnome.settings-daemon.plugins.media-keys home '<Super>e'
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal '<Super>t'
gsettings set org.gnome.shell enabled-extensions "['user-theme@gnome-shell-extensions.gcampax.github.com', 'mediaplayer@patapon.info', 'panel-osd@berend.de.schouwer.gmail.com', 'system-monitor@paradoxxx.zero.gmail.com']"
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'google-chrome.desktop', 'terminator.desktop', 'spotify.desktop', 'franz.desktop', 'org.gnome.Software.desktop']"
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'

sudo sed -i "s/^\(\s*font-family:\).*$/\1 Lato;/" /usr/share/themes/Arc-Dark/gnome-shell/gnome-shell.css # Top bar font

#### Requires interaction ####

# Ubuntu Restricted Extras
sudo apt-get install -y ubuntu-restricted-extras

#### Reboot ####
echo ""
echo ""
echo "===================="
echo " REBOOT! "
echo "===================="
echo ""
