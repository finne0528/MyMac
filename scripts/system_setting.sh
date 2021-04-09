#!/bin/zsh

# .DS_Store が作られないようにする
defaults write com.apple.desktopservices DSDontWriteNetworkStores True
# ライブ変換を無効化する
defaults write com.apple.inputmethod.Kotoeri JIMPrefLiveConversionKey -bool False
# トラックパッドのカーソル速度を変更する
defaults write -g com.apple.trackpad.scaling 2
# すべての拡張子のファイルを表示する
defaults write -g AppleShowAllExtensions -bool True
# タップでクリックを有効化
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool True
# サイレントクリックを有効化
defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -int 0
# 強めのクリックと感覚フィードバックを無効化
defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -int 0
defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool True
# クリック強度を弱いに
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 0
# スクリーンセーバを開始させない
defaults -currentHost write com.apple.screensaver idleTime -int 0
# スクリーンショットのファイル名を Screenshot に変更
defaults write com.apple.screencapture name Screenshot
# spotlight のキーボードショートカットを無効化
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>"
# spotlight の Finder の検索ウィンドウを表示を無効化
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>49</integer><integer>1572864</integer></array><key>type</key><string>standard</string></dict></dict>"
# dock に最近つかったアプリを表示しないようにする
defaults write com.apple.dock show-recents -bool False
# dock を左側に表示するようにする
defaults write com.apple.dock orientation -string left
# スリープしないようにする
sudo pmset -a disksleep 0
sudo pmset -a displaysleep 0
sudo pmset -a sleep 0
# 起動時にサウンドを再生を無効化
sudo nvram SystemAudioVolume=%80

# バッテリー残量をパーセンテージ表示する

# dock に表示するアイテムを設定する
dockitems=(
  "Launchpad"       "com.apple.launchpad.launcher"            "file:///System/Applications/Launchpad.app"
  "App Store"       "com.apple.AppStore"                      "file:///System/Applications/App%20Store.app"
  "iTerm"           "com.googlecode.iTerm2"                   "file:///Applications/iTerm.app"
  "Notion"          "notion.id"                               "file:///Applications/Notion.app"
  "IntelliJ IDEA"   "com.jetbrains.intellij"                  "file:///Applications/IntelliJ%20IDEA.app"
  "PyCharm"         "com.jetbrains.pycharm"                   "file:///Applications/PyCharm.app"
  "RubyMine"        "com.jetbrains.rubymine"                  "file:///Applications/RubyMine.app"
  "Google Chrome"   "com.google.Chrome"                       "file:///Applications/Google%20Chrome.app"
  "LINE"            "jp.naver.line.mac"                       "file:///Applications/LINE.app"
  "Tweeten"         "com.builtbymeh.tweeten"                  "file:///Applications/Tweeten.app"
  "Discord"         "com.hnc.Discord"                         "file:///Applications/Discord.app"
  "Slack"           "com.tinyspeck.slackmacgap"               "file:///Applications/Slack.app"
  "Mail for Gmail"  "com.rockysandstudio.DeskApp-for-Gmail"   "file:///Applications/Mail%20for%20Gmail.app"
  "1Password 7"     "com.agilebits.onepassword7"              "file:///Applications/1Password%207.app"
  "Audirvana"       "com.audirvana.Audirvana"                 "file:///Applications/Audirvana.app"
  "システム環境設定"   "com.apple.systempreferences"             "file:///System/Applications/System%20Preferences.app"
)
PLIST_PATH="$HOME/Library/Preferences/com.apple.dock.plist"
PLIST_BUDDY="/usr/libexec/PlistBuddy"

item_num=$((${#dockitems[*]} / 3))

${PLIST_BUDDY} -c "Delete persistent-apps" ${PLIST_PATH}
${PLIST_BUDDY} -c "Add persistent-apps array" ${PLIST_PATH}
for idx in $(seq 0 ${item_num}); do
  name_idx=${dockitems[$((idx * 3 + 1))]}
  item_idx=${dockitems[$((idx * 3 + 2))]}
  path_idx=${dockitems[$((idx * 3 + 3))]}

  $PLIST_BUDDY \
    -c "Add persistent-apps:${idx} dict" \
    -c "Add persistent-apps:${idx}:tile-data dict" \
    -c "Add persistent-apps:${idx}:tile-data:file-label string ${name_idx}" \
    -c "Add persistent-apps:${idx}:tile-data:bundle-identifier string ${item_idx}" \
    -c "Add persistent-apps:${idx}:tile-data:file-data dict" \
    -c "Add persistent-apps:${idx}:tile-data:file-data:_CFURLString string ${path_idx}" \
    -c "Add persistent-apps:${idx}:tile-data:file-data:_CFURLStringType integer 15" \
    ${PLIST_PATH}
done

echo "completed"
