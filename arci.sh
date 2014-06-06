#!/bin/bash

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
echo "##################################################################"
echo "## 		Welcome to the Arch Linux - Raspberry Pi Setup  ##"
echo "## 		By kingspp      		        	##"
echo "##################################################################"

#---------------------------------------------------------------------------
# Functions Declared Here

function pingcheck
{
echo "To check if the pi got Internet??!!"
if ping -c 5 google.com &> /dev/null
then
  echo "Success!"
  echo " "
else
  echo "Fail! Please connect to the Internet and Try Again"
  echo "  "
fi
}

#-------------------------------------------------------------------------------

## To check if its running as Root
echo "To check if its running as Root"
echo " "
if [ "$UID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


## Ping Check
#pingcheck # To check for an Internet Connection
echo " "

## Password Update
echo "Please enter a new password for the root"
echo " "
#passwd # To set new password for Root User


## Installation
echo "Updating Arch Linux to its Latest Release"
echo " "
# pacman -Syu  # To update the Arch Linux to the latest Release
echo "Instlling Utilities"
echo " "
#pacman-key --init
#pacman -S archlinux-keyring
#pacman-key --populate archlinux
#pacman -Syu --ignore filesystem
#pacman -S filesystem --force
#pacman  -S bash # To install bash for scripting
#pacman  -S coreutils # To install Core-Utilities
#pacman  -S util-linux # To install Linux-Utilities
#pacman  -S devtools # To install Development Tools



## Partition Manager (To Do)
echo " Lets Utilize full size of the Memory Card "
echo "Partition Manager"
echo " "
echo " Commands "
echo " "
echo "d  - delete a partition"
echo "l   -list known partition types"
echo "n   -add a new partition"
echo "p   -print the partition table"
echo "t   -change a partition type"
echo "v   -verify the partition table"
echo " "

#fdisk /dev/mmcblk0

## SUDO Installation
echo "Lets install sudo"
echo " "
#pacman -S sudo

##User Addition
echo "Lets create an User Account"
echo " "
echo " Please enter the name for the user account"
#read name
# useradd -m -g users -s /bin/bash -G audio,games,lp,optical,power,scanner,storage,video $name
addin = "%sudo ALL= '('ALL')' NOPASSWD: ALL"


 echo $addin  >  /etc/sudoers.tmp
 #groupadd sudo
 usermod -a -G sudo $name
 echo "Enter the password for new user"
 echo " "
 #passwd $name
 




















