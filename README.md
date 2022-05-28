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

/sbin/lspci | grep -e VGA
dnf install kmod-nvidia xorg-x11-drv-nvidia-libs.i686 xorg-x11-drv-nvidia-cuda libva-vdpau-driver -y
modinfo -F version nvidia
akmods --force
dracut --force
systemctl enable nvidia-{suspend,resume,hibernate}
nano /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
reboot

dnf install system76-dkms system76-power system76-driver system76-firmware firmware-manager system76-io-dkms system76-acpi-dkms -y
systemctl enable system76-power system76-power-wake system76-firmware-daemon
systemctl start system76-power system76-firmware-daemon
systemctl enable --user com.system76.FirmwareManager.Notify.timer
system76-power graphics nvidia
reboot

dnf install vulkan-tools cmake ncurses-devel git -y
mkdir /home/adner/Git
cd /home/adner/Git
git clone https://github.com/Syllo/nvtop.git
mkdir -p nvtop/build && cd nvtop/build
cmake .. -DNVIDIA_SUPPORT=ON -DAMDGPU_SUPPORT=ON
make
make install
