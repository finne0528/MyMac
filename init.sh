#!/bin/bash

cd $(dirname $0)

# install homebrew
if which brew > /dev/null; then
    echo 'Homebrew already installed.'
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# install zprezto
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

# zprezto settings
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

cp fonts/* ~/Library/fonts/

sed -i -e 's/sorin/powerlevel10k/g' ~/.zpreztorc

# source .zpreztorc
source ~/.zpreztorc

# homebrew settings on .zprofile
echo "$(cat ./zprofile-customize)" > ~/.zprofile

# add customize to zshrc
echo "$(cat ./zshrc-customize)" > ~/.zshrc
echo "$(cat ./aliases)" > ~/.zshrc

# source .zshrc
source ~/.zshrc

# application install
brew doctor
brew bundle

echo "please self install 'powermymac'"

# execute defaults settings
/bin/bash ./defaults

# skicka install and download .ssh from google drive
anyenv install goenv
relogin

GO_LATEST_VERSION=$(goenv install -l | grep -v - | tail -1)
goenv install $GO_LATEST_VERSION
goenv global $GO_LATEST_VERSION

go get github.com/google/skicka
skicka init
skicka download .ssh ~/.ssh

# vim settings
mkdir ~/.vim
mkdir ~/.vim/colors
cp vim/vimrc ~/.vimrc
cp vim/gvimrc ~/.gvimrc
cp vim/colors/molokai.vim ~/.vim/colors/molokai.vim

echo "finished !"

