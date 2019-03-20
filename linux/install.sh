#!/bin/bash
set -ev

if [ "$(uname)" != "Linux" ]; then
  echo "This install script is meant for Linux (Debian) only"
  exit 1
fi

# Create a bare clone repository
# Dotfiles in $HOME are still under version control, no symlinks necessary
function init {
  DOTFILES_GIT_REPO=git@github.com:tongrhj/dotfiles.git

  git clone --separate-git-dir=$HOME/.dotfiles $DOTFILES_GIT_REPO tmpdotfiles
  rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
  rm -r tmpdotfiles
}

function getLatestBrew {
  echo "Installing homebrew dependencies..."
  sudo apt-get install build-essential curl file git

	echo "Installing latest homebrew..."
  which brew || sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

  # test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv) # For home directory installs
  test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  # test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile #CentOS/Fedora/RedHat
  echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile # Debian/Ubuntu

	brew update
}

function brewInstall {
	echo "Installing brewfile..."
  echo $PWD/Brewfile
	(brew bundle install --verbose --file=$HOME/linux/Brewfile && brew bundle check --verbose --file=$HOME/linux/Brewfile)
}

function finishBrewInstall {
  echo "Installing after brewfile..."

  $(brew --prefix)/opt/fzf/install # fzf key bindings and auto-complete
}

function installZSHPlugins {
  echo "Installing zsh plugins..."
  ZSH_PLUGIN_DIR=~/.oh-my-zsh/custom/plugins
  echo "Installing $ZSH_PLUGIN_DIR/zsh-syntax-highlighting"
  [ -d $ZSH_PLUGIN_DIR/zsh-syntax-highlighting ] \
    || git clone git@github.com:zsh-users/zsh-syntax-highlighting.git $ZSH_PLUGIN_DIR/zsh-syntax-highlighting
}

# init
# getLatestBrew
brewInstall
installZSHPlugins

echo "...install done ✅"
