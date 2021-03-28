#!/bin/zsh

cd $(dirname $0)

# check signed in to AppStore.
echo -n "Do you signed in to AppStore? (y/N): "
if read -q; then
    echo "\nThank you. the application will be installed from AppStore with homebrew mas."
else
    echo "\nPlease sign in to install from AppStore with homebrew mas."
    exit
fi

# install homebrew
if which brew > /dev/null; then
    echo 'Homebrew already installed.'
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# application install with homebrew
brew doctor
brew bundle
echo "please self install 'powermymac'"

# execute defaults settings
/bin/zsh ./defaults

# enable aliases
/bin/zsh ./aliases

# skicka install and download .ssh from google drive
anyenv install --init
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

# install zprezto
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

# zprezto settings
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

