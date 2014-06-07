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


#---------------------------------------------------------------------------
# Functions Declared Here

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
echo ""
echo ""
echo "Thank You"
echo "By Kingspp"
echo " Reboot the system to apply changes?? [y/n]"
read ch
if [ "$ch" == 'y' ]; then
reboot
else
exit
fi
}

function pingcheck
{
echo "To check if the pi got Internet??!!"
echo " "
if ping -c 5 google.com &> /dev/null
then
  echo "Success! Pi's got net!!'"
  sleep 1
  echo " "
else
  echo "Fail! Please connect to the Internet and Try Again"
  echo "  "
fi
}



function defins()
{
## Installation
echo "Updating Arch Linux to its Latest Release"
echo " "
pacman -Syu  # To update the Arch Linux to the latest Release
sleep 1
echo "Instlling Utilities"
echo " "
pacman-key --init
pacman -S archlinux-keyring
pacman-key --populate archlinux
pacman  -S bash # To install bash for scripting
pacman  -S coreutils # To install Core-Utilities
pacman  -S util-linux # To install Linux-Utilities
pacman  -S devtools # To install Development Tools
pacman -S git
sleep 1
}

function partm()
{
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

function addu()
{
echo "Lets create an User Account"
echo " "
echo " Please enter the name for the user account"
read name
useradd -m -g users -s /bin/bash -G audio,games,lp,optical,power,scanner,storage,video $name
echo "##
## User privilege specification
##
root ALL=(ALL) ALL
pi ALL=(ALL) ALL" >>  /etc/sudoers
groupadd sudo
usermod -a -G sudo $name
echo "Enter the password for new user"
echo " "
passwd $name
}

function passm()
{
## Password Update
echo "Please enter a new password for the root"
echo " "
#passwd # To set new password for Root User
sleep 1
}

function util()
{
## SUDO Installation
echo "Lets install sudo"
echo " "
sleep 1
#pacman -S sudo
}

function ui
{

##User Interface
clear
top
echo "########################################################"
echo "1. Ping Check"
echo "2. Arch Linux Update"
echo "3. Partition Manager **"
echo "4. Add Users"
echo "5. OverClocking PI"
echo "6. Change Passwords **"
echo "7. Install Utilities **"
echo "8. Change Locale **"
echo "9. Hostname"
echo "########################################################"
echo ""
echo "Select an option"
read opt
case $opt in
1) echo "Ping Check Selected" 
echo ""
pingcheck
;;

2) echo "Do you want to update Arch? [y/n]"
echo ""
ask
defins
;;

3) echo "Manage Partitions? [y/n]"
echo ""
ask
partm
;;

4) echo "Do you want to add an User ? [y/n]"
echo ""
ask
addu
;;

5) echo "Do you want to OverClock PI? [y/n]"
echo ""
ask
echo "Overclocking"
echo "Please make sure oc.sh is present in the same directory"
sleep 1
chmod +x oc.sh
./oc.sh
;;

6) echo "Do you want to change Passwords? [y/n]"
echo ""
ask
passm
;;

7) echo "Do you want to install Utilities? [y/n]"
echo ""
ask
util
;;

8) echo "Do you want to change the Locale? [y/n]"
ask
echo "Default Locale: "
sleep 1
grep -v ^# /etc/locale.gen
;;

9)  echo "Your hostname is: "
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
thank




esac

}

function top()
{
echo "##################################################################"
echo "## 		Welcome to the Arch Linux - Raspberry Pi Setup  ##"
echo "## 		By kingspp      		        	##"
echo "##################################################################"
sleep 1
}
#-------------------------------------------------------------------------------



## To check if its running as Root
echo "To check if its running as Root"
echo " "
checkr

ui














 
 




 
 
 

 




















