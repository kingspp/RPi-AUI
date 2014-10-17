#!/bin/bash
# User Management v2.0
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

#Default Values

defsleep=0;
actionsleep=2;


function top()
{
	clear
	echo "##############################################################"
	echo "##   Welcome to User Management v2.0                        ##"
	echo "##   -- By kingspp                                          ##"
	echo "##############################################################"
	echo "  "
	sleep $defsleep
}

function listu()
{
	top
	echo "Users:" 
	echo ""
	grep home /etc/passwd
	
}

function addu()
{	
  top
  echo "Lets create an User Account"
  echo " "
  echo "Please enter the name for the user account: "
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
  echo "User $name Successfully added!"
  sleep $actionsleep
  ui
}

function delu()
{
	listu
	echo ""
	echo "Remove User:"
	echo "Enter the name of the user"
	read name
	userdel -rf $name &> /dev/null
	echo "User $name Successfully removed"	
	sleep $actionsleep
	ui
	
}

function thank
{
  top
  echo ""
  echo ""
  echo "Thank You"
  echo "--By Kingspp"
  echo "Reboot the system to apply changes?? [y/n]"
  read ch
  if [ "$ch" == 'y' ]; then
  reboot
  else
  clear
  exit
  fi
}

function ui()
{
	##User Interface
  top
  echo "Press q to quit"
  echo " ** --> To do (Be Cautious)"
  echo ""
  echo "########################################################"
  echo "1. List Users"
  echo "2. Add User"
  echo "3. Remove User"	
  echo "########################################################"
  echo ""
  echo "Select an option: "
  read opt
  case $opt in
	  1)listu
	  echo ""
	  echo "Press any key to continue... "
	  read s
	  ui
	  ;;
	  
	  2)addu	  
	  ui
	  ;;
	  
	  3)delu	  	  
	  ui
	  ;;
	  
	  q) thank
	  clear
	  exit
	  ;;
  esac

}


top
ui

