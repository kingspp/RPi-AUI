#!/bin/bash
# Overclocking PI v1.0
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
#-------------------------------------------------------------------------------------------------------------
#Functions
function checkr()
{
if [ "$UID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
echo "User running as root!!"
sleep 1
}

function ask()
{
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
echo " Reboot the system to apply changes?? [y/n]"
read ch
if [ "$ch" == 'y' ]; then
reboot
else
exit
fi
}

function overview()
{
echo "Pi Temperature:"
/opt/vc/bin/vcgencmd measure_temp
}

function mountm()
{
echo "To view fstab file"
sleep 1

while (1)
do 
name=$line
     echo $name
done < $1
}


function ui()
{

echo "##########################################################################################################################################################"
echo "1.Overview"
echo "2.Configuration"
echo "3.Overclocking Settings"
echo "4..Temperature"
echo "5.Mounting Options"
echo "##########################################################################################################################################################"
sleep 1
echo "Choose among the following"
echo ""
read opt
case $opt in
1) overview
;;

2) config
;;


5) mountm
;;








esac
}
#-----------------------------------------------------------------------------------------------------------------------------------------------------------



echo "#######################################################"
echo "###              Display Script by kingspp     ###"
echo "######################################################"
echo ""
sleep 1
## To check if its running as Root
checkr
ui