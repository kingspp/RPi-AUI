#!/bin/bash
# Modified by Ivan Tham <pickfire@riseup.net> - Fri Jan  9 03:29:46 UTC 2015
# FILE:         : LAN LXDE v1.0
# DESCRIPTION	: Installation of LXDE on LAN
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
# Defaults
path=/opt/RPi_AUI/AUI


# Main
$path/./main.sh title
$path/./yn.sh "Do you want to install LXDE available on LAN? [y/N]" || exit
echo "Installing . . ."
sleep 1
pacman -S --noconfirm xrdp lxde xf86-video-fbturbo-git xorg-xinit xorg-server xorg-server-utils xterm
echo "exec startlxde" > ~/.xinitrc
