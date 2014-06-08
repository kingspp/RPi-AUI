#!/bin/bash
#Arch Installer- Raspberry Pi v2.0
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

function top()
{
clear
echo "##############################################################"
echo "##   Welcome to Arch Linux - Raspberry Pi Setup v2.0        ##"
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
sleep 1
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
echo "By Kingspp"
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
top
echo "Updating Arch Linux to its Latest Release"
echo " "
pacman -Syu  # To update the Arch Linux to the latest Release
sleep 1
echo "Installing utilities"
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

function addu()
{
top
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
passwd # To set new password for Root User
sleep 1
}

function util()
{
top
chmod +x util.sh
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
echo "1. Ping Check			d. Display Pi v1.1"
echo "2. Arch Linux Update		o. OverClocking PI v1.2"
echo "3. Partition Manager **		u. Utility Pi v1.1"	
echo "4. Add Users"
echo "5. Change Passwords **"
echo "6. Change Locale **"
echo "7. Hostname"
echo "8. Default Installation"
echo "########################################################"
echo ""
echo "Select an option"
read opt
case $opt in
1) echo "Ping Check Selected" 
echo ""
pingcheck
read s
ui
;;

2) echo "Do you want to update Arch? [y/n]"
echo ""
ask
defins
read s
ui
;;

3) echo "Manage Partitions? [y/n]"
echo ""
ask
partm
read s
ui
;;

4) echo "Do you want to add an User ? [y/n]"
echo ""
ask
addu
read s
ui
;;

5) echo "Do you want to change Passwords? [y/n]"
echo ""
ask
passm
read s
ui
;;

6) echo "Do you want to change the Locale? [y/n]"
ask
echo "Default Locale: "
sleep 1
grep -v ^# /etc/locale.gen
read s
ui
;;

7)  hname
read s
ui
;;

8) echo "Default Installation: "
pingcheck
defins
addu
chmod +x oc.sh
./oc.sh
passm
util
hname
read s
ui
;;

d) echo " You have selected Display Pi v1.0"
chmod +x disp.sh
./disp.sh
read s
ui
;;

o) echo "Do you want to OverClock PI? [y/n]"
echo ""
ask
echo "Overclocking"
echo "Please make sure oc.sh is present in the same directory"
sleep 1
chmod +x oc.sh
./oc.sh
read s
ui
;;

u) util
;;

q) thank
clear
exit
;;
esac
}
#-------------------------------------------------------------------------------
## To check if its running as Root
echo "To check if its running as Root"
echo " "
checkr
sleep 1
ui














 
 




 
 
 

 




















