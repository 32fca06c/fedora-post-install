#!/bin/bash
# dnf
echo fastestmirror=True>>/etc/dnf/dnf.conf
echo max_parallel_downloads=20>>/etc/dnf/dnf.conf
dnf install fedora-workstation-repositories https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
# onlyoffice
echo [onlyoffice]>/etc/yum.repos.d/onlyoffice.repo
echo name=onlyoffice repo>>/etc/yum.repos.d/onlyoffice.repo
echo baseurl=http://download.onlyoffice.com/repo/centos/main/noarch/>>/etc/yum.repos.d/onlyoffice.repo
echo gpgcheck=0>>/etc/yum.repos.d/onlyoffice.repo
echo enabled=1>>/etc/yum.repos.d/onlyoffice.repo
#
dnf config-manager --set-enabled 
# xanmod kernel
dnf copr enable rmnscnce/kernel-xanmod -y

# dnf-automatic
dnf install dnf-automatic -y
env EDITOR='gedit -w' sudoedit /etc/dnf/automatic.conf
systemctl start dnf-automatic.timer
systemctl enable dnf-automatic.timer

# XANMOD kernel
dnf install kernel-xanmod-edge kernel-xanmod-edge-devel kernel-xanmod-edge-devel-matched kernel-xanmod-edge-headers -y

# Virtualization
dnf install @virtualization remmina -y
systemctl start libvirtd
systemctl enable libvirtd
sudo usermod -a -G libvirt $(whoami)

# Apps
dnf install telegram discord google-chrome-stable qbittorrent ark vlc onlyoffice-desktopeditors -y

#
reboot
dnf remove kernel kernel-core kernel-modules kernel-modules-extra -y
