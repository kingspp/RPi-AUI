#!/bin/bash
# Uninstall Pi v1.0
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
echo "##   Uninstall Pi v1.0                                      ##"
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
echo "Do you want to uninstall Arch Linux Ultimate Install? "
ask
cd /opt
rm -rf Raspberry-Pi-AUI
rm /usr/bin/aui
rm /usr/bin/disp
rm /usr/bin/oc
rm /usr/bin/userm
rm /usr/bin/util
echo "Uninstallation is complete."
sleep 2
aui