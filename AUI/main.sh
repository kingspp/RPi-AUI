#!/bin/bash
#---------------------------------------------------------------------------
# Created by Ivan Tham <pickfire@riseup.net> - Fri Jan 16 15:23:48 UTC 2015
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
function root() {
  [[ $UID -eq 0 ]] && echo "User running as root." || echo -e "\033[91mPlease run as root!\033[0m"
}

function title() {  # put whatever title you like here
  echo -e "\033[92m     ____  ____  _       ___   __  ______                "
  echo -e "\033[92m    / __ \/ __ \(_)     /   | / / / /  _/   Raspberry Pi "
  echo -e "\033[92m   / /_/ / /_/ / ______/ /| |/ / / // /    ArchLinux-Arm "
  echo -e "\033[92m  / _, _/ ____/ /_____/ ___ / /_/ _/ /    [ Ultimate ]   "
  echo -e "\033[92m /_/ |_/_/   /_/     /_/  |_\____/___/   Installer       "
  echo -e "\033[0m"; return 0
}

function thank() {
  echo
  echo "Thank You --By Kingspp"
  $path/./yn.sh "Reboot to apply changes? [y/N]" && reboot || exit 0
}


# Main
for i in $*; do
  $i
done
