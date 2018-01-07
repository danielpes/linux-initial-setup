#!/bin/sh

DOWNLOADS_DIR=$HOME/Downloads
REPO=$HOME/git/ubuntu-init
DATA_DIR=$REPO/data
CONFIG_DIR=$DATA_DIR/config

#### Directories ####
echo "Preparing directories..."
rm -r $HOME/Public $HOME/Templates
mkdir $HOME/apps
mkdir $HOME/config
mkdir $HOME/git
mkdir $HOME/misc
cd $REPO

#### Instalations ####

# Basic tools
echo "Installing basic tools..."
sudo apt-get -y --force-yes update
sudo apt-get install -y apt-transport-https build-essential curl terminator vim zsh

# Add repositories and keys
echo "Adding repositories and keys..."
sudo add-apt-repository -y ppa:snwh/pulp # Paper themes
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg # VS Code		
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg # VS Code
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list # VS Code

# Update apt
sudo apt-get -y --force-yes update

# Install everything apt
echo "Runnning main apt-get install..."
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
    libssl-dev \
    nautilus-actions \
    openjdk-8-jdk \
    paper-cursor-theme \
    paper-icon-theme \
    ruby-full

# nvm and node
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

# npm global packages
npm install -g express-generator
npm install -g create-react-app
npm install -g typescript

# Google Chrome
echo "Installing Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O $DOWNLOADS_DIR/google-chrome.deb
sudo dpkg -i $DOWNLOADS_DIR/google-chrome.deb

# GitKraken
echo "Installing GitKraken..."
wget https://release.gitkraken.com/linux/gitkraken-amd64.deb -O $DOWNLOADS_DIR/gitkraken.deb
sudo dpkg -i $DOWNLOADS_DIR/gitkraken.deb

# Franz 5.0.0
echo "Installing Franz..."
wget https://github.com/meetfranz/franz/releases/download/v5.0.0-beta.14/franz_5.0.0-beta.14_amd64.deb -O $DOWNLOADS_DIR/franz.deb
sudo dpkg -i $DOWNLOADS_DIR/franz.deb

# Spotify
echo "Installing Spotify..."
sudo snap install spotify

# JetBrains toolbox
echo "Installing JetBrains Toolbox..."
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.6.2914.tar.gz -O $DOWNLOADS_DIR/jetbrains-toolbox.tar.gz
tar -xf $DOWNLOADS_DIR/jetbrains-toolbox-1.6.2914.tar.gz -C $DOWNLOADS_DIR --wildcards --no-anchored 'jetbrains-toolbox' --strip-components 1
$DOWNLOADS_DIR/jetbrains-toolbox

# Oh-My-Zsh
echo "Installing Oh-My-Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Final steps
echo "Running final steps..."
sudo dpkg --configure -a
sudo apt-get --fix-broken install -y
sudo apt-get -y upgrade

#### Apps Configuration ####

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
unzip -o -d ~/.config/Code/User/ $CONFIG_DIR/vscode/User.zip

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

cp $DATA_DIR/fonts/* $HOME/.local/share/fonts/

#### Enviornment Configuration ####

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
gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Darker'
gsettings set org.gnome.desktop.interface icon-theme 'Paper'
gsettings set org.gnome.desktop.screensaver picture-uri 'file:///usr/share/backgrounds/Planking_is_going_against_the_grain_by_mendhak.jpg'
gsettings set org.gnome.desktop.screensaver primary-color '#000000'
gsettings set org.gnome.desktop.screensaver secondary-color '#000000'
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "['<Shift><Super>w']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "['<Shift><Super>q']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Super>w']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Super>q']"
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
gsettings set org.gnome.settings-daemon.plugins.media-keys home '<Super>e'
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal '<Super>t'
gsettings set org.gnome.shell enabled-extensions "['user-theme@gnome-shell-extensions.gcampax.github.com', 'mediaplayer@patapon.info', 'panel-osd@berend.de.schouwer.gmail.com', 'system-monitor@paradoxxx.zero.gmail.com']"
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'google-chrome.desktop', 'terminator.desktop', 'spotify.desktop', 'franz.desktop', 'org.gnome.Software.desktop']"
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'

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
