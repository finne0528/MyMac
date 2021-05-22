#!/bin/zsh

mkdir ~/IdeaProjects
cd ~/IdeaProjects || exit

mkdir claves
cd claves || exit

git clone ssh://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/barista-view-template
git clone ssh://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/medicmedia-auth-server
git clone git@github.com.claves:claves/chatform.git
git clone git@bitbucket.org.claves:claves/chatform-front.git

cd ..

git clone git@github.com:finne0528/discordbot-template-for-kotlin.git
git clone git@github.com:finne0528/watering.git
git clone git@github.com:finne0528/voice-watcher.git
git clone git@github.com:finne0528/MyMac.git
git clone git@github.com:finne0528/MyMac-Config.git
