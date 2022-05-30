#!/bin/bash
# dnf
echo fastestmirror=True>>/etc/dnf/dnf.conf
echo max_parallel_downloads=20>>/etc/dnf/dnf.conf
dnf install fedora-workstation-repositories https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf install dnf-automatic -y
env EDITOR='gedit -w' sudoedit /etc/dnf/automatic.conf
systemctl start --now dnf-automatic.timer
systemctl enable --now dnf-automatic.timer

# xanmod kernel
dnf copr enable rmnscnce/kernel-xanmod -y
dnf install kernel-xanmod-edge kernel-xanmod-edge-devel kernel-xanmod-edge-devel-matched kernel-xanmod-edge-headers -y
reboot

# nvidia
dnf install kmod-nvidia xorg-x11-drv-nvidia-libs.i686 xorg-x11-drv-nvidia-cuda libva-vdpau-driver -y
modinfo -F version nvidia
akmods --force
dracut --force
systemctl enable nvidia-{suspend,resume,hibernate}
nano /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
reboot

# virtualization
dnf install @virtualization remmina -y
systemctl start libvirtd
systemctl enable libvirtd

# apps
dnf install telegram discord google-chrome-stable -y