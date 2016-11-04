#! /usr/bin/env bash
### Setup for MacOS (v10.11, v10.12)
### Modified from https://github.com/why-jay/osx-init

echo "Setting up dock..."
defaults write com.apple.dock tilesize -int 36                 # smaller icon sizes
defaults write com.apple.dock autohide -bool true              # turn auto-hidng on
defaults write com.apple.dock autohide-delay -float 0          # remove show delay
defaults write com.apple.dock autohide-time-modifier -float 0  # remove show delay
defaults write com.apple.dock orientation left                 # place Dock on left
killall Dock 2>/dev/null
killall Finder 2>/dev/null

echo "Installing Xcode CLI tools..."
# https://github.com/timsutton/osx-vm-templates/blob/ce8df8a7468faa7c5312444ece1b977c1b2f77a4/scripts/xcode-cli-tools.sh
# Create the placeholder file that's checked by CLI updates' .dist code in Apple's SUS catalog
touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
# Find the CLI Tools update and install
PROD=$(softwareupdate -l | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n')
softwareupdate -i "$PROD" -v

echo "Installing Homebrew..."
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Installing various apps via Homebrew and Cask..."
brew install \
  ssh-copy-id \
  boost \
  caskroom/cask/brew-cask \
  docker \
  boot2docker \
  git \
  mysql \
  openssl \
  pssh \
  postgresql \
  python \
  python3 \
  redis \
;
brew tap caskroom/versions;
brew cask install \
  firefox \
  google-chrome \
  macdown \
  java \
  rstudio \
  skype \
  slack \
  spectacle \
  spotify \
  sublime-text \
  vagrant \
  xquartz \
;

echo "Updating RVM, ruby version..."
curl -sSL https://get.rvm.io | bash -s stable --ruby
rvm install 2.2
rvm use 2.2 --default

echo "Setting up ~/.bash_profile...";
cp ./bash_profile.template >> ~/.bash_profile;

echo "Setting up ~/.vimrc...";
touch ~/.vimrc;
echo "highlight OverLength ctermbg=red ctermfg=white guibg=#592929" >> ~/.vimrc;
echo "match OverLength /\\%81v.\\+/" >> ~/.vimrc;

echo "Setting up git configurations..."
git config --global credential.helper osxkeychain  # store git credentials
git config --global push.default simple            # set 'simple' as default push behavior
git config --global alias.b branch
git config --global alias.co checkout
git config --global alias.d diff
git config --global alias.dc 'diff --cached'
git config --global alias.lo 'log --oneline'
git config --global alias.s status
