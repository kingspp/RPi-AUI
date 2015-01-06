#!/bin/bash
# Created by Ivan Tham <pickfire@riseup.net> - Fri Jan  9 03:29:46 UTC 2015
# DESCRIPTION	: The main part of RPi-AUI
# Arch Installer- Raspberry Pi v6.2
# Remove Carriage return sed -i 's/ \r//g' <filename>
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
# Variables
#----------------------------------------------------------------------------
defsleep=0;
uisleep=2;
path=/opt/RPi-AUI/AUI
r='\033[91m'; g='\033[92m'; w='\033[0m' # Colours

#----------------------------------------------------------------------------
# Functions
#----------------------------------------------------------------------------
function update() { # Self-update
  cd $path
  git pull
}

function perm() {   # Change permission
  $path/./main.sh title
  echo "Changing Permissions..."
  chmod +x *.sh *.py 
  sleep $defsleep
}

function checkr() { # Check if user is running as root
  if [ "$UID" != 0 ]; then
    echo "Please run as root!"
    exit 1
  fi
  echo "User running as root!!"
  sleep $defsleep
}

#function top() { # function top -> $path/./main.sh title
#  clear
#  echo "##############################################################"
#  echo "##   Welcome to Arch Linux - Raspberry Pi Setup v6.2        ##"
#  echo "##   -- By kingspp                                          ##"
#  echo "##############################################################"
#  echo "  "
#  sleep $defsleep
#}

#function ask() { # ask -> $path/./yn.sh "Is this what you want? [Y/n]"
#  read ch
#  if [ "$ch" == 'y' ] || [ "ch" == "Y" ] ; then
#  	echo ""
#  else
#  	thank
#  fi
#}

#function thank # thank replaced by $path/./main.sh thank
#  top
#  echo ""
#  echo ""
#  echo "Thank You"
#  echo "--By Kingspp"
#  echo " Reboot the system to apply changes?? [y/n]"
#  read ch
#  if [ "$ch" == 'y' ]; then
#  reboot
#  else
#  clear
#  exit
#  fi
#}

function pingcheck() {
  $path/./main.sh title
  echo -e "To check if the pi got Internet??!!\n"
  ping -c 3 google.com 2>/dev/null && { echo -e "Success! Pi's got net!!"; \
    sleep $uisleep; ui; } || \
    { echo "Fail! Please connect to the Internet and Try Again"; exit 1; }
}

function defins() { # Default Installation
  $path/./main.sh title
  $path/./yn.sh "Do you want pacman to be in colours? [Y/n]" && \
    sed -i 's/#Color/Color/g' /etc/pacman.conf
  echo "Updating Arch Linux to its Latest Release"
  echo " "
  pacman -Syu --noconfirm  # To update the Arch Linux to the latest Release
  sleep $defsleep
  echo "Installing utilities"
  echo "Packages that are going to be install: "
  echo "1. archlinuxarm-keyring & archlinux-keyring"
  echo "2. bash - To install bash for scripting"
  echo "3. coreutils - To install Core Utilities"
  echo "4. util-linux - To install Linux Utilities"
  echo "5. devtools - To install Development Tools"
  pacman-key --init
  pacman -S --noconfirm archlinux-keyring archlinux
  pacman-key --populate archlinux
  pacman -S --noconfirm --needed bash coreutils util-linux devtools git
  sleep $defsleep
}

function partm() {
  $path/./main.sh title
  echo " Lets Utilize full size of the Memory Card "
  echo "Partition Manager"
  echo " "
  echo " Commands "
  echo " "
  echo "d - delete a partition"
  echo "l - list known partition types"
  echo "n - add a new partition"
  echo "p - print the partition table"
  echo "t - change a partition type"
  echo "v - verify the partition table"
  echo " "
  #fdisk /dev/mmcblk0
}

#function passm()
#{
#  ## Password Update
#  echo "Please enter a new password for the root"
#  echo " "
#  passwd # To set new password for Root User
#  sleep $defsleep+1
#  ui
#}

function util() {
  $path/./main.sh title
  $path/./util.sh
}

function hname() {
  echo "Your current hostname is:" $(hostname)
  $path/./yn.sh "Do you wish to change the hostname? [y/N]" || ui
  cp /etc/hostname /etc/hostname.old # Create a backup for hostname
  rm /etc/hostname; echo -n "Enter the new hostname:"; read hn
  echo "$hn" > /etc/hostname; echo
  echo "Your new hostname is:" $(hostname)
}

function ui() { # User Interface
  $path/./main.sh title
  echo "Press q to quit"
  echo -e " $r**$w --> To do (Be Cautious)"
  echo ""
  echo -e "########################################################"
  echo -e "1. Ping Check                  c. Command Pi v1.0 $r**$w"
  echo -e "2. Arch Linux Update           d. Display Pi v1.5       "
  echo -e "3. Partition Manager $r**$w        o. OverClocking Pi v2.0  "
  echo -e "4. User Management             u. Utility Pi v2.0       "
  echo -e "5. Change Root Password        l. LXDE on LAN v1.0      "
  echo -e "6. Change Locale $r**$w            p. Install pi4j v1.0     "
  echo -e "7. Hostname                    r. Resize Pi v1.1        "
  echo -e "8. Resize root file system $r**$w  m. User Pi v2.0          "
  echo -e "9. Default Installation        t. Change timezone       "
  echo -e "10.Update AUI $r**$w               v. View Credits $r**$w   "
  echo -e "99.Changelog $r**$w                                     "
  echo -e "########################################################"
  echo -e ""
  echo -n "Select an option: "; read opt
  case $opt in
    1) echo -e "Ping Check Selected\n"; pingcheck;;

    2) $path/./main.sh title
    $path/./yn.sh "Do you want to update Arch? [Y/n]" || ui # Else
    echo "Updating Arch Linux to its Latest Release..."
    pacman -Syu --noconfirm; sleep $defsleep    # Update Arch Linux & sleep
    echo " You have the latest Arch ;) "; ui    # Back to user interface
    ;;

    3) $path/./yn.sh "You are $rWARNED$w not to manage Partitions. Are you sure? [y/N]" || ui # Too long! -> Need to shorten
    partm
    read s
    ui
    ;;
  
    4) echo "User Management"; echo
    $path/./userm.sh; ui    # Return to user interface
    ;;
  
    5) $path/./yn.sh "Do you want to change $r\Root$w Password? [y/N]" && passwd;;  # Too long! -> Need to shorten
  
    6) $path/./yn.sh "Do you want to change the Locale? [y/N]" || ui
    echo -n "Default Locale: "
    sleep $defsleep
    grep -v ^# /etc/locale.gen
    read s
    ui
    ;;
  
    7) hname; ui;;
  
    8) $path/./resize.sh;;
  
    9) echo "Default Installation: "
    pingcheck
    defins
    # addu # What does this mean?
    $path/./oc.sh
    passm
    util
    hname	  
    read s	  
    ui
    ;;

    10) echo "Checking for AUI Updates . . "; update
    echo "Update Complete!"
    sleep 1
    ui
    ;;

    c) echo "You have selected Command Pi"
    sleep $uisleep	  
    $path/./command.sh
    ;;
  
    d) echo " You have selected Display Pi "
    sleep $uisleep	  
    $path/./disp.sh
    ui
    ;;
  
    o) $path/./yn.sh "Do you want to OverClock PI? [y/n]" || ui
    echo "You have selected Overclock Pi"
    sleep $uisleep
    $path/./oc.sh
    ui
    ;;
  
    u) echo "You have selected Utility Pi "
    sleep $uisleep
    $path/./util.sh
    ;;
  
    l) echo "You have selected LXDE on LAN "
    sleep $uisleep
    $path/./lan_lxde.sh	  
    ui
    ;;
  
    p) echo "You have selected pi4j "
    sleep $uisleep
    $path/./pi4j.sh	  
    ui
    ;;
  
    r) echo "You have selected Resize Pi "
    sleep $uisleep
    $path/./resize.sh	  
    ui
    ;;

    m) echo "You have selected User Pi "
    sleep $uisleep
    $path/./userm.sh
    ui
    ;;

    t) [[ ! -f /etc/localtime ]] && echo "You have not set your timezone." ||
    echo "Your current localtime:" $(basename `realpath /etc/localtime`)
    $path/./yn.sh "Do you wish to set your localtime? [y/N]" || ui
    if hash python2 2>/dev/null; then
      echo "Python2 is installed."
    elif hash python3 2>/dev/null; then
      # Translate to python3 if python3 is installed
      echo "Python3 in installed."
      sed -i 's/python2/python3/g; s/raw_input/input/g' $path/timezone.py
    else echo "Python is not installed... installing python2."
      pacman -S --needed --noconfirm python2
    fi
    $path/./timezone.py # Run timezone.py
    ;;

    q) $path/./main.sh title thank;;
  esac
}


#----------------------------------------------------------------------------
# Main
#----------------------------------------------------------------------------
#echo "To check if user is running as Root"; checkr
perm    # Title in perm
sleep $defsleep
ui  # Start the user interface
