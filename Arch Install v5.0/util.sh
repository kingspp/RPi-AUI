#!/bin/bash
# Utility Pi v1.1
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
echo "##   Welcome to Utility Pi v1.1				    ##"
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
sleep 1
clear
exit
}

function view
{
top
echo " Utilities available:"
echo ""
echo "1. Transmission - A torrent Client"
echo "2. Webmin - Administer Raspberry Pi from browser"
echo "3. Samba - Windows Remote Client"
echo "4. NTFS-3G - Mount NTFS Partitions"
echo "5. Git - Git client for Github"
echo "6. VSFTPD - FTP client for Pi"
echo "7. Nano - File Editor for Pi"
echo "8. XRDP - Windows RDP Client for Arch"
echo "9. XBMC - An awesome Media manager for Raspberry pi"
echo ""
echo "Please Select from the options [1-7]: "
read opt
echo ""
case $opt in
1)  echo "You have Selected Transmission"
ask
echo "Installing Transmission . . . "
pacman -S --noconfirm --needed transmission-cli 
printf "Enabling Transmission Service . . . "
systemctl enable transmission 
ui
;;

2)  echo "You have Selected Webmin"
ask
pacman -S --noconfirm --needed webmin
ui
;;

3)  echo "You have Selected Samba"
ask
pacman -S --noconfirm --needed samba
ui
;;

4)  echo "You have Selected NTFS-3G"
ask
pacman -S --noconfirm --needed ntfs-3g
ui
;;

5)  echo "You have Selected Git"
ask
pacman -S --noconfirm --needed git
ui
;;

6)  echo "You have Selected VSFTPD"
ask
pacman -S --noconfirm --needed vsftpd
ui
;;

7)  echo "You have Selected Nano"
ask
pacman -S --noconfirm --needed nano
ui
;;

8)  echo "You have Selected XRDP"
ask
pacman -S --noconfirm --needed xrdp
ui
;;

9)  echo "You have Selected XBMC"
ask
pacman -S xbmc-rbp --noconfirm --needed && /usr/bin/systemctl enable xbmc
ui
;;
esac
}

function defins()
{
top
echo "Install Essential Utilities?"
ask
pacman -S transmission samba webmin ntfs-3g nano vsftpd git xrdp
read s
ui
}

function ui
{
top  
echo "Press q to exit"
echo ""
echo "1. View all utilities"
echo "2. Default Installation"
echo ""
echo "Enter your choice [1-2]: "
read opt
case $opt in
1) view
;;

2) defins
;;

q)thank
;;
esac
}
#-----------------------------------------------------------------------------------------------
checkr
ui
