#!/bin/bash -e

cd /tmp
wget "https://rightscale-oss-deb-packages.s3.amazonaws.com/linux-image-3.2.30-1khz_3.2.30-1khz-10.00.Custom_amd64.deb"
dpkg -i linux-image-3.2.30-1khz_3.2.30-1khz-10.00.Custom_amd64.deb

[ -e /boot/grub/menu.lst ] && mv -v /boot/grub/menu.lst /boot/grub/menu.lst.original
touch /boot/grub/menu.lst
cat > /boot/grub/menu.lst <<EOF
default     0
timeout     0

title       Ubuntu 12.04 LTS, kernel 3.2.30-1khz
root        (hd0)
kernel      /boot/vmlinuz-3.2.30-1khz root=LABEL=cloudimg-rootfs ro console=hvc0 
initrd      /boot/initrd.img-3.2.30-1khz

title       Ubuntu 12.04 LTS, kernel 3.2.30-1khz (recovery mode)
root        (hd0)
kernel      /boot/vmlinuz-3.2.30-1khz root=LABEL=cloudimg-rootfs ro  single
initrd      /boot/initrd.img-3.2.30-1khz

title       Ubuntu 12.04 LTS, memtest86+
root        (hd0)
kernel      /boot/memtest86+.bin
EOF

rm -fv /tmp/linux-image-3.2.30-1khz_3.2.30-1khz-10.00.Custom_amd64.deb