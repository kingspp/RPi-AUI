#!/bin/bash
# Overclocking PI v1.1
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
echo "Got Superuser ability !!"
echo ""
sleep 1
}

function defconf()
{
echo "# uncomment if you get no picture on HDMI for a default 'safe' mode
#hdmi_safe=1

# uncomment this if your display has a black border of unused pixels visible
# and your display can output without overscan
#disable_overscan=1

# uncomment the following to adjust overscan. Use positive numbers if console
# goes off screen, and negative if there is too much border
#overscan_left=16
#overscan_right=16
#overscan_top=16
#overscan_bottom=16

# uncomment to force a console size. By default it will be display's size minus
# overscan.
#framebuffer_width=1280
#framebuffer_height=720

# uncomment if hdmi display is not detected and composite is being output
#hdmi_force_hotplug=1

# uncomment to force a specific HDMI mode (this will force VGA)
#hdmi_group=1
#hdmi_mode=1

# uncomment to force a HDMI mode rather than DVI. This can make audio work in
# DMT (computer monitor) modes
#hdmi_drive=2

# uncomment to increase signal to HDMI, if you have interference, blanking, or
# no display
#config_hdmi_boost=4

# uncomment for composite PAL
#sdtv_mode=2

# for more options see http://elinux.org/RPi_config.txt

gpu_mem_512=316
gpu_mem_256=128
#cma_lwm=16
#cma_hwm=32
#cma_offline_start=16
"  >> /boot/config.txt
echo ""
}

function ask()
{
echo "Are you sure? [Y/N]: "
read ch
if [ "$ch" == 'y' ]; then
echo ""
else
thank
fi
}


function ask1()
{
echo "Are you sure? [Y/N]: "
read ch
if [ "$ch" == 'y' ]; then
echo "Rebooting . . . ."
sleep 2
reboot
else
exit
fi
}

function thank
{
echo ""
echo ""
echo "Thank You"
echo "By Kingspp"
echo " Reboot the system to apply changes?? [y/n]"
ask1
}

function fin()
{
echo "Settings applied successfully"
echo ""
sleep 1
thank
}

function check()
{
echo "Lets Check if the settings are applied"
echo ""

echo "ARM Frequency : "
/opt/vc/bin/vcgencmd get_config arm_freq
sleep 1

echo "Core Frequency :"
/opt/vc/bin/vcgencmd get_config core_freq
sleep 1

echo "Core Frequency :"
/opt/vc/bin/vcgencmd get_config sdram_freq
sleep 1

echo "Core Frequency :"
/opt/vc/bin/vcgencmd get_config over_voltage
sleep 1
}

function custom()
{
echo "Be very careful while entering!!"
sleep 1
echo "Enter the ARM frequency: [700 - 1000] "
read a_freq
if (( ( a_freq < 1001 ) && (  a_freq > 659) )); then
echo "Okay"
echo ""
else
echo "Please check the values again!!"
echo ""
custom
fi
sleep 1

echo "Enter the Core frequency:[250 -500] "
read c_freq
if (( ( c_freq < 501) && (  c_freq > 249 ) )); then
echo "Okay"
echo ""
else
echo "Please check the values again!!"
echo ""
custom
fi
sleep 1

echo "Enter the SD-RAM frequency:[400 -500] "
read sd_freq
if (( ( sd_freq < 501) && (  sd_freq > 399 ) )); then
echo "Okay"
echo ""
else
echo "Please check the values again!!"
echo ""
custom
fi
sleep 1

echo "Enter the Over Voltage:[0-6] "
read  ov
if (( ( ov < 7 ) && (  sd_freq > -1 ) )); then
echo "Okay"
echo ""
else
echo "Please check the values again!!"
echo ""
custom
fi
sleep 1

echo "The custom values are"
echo " ARM Frequency: $a_freq
Core Frequency: $c_freq
SD-RAM Frequency: $sd_freq
Over Voltage: $ov"

ask
echo " #Custom_mode
arm_freq=$a_freq
core_freq=$c_freq
sdram_freq=$sd_freq
over_voltage=$ov">> /boot/config.txt
echo ""
sleep 1
fin

}


function dis()
{
echo "Welcome to OverClocking"
echo "Do not change the settings if you so not know about Overclocking"
echo "
/*
 * I am not responsible for bricked devices, dead SD cards,
 * thermonuclear war, or you getting fired because the alarm app failed. Please
 * do some research if you have any concerns about features included in this Script
 * before running it! YOU are choosing to make these modifications, and if
 * you point the finger at me for messing up your device, I will laugh at you.
 */"
 sleep 1
}

function top()
{
clear
echo "#######################################################"
echo "###              Overclocking Script by kingspp     ###"
echo "######################################################"
echo ""
sleep 1
}

function backu()
{

echo "Lets backup old config.txt for emergency"
cp /boot/config.txt /boot/config.old
echo  "Success! Backed up as config.old"
sleep 1
rm /boot/config.txt
touch /boot/config.txt
defconf
sleep 1
}


function cpu_f()
{
echo "1.Normal Mode
ARM Frequency=750 Mhz
Core Frequency=250 Mhz
SD-RAM Frequency=400 Mhz
Over Voltage=0 V "
 echo ""
 sleep 1
 
 echo "2.Modest Mode
ARM Frequency=800 Mhz
Core Frequency=300 Mhz
SD-RAM Frequency=400 Mhz
Over Voltage=0 V"
echo ""
sleep 1

echo "3.Medium Mode
ARM Frequency=900 Mhz
Core Frequency=333 Mhz
SD-RAM Frequency=450 Mhz
Over Voltage=2 V"
echo ""
sleep 1


echo "4.High Mode
ARM Frequency=950 Mhz
Core Frequency=450 Mhz
SD-RAM Frequency=450 Mhz
Over Voltage=6 V"
echo ""
sleep 1

echo "5.Turbo Mode
ARM Frequency=1 GHZ
Core Frequency=500 Mhz
SD-RAM Frequency=500 Mhz
Over Voltage=6 V"
echo ""
sleep 1

echo "6.Custom"
echo "Be Careful!!!!"
echo "Enter the Mode [1-6]: "
read opt
echo ""


case $opt in

1 ) echo "You have selected Normal Mode"
ask
 echo "#Normal Mode
arm_freq=750
core_freq=250
sdram_freq=400
over_voltage=0">> /boot/config.txt
fin
;;

2 ) echo "You have selected Modetate Mode"
ask
 echo "#Moderate Mode
arm_freq=800
core_freq=300
sdram_freq=400
over_voltage=0">> /boot/config.txt
fin
;;

3 ) echo "You have selected Medium Mode"
ask
 echo "#Medium Mode
arm_freq=900
core_freq=333
sdram_freq=450
over_voltage=2">> /boot/config.txt
fin
;;

4 ) echo "You have selected High Mode"
ask
 echo "#High Mode
arm_freq=950
core_freq=450
sdram_freq=450
over_voltage=6">> /boot/config.txt
fin
;;

5 ) echo "You have selected Turbo Mode"
ask
 echo "#Turbo Mode
arm_freq=1000
core_freq=500
sdram_freq=500
over_voltage=6">> /boot/config.txt
fin
;;

6 ) echo "You have selected Custom Mode"
ask
custom
;;


q)  echo "Thank you"
exit
;;
esac


}

function gov()
{

echo "Governors"
echo ""
echo "Available Governors"
echo "1. Conservative 
2. Userspace 
3. Powersave 
4. Ondemand 
5. Performance
"
echo ""
echo "Enter your Preferred Governor: [1-5]: "
read gv
case $gv in
1) echo "You have selected Conservative"
ask
echo "conservative" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
;;
2) echo "You have selected Userspace"
ask
echo "userspace" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
;;
3) echo "You have selected Powersave"
ask
echo "powersave" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
;;
4) echo "You have selected Ondemand"
ask
echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
;;
5) echo "You have selected Performance"
ask
echo "performance" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
;;
esac
fin
thank

}


function ui()
{
top
backu
dis
echo "Overclocking Settings:"
echo ""
echo "1. CPU Settings"
echo "2. Governor"
echo ""
echo "Enter your choice [1-2]: "
read opt
case $opt in
1) cpu_f
;;
2) gov
;;
esac


## Overclocking Settings

 
 echo " Choose from the options "
 echo ""
 
 
}

#--------------------------------------------------------------------------------------------------------




## To check if its running as Root
checkr
ui






