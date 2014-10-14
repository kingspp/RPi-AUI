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
echo "##   Welcome to Root System Resize v1.0                     ##"
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

echo "Do you want to resize the root partition to the maximum?[y/n]:  "
ask
fdisk /dev/mmcblk0 <<EOF
d
2
n
e
2


n
l


w
EOF
reboot










