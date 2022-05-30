#!/bin/bash
# dnf
echo fastestmirror=True>>/etc/dnf/dnf.conf
echo max_parallel_downloads=20>>/etc/dnf/dnf.conf
dnf install fedora-workstation-repositories https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# dnf-automatic
dnf install dnf-automatic -y
env EDITOR='gedit -w' sudoedit /etc/dnf/automatic.conf
systemctl start dnf-automatic.timer
systemctl enable dnf-automatic.timer

# XANMOD kernel
dnf copr enable rmnscnce/kernel-xanmod -y
dnf install kernel-xanmod-edge kernel-xanmod-edge-devel kernel-xanmod-edge-devel-matched kernel-xanmod-edge-headers -y
reboot

# Nvidia
dnf install kmod-nvidia xorg-x11-drv-nvidia-libs.i686 xorg-x11-drv-nvidia-cuda libva-vdpau-driver -y
modinfo -F version nvidia
akmods --force
dracut --force
systemctl enable nvidia-{suspend,resume,hibernate}
nano /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
reboot

# Virtualization
dnf install @virtualization remmina -y
systemctl start libvirtd
systemctl enable libvirtd
echo "vfio" > /etc/modules-load.d/vfio.conf
echo "vfio-pci" > /etc/modules-load.d/vfio-pci.conf
echo "vfio_iommu_type1" > /etc/modules-load.d/vfio_iommu_type1.conf
echo "vfio_virqfd" > /etc/modules-load.d/vfio_virqfd.conf
dracut -f --kver $(uname -r)
grub2-mkconfig > /etc/grub2-efi.cfg
reboot
nano /etc/default/grub
echo options vfio-pci ids=8086:1901,10de:1c20,10de:10f1>/etc/modprobe.d/vfio.conf

# onlyoffice
echo [onlyoffice]>/etc/yum.repos.d/onlyoffice.repo
echo name=onlyoffice repo>>/etc/yum.repos.d/onlyoffice.repo
echo baseurl=https://download.onlyoffice.com/repo/centos/main/noarch/>>/etc/yum.repos.d/onlyoffice.repo
echo gpgcheck=0>>/etc/yum.repos.d/onlyoffice.repo
echo enabled=1>>/etc/yum.repos.d/onlyoffice.repo
dnf install onlyoffice-desktopeditors -y

# Apps
dnf install telegram discord google-chrome-stable qbittorrent -y

# Update
dnf update -y
