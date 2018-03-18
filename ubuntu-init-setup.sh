#!/bin/bash

#### Variables ####

DOWNLOADS_DIR=$HOME/Downloads
REPO=$HOME/git/ubuntu-initial-setup
DATA_DIR=$REPO/data
CONFIG_DIR=$DATA_DIR/config

#### Directories ####

rm -r $HOME/Public $HOME/Templates
mkdir $HOME/apps
mkdir $HOME/config
mkdir $HOME/misc
cd $REPO

#### Instalations ####

# Basic tools
echo "===> Installing basic tools..."
sudo apt update
sudo apt -y full-upgrade
sudo apt install -y apt-transport-https build-essential gnome-shell curl terminator vim zsh

# Add repositories and keys
echo "===> Adding repositories and keys..."
sudo add-apt-repository "deb http://archive.canonical.com/ubuntu $(lsb_release -sc) partner" # Partners
sudo add-apt-repository -y ppa:snwh/pulp # Paper themes
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg # VS Code		
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg # VS Code
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list # VS Code

# Update apt
echo "===> apt update..."
sudo apt update

# Install everything apt
echo "===> Runnning main apt install..."
sudo apt install -y \
    adobe-flashplugin \
    arc-theme \
    build-essential \
    chrome-gnome-shell \
    code \
    fonts-firacode \
    fonts-inconsolata \
    fonts-lato \
    fonts-open-sans \
    fonts-roboto \
    gconf2 \
    gir1.2-clutter-1.0 \
    gir1.2-gtop-2.0  \
    gir1.2-networkmanager-1.0 \
    gnome-tweak-tool \
    libssl-dev \
    nautilus-actions \
    openjdk-8-jdk \
    openssh-server \
    paper-cursor-theme \
    paper-icon-theme \
    pdftk \
    ruby-full

fc-cache -f

# nvm and node
echo "===> Installing nvm, node and npm global packages..."
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
export NVM_DIR="$HOME/.nvm"
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
./install-gnome-extension.sh install arc-menu@linxgem33.com
./install-gnome-extension.sh install auto-move-windows@gnome-shell-extensions.gcampax.github.com
./install-gnome-extension.sh install clock-override@gnomeshell.kryogenix.org
./install-gnome-extension.sh install dash-to-panel@jderose9.github.com
./install-gnome-extension.sh install gnome-shell-extensions.gcampax.github.com
./install-gnome-extension.sh install mediaplayer@patapon.info
./install-gnome-extension.sh install nohotcorner@azuri.free.fr
./install-gnome-extension.sh install panel-osd@berend.de.schouwer.gmail.com
./install-gnome-extension.sh install system-monitor@paradoxxx.zero.gmail.com

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
tar -xf $DOWNLOADS_DIR/jetbrains-toolbox.tar.gz -C $DOWNLOADS_DIR --wildcards --no-anchored 'jetbrains-toolbox' --strip-components 1
$DOWNLOADS_DIR/jetbrains-toolbox

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

# Final steps
echo "===> Running final steps..."
sudo apt remove --purge gnome-shell-extension-ubuntu-dock
sudo apt --fix-broken install -y
sudo apt -y upgrade
sudo dpkg --configure -a
sudo apt -y autoremove

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
mkdir $PURE_DIR
cp $DATA_DIR/pure-zsh/* $PURE_DIR/
sudo ln -s "$PURE_DIR/pure.zsh" /usr/local/share/zsh/site-functions/prompt_pure_setup
sudo ln -s "$PURE_DIR/async.zsh" /usr/local/share/zsh/site-functions/async

# Zsh / Oh-My-Zsh
cp $CONFIG_DIR/zsh/zshrc $HOME/.zshrc
sudo cp $CONFIG_DIR/zsh/zprofile /etc/zsh/zprofile

# Franz (logo)
sudo cp $DATA_DIR/images/franz-logo.svg /opt/Franz/logo.svg
sudo sed -i "s/^Icon=.*$/Icon=\/opt\/Franz\/logo.svg/" /usr/share/applications/franz.desktop

# Terminator
mkdir ~/.config/terminator/
cp -R $CONFIG_DIR/terminator/* $HOME/.config/terminator/

# JetBrains
cp $CONFIG_DIR/jetbrains/intellij.jar $HOME/config/
cp $CONFIG_DIR/jetbrains/webstorm.jar $HOME/config/

# Extensions
for p in $CONFIG_DIR/extensions/*/ ; do
    dirname=`basename "$p"`
    echo "===> Configuring extension $dirname..."
    dconf_path="/org/gnome/shell/extensions/$dirname/"
    cat $p/dump.dconf | dconf load $dconf_path
done

# Locale
sudo update-locale LANG="en_CA.UTF-8" LANGUAGE="en_CA.UTF-8" LC_ALL="en_AU.UTF-8"

# Gnome Shell theme configuration
sudo update-alternatives --set gdm3.css /usr/share/gnome-shell/theme/gnome-shell.css
sudo sed -i "s/^\(\s*font-family:\).*$/\1 Lato;/" /usr/share/gnome-shell/theme/gnome-shell.css # Lock screen fonts (and some other places)
sudo sed -i "s/^\(\s*font-family:\).*$/\1 Lato;/" /usr/share/themes/Arc-Dark/gnome-shell/gnome-shell.css # Change top bar font

# Plymouth theme color
sudo sed -i "s/^\(Window.SetBackgroundTopColor \)(0.16, 0.00, 0.12)/\1\(0.18, 0.20, 0.21\)/" /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.script
sudo sed -i "s/^\(Window.SetBackgroundBottomColor \)(0.16, 0.00, 0.12)/\1\(0.18, 0.20, 0.21\)/" /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.script

#### Enviornment Configuration ####

echo "===> Configuring gsettings..."
gsettings set com.ubuntu.update-manager first-run false
gsettings set com.ubuntu.update-manager show-details true
gsettings set org.gnome.shell enabled-extensions "['user-theme@gnome-shell-extensions.gcampax.github.com', 'mediaplayer@patapon.info', 'system-monitor@paradoxxx.zero.gmail.com', 'dash-to-panel@jderose9.github.com', 'clock-override@gnomeshell.kryogenix.org', 'nohotcorner@azuri.free.fr', 'panel-osd@berend.de.schouwer.gmail.com']"
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

#### Requires interaction ####

# Ubuntu Restricted Extras
sudo apt install -y ubuntu-restricted-extras

#### Reboot ####
echo ""
echo ""
echo "===================="
echo " Don't forget to update .giconfig!"
echo " Don't forget to add ssh keys and config!"
echo " REBOOT!"
echo "===================="
echo ""
