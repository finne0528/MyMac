#!/bin/zsh

cd $(dirname $0)

# check signed in to AppStore.
echo -n "Do you signed in to AppStore? (y/N): "
if read -q; then
    echo "\nThank you. the application will be installed from AppStore with homebrew mas.\n"
else
    echo "\nPlease sign in to install from AppStore with homebrew mas.\n"
    exit
fi

echo -n "Do you configure google drive security settings? (y/N): "
if read -q; then
    echo "\nThank you. You can use Google Drive App!\n"
else
    echo "\nPlease configure google drive security settings.\n"
    exit
fi

# install homebrew
if which brew > /dev/null; then
    echo 'Homebrew already installed.'
else
    echo "=================="
    echo "Install homebrew !"
    echo "=================="
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# application install with homebrew
echo "=============================================="
echo "Applications will be installed with Homebrew !"
echo "=============================================="
brew doctor
brew bundle
echo "please self install 'powermymac'"

# execute defaults settings
echo "=============================="
echo "Execute Mac default settings !"
echo "=============================="
/bin/zsh ./defaults

# skicka install and download .ssh from google drive
echo "============================================="
echo "Install goenv with anyenv to install skicka !"
echo "============================================="
eval "$(anyenv init -)"
anyenv install --init
anyenv install goenv
eval "$(anyenv init -)"

echo "==============================="
echo "Install golang latest version !"
echo "==============================="
GO_LATEST_VERSION=$(goenv install -l | grep -v - | tail -1)
goenv install $GO_LATEST_VERSION
goenv global $GO_LATEST_VERSION

echo "============================"
echo "Install skicka with golang !"
echo "============================"
go get github.com/google/skicka
skicka init

echo "========================="
echo "Download .ssh to ~/.ssh !"
echo "========================="
skicka download .ssh ~/.ssh

find ~/.ssh -type d -print | xargs chmod 755
find ~/.ssh -type f -print | xargs chmod 600

# vim settings
echo "==========================================="
echo "Configure vim settings and plugin manager !"
echo "==========================================="
mkdir ~/.vim
mkdir ~/.vim/colors
mkdir ~/.vim/bundle
cp vim/vimrc ~/.vimrc
cp vim/gvimrc ~/.gvimrc
cp vim/colors/molokai.vim ~/.vim/colors/molokai.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# install zprezto
echo "====================================="
echo "Install zprezto for iTerm2 customize."
echo "====================================="
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

# zprezto settings
echo "==================================="
echo "Configure zprezto - powerlevel10k !"
echo "==================================="
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

cp fonts/* ~/Library/fonts/

mv ~/.zpreztorc ~/.zpreztorc_temp
sed -e 's/sorin/powerlevel10k/g' ~/.zpreztorc_temp > ~/.zpreztorc
rm -rf ~/.zpreztorc_temp

# source .zpreztorc
source ~/.zpreztorc

# homebrew settings on .zprofile
echo "$(cat ./zprofile-customize)" >> ~/.zprofile

# source .zprofile
source ~/.zprofile

# add customize to zshrc
echo "$(cat ./zshrc-customize)" >> ~/.zshrc
echo "$(cat ./aliases)" >> ~/.zshrc

# source .zshrc
source ~/.zshrc

# open iterm2 to setting zprezto
open /Applications/iTerm.app

echo "finished !"

