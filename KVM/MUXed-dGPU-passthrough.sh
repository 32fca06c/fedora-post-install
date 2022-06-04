#!/bin/bash

nano /etc/default/grub
intel_iommu=on iommu=pt rd.driver.pre=vfio_pci vfio-pci.ids=10de:1c20,10de:10f1
grub2-mkconfig -o /boot/grub2/grub.cfg
reboot

lspci -nnk -s 1:

dnf install git python2 iasl nasm subversion perl-libwww-perl vim dos2unix gcc gcc-c++ patch libuuid-devel -y
cd /var/lib/libvirt/
git clone --recurse-submodules https://github.com/tianocore/edk2.git
