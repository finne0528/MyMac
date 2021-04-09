#!/bin/zsh

cd $(dirname $0) || exit

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

echo -n "Do you enable google drive api on google cloud platform? (y/N): "
if read -q; then
    echo "\nThank you. You can use Skicka!"
else
    echo "\nPlease enable google drive api on google cloud platform for use skicka."
    exit
fi

# install homebrew
if which brew > /dev/null; then
    echo 'Homebrew already installed.'
else
    echo "**********************"
    echo "* Install homebrew ! *"
    echo "**********************"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# application install with homebrew
echo "**************************************************"
echo "* Applications will be installed with Homebrew ! *"
echo "**************************************************"
brew doctor
brew update
brew bundle
echo "please self install 'powermymac'"

# execute system settings script
echo "****************************************"
echo "* Execute Mac system settings script ! *"
echo "****************************************"
/bin/zsh ./scripts/system_setting.sh

# skicka install and download .ssh from google drive
echo "*************************************************"
echo "* Install goenv with anyenv to install skicka ! *"
echo "*************************************************"
eval "$(anyenv init -)"
anyenv install --init
anyenv install goenv
eval "$(anyenv init -)"

echo "***********************************"
echo "* Install golang latest version ! *"
echo "***********************************"
GO_LATEST_VERSION=$(goenv install -l | grep -v - | tail -1 | xargs)
goenv install $GO_LATEST_VERSION
goenv global $GO_LATEST_VERSION

echo "********************************"
echo "* Install skicka with golang ! *"
echo "********************************"
go get github.com/google/skicka
eval "$(anyenv init -)"

skicka init
echo -n "Enter skicka client id: "
read SKICKA_CLIENT_ID
echo -n "Enter skicka client secret: "
read SKICKA_SECRET
sed -i -e "s/;clientid=YOUR_GOOGLE_APP_CLIENT_ID/clientid=$SKICKA_CLIENT_ID/g" ~/.skicka.config
sed -i -e "s/;clientsecret=YOUR_GOOGLE_APP_SECRET/clientsecret=$SKICKA_SECRET/g" ~/.skicka.config

echo "*****************************"
echo "* Download .ssh to ~/.ssh ! *"
echo "*****************************"
skicka download .ssh ~/.ssh

find ~/.ssh -type d -print | xargs chmod 755
find ~/.ssh -type f -print | xargs chmod 600

# clone MyMac-Config and setup dotfiles, app config files and plists
echo "*************************************************************************"
echo "* Clone MyMac-Config and Setup dotfiles, app config files, and plists ! *"
echo "*************************************************************************"
git clone git@github.com:finne0528/MyMac-Config.git config
/bin/zsh config/setup.sh

# vim settings
echo "**********************************"
echo "* Configure vim plugin manager ! *"
echo "**********************************"
mkdir ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
echo "Please run ':PluginInstall' on Vim."

# install zprezto
echo "********************************************************"
echo "* Install and Configure zprezto for iTerm2 customize ! *"
echo "********************************************************"
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

cp fonts/* ~/Library/fonts/

# open iterm2 to setting zprezto
echo "***************************************"
echo "* Please configure zprezto on iTerm ! *"
echo "***************************************"
open /Applications/iTerm.app

echo "finished !"
