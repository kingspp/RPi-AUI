#!/bin/bash
#Arch Installer- Raspberry Pi v5.0
#Remove Carriage return sed -i 's/ \r//g' <filename>
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


#---------------------------------------------------------------------------
# Defaults Declared Here

defsleep=0;
uisleep=2;
showwelcome==

# Functions Declared Here

function perm()
{	
	top
	echo " Changing Permissions. . . "
	sleep $defsleep
	chmod +x archi.sh
	chmod +x command.sh
	chmod +x disp.sh
	chmod +x oc.sh
	chmod +x resize.sh
	chmod +x userm.sh
	chmod +x util.sh
}


function top()
{
  clear
  echo "##############################################################"
  echo "##   Welcome to Arch Linux - Raspberry Pi Setup v3.0        ##"
  echo "##   -- By kingspp                                          ##"
  echo "##############################################################"
  echo "  "
  sleep $defsleep
}

function checkr()
{
  if [ "$UID" -ne 0 ]
    then echo "Please run as root"
    exit
  fi
  echo "User running as root!!"
  sleep $defsleep
}

function ask()
{
  read ch
  if [ "$ch" == 'y' ]; then
  echo ""
  else
  thank
  fi
}

function thank
{
  top
  echo ""
  echo ""
  echo "Thank You"
  echo "--By Kingspp"
  echo " Reboot the system to apply changes?? [y/n]"
  read ch
  if [ "$ch" == 'y' ]; then
  reboot
  else
  clear
  exit
  fi
}

function pingcheck
{
  top
  echo "To check if the pi got Internet??!!"
  echo " "
  if ping -c 5 google.com &> /dev/null
  then
    echo "Success! Pi's got net!!'"
    sleep $uisleep
    echo " "
  else
    echo "Fail! Please connect to the Internet and Try Again"
    echo "  "
  fi
  ui
}

function defins()
{
  ## Installation
  top
  echo "Updating Arch Linux to its Latest Release"
  echo " "
  pacman -Syu --noconfirm  # To update the Arch Linux to the latest Release
  sleep $defsleep
  echo "Installing utilities"
  echo " "
  pacman-key --init
  pacman -S --noconfirm archlinux-keyring
  pacman-key --populate archlinux
  pacman  -S --noconfirm bash # To install bash for scripting
  pacman  -S --noconfirm coreutils # To install Core-Utilities
  pacman  -S --noconfirm util-linux # To install Linux-Utilities
  pacman  -S --noconfirm devtools # To install Development Tools
  pacman -S --noconfirm git
  sleep $defsleep
}

function partm()
{
  top
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
}

function passm()
{
  ## Password Update
  echo "Please enter a new password for the root"
  echo " "
  passwd # To set new password for Root User
  sleep $defsleep+1
  ui
}

function util()
{
  top  
  ./util.sh
}

function hname()
{
  echo "Your hostname is: "
  hostname
  echo "Do you want to change the host name? [y/n]"
  ask
  cp /etc/hostname /etc/hostname.old
  rm /etc/hostname
  touch /etc/hostname
  echo "Enter a Hostname:"
  read hn
  echo "$hn" >> /etc/hostname
  echo ""
  echo "Your Hostname is: "
  hostname
}

function ui
{
  ##User Interface
  top
  echo "Press q to quit"
  echo " ** --> To do (Be Cautious)"
  echo ""
  echo "########################################################"
  echo "1. Ping Check                   c. Command Pi v1.0 **   "
  echo "2. Arch Linux Update		d. Display Pi v1.1"
  echo "3. Partition Manager **		o. OverClocking PI v1.2	"	
  echo "4. User Management 	        u. Utility Pi v1.1"
  echo "5. Change Password "
  echo "6. Change Locale **"
  echo "7. Hostname"
  echo "8. Resize root file system"
  echo "9. Default Installation"  
  echo "########################################################"
  echo ""
  echo "Select an option: "
  read opt
  case $opt in
	  1) echo "Ping Check Selected" 
	  echo ""
	  pingcheck
	  read s
	  ui
	  ;;
	  
	  2)top
	  echo "Do you want to update Arch? [y/n]"
	  echo ""
	  ask   
	  echo "Updating Arch Linux to its Latest Release"
	  echo " "
	  pacman -Syu --noconfirm  # To update the Arch Linux to the latest Release
	  sleep $defsleep
	  echo " You have the latest Arch ;) "
	  ui
	  ;;
	  
	  3) echo "Manage Partitions? [y/n]"
	  echo ""
	  ask
	  partm
	  read s
	  ui
	  ;;
	  
	  4) echo "User Management"
	  echo ""	  
	  ./userm.sh
	  ui
	  ;;
	  
	  5) echo "Do you want to change Password? [y/n]"	  
	  ask
	  passm	  
	  ;;
	  
	  6) echo "Do you want to change the Locale? [y/n]"
	  ask
	  echo "Default Locale: "
	  sleep $defsleep
	  grep -v ^# /etc/locale.gen
	  read s
	  ui
	  ;;
	  
	  7)hname
	  read s
	  ui
	  ;;
	  
	  8)./resize.sh	  
	  ;;
	  
	  
	  9) echo "Default Installation: "
	  pingcheck
	  defins
	  addu	  
	  ./oc.sh
	  passm
	  util
	  hname
	  read s
	  ui
	  ;;
	  
	  c) echo "You have selected Command Pi"
	  sleep $uisleep	  
	  ./command.sh
	  ;;
	  
	  d) echo " You have selected Display Pi "
	  sleep $uisleep	  
	  ./disp.sh
	  read s
	  ui
	  ;;
	  
	  o) echo "Do you want to OverClock PI? [y/n]"
	  echo ""
	  ask
	  echo "Overclocking"
	  echo "Please make sure oc.sh is present in the same directory"
	  sleep $uisleep	  
	  ./oc.sh
	  read s
	  ui
	  ;;
	  
	  u) echo "You have selected Utility Pi "
	  sleep $uisleep
	  util
	  ;;
	  
	  q) thank	  
	  ;;
   esac
}





#-------------------------------------------------------------------------------


##Main
## To check if its running as Root
top
echo "To check if user is running as Root"
checkr
perm
sleep $defsleep
ui
