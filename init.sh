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

# download secret files from google drive
echo -n "Press Enter when you can login to Google Drive > " || read enter
echo "********************************************************"
echo "* Create secret files symbolic links from Google Drive *"
echo "********************************************************"
ln -s /Users/finne/Google\ Drive/マイドライブ/MyMac/.ssh /Users/finne/.ssh
ln -s /Users/finne/Google\ Drive/マイドライブ/MyMac/.aws /Users/finne/.aws

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
