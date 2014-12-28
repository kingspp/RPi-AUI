Raspberry-Pi-AUI v6.2
============

It is a basic introduction for Configuring Raspberry Pi

***Steps to install Raspberry-Pi-AUI:***

1. Download the install file: <br>
wget https://raw.githubusercontent.com/kingspp/Raspberry-Pi-AUI/master/aui-setup.sh<br>
(if you get error regarding **wget**, see the note in the bottom)

2. Give permission for the setup file: <br>
chmod +x aui-setup.sh

3. Run the install: <br>
./aui-setup

***Commands:***

aui   - Arch Ultimate Install UI <br>
aui-disp  - Display UI <br>
aui-oc    - OverClocking UI <br>
aui-userm - Usermanagement UI <br> 
aui-util  - Utility Manager UI <br>

**How to commit to the repository?**<br>
Coming soon...

***Note:***<br>
**Wget error:**<br>
Execute:<br>
pacman -Syu <br>
pacman -S wget <br>
