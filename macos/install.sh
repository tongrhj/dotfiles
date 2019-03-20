#!/bin/bash
set -ev

if [ "$(uname)" != "Darwin" ]; then
  echo "install.sh is meant for OS X only"
  exit 1
fi

DOTFILES_GIT_REPO=git@github.com:tongrhj/dotfiles.git

# Create a bare clone repository
# Dotfiles in $HOME are still under version control, no symlinks necessary
git clone --separate-git-dir=$HOME/.dotfiles $DOTFILES_GIT_REPO ~

function installXCode {
  echo "Installing xcode command line tools..."
  xcode-select --install
}

function getLatestBrew {
	echo "Installing latest homebrew..."
	which brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

	brew update
}

function brewInstall {
	echo "Installing brewfile..."
	(pushd brew && brew bundle install && brew bundle check && popd)
}

function finishBrewInstall {
  echo "Installing after brewfile..."

  $(brew --prefix)/opt/fzf/install # fzf key bindings and auto-complete
}

# function installSSHConfig {
#   echo "Installing ssh config..."
#   rm ~/.ssh/config
#   ln -s $PWD/ssh/config ~/.ssh/config && chmod 0700 ~/.ssh/config
# }

function installJitouch {
  echo "Installing jitouch2..."
  curl http://www.jitouch.com/jitouch_mojave.zip -o $PWD/jitouch.zip
  unzip $PWD/jitouch.zip
  open $PWD/jitouch/Jitouch.prefPane
  rm -rf $PWD/jitouch $PWD/__MACOSX $pwd/jitouch.zip # delete files created when installing jitouch
}

function installZSHPlugins {
  echo "Installing zsh plugins..."
  ZSH_PLUGIN_DIR=~/.oh-my-zsh/custom/plugins
  echo "Installing $ZSH_PLUGIN_DIR/zsh-syntax-highlighting"
  [ -d $ZSH_PLUGIN_DIR/zsh-syntax-highlighting ] \
    || git clone git@github.com:zsh-users/zsh-syntax-highlighting.git $ZSH_PLUGIN_DIR/zsh-syntax-highlighting

  echo 'eval "$(jump shell)"' >> $PWD/.zshrc # Add autojump

  echo '[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh' >> $PWD/.zshrc # Add fzf

  echo 'export GPG_TTY=$(tty)' >> $PWD/.zshrc # Added by Kypton
}

installXCode
getLatestBrew
brewInstall
installSymlinks
installJitouch
installZSHPlugins

echo "...install done ✅"
