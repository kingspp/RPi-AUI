#!/bin/bash
# Utility Pi v1.5
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
#----------------------------------------------------------------------------
# Run this script after your first boot with archlinux (as root)
#----------------------------------------------------------------------------
# Default Variables
defsleep=1


#---------------------------------------------------------------------------
# Functions
#---------------------------------------------------------------------------
function thank() {
  echo ""
  echo ""
  echo "Thank You"
  echo "By Kingspp"
  sleep 1.5
  clear
  exit
}

function ask() {
echo "Are you sure? [Y/n]: "; read ch -n 1
[[ $ch == [Yy] ]] && echo "" || thank
}


#---------------------------------------------------------------------------
# Main
#---------------------------------------------------------------------------
# Check if user running as root
[[ "$UID" -ne 0 ]] && { echo "Please run as root"; exit 1; }
echo "User running as root!!"
echo "Got Superuser ability !!"
echo ""
sleep 1

# Print the title
clear
echo ""
echo "##############################################################"
echo "##   Welcome to Setup Pi v1.0                               ##"
echo "##   -- By kingspp                                          ##"
echo "##############################################################"
echo "  "
sleep 1

echo "Do you want to install Arch Linux Ultimate Install?"
ask
hash git 2>/dev/null && { echo "Installing Git..."; pacman -S --noconfirm git; }
cd /opt

# Clone the repository and setup
git clone https://github.com/kingspp/RPi-AUI
cd /opt/RPi-AUI/AUI/
chmod +x archi.sh
ln -s /opt/Raspberry-Pi-AUI/AUI/archi.sh /usr/bin/aui
ln -s /opt/Raspberry-Pi-AUI/AUI/disp.sh /usr/bin/aui-disp
ln -s /opt/Raspberry-Pi-AUI/AUI/oc.sh /usr/bin/aui-oc
ln -s /opt/Raspberry-Pi-AUI/AUI/userm.sh /usr/bin/aui-userm
ln -s /opt/Raspberry-Pi-AUI/AUI/util.sh /usr/bin/aui-util
echo "Installation is complete."
sleep 2
aui
