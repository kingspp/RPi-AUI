#!/bin/bash
# Modified by Ivan Tham <pickfire@riseup.net> - Tue Feb  3 01:43:56 UTC 2015
# Utility Pi v2.0
# DESCRIPTION	: Utility
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
# Variables
rpi_aui=/opt/RPi-AUI/AUI; aui_doc=/opt/RPi-AUI/doc
#Default Variables
defsleep=1

#----------------------------------------------------------------------------
# Functions
#----------------------------------------------------------------------------
function top() {
clear
echo "##############################################################"
echo "##   Welcome to Utility Pi v2.0                             ##"
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

function util_ui() {
  $rpi_aui/./main.sh title
  echo -en " Utilities available:

1. Transmission - A torrent Client                     a.Install Alsa-Mixer
2. Webmin - Administer Raspberry Pi from browser
3. Samba - Windows Remote Client
4. NTFS-3G - Mount NTFS Partitions
5. Git - Git client for Github
6. VSFTPD - FTP client for Pi
7. Nano - File Editor for Pi
8. XRDP - Windows RDP Client for Arch
9. XBMC - An awesome Media manager for Raspberry pi
10.Aria2 - A light weight torrent manager

Please Select from the options [1-7]: "; read opt; echo""
  case $opt in
    1) echo "You have selected Transmission."
      $rpi_aui/yn.sh "Do you want do install transmission? [y/N]" || util_ui
      echo "Installing Transmission . . . "
      pacman -S --noconfirm --needed transmission-cli 
      printf "Enabling Transmission Service . . . "
      systemctl enable transmission
      util_ui
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

10)  echo "You have Selected Aria2"
ask
pacman -S xbmc-rbp --noconfirm --needed aria2
ui
;;

a)  echo "You have Selected Alsa Mixer"
ask
pacman -S --noconfirm --needed alsa-utils 
clear
top
echo "Amixer Installed!" 
echo " "
echo "Default Audio output: "
echo "1. Auto Configuration"
echo "2. Analogue output"
echo "3. HDMI output"
echo "Enter your choice: "
read ch
case $ch in
	1) echo "You have selected Auto Configuration."
	ask
	amixer cset numid=3 0
	echo "Audio output set to Auto Mode"
	sleep $defsleep
	ui
	;;
	
	2) echo "You have selected Analogue Output."
	ask
	amixer cset numid=3 1
	echo "Audio output set to Analogous Output"
	sleep $defsleep	
	ui
	;;
	
	3) echo "You have selected HDMI Output."
	ask
	amixer cset numid=3 2
	echo "Audio output set to HDMI"
	sleep $defsleep
	ui
	;;
	esac


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
#----------------------------------------------------------------------------
# Main
#----------------------------------------------------------------------------
checkr
ui
