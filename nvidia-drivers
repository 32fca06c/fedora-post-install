#!/bin/bash
# nvidia drivers
dnf install kmod-nvidia xorg-x11-drv-nvidia-libs.i686 xorg-x11-drv-nvidia-cuda libva-vdpau-driver -y
sleep 2m
modinfo -F version nvidia
akmods --force
dracut --force
systemctl enable nvidia-{suspend,resume,hibernate}
#nano /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
reboot
