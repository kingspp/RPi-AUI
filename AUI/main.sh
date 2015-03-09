#!/bin/bash
#---------------------------------------------------------------------------
# Modified by Ivan Tham <pickfire@riseup.net> - Sun Jan 18 09:40:33 UTC 2015
# SYNOPSIS      : main.sh [root] [title] [thank] [net]
#                 main.sh pkg_in|pkg_rm pkg1 [pkg2 ...]
#                 main.sh pkg_up|pkg_de
# DESCRIPTION   : Reuse code
# TODO(pickfire): add colors variable for use in main.sh
#---------------------------------------------------------------------------
#    Copyright (C) Prathyush 2015
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#---------------------------------------------------------------------------
# The default path, must be on every file
rpi_aui=/opt/RPi-AUI/AUI
defsleep=0  # function sleep time
uisleep=2
# ------------------------------------------------------------------------ #
# Color variable for use in main.sh
# Usage: . main.sh  (still not working)
# TODO: find a way to use in other scripts
# Bold: 1, Underline: 4, Highlight: 7, Blink: 8
# Color     # Strong(bold)   # Background       # Color Name
R="\033[91m"; SR="\033[91;1m"; BR="\033[91;1m"  # Red
G="\033[92m"; SG="\033[92;1m"; BG="\033[92;1m"  # Green
Y="\033[93m"; SY="\033[93;1m"; BY="\033[93;1m"  # Yellow
B="\033[94m"; SB="\033[94;1m"; BB="\033[94;1m"  # Blue
P="\033[95m"; SP="\033[95;1m"; BP="\033[95;1m"  # Pink
I="\033[96m"; SI="\033[96;1m"; BI="\033[95;1m"  # Indigo
W="\033[m"                       # White(reset)
# ------------------------------------------------------------------------ #


#---------------------------------------------------------------------------
# Functions
#---------------------------------------------------------------------------
function root() {   # exit 1 if not running as root
  #echo -en "Checking if user is running as \033[91mROOT\033[0m"; sleep 0.5
  #for i in $(seq 3); do echo -n '.'; sleep 1; done  # for some waiting time
  [[ $UID -eq 0 ]] && return 0 || { echo -e "\033[91mPlease run as root! \
Try '\033[32msudo archi\033[31m'\033[0m" >&2; exit 1; }
}

function net() {   # ping test to 8.8.8.8 (google.com)
  echo -en "Checking for internet connection"; sleep 0.2
  for i in $(seq 3); do echo -n '.'; sleep 0.8; done  # waiting time
  ping -c 3 8.8.8.8 &>/dev/null && { echo -e "${G}Success!\n$W"; return \
    0; } || { echo -e "${R}Failure! Please connect to the Internet!\n$W" >&2;
    return 1; }
}

function title() { echo -e "\033[92m\
      ____  ____  _       ___   __  ______
     / __ \/ __ \(_)     /   | / / / /  _/   The Raspberry PI
    / /_/ / /_/ / ______/ /| |/ / / // /    Arch Linux ARM
   / _, _/ ____/ /_____/ ___ / /_/ _/ /    [ Ultimate ]
  /_/ |_/_/   /_/     /_/  |_\____/___/   Installer\n\033[m"; return 0
}

function thank() {  # exit 0 if not rebooting
  echo; echo "Thank You --By Kingspp"   # add new line and ending message
  $rpi_aui/./yn.sh "Reboot to apply changes? [y/N]" && reboot || exit 0
}

function pkg() {    # Package management    USAGE: ./main.sh pkg_in pkg...
  case $(grep "^ID_LIKE=" /etc/*-release | cut -d= -f2)_${1: -2} in
    arch_in) pacman -S --noconfirm --needed ${*:2} ;;
    arch_rm) pacman -R --noconfirm ${*:2} ;;
    arch_up) pacman -Syu --noconfirm ;;
    arch_de) pacman-key --init ;;
    debian_in) apt-get -y install ${*:2} ;;
    debian_rm) apt-get -y remove ${*:2} ;;
    debian_up) apt-get -y update; apt-get -y dist-upgrade ;;
  esac
}


#---------------------------------------------------------------------------
# Main
#---------------------------------------------------------------------------
[[ ${1:0:3} = "pkg" ]] && pkg $* && exit 0  # Package management
for i in $*; do
  $i
done; exit 0    # return success to the system when the loop finish
