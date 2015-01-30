#!/bin/bash
#----------------------------------------------------------------------------
# Created by Ivan Tham <pickfire@riseup.net> - Fri Jan  9 02:04:00 UTC 2015
# USAGE		    : $path/./yn.sh "Do you want that? [Y/n]"
# DESCRIPTION	: Reuse code
#
#    Copyright (C) Prathyush 2015
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#----------------------------------------------------------------------------
while : ; do  # ask again when there's no default preference
  # Usage: $path/./main.sh yn "Question: [Y/n]"   Note: [Y/n] -> default Y
  echo -en "$1 "; read -n 1 ans; echo # echo with 1 space & read 1 character
  [[ $ans == [Yy] ]] && { exit 0; } # return success if ans = y or Y
  [[ $ans == [Nn] ]] && { exit 1; } # return failure if ans = n or N
  [[ $(grep -o '\[./.\]' <<< $1) == *'Y'* ]] && exit 0 # [Y/n] -> default Y
  [[ $(grep -o '\[./.\]' <<< $1) == *'N'* ]] && exit 1 # [y/N] -> default N
done
