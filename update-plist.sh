#!/bin/zsh

LIBRARY_PREFERENCES_PATH="$HOME/Library/Preferences"
MYMAC_PLIST_PATH="$(dirname $0)/config/plist"

cd $MYMAC_PLIST_PATH

for plist (*.plist) {
    echo "remove $MYMAC_PLIST_PATH/$plist"
    rm "./$plist"
    echo "copy $LIBRARY_PREFERENCES_PATH/$plist => $MYMAC_PLIST_PATH/$plist"
    cp "$LIBRARY_PREFERENCES_PATH/$plist" "./$plist"
}

git status

