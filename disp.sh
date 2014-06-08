#!/bin/bash
# Display Pi v1.0
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
exit
}

function overview()
{
clear
top
echo ""
echo "Version: "
echo "-------------"
/opt/vc/bin/vcgencmd version
echo ""

echo "Device Specifics: "
echo "--------------------------"
pitemp=$(/opt/vc/bin/vcgencmd measure_temp )
arm_f=$(/opt/vc/bin/vcgencmd measure_clock arm)
core_f=$(/opt/vc/bin/vcgencmd measure_clock core)
core_v=$(/opt/vc/bin/vcgencmd measure_volts core)
arm_m=$(/opt/vc/bin/vcgencmd get_mem arm)
gpu_m=$(/opt/vc/bin/vcgencmd get_mem gpu)
echo "Pi $pitemp"
echo "ARM $arm_f Hz"
echo "Core $core_f Hz"
echo "Core $core_v "
echo "ARM Memory: $arm_m"
echo "GPU Memory: $gpu_m"
gv=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
echo "Governor in use: $gv"
echo ""

echo "Config.txt Options:"
echo "---------------------------"
/opt/vc/bin/vcgencmd get_config int
echo ""

echo "Codecs Enabled:"
echo "--------------------------"
for codec in H264 MPG2 WVC1 MPG4 MJPG WMV9 ; do 
     echo -e "$codec:\t$(/opt/vc/bin/vcgencmd codec_enabled $codec)" ; 
 done 
 echo ""

 
 
}

function mountm()
{
top
echo "To view fstab file . . ."
echo ""
sleep 1
cat /etc/fstab
echo ""
}

function tempr()
{
top
echo "Raspberry Pi Temperature:"
echo ""
sleep 1
/opt/vc/bin/vcgencmd measure_temp 
echo ""

}

function configd()
{
top
echo "Current Config.txt Configuration:"
echo ""
echo "Config.txt Options:"
echo "---------------------------"
/opt/vc/bin/vcgencmd get_config int
echo ""


}


function top()
{
clear
echo "##############################################################"
echo "##   Welcome to Display Pi v1.1  			    ##"
echo "##   -- By kingspp                                          ##"
echo "##############################################################"
echo "  "

sleep 1
}

function ui()
{
clear
top
echo "Press q to quit"
echo " ** --> To do (Be Cautious)"
echo ""
echo "########################################################################"
echo "1. Overview"
echo "2. Configuration "
echo "3. Overclocking Settings **"
echo "4. Temperature "
echo "5. Mounting Settings "
echo "########################################################################"
echo "Choose among the following [1-5]"
echo ""
read opt
echo ""
case $opt in
1) overview
read s
ui
;;

2) configd
read s
ui
;;

4) tempr
read s
ui
;;

5) mountm
read s
ui
;;

q) thank
clear
exit
;;
esac
}
#-----------------------------------------------------------------------------------------------------------------------------------------------------------




## To check if its running as Root
checkr
ui
