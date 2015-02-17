#!/bin/bash
# Modified by Ivan Tham <pickfire@riseup.net> - Sun Jan 18 09:30:33 UTC 2015
# FILE          : Command Pi v0.1
# DESCRIPTION   : ???
# Remove Carriage return sed -i 's/ \r//g' <filename>
# TODO(kingspp): What do you need to do with this file?
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
path=/opt/RPi-AUI/AUI


# Main
$path/./main.sh root title
$path/./main.sh title thank
