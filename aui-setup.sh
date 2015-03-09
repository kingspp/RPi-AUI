#!/bin/bash
# Utility Pi v1.5
# Description:  Install or uninstall RPi-AUI
# Usage:        ./aui-setup.sh --help
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
aui_path=/opt
defsleep=1


#---------------------------------------------------------------------------
# Functions
#---------------------------------------------------------------------------
function thank() {
  echo ""
  echo "Thank You"
  echo "By Kingspp"
  sleep 1.5
  clear
  exit 0
}

function do_uninstall() {
  echo "Uninstall is still in progress."
  exit 0
}

function do_help() {
  echo "Usage: $0 [uninstall|help]
Run without any argument will default to installtion."
  exit 0
}


#---------------------------------------------------------------------------
# Main
#---------------------------------------------------------------------------
# Help and uninstallation
[[ $# -gt 1 || $1 == *h* ]] && do_help  # Help if 'h' is specified
[[ $1 == *uninstall ]] && do_uninstall  # Uninstall if specified
[[ $# -gt 0 && -n $1 ]] && do_help      # Help for those enter nonsense

# Root privilege
[[ $UID -ne 0 ]] && { echo -e "\e[31mPlease run as root!\e[m"; exit 1; }

# Print the title
echo ""
echo "##############################################################"
echo "##   Welcome to Setup Pi v1.0                               ##"
echo "##   -- By kingspp                                          ##"
echo "##############################################################"
echo "  "
sleep 1

# Confirmation for installation
read -p "Do you want to install Arch Linux Ultimate Install? " -e -n 1 ch
[[ $ch != [Yy] ]] && thank

# Install dependencies
hash git 2>/dev/null || { echo "Installing Git..."; pacman -S --noconfirm git; }

# Clone the repository and setup
cd /opt && git clone https://github.com/kingspp/RPi-AUI && cd RPi-AUI/AUI
chmod +x archi.sh
ln -s /opt/RPi-AUI/AUI/archi.sh /usr/bin/aui
ln -s /opt/RPi-AUI/AUI/disp.sh /usr/bin/aui-disp
ln -s /opt/RPi-AUI/AUI/oc.sh /usr/bin/aui-oc
ln -s /opt/RPi-AUI/AUI/userm.sh /usr/bin/aui-userm
ln -s /opt/RPi-AUI/AUI/util.sh /usr/bin/aui-util
echo "Installation is complete."
sleep 2
aui
