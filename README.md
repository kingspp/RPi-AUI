Raspberry-Pi-AUI v6.2
=====================
> Basic introduction for Configuring Raspberry Pi

Steps to install Raspberry-Pi-AUI:
----------------------------------

1. Download the installation script:
```
wget https://raw.githubusercontent.com/kingspp/Raspberry-Pi-AUI/master/aui-setup.sh
```
(if you get error regarding **wget**, see the [note](https://github.com/kingspp/Raspberry-Pi-AUI/blob/master/README.md#note) in the bottom)

2. Give permission to execute the setup script:
```
chmod +x aui-setup.sh
```

3. Run the installation script:
```
./aui-setup.sh
```

Commands  | Description
----------|--------------------------
aui       | Arch Ultimate Install UI
aui-disp  | Display UI
aui-oc    | OverClocking UI
aui-userm | Usermanagement UI
aui-util  | Utility Manager UI

How to commit to the repository?
--------------------------------
Coming soon...

Note
----
**Wget error.** Execute:
```
sudo pacman -Syu wget
```

Milestone
---------
- [ ] [Commit to the repository](https://github.com/kingspp/Raspberry-Pi-AUI/blob/master/README.md#how-to-commit-to-the-repository)
- [ ] Improve UI
