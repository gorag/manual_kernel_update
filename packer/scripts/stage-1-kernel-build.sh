#!/bin/bash

# Install tools
yum install -y ncurses-devel gcc flex bison elfutils-libelf-devel openssl-devel bc perl bzip2

# Load modules for mount
mount -o loop /home/vagrant/VBoxGuestAdditions.iso /mnt

# Download and copy kernel sources
curl -s https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.3.8.tar.xz | tar xfJ - -C /usr/src/kernels/

# Configure and make kernel
cd /usr/src/kernels/linux-5.3.8/
cp /boot/config* .config && \
make olddefconfig && \
yes "" | make localmodconfig && \
make -j$(nproc) bzImage && \
make -j$(nproc) modules && \
make -j$(nproc) && \
make -j$(nproc) modules_install && \
make -j$(nproc) install

# Remove older kernels (Only for demo! Not Production!)
rm -f /boot/*3.10*

# Update GRUB
grub2-mkconfig -o /boot/grub2/grub.cfg && \
grub2-set-default 0
echo "Grub update done."

# Reboot VM
shutdown -r now
