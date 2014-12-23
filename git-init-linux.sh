#!/bin/bash
# Git - Initialization - Linux
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

top()
{
	clear
	echo "############################"
	echo "# Git-Initialization-Linux #"
	echo "# -- Prathyush             #" 
	echo "############################"
	echo ""
}

clear
top
if [ ! -x /usr/bin/git ]; then
  printf "Installing Git . . . "
  pacman -S --noconfirm git  
fi

clear
top
git --version
echo ""
echo "Please Enter your Username: "
read uname
echo "Please Enter your Email   : "
read umail

git config --global user.name "$uname"
git config --global user.email "$umail"

echo "Please enter the location of the repo: "
read repo
git remote add origin $repo


