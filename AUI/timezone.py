#!/usr/bin/python2
# Created by Ivan Tham - 23rd December 2014
# TODO(pickfire): Translate to sh and merge into archi.sh
# A simple python script to change the timezone
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
import os


loc = "/usr/share/zoneinfo" # Directory of timezone information
print("\033[92mType 'q' to return to the original directory.\033[0m") # Info

while True: # For debug use only
    print(", ".join(os.listdir(loc)))
    a = raw_input("Enter your timezone/continent from above: ") # Ask for ans
    if a == "q": loc = "/usr/share/zoneinfo" # Change the loc if 'q' is typed
    elif os.path.isdir(os.path.join(loc, a)): # If it is a directory
        loc = os.path.join(loc,a) # Change the new loc
    elif os.path.isfile(os.path.join(loc, a)): # If it is a file
        if "y" in raw_input("Do you want " + a + " as localtime? ").lower():
            print("Changing the timezone...")
            os.remove("/etc/localtime") # rm /etc/localtime
            os.symlink(os.path.join(loc,a), "/etc/localtime") # ln -s
            break # Break the loop
