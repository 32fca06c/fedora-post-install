# fedora-post-install

# https://docs.fedoraproject.org/en-US/quick-docs/setup_rpmfusion/
dnf install fedora-workstation-repositories https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

dnf update -y

dnf copr enable rmnscnce/kernel-xanmod -y

dnf install kernel-xanmod-edge -y
reboot

# https://docs.fedoraproject.org/en-US/quick-docs/getting-started-with-virtualization/
dnf install @virtualization -y

systemctl start libvirtd

systemctl enable libvirtd

#lsmod | grep kvm

nano /etc/default/grub

grub2-mkconfig -o /boot/grub2/grub.cfg
