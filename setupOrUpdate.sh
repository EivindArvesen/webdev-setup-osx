#!/bin/bash

install_from_array()
{
    COMMAND=$1
    shift
    for PROGRAM in "$@";
    do
        if [ "$COMMAND" = "brew install" ]; then
            $COMMAND $PROGRAM
        elif [ "$COMMAND" = "brew cask install" ]; then
            # Don't install apps that have already been installed (manually)
            [[ ! -d /opt/homebrew-cask/Caskroom/$PROGRAM ]] && [[ ! $(find /Applications -iname "$(echo $PROGRAM | tr - ' ')" | wc -l) -gt 0 ]] && $COMMAND $PROGRAM
        else
            echo "Error processing install-command..."
        fi
    done
}

declare -a brews=(
    bash-completion
    ctags-exuberant
    diction
    finch
    fpp
    gdb
    imagemagick
    irssi
    ispell
    htop-osx
    lynx
    node
    osxfuse
    pandoc
    reattach-to-user-namespace
    ssh-copy-id
    sqlmap
    terminal-notifier
    tidy-html5
    thefuck
    tmux
    upx
    wget
)

declare -a casks=(
    amethyst
    appcleaner
    caffeine
    cakebrew
    clipmenu
    cyberduck
    docker
    firefox
    flux
    github
    google-chrome
    honer
    imageoptim
    iterm2
    java
    karabiner
    keka
    less
    libreoffice
    macfusion
    mamp
    ngrok
    sequel-pro
    shortcat
    skim
    skype
    slate
    spotify
    sqlitebrowser
    sublime-text
    transmission
    vagrant
    virtualbox
    vivaldi
    vlc
    xquartz
)

# Fix Homebrew on El Capitan
sudo chown $(whoami):admin /usr/local && sudo chown -R $(whoami):admin /usr/local

# Set some OS X defaults

defaults write com.apple.dock autohide -bool true; # turn Dock auto-hidng on
defaults write NSGlobalDomain AppleShowAllExtensions -bool true; # show all file extensions
# Disable transparency in the menu bar and elsewhere on Yosemite
defaults write com.apple.universalaccess reduceTransparency -bool true
# Menu bar: hide the Time Machine, Volume, and User icons
for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
    defaults write "${domain}" dontAutoLoad -array \
        "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
        "/System/Library/CoreServices/Menu Extras/User.menu"
done
# Check for software updates daily, not just once per week
#defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
# Appearance: Graphite
defaults write -g AppleAquaColorVariant -int 6
# Set highlight color to graphite
defaults write NSGlobalDomain AppleHighlightColor -string "0.847059 0.847059 0.862745"
# Change minimize/maximize window effect
defaults write com.apple.dock mineffect -string "scale"
# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true
# Set the icon size of Dock items to 36 pixels
DOCK_W=$(echo `expr $(system_profiler SPDisplaysDataType|grep -m 1 Resolution|sed 's/:/ /'|awk '{print $2}')/40`|bc)
defaults write com.apple.dock tilesize -int $DOCK_W
# Remove the auto-hiding Dock delay
#defaults write com.apple.dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
#defaults write com.apple.dock autohide-time-modifier -float 0
# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "www.google.com"
# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
# Enable Safari’s debug menu
#defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

defaults write com.apple.screencapture location ~/Downloads
killall SystemUIServer

#killall Dock
#killall Finder

if [[ ! -d /Applications/Xcode.app ]]; then
    # install Xcode Command Line Tools
    # https://github.com/timsutton/osx-vm-templates/blob/ce8df8a7468faa7c5312444ece1b977c1b2f77a4/scripts/xcode-cli-tools.sh
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
    PROD=$(softwareupdate -l |
      grep "\*.*Command Line" |
      head -n 1 | awk -F"*" '{print $2}' |
      sed -e 's/^ *//' |
      tr -d '\n')
    softwareupdate -i "$PROD" -v;

    # Install command-line tools for Xcode...
    xcode-select --install
fi

# Check if brew is installed. Install if not.
command -v brew >/dev/null 2>&1 || { ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; }

# Various fixing of homebrew
brew doctor
# Linking
ls -1 /usr/local/Library/LinkedKegs | while read line; do
    echo $line
    brew unlink $line
    brew link --force $line
done

# BREW update (self + lists) and upgrade (software)
brew update && brew upgrade
brew upgrade brew-cask

# Check if cask is installed. Install if not.
#command -v brew cask > /dev/null 2>&1 || { brew tap phinze/cask; brew install brew-cask; }
#command -v brew cask > /dev/null 2>&1 || { brew install caskroom/cask/brew-cask; }
command -v brew cask > /dev/null 2>&1 || { brew install caskroom/cask/brew-cask; }

# symlink dotfiles
# ERROR HERE...
PWD=$(pwd)
cd $HOME
for i in $(ls -A dotfiles/)
do
    ln -s "$PWD/dotfiles/$i" "${i##*/}"
done
cd -

# Install brew
install_from_array 'brew install' "${brews[@]}"

# Install from cask
install_from_array 'brew cask install' "${casks[@]}"

# Fix iTerm2 tab width
defaults write com.googlecode.iterm2 OptimumTabWidth -int $(system_profiler SPDisplaysDataType | grep Resolution | sed 's/:/ /' | awk '{print $2}')
# see https://www.iterm2.com/documentation-hidden-settings.html for more

# Set Sublime Text 3 as Default App for text-files in Finder (using CFBundleIdentifier, found in app's  Contents/Info.plist)
defaults write com.apple.LaunchServices LSHandlers -array-add '{LSHandlerContentType=public.plain-text;LSHandlerRoleAll=com.sublimetext.3;}'

# Make Sublime Text available from the commandline, if not already.
command -v subl >/dev/null 2>&1 || { ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl; echo "Sublime now available with: subl"; }

# Fix for repetitive keys for Vintageous (Sublime Text)
defaults write com.sublimetext.3 ApplePressAndHoldEnabled -bool false

# install Oracle VM VirtualBox Extension Pack (needed to load OS X on VirtualBox)
# http://alanthing.com/blog/2013/03/17/virtualbox-extension-pack-with-one-line
#
# add --silent  to the curl command to silence download progress
export version=$(/usr/bin/vboxmanage -v) &&
export var1=$(echo ${version} | cut -d 'r' -f 1) &&
export var2=$(echo ${version} | cut -d 'r' -f 2) &&
export file="Oracle_VM_VirtualBox_Extension_Pack-${var1}-${var2}.vbox-extpack" &&
curl --location http://download.virtualbox.org/virtualbox/${var1}/${file} \
  -o ~/Downloads/${file} && VBoxManage extpack install ~/Downloads/${file} --replace &&
rm ~/Downloads/${file} &&
unset version var1 var2 file;

# Composer-specific stuff (PHP)
brew update
brew tap homebrew/homebrew-php
brew tap homebrew/dupes
brew tap homebrew/versions
brew install php55-intl
brew install homebrew/php/composer

# Upgrade bower
npm install -g npm
npm update -g

# Install bower
npm install -g bower

# Install grunt
npm install -g grunt
npm install -g grunt-cli

npm install -g coffee-script csslint http-server jscs jshint write-good
npm install -g clean-css uglifycss js-beautify html-minifier uglify-js minjson svgo

# Install fzf (command-line fuzzy finder), ctrl+t
brew reinstall --HEAD fzf
# Install shell extensions
/usr/local/Cellar/fzf/HEAD/install

# BREW clean
brew cleanup
brew cask cleanup

# Install Miniconda (Anaconda Python)
[[ ! -d $HOME/anaconda ]] && curl -L https://repo.continuum.io/miniconda/Miniconda-latest-MacOSX-x86_64.sh | bash

# Fix macosx (restore privacy) - https://fix-macosx.com
pip install pyobjc-core # workaround for long compile times
pip install pyobjc
curl https://fix-macosx.com/fix-macosx.py | python

# Install Tmux Plugin Manager
[[ ! -d  ~/.tmux/plugins/tpm ]] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Sublime Text: Copy package list
cp extras/sublime/* $HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/

mkdir -p $HOME/src/Bash/prm && git clone https://github.com/eivind88/prm.git $HOME/src/Bash/prm
cp extras/tmuxAuto.sh $HOME/src/Bash/

cp -r prefs/application_support/* $HOME/Library/Application\ Support/
cp -r prefs/preferences/* $HOME/Library/Preferences/

echo "All done!"
echo "Remember to manually install fonts"
