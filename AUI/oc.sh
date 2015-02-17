#!/bin/bash
# Modified by Ivan Tham <pickfire@riseup.net> - Sun Jan 11 06:58:45 UTC 2015
# FILE          : Overclocking Pi v0.1
# DESCRIPTION   : Overclocking the Raspberry Pi
# TODO(pickfire): Fix those ask and gov function
# TODO(pickfire): Add gpu memory split
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
# Variables
rpi_aui=/opt/RPi-AUI/AUI; rpi_doc=/opt/RPi-AUI/doc
conf=/boot/config.txt; cmdl=/boot/cmdline.txt


#----------------------------------------------------------------------------
# Functions
#----------------------------------------------------------------------------
function defconf() {
  cp $rpi_doc/config.txt > /boot/config.txt
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

function custom_ask() {   # 1 parameter "Enter the ARM frequency: [700-1200]"
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
    echo "Let's backup old config.txt as config.bak for emergency." &&
    cp /boot/config.txt /boot/config.bak
  sleep 1
}

function set_config() {
  # USAGE: set_config arm_freq 700 $conf ($1:Key, $2:Value, $3:File)
  grep -q "^$1=" $3 && sed -i "/^$1=/c $1=$2" $3 || echo "$1=$2" >> $3
  return 0  # search $1 and change "$1=*" to "$1=$2" or append "$1=$2" to EOF
}

function cpu_f() {  # Cpu Frequency function
  $rpi_aui/./main.sh title  # Show the title every time

  # The value of $conf(if empty use default) and change to 6 digits in spaces
  arm=$(sed -n 's/arm_freq=// p' $conf); arm=$(printf %9d ${arm:-700})
  cor=$(sed -n 's/core_freq=// p' $conf); cor=$(printf %9d ${cor:-250})
  sdr=$(sed -n 's/sdram_freq=// p' $conf); sdr=$(printf %9d ${sdr:-400})
  ov=$(sed -n 's/over_voltage=// p' $conf); ov=$(printf %9d ${oc:-0})
#  ------------------------------------------------------------------------
# | Presets          |   None | Modest | Medium |   High |  Turbo |    Now |
# |------------------|--------|--------|--------|--------|--------|--------|
# | arm_freq (Mhz)   |    700 |    800 |    900 |    950 |   1000 | $arm |
# | core_freq (Mhz)  |    250 |    300 |    333 |    450 |    500 | $cor |
# | sdram_freq (Mhz) |    400 |    400 |    450 |    450 |    500 | $sdr |
# | over_voltage (V) |      0 |      0 |      2 |      6 |      6 | $ov |
#  ------------------------------------------------------------------------
  printf "Press '\033[31mq\033[0m' to return to main menu. (abort changes)

  --------------------------------------------------------------------------
 | Presets  | ARM (MHz)     | core (MHz)    | sdram (MHz)   | overvolt (V)  |
 |--------------------------------------------------------------------------|
 | 1.None   |           700 |           250 |           400 |             0 |
 | 2.Modest |           800 |           300 |           400 |             0 |
 | 3.Medium |           900 |           333 |           450 |             2 |
 | 4.High   |           950 |           450 |           450 |             6 |
 | 5.Turbo  |          1000 |           500 |           600 |             6 |
 | 6.Pi2    |          1000 |           500 |           500 |             2 |
 | \033[32mCurrent\033[m  |     $arm |     $cor |     $sdr |     $ov |
  --------------------------------------------------------------------------
  * Custom preset -> ? (\033[31mNOT encouraged!\033[m)"
  echo -e "\n"; echo -n "Select the Preset [1-7]: "; read -n 1 opt; echo ""
  case $opt in  # Using new arm, cor, sdr, ov values(easier to read & short)
    1) mode="None";   arm=700; cor=250; sdr=400; ov=0; ;;
    2) mode="Modest"; arm=800; cor=300; sdr=400; ov=0; ;;
    3) mode="Medium"; arm=900; cor=333; sdr=450; ov=2; ;;
    4) mode="High";   arm=950; cor=450; sdr=450; ov=6; ;;
    5) mode="Turbo"; arm=1000; cor=500; sdr=500; ov=6; ;;
    6) mode="Pi2";   arm=1000; cor=500; sdr=500; ov=2; ;;
    7) echo "You are warned not to select custom mode."; mode="Custom"
      $rpi_aui/./yn.sh "Do you wish to continue? [y/N]" || cpu_f
      echo -e "\033[91mBe very careful while entering!!\033[0m"; sleep 1
      custom_ask "Enter the ARM frequency: [700-1200]"; arm=$a   #  user
      custom_ask "Enter the Core frequency: [250-500]"; cor=$a   #+ input
      custom_ask "Enter the SD-RAM frequency: [400-500]"; sdr=$a
      custom_ask "Enter the Over Voltage: [0-8]"; ov=$a
      ;;
    q) ui ;;
    *) echo "You enter an invalid option!"; sleep 1; cpu_f ;;
  esac

  # Ask for changes after setting variables
  echo -e "\033[32mYou have selected $mode Preset:\033[m"
  arm="arm_freq $arm"; echo $arm | tr ' ' =     #  Add "$key $value" to make
  cor="core_freq $cor"; echo $cor | tr ' ' =    #+ set_conf easier and echo
  sdr="sdram_freq $sdr"; echo $sdr | tr ' ' =   #+ ' ' in '='
  ov="over_voltage $ov"; echo $ov | tr ' ' =
  $rpi_aui/./yn.sh "Are you sure? [y/N]" || cpu_f
  # Apply the changes to /boot/config.txt in one line(shorter)
  for i in "$arm" "$cor" "$sdr" "$ov"; do set_config $i $conf; done
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

function ui() { # User interface for oc.sh
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
}


#----------------------------------------------------------------------------
# Main
#----------------------------------------------------------------------------
if [ $(stat -fc%t:%T $conf) = $(stat -fc%t:%T /) ]; then    # /boot mounted?
  echo "Boot partition not mounted. Mounting boot partition..."     # Find &
  mount $(fdisk -l|grep "mmcblk0.*FAT32"|cut -d' ' -f1) /boot ||    #+ mount
    echo -e "\e[31mBoot partition not found! Aborting." && exit 1   # /boot?
fi
$rpi_aui/./main.sh root && ui || exit 1 # enter ui if running as root
