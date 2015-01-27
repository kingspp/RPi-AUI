#!/bin/bash
# Modified by Ivan Tham <pickfire@riseup.net> - Sun Jan 11 06:58:45 UTC 2015
# FILE          : Overclocking Pi v0.1
# DESCRIPTION   : Overclocking the Raspberry Pi
# TODO(pickfire): Fix those ask and gov function
# TODO(pickfire): Add gpu memory split
# TODO(pickfire): Better backup system
# TODO(pickfire): Add restore function
#---------------------------------------------------------------------------
#    Copyright © Prathyush 2015
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
rpi_aui=/opt/RPi-AUI/AUI; rpi_doc=/opt/RPi-AUI/doc


#Functions
function defconf() {
  cp $rpi_doc/config.txt >> /boot/config.txt
  echo ""
}

function ask() {
echo "Are you sure? [Y/N]: "
read ch
if [ "$ch" == 'y' ]; then
echo ""
else
thank
fi
}


function ask1() {
echo "Are you sure? [Y/N]: "
read ch
if [ "$ch" == 'y' ]; then
echo "Rebooting . . . ."
sleep 2
reboot
else
clear
exit
fi
}

function thank() {
echo ""
echo ""
echo "Thank You"
echo "By Kingspp"
echo " Reboot the system to apply changes?? [y/n]"
ask1
}

function fin() {
  echo "Settings applied successfully"
  echo ""
  sleep 1
  ui
  thank
}

function check() {
  echo "Lets Check if the settings are applied:"
  echo "ARM Frequency : $(/opt/vc/bin/vcgencmd get_config arm_freq)"; sleep 1
  echo "Core Frequency: $(/opt/vc/bin/vcgencmd get_config core_freq)"; sleep 1
  echo "SDRAM Frequency: $(/opt/vc/bin/vcgencmd get_config sdram_freq)"; sleep 1
  echo "Over Voltage: $(/opt/vc/bin/vcgencmd get_config over_voltage)"; sleep 1
}

function custom_ask {   # 1 parameter "Enter the ARM frequency: [700-1200]"
  while true; do
    echo -n "$1 "; read a
    f=$(grep -o '[0-9]*-' <<< $1 | head -c -2)    # first 700
    l=$(grep -o '[0-9]*\]' <<< $1 | head -c -2)   # last 1200
    [[ $a -ge $f && $a -le $l ]] && { echo "Okay"; break; } || { \
      echo -e "\033[91mPlease check the values again!!\033[0m"; }
    sleep 1
  done
}

function dis() {
  echo "Welcome to OverClocking"
  echo "Do not change the settings if you so not know about Overclocking"
  echo "
 > I am not responsible for bricked devices, dead SD cards, thermonuclear war,
 > or you getting fired because the alarm app failed. Please do some research
 > if you have any concerns about features included in this Script before
 > running it! YOU are choosing to make these modifications, and IF you point
 > the finger at me for messing up your device, I will laugh at you! Hahah..."
  echo ""
  sleep 1
}

function top() {
clear
echo "##############################################################"
echo "##   Welcome to the OverClocking Pi  v2.0                   ##"
echo "##   -- By kingspp                                          ##"
echo "##############################################################"
echo "  "
sleep 1
}

function do_backup() {
  [ -f /boot/config.txt -a ! -f /boot/config.bak ] &&
    echo "Let's backup old config.txt for emergency" &&
    cp /boot/config.txt /boot/config.bak &&
    echo "Success! Backed up as config.bak" &&
    defconf
  sleep 1
}

function cpu_f() {
  $rpi_aui/./main.sh title
  echo -e "
Press '\033[91mq\033[0m' to return to main menu.

  ------------------------------------------------------------------------
 | Presets          |   None | Modest | Medium |   High |  Turbo | Custom |
 |------------------|--------|--------|--------|--------|--------|--------|
 | arm_freq (Mhz)   |    700 |    800 |    900 |    950 |   1000 |    ?   |
 | core_freq (Mhz)  |    250 |    300 |    333 |    450 |    500 |    ?   |
 | sdram_freq (Mhz) |    400 |    400 |    450 |    450 |    500 |    ?   |
 | over_voltage (V) |      0 |      0 |      2 |      6 |      6 |    ?   |
  ------------------------------------------------------------------------
  * Custom preset is \033[91mNOT\033[0m encouraged.
"
  echo "1) None     2) Modest   3) Medium"
  echo "4) High     5) Turbo    6) Custom"
  echo ""; echo -n "Select the Preset [1-6]: "; read -n 1 opt; echo ""
  rm /boot/config.txt
  touch /boot/config.txt
  defconf

  case $opt in
    1) mode="None";   a_freq=700; c_freq=250; sd_freq=400; ov=0; ;;
    2) mode="Modest"; a_freq=800; c_freq=300; sd_freq=400; ov=0; ;;
    3) mode="Medium"; a_freq=900; c_freq=333; sd_freq=450; ov=2; ;;
    4) mode="High";   a_freq=950; c_freq=450; sd_freq=450; ov=6; ;;
    5) mode="Turbo"; a_freq=1000; c_freq=500; sd_freq=500; ov=6; ;;
    6) echo "You are warned not to select custom mode."
      $rpi_aui/./yn.sh "Do you wish to continue? [y/N]" || cpu_f
      echo -e "\033[91mBe very careful while entering!!\033[0m"; sleep 1
      mode="Custom" # $a is the user input value
      custom_ask "Enter the ARM frequency: [700-1200]"; a_freq=$a
      custom_ask "Enter the Core frequency: [250-500]"; c_freq=$a
      custom_ask "Enter the SD-RAM frequency: [400-500]"; sd_freq=$a
      custom_ask "Enter the Over Voltage: [0-6]"; ov=$a
      ;;
    q) ui ;;
    *) echo "You enter an invalid option!"; sleep 1; cpu_f ;;
  esac

  # Ask for changes after setting variables
  echo "You have selected $mode Preset:"
  echo "arm_freq=$a_freq"
  echo "core_freq=$c_freq"
  echo "sdram_freq=$sd_freq"
  echo "over_voltage=$ov"
  $rpi_aui/./yn.sh "Are you sure? [y/N]" || ui

  # Apply the changes to /boot/config.txt
  echo "# $mode Preset
arm_freq=$a_freq
core_freq=$c_freq
sdram_freq=$sd_freq
over_voltage=$ov" >> /boot/config.txt
  fin   # finished
}

function gov() {
  $rpi_aui/./main.sh title
  echo "Governors"
  echo ""
  curgov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
  echo "The current Governor in use is: $curgov"
  echo ""
  echo "Available Governors"
  echo "1. Conservative
2. Userspace
3. Powersave
4. Ondemand
5. Performance
"
  bash_path=/etc/bash.bashrc
  sed -i '/scaling_governor/d' $bash_path

  echo ""
  echo "Enter your Preferred Governor: [1-5]: "
  read gv
  case $gv in
    1) echo "You have selected Conservative"
      ask
      echo "conservative" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
      echo -n "echo \"conservative\" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor" >> $bash_path
    ;;

    2) echo "You have selected Userspace"
      ask
      echo "userspace" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
      echo -n "echo \"userspace\" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor" >> $bash_path
    ;;

    3) echo "You have selected Powersave"
      ask
      echo "powersave" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
      echo -n "echo \"powersave\" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor" >> $bash_path
    ;;

    4) echo "You have selected Ondemand"
      ask
      echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
      echo -n "echo \"ondemand\" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor" >> $bash_path
    ;;

    5) echo "You have selected Performance"
      ask
      echo "performance" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
      echo -n "echo \"performance\" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor" >> $bash_path
    ;;
  esac
  fin
  thank
}

function ui() {
  $rpi_aui/./main.sh title
  echo -e "Press '\033[91mq\033[0m' to quit"
  echo ""
  do_backup
  dis
  echo "Overclocking Settings:"
  echo "1. CPU Settings"
  echo "2. Governor"
  echo ""
  echo -n "Enter your choice [1-2]: "; read -n 1 opt; echo
  case $opt in
    1) cpu_f;;
    2) gov;;
    q) $rpi_aui/./main.sh title thank; exit 0;;
    *) echo "You selected an invalid option."; sleep 1; ui;;
  esac
  ## Overclocking Settings
  echo " Choose from the options "
  echo ""
}


#----------------------------------------------------------------------------
# Main
#----------------------------------------------------------------------------
$rpi_aui/./main.sh root && ui || exit 1    # enter ui if running as root
