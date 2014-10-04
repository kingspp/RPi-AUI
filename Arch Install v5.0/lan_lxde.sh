#!/bin/bash
# Command Pi v1.1
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.
#-------------------------------------------------------------------------------
# Run this script after your first boot with archlinux (as root)
#------------------------------------------------------------------------------------------------
function top()
{
clear
echo "##############################################################"
echo "##   Welcome to LANLxde v1.0                                ##"
echo "##   -- By kingspp                                          ##"
echo "##############################################################"
echo "  "
sleep 1
}

function ask()
{
  read ch
  if [ "$ch" == 'y' ]; then
  echo ""
  else
  clear
  exit
  fi
}


top
echo "Do you want to install LXDE available on LAN ? [y/n]  "
ask
echo "Installing . . ."
sleep 1
pacman -S --noconfirm xrdp lxde xf86-video-fbdev xorg-xinit xorg  xorg-server xorg-server-utils xterm 
echo "exec startlxde" > ~/.xinitrc










