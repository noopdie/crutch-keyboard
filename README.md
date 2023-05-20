#crutch-keyboard - Virtual Keyboard for Wayland and Xorg.
Works great on KDE Plasma Mobile and KDE Halcyon

Currently under developement. Yet only supports english and russian layout.

Dependencies: evemu-tools, root access, qt5 libraries, sudo

Compilation:
1) Open Qt Creator
2) Open file crutch-keyboard.pro
3) Often it throws an error and asks to select a kit, i select "Desktop" in this case
4) Press Run button, or `Ctrl+R`

Installation:
1) $ `git clone https://github.com/noopdie/crutch-keyboard.git`
2) $ `cd crutch-keyboard`
3) Make sure you can execute binary in crutch-keyboard-files folder (you shoud see a window of keyboard appear). If it doesn`t work, compile one for your system.
4) $ `cp crutch-keyboard-files /`
5) $ `cp crutch-keyboard-sudo /etc/sudoers.d`
6) $ `sudo apt install evemu-tools`
7) $ `sudo evemu-describe`
8) Find address of your physical keyboard
9) `Ctrl + C`
10) $ `sudo evemu-describe /dev/input/event* /crutch-keyboard-files/vkb-device`
11) $ `chmod + crutch-keyboard.desktop`
That's it. You can open it by desktop file or by command `sudo /crutch-keyboard-files/crutch-keyboard
