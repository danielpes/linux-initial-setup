#!/bin/sh

DOWNLOADS_DIR=$HOME/Downloads
REPO = $HOME/git/ubuntu-init
CONFIG_DIR=$REPO/data/config

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
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -  # Node.js
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
	gconf2 \
	gir1.2-gtop-2.0  \
	gir1.2-networkmanager-1.0 \
	nautilus-actions \
	nodejs \
	openjdk-8-jdk \
	paper-cursor-theme \
	paper-icon-theme \
	ruby-full

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
cp $CONFIG_DIR/pure/* $PURE_DIR/
sudo ln -s "$PURE_DIR/async.zsh" /usr/local/share/zsh/site-functions/async
sudo ln -s "$PURE_DIR/pure.zsh" /usr/local/share/zsh/site-functions/async

# Zsh / Oh-My-Zsh
cp $CONFIG_DIR/zsh/.zshrc $HOME/.zshrc
sudo cp $CONFIG_DIR/zsh/zprofile /etc/zsh/zprofile

# Terminator
mkdir ~/.config/terminator/
cp -R $CONFIG_DIR/terminator/* $HOME/.config/terminator/

# VS Code
unzip -d ~/.config/Code/User $CONFIG_DIR/vscode-user.zip

# JetBrains
cp $CONFIG_DIR/intellij.jar $HOME/config/intellij.jar
cp $CONFIG_DIR/webstorm.jar $HOME/config/webstorm.jar


#### Enviornment Configuration ####

# TODO: Add gsettings and dconf commands

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
