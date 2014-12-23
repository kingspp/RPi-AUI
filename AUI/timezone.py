#!/usr/bin/python3
# Created by Ivan Tham - 23rd December 2014
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

while True: #print("Listing directory", loc) # For debug use only
    [ print(i) for i in os.listdir(loc) ] # List the directory loc
    print("You can type 'q' to return to the original directory.") # Info
    ans = str(input("What is your timezone or continent: ")) # Ask for ans
    if ans == "q": loc = "/usr/share/zoneinfo" # Change the loc if 'q' is typed
    elif os.path.isdir(os.path.join(loc, ans)): # If it is a directory
        loc = os.path.join(loc,ans) # Change the new loc
    elif os.path.isfile(os.path.join(loc, ans)):
        if input("Do you want", ans, "as localtime? [y/N] ").lower() == "y":
            print("Changing the timezone.")
            os.remove("/etc/localtime") # rm /etc/localtime
            os.symlink(os.path.join(loc,ans), "/etc/localtime") # ln -s
            break # Break the loop
