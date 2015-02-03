#!/bin/bash
# Created by Ivan Tham <pickfire@riseup.net> - Fri Jan  9 03:29:46 UTC 2015
# DESCRIPTION	: The main part of RPi-AUI
# TODO(pickfire): colorized output and reorganize TUI
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
# Defaults
rpi_aui=/opt/RPi-AUI/AUI; aui_doc=/opt/RPi-AUI/doc
defsleep=0;
uisleep=2;
r='\033[91m'; g='\033[92m'; w='\033[0m' # Colours


#----------------------------------------------------------------------------
# Functions
#----------------------------------------------------------------------------
function update() { # Self-update
  cd $rpi_aui
  git pull
}

#function perm() {   # Change permission
#  $rpi_aui/./main.sh title
#  echo "Changing Permissions..."
#  chmod +x *.sh *.py
#  sleep $defsleep
#}

function checkr() { # Check if user is running as root
  [[ "$UID" != 0 ]] && { echo "Please run as root!"; exit 1; }
  echo "User running as root!!"
  sleep $defsleep
}

#function top() { # function top -> $rpi_aui/./main.sh title
#  clear
#  echo "##############################################################"
#  echo "##   Welcome to Arch Linux - Raspberry Pi Setup v6.2        ##"
#  echo "##   -- By kingspp                                          ##"
#  echo "##############################################################"
#  echo "  "
#  sleep $defsleep
#}

#function ask() { # ask -> $rpi_aui/./yn.sh "Is this what you want? [Y/n]"
#  read ch
#  if [ "$ch" == 'y' ] || [ "ch" == "Y" ] ; then
#  	echo ""
#  else
#  	thank
#  fi
#}

#function thank # thank replaced by $rpi_aui/./main.sh thank
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

#function pingcheck() {
#  $rpi_aui/./main.sh title
#  echo -e "To check if the pi got Internet??!!\n"
#  ping -c 3 google.com 2>/dev/null && { echo -e "Success! Pi's got net!!"; \
#    sleep $uisleep; ui; } || \
#    { echo "Fail! Please connect to the Internet and Try Again"; exit 1; }
#}

function defins() { # Default Installation
  $rpi_aui/./main.sh title
  echo "Updating $(grep "^ID=" /etc/*-release|cut -d= -f2)..."
  $rpi_aui/main.sh pkg_up   # Update distribution
  sleep $defsleep; echo "Installing base packages:
1. bash - for scripting         3. util-linux - Linux Utilities
2. coreutils - Core Utilities"
  $rpi_aui/main.sh pkg_in bash coreutils util-linux git

  # Different initialisation for different distribution
  case $(grep "^ID_LIKE=" /etc/*-release | cut -d = -f 2) in
    arch) pac=/etc/pacman.conf
      $rpi_aui/./yn.sh "Pacman uses candy instead of bored hashes? [Y/n]" &&
        sed -i '/# Misc/a ILoveCandy' $pac || sed -i 's/ILoveCandy/#&/' $pac
      $rpi_aui/./yn.sh "Do you want pacman to be in colours? [Y/n]" &&
        sed -i 's/#Color/Color/' $pac || sed -i 's/^Color/#&/' $pac
      echo "Installing archlinux-keyring..."
      pacman-key --init
      $rpi_aui/main.sh pkg_in archlinux-keyring archlinux
      pacman-key --populate archlinux
      ;;
    debian) ;;
  esac
  sleep $defsleep
}

function partm() {
  $rpi_aui/./main.sh title
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

function hname() {
  echo "Your current hostname is:" $(hostname)
  $rpi_aui/./yn.sh "Do you wish to change the hostname? [y/N]" || ui
  cp /etc/hostname /etc/hostname.old # Create a backup for hostname
  rm /etc/hostname; echo -n "Enter the new hostname:"; read hn
  echo "$hn" > /etc/hostname; echo
  echo "Your new hostname is:" $(hostname)
}

function ui() { # User Interface
  $rpi_aui/./main.sh title
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
    1) $rpi_aui/main.sh net; sleep 1 ;;

    2) $rpi_aui/./yn.sh "Do you want to update Arch? [Y/n]" || ui # Else
    echo "Updating Arch Linux to its Latest Release..."
    pacman -Syu --noconfirm; sleep $defsleep    # Update Arch Linux & sleep
    echo " You have the latest Arch ;) "; ui    # Back to user interface
    ;;

    3) $rpi_aui/./yn.sh "You are $rWARNED$w not to manage Partitions. Are you sure? [y/N]" || ui # Too long! -> Need to shorten
    partm
    read s
    ui
    ;;

    4) echo "User Management"; echo
    $rpi_aui/./userm.sh; ui    # Return to user interface
    ;;

    5) $rpi_aui/./yn.sh "Do you want to change $r\Root$w Password? [y/N]" && passwd;;  # Too long! -> Need to shorten

    6) $rpi_aui/./yn.sh "Do you want to change the Locale? [y/N]" || ui
    echo -n "Default Locale: "
    sleep $defsleep
    grep -v ^# /etc/locale.gen
    read s
    ui
    ;;

    7) hname; ui;;

    8) $rpi_aui/./resize.sh;;

    9) echo "Default Installation: "; $rpi_aui/main.sh net; defins
      $rpi_aui/oc.sh
      $rpi_aui/yn.sh "Do you want to change $r\Root$w Password? [y/N]" &&
        passwd
      $rpi_aui/util.sh
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
    $rpi_aui/./command.sh
    ;;

    d) echo " You have selected Display Pi "
    sleep $uisleep
    $rpi_aui/./disp.sh
    ui
    ;;

    o) $rpi_aui/yn.sh "Do you want to OverClock PI? [y/N]" || ui
      sleep $uisleep && $rpi_aui/./oc.sh
      ;;

    u) echo "You have selected Utility Pi "
    sleep $uisleep
    $rpi_aui/./util.sh
    ;;

    l) echo "You have selected LXDE on LAN "
    sleep $uisleep
    $rpi_aui/./lan_lxde.sh
    ui
    ;;

    p) echo "You have selected pi4j "
    sleep $uisleep
    $rpi_aui/./pi4j.sh
    ui
    ;;

    r) echo "You have selected Resize Pi "
      sleep $uisleep
      $rpi_aui/./resize.sh
      ui
      ;;

    m) echo "You have selected User Pi "
      sleep $uisleep
      $rpi_aui/./userm.sh
      ui
      ;;

    t) [[ ! -f /etc/localtime ]] && echo "You have not set your timezone." ||
    echo "Your current localtime:" $(basename `realpath /etc/localtime`)
    $rpi_aui/./yn.sh "Do you wish to set your localtime? [y/N]" || ui
    if hash python2 2>/dev/null; then
      echo "Python2 is installed."
    elif hash python3 2>/dev/null; then
      # Translate to python3 if python3 is installed
      echo "Python3 in installed."
      sed -i 's/python2/python3/g; s/raw_input/input/g' $rpi_aui/timezone.py
    else echo "Python is not installed... installing python2."
      pacman -S --needed --noconfirm python2
    fi
    $rpi_aui/./timezone.py # Run timezone.py
    ;;

    q) $rpi_aui/./main.sh title thank;;
  esac
}


#----------------------------------------------------------------------------
# Main
#----------------------------------------------------------------------------
chmod +x $rpi_aui/*; $rpi_aui/main.sh root && ui || exit 1
