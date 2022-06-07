#!/bin/bash

#nano /etc/default/grub
intel_iommu=on iommu=pt rd.driver.pre=vfio_pci vfio-pci.ids=10de:1c20,10de:10f1
grub2-mkconfig -o /boot/grub2/grub.cfg
reboot

#lspci -nnk -s 1:

#dnf install git python2 iasl nasm subversion perl-libwww-perl vim dos2unix gcc -y
dnf install dos2unix gcc-c++ patch libuuid-devel -y
cd /var/lib/libvirt/
cp /home/adner/kvm/SSDT1.dat SSDT1.dat
git clone --recurse-submodules https://github.com/tianocore/edk2.git
cd edk2/OvmfPkg/AcpiPlatformDxe
cp /home/adner/kvm/vbios.rom vbios.rom
xxd -i vbios.rom vrom.h
#nano vrom.h
wget https://github.com/jscinoz/optimus-vfio-docs/files/1842788/ssdt.txt -O ssdt.asl
#nano ssdt.asl
iasl -f ssdt.asl
xxd -c1 Ssdt.aml | tail -n +37 | cut -f2 -d' ' | paste -sd' ' | sed 's/ //g' | xxd -r -p > vrom_table.aml
xxd -i vrom_table.aml | sed 's/vrom_table_aml/vrom_table/g' > vrom_table.h
cd ../..
wget https://gist.github.com/unilock/1bdaefb18d0fb66f2c8e219cbb64759d/raw/3498a092ce37a52c456811c4351390e459669bc1/nvidia-hack-2.diff
dos2unix OvmfPkg/AcpiPlatformDxe/QemuFwCfgAcpi.c
patch -p1 < nvidia-hack-2.diff
unix2dos OvmfPkg/AcpiPlatformDxe/QemuFwCfgAcpi.c
make -C BaseTools
. ./edksetup.sh BaseTools
#nano Conf/target.txt
build
yes | cp Build/OvmfX64/DEBUG_GCC5/FV/OVMF_VARS.fd /var/lib/libvirt/qemu/nvram/Win10_VARS.fd
