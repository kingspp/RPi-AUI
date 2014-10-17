#!/bin/bash
# Pi4J v1.0
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
#------------------------------------------------------------------------------------------------
function top()
{
clear
echo "##############################################################"
echo "##   Welcome to Pi4J v1.0                                   ##"
echo "##   -- By kingspp                                          ##"
echo "##############################################################"
echo "  "
sleep 1
}

function ask()
{
  read ch
  if [ "$ch" == 'y' ]; then
  echo ""
  else
  clear 
  exit  
  fi
}


top
echo "Do you want to install Pi4J ? [y/n]  "
ask
echo "Installing . . ."
sleep 1
wget https://github.com/glnds/pi4j-arch/releases/download/arch-release%2F0.0.5/pi4j-0.0.5.tar.gz
tar -xvzf pi4j-0.0.5.tar.gz
mkdir /opt/pi4j
mv pi4j-0.0.5/lib/ /opt/pi4j/
mv pi4j-0.0.5/examples/ /opt/pi4j/
mv pi4j-0.0.5/LICENSE.txt  /opt/pi4j/
mv pi4j-0.0.5/NOTICE.txt  /opt/pi4j/
mv pi4j-0.0.5/README.md  /opt/pi4j/




#sudo java -cp SomeJar.jar:.:classes:/opt/pi4j/lib/'*' be.pixxis.Example #Command to compile and run .java file 
#javac -classpath .:classes:/opt/pi4j/lib/'*' -d . FileName.java #Compile the java file`
#java -classpath .:classes:/opt/pi4j/lib/'*' ControlGpioExample # Run the program

rm -rf pi4j-0.0.5.tar.gz
rm pi4j-0.0.5

echo "Installation Complete "
sleep 2












