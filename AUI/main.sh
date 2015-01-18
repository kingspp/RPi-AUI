#!/bin/bash
#---------------------------------------------------------------------------
# Modified by Ivan Tham <pickfire@riseup.net> - Sun Jan 18 09:40:33 UTC 2015
# USAGE		    : main.sh [root] [title] [thank]
# DESCRIPTION	: Reuse code
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
path=/opt/RPi-AUI/AUI
defsleep=0  # function sleep time
uisleep=2


# Functions
function root() {   # exit 1 if not running as root
  echo -en "Checking if user is running as \033[91mROOT\033[0m"; sleep 0.5
  for i in $(seq 3); do echo -n '.'; sleep 1; done  # for some waiting time
  [[ $UID -eq 0 ]] && echo -e "\033[92mUser running as root.\033[0m" || { \
    echo -e "\033[91mPlease run as root!\033[0m"; exit 1; }
}

function title() {  # put whatever title you like here
  echo -e "\033[92m     ____  ____  _       ___   __  ______                "
  echo -e "\033[92m    / __ \/ __ \(_)     /   | / / / /  _/   Raspberry Pi "
  echo -e "\033[92m   / /_/ / /_/ / ______/ /| |/ / / // /    ArchLinux-Arm "
  echo -e "\033[92m  / _, _/ ____/ /_____/ ___ / /_/ _/ /    [ Ultimate ]   "
  echo -e "\033[92m /_/ |_/_/   /_/     /_/  |_\____/___/   Installer       "
  echo -e "\033[0m"; return 0
}

function thank() {  # exit 0 if not rebooting
  echo; echo "Thank You --By Kingspp"   # add new line and ending message
  $path/./yn.sh "Reboot to apply changes? [y/N]" && reboot || exit 0
}


# Main
for i in $*; do
  $i
done; exit 0    # return success to the system when the loop finish
