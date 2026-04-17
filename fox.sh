#!/bin/bash

# ╔═[ 📄 LICENSE ]════════════════════════════════════════════════╗
# ║ This software is licensed under the Alofsto General Public    ║
# ║ License. It can be viewed at https://bit.ly/agplraw.          ║
# ╚═══════════════════════════════════════════════════════════════╝

# ===[ 🎨 COLOUR SETUP ]====================== #
color_black="\033[30m"; color_red="\033[31m"; color_green="\033[32m"; color_yellow="\033[33m"; color_blue="\033[34m"; color_magenta="\033[35m"; color_pink="\033[35m"; color_cyan="\033[36m"; color_white="\033[37m"
bgcolor_black="\033[40m";bgcolor_red="\033[41m"; bgcolor_green="\033[42m"; bgcolor_yellow="\033[43m"; bgcolor_blue="\033[44m"; bgcolor_magenta="\033[45m"; bgcolor_pink="\033[45m"; bgcolor_cyan="\033[46m"; bgcolor_white="\033[47m"
bold="\033[1m"; italic="\033[3m"; underline="\033[4m"; strikethrough="\033[9m"; reset="\033[0m"
# ===[ 📜 FUNCTIONS SETUP ]=================== #
repchar() { for i in {1..$2}; do echo -n "$1"; done ; }
progress () { spaces=""; printmsgprog () { if ! [ "${#1}" == "0" ]; then echo -n "$1 "; width=$(($(tput cols)-${#1}-3)); fi; if [ "${#1}" == "0" ]; then width=$(($(tput cols)-2)); fi }; printmsgprog "$2"; del=$(bc <<< "scale=10; ${1}/${width}"); for i in $(seq $width); do spaces="$spaces-"; done; echo -n -e "[$spaces]\r"; printmsgprog "$2"; echo -n "["; for i in $(seq $width); do echo -n "#"; sleep ${del}; done; if [ "$3" == "nr" ]; then echo -n -e "]\r"; else echo "]"; fi }
usingsudo(){ if [[ $EUID -ne 0 ]]; then return 1; fi }
# ============================================ #

foxpath="$HOME/.foxcmd"
cl=1
del=0.01
ver="5.3.3"
if [ -z "$1" ]; then
  echo -e ""
  echo -e "🦊 FoxCMD v$ver"
  sleep $del
  echo -e ""
  sleep $del
  echo -e "${bold}===== 📄 Commands =======================================${reset}"
  sleep $del
  echo -e "⬇️  install <package> [-c] • Installs a package"
  sleep $del
  echo -e "📦 list                   • Lists installable packages"
  sleep $del
  echo -e "👀 hdi <y/n> [o]          • Hides icons on your desktop" 
  sleep $del
  echo -e "⭐️ starwars               • Watch ascii starwars"
  sleep $del
  echo -e "⬇️  dl                     • Downloads a youtube video"
  sleep $del
  echo -e "🤖 aiperson <count>       • Bulk fetches thispersondoesnotexist.com"
  sleep $del
  echo -e "🔧 tweak <list/tweak>     • Simple tweaks for your mac"
  sleep $del
  echo -e "🔄 ezconv                 • Simplified ffmpeg CLI"
  sleep $del
  echo -e ""
  sleep $del
  echo -e "⬆️  update                 • Updates FoxCMD" 
  sleep $del
  echo -e "❌ remove                 • Removes FoxCMD from your computer"
  echo -e ""
  sleep $del
  echo -e "Command syntax: ${color_blue}\$ fox <command> <arguments>${reset}"
  sleep $del
  echo -e "Arguments: ${color_green}[optional] ${color_yellow}<required>"
  sleep $del
  cl=0
fi

# Redirects "install" and "list" commands to seperate command manager
if [ "$1" == "install" ]; then
  foxint-install package $2 $3 $4 $5
  cl=0
fi

if [ "$1" == "list" ]; then
  foxint-install list;
  cl=0
fi

if [ "$1" == "remove" ]; then
  read -p "⛔️ Are you sure you want to uninstall FoxCMD and it's standalone CLIs? y/n: " confirm
  if [ "$confirm" == "y" ]; then
    sed -i '/export PATH=\"\$PATH:$foxpath\"/d' .zshrc
    sed -i '/export PATH=\"\$PATH:$foxpath\"/d' .bashrc
    rm -r $foxpath
    echo -e "${color_green}✅ Completely uninstalled FoxCMD from your computer."
  elif [ "$confirm" == "n" ]; then
    echo -e "${color_red}❌ Uninstall canceled."
  else
    echo -e "${color_red}❌ Please enter either \"y\" or \"n\"."
  fi
  cl=0
fi
if [ "$1" == "update" ]; then
  echo -e ""
  sleep $del
  echo -e "${color_blue}⬇️  Downloading FoxCMD"
  sleep $del
  curl -fsSL "https://raw.githubusercontent.com/beckettclarke/FoxCMD/main/fox.sh" -o $foxpath/fox
  curl -fsSL "https://raw.githubusercontent.com/beckettclarke/FoxCMD/main/cmd/install.sh" -o $foxpath/foxint-install
  echo -e "${color_blue}📥 Installing FoxCMD..."
  sleep $del
  chmod 755 $foxpath/fox
  chmod 755 $foxpath/foxint-install
  echo -e "${color_green}✅ FoxCMD has been successfully updated!"
  sleep $del
  cl=0
fi
if [ "$1" == "hdi" ]; then
  if [ "$2" == "y" ]; then
    if [ "$3" == "o" ]; then
      defaults write com.apple.finder CreateDesktop false
      killall Finder
    else
      chflags hidden ~/Desktop/*
    fi
    echo -e "${color_green}✅ Hid desktop icons. To unhide, run \"fox hdi n\"" 
  fi
  if [ "$2" == "n" ]; then
    chflags nohidden ~/Desktop/*
    defaults delete com.apple.finder CreateDesktop
    killall Finder
    echo -e "${color_green}✅ Unhid desktop icons. To hide, run \"fox hdi y\"" 
  fi
  if [ -z "$2" ]; then
    echo -e "${color_red}❌ Please use \"fox hdi y\" or \"fox hdi n\""
  fi
  cl=0
fi
if [ "$1" == "starwars" ]; then
  echo -e "${color_yellow}⭐️ Loading starwars. To exit, press CTRL+C"
  sleep 1
  nc towel.blinkenlights.nl 23
  cl=0
fi

if [ "$1" == "aiperson" ]; then
  if [ -z "$2" ] || ! [[ "$2" =~ ^[0-9]+$ ]]; then
    echo -e "${color_red}❌ Please enter a valid number"
    sleep $del
    echo -e "Syntax: \"fox aiperson <number of people>\""
    cl=0
    exit 1
  fi
  echo -e ""
  echo -e "${color_blue}🏁 Setting things up..."
  echo -e ""
  mkdir ~/people
  sleep 0.1
  echo -e "${color_blue}🌐 Connecting to thispersondoesnotexist.com"
  sleep 0.1
  echo -e ""
  count=1
  for i in $(seq $2)
  do
    progress 0.7 "⬇️ Downloading ${count}/${2}" nr
    curl -fsSL "https://thispersondoesnotexist.com/image" -o ~/people/$count.jpg
    count=$((count+1))
  done
  echo -e ""
  echo -e "${color_blue}📂 Zipping files to desktop..."
  cd ~/people
  zip -q ~/Desktop/people.zip ./*
  sleep 0.3
  echo -e "${color_blue}🧼 Cleaning up..."
  cd
  rm -r ~/people
  echo -e ""
  echo -e "${color_green}✅ Saved $2 people to your desktop!"
  cl=0
fi
if [ "$1" == "tweak" ]; then
  if [ "$2" == "list" ] || [  -z "$2" ]; then
    echo -e "${bold}===== 🔧 Tweak list =====================================${reset}"
    sleep $del
    echo -e "🗂  openline [n]      • Adds a divider between open apps"
    sleep $del
    echo -e "💨 suck [n]          • Enables the hidden suck animation"
    sleep $del
    echo -e "⏩ instadock [n]     • Removes the delay on dock reveal"
    sleep $del
    echo -e "🗑  resetdock         • Resets your mac's dock"
    sleep $del
    echo -e "🪐 addspace [s]      • Adds a spacer to your dock"
    sleep $del
    echo -e ""
    sleep $del
    echo -e "Command syntax: \"fox tweak <tweak name>\" "
    sleep $del
    echo -e "${color_blue}ℹ️ Add \"n\" to the end of the command to disable the tweak."
  fi
  if [ "$2" == "openline" ]; then
    if [ "$3" == "n" ]; then
      defaults write com.apple.dock show-recents -bool true;
      defaults write com.apple.dock show-recent-count -int 3;
      killall Dock
      echo -e "${color_green}✅ Disabled the openline tweak."
    else
      defaults write com.apple.dock show-recents -bool true;
      defaults write com.apple.dock show-recent-count -int 0;
      killall Dock
      echo -e "${color_green}✅ Enabled the openline tweak."
    fi
  fi
  if [ "$2" == "suck" ]; then
    if [ "$3" == "n" ]; then
      defaults write com.apple.dock mineffect genie
      killall Dock
      echo -e "${color_green}✅ Disabled the suck animation."
    else
      defaults write com.apple.dock mineffect suck
      killall Dock
      echo -e "${color_green}✅ Enabled the suck animation."
    fi
  fi
  if [ "$2" == "resetdock" ]; then
    read -p "Are you sure you want to reset your dock? y/n: " confirm
    if [ "$confirm" == "y" ]; then
      defaults delete com.apple.dock
      killall Dock
      echo -e "${color_green}✅ Reset your dock to system defaults."
    elif [ "$confirm" == "n" ]; then
      echo -e "${color_red}❌ Dock reset canceled."
    else
      echo -e "${color_red}❌ Please enter either \"y\" or \"n\"."
    fi
  fi
  if [ "$2" == "addspace" ]; then
    if [ "$3" == "s" ]; then
      defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'
      killall Dock
    else
      defaults write com.apple.dock persistent-apps -array-add '{tile-type="spacer-tile";}'
      killall Dock
    fi
    echo -e "${color_green}✅ Added a spacer to your dock."
    echo -e "${color_blue}ℹ️  If it didn't work, you may have to run the command again."
  fi
  if [ "$2" == "instadock" ]; then
    if [ "$3" == "n" ]; then
      defaults delete com.apple.Dock autohide-delay
      killall Dock
      echo -e "${color_green}✅ Disabled instant dock reveal."
    else
      defaults write com.apple.Dock autohide-delay -float 0
      killall Dock
      echo -e "${color_green}✅ Enabled instant dock reveal."
    fi
  fi
  cl=0
fi

if [ "$1" == "dl" ]; then
  if [ ! "$foxpath/ytdlp" ]; then
    echo -e "${color_red}⚠️ ytdlp is required to use the \"dl\" command"
    foxint-install package ytdlp
  fi
  read -p "🎥 Please enter YouTube URL: " yturl
  if [[ "$yturl" == *'/playlist?list='* ]]; then
    echo -e "${color_blue}📄 Playlist detected. Which items do you want to download?"
    read -p "Format: \"first:last\" OR \"all\". Items: " playlistitems
    if [ "$playlistitems" == "all" ]; then
      ytdlp -f mp4 --embed-thumbnail -o '%(title)s.%(ext)s' "$yturl"
      echo -e "${color_green}✅ Saved all videos in playlist to your home folder!"
    else
      ytdlp -f mp4 --playlist-items $playlistitems --embed-thumbnail -o '%(title)s.%(ext)s' "$yturl"
      echo -e "${color_green}✅ Saved selected videos in playlist to your home folder!"
    fi
  else
    if [[ "$yturl" == *'/c/'* ]] || [[ "$yturl" == *'/@'* ]] ; then
      echo -e "${color_blue}📄 Channel detected. Which items do you want to download?"
      read -p "Format: \"first:last\" OR \"all\". Items: " channelitems
      if [ "$channelitems" == "all" ]; then
        ytdlp -f mp4 --embed-thumbnail -o '%(title)s.%(ext)s' "$yturl"
        echo -e "${color_green}✅ Saved all of the channels videos to your home folder!"
      else
        ytdlp -f mp4 --playlist-items $channelitems --embed-thumbnail -o '%(title)s.%(ext)s' "$yturl"
        echo -e "${color_green}✅ Saved the channels selected videos items to your home folder!"
      fi
    else
     ytdlp -f mp4 --embed-thumbnail -o '%(title)s.%(ext)s' "$yturl"
     echo -e "${color_green}✅ Saved the video to your home folder! "
    fi
  fi
  cl=0
fi
if [ "$1" == "ezconv" ]; then
  read -p "📄 File: " fullfile
  read -p "🔄 New format (E.x: \"webm\", \"mp4\"): " newformat
  fullfile=$(echo $fullfile | tr -d "'")
  filename=$(basename -- "$fullfile")
  extension="${filename##*.}"
  filename="${filename%.*}"
  echo "🔄  Converting from $extension to $newformat..."
  cp $fullfile $HOME/converting.$extension
  ffmpeg -i "$fullfile" "$HOME/Desktop/$filename.$newformat"
  rm $HOME/converting.$extension
  echo "✅ Converted $filename.$extension to $newformat format."
  cl=0
fi
if [ "$cl" == "1" ]; then
  echo
  sleep $del
  echo -e "${color_red}❌ Command not found: ${bold}$1${reset}"
  sleep $del
  echo -e "${color_yellow}💡 Run ${bold}\"fox\"${reset}${color_yellow} to see the command list"
fi
echo -e "${reset}"
