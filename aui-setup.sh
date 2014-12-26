#!/bin/bash
# SetUp Pi v1.0
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
#Default Variables
defsleep=1


#Functions
function top()
{
clear
echo "##############################################################"
echo "##   Welcome to Setup Pi v1.0                               ##"
echo "##   -- By kingspp                                          ##"
echo "##############################################################"
echo "  "
sleep 1
}

function checkr()
{
if [ "$UID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
echo "User running as root!!"
echo "Got Superuser ability !!"
echo ""
sleep 1
}


function pingcheck
{
  top
  echo "To check if the pi got Internet??!!"
  echo " "
  if ping -c 3 google.com &> /dev/null
  then
    echo "Success! Pi's got net!!'"
    sleep $uisleep
    echo " "
  else
    echo "Fail! Please connect to the Internet and Try Again"
    echo "  "
  fi
  thank
}

function ask()
{
echo "Are you sure? [y/n]: "
read ch
if [ "$ch" == 'y' ]; then
echo ""
else
thank
fi
}

function thank()
{
echo ""
echo ""
echo "Thank You"
echo "By Kingspp"
sleep 1.5
clear
exit
}

checkr
top
pingcheck
echo "Do you want to install Arch Linux Ultimate Install? "
ask
if [ ! -x /usr/bin/git ]; then
  printf "Installing Git . . . "
  pacman -S --noconfirm git  
fi
cd /opt
git clone https://github.com/kingspp/Raspberry-Pi-AUI
cd Raspberry-Pi-AUI/AUI/
chmod +x archi.sh
ln -s /opt/Raspberry-Pi-AUI/AUI/archi.sh /usr/bin/aui
ln -s /opt/Raspberry-Pi-AUI/AUI/disp.sh /usr/bin/disp
ln -s /opt/Raspberry-Pi-AUI/AUI/oc.sh /usr/bin/oc
ln -s /opt/Raspberry-Pi-AUI/AUI/userm.sh /usr/bin/userm
ln -s /opt/Raspberry-Pi-AUI/AUI/util.sh /usr/bin/util
echo "Installation is complete."
sleep 2
aui

