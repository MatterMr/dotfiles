#!/bin/zsh

# Install xcode cli tools
echo "Installing commandline tools..."
xcode-select --install

# Homebrew
echo "Installing Brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
export PATH=/opt/homebrew/bin:$PATH
brew analytics off

## Taps
echo "Tapping Brew..."
brew tap homebrew/bundle
brew tap koekeishiya/formulae
brew tap FelixKratz/formulae

## Formulae
echo "Installing Brew Formulae..."

### Essentials
brew install gsl
brew install llvm
brew install wget
brew install gh
brew install jq
brew install mas
brew install switchaudio-osx
brew install stow
brew install skhd
brew install sketchybar
brew install borders
brew install yabai

### Terminal
brew install neovim
brew install tmux
brew install starship
brew install zsh-autosuggestions
brew install zoxide

### Fun
brew install btop
brew install cmatrix
brew install neofetch
brew install lazygit
brew install dooit
brew install spotify_player

### Dev
brew install cmake
brew install make
brew install ripgrep
brew install pyenv

## Casks
echo "Installing Brew Casks..."

brew install --cask kitty
brew install --cask utm
brew install --cask vlc
brew install --cask discord
brew install --cask betterdiscord-installer
brew install --cask alfred
brew install --cask firefox
brew install --cask notion
brew install --cask mullvadvpn
brew install --cask obsidian

## Fonts
brew install --cask sf-symbols
brew install --cask font-hack-nerd-font
brew install --cask font-jetbrains-mono
brew install --cask font-fira-code

# Mac Appstore Apps
echo "Installing Mac App Store Apps..."

mas install 497799835 #Xcode
mas install 409183694 #Keynote

# macOS Settings
echo "Changing macOS defaults..."

osascript -e 'tell application "System Preferences" to quit'

defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.spaces spans-displays -bool false
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock "mru-spaces" -bool "false"
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write com.apple.LaunchServices LSQuarantine -bool false
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain _HIHideMenuBar -bool true
defaults write NSGlobalDomain AppleHighlightColor -string "0.49804 0.79216 0.80784"
defaults write NSGlobalDomain AppleAccentColor -int 1
defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.Finder AppleShowAllFiles -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder ShowStatusBar -bool false
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool YES
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
defaults write -g NSWindowShouldDragOnGesture YES

# Plant configuration files
echo "Planting configuration files"
stow .

# Starting Services
brew services start borders
brew services start sketchybar
skhd --start-service
yabai --start-service
