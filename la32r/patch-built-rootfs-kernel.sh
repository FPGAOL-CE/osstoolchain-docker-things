#!/bin/bash
cd /src/la32r-buildroot && \
rm -rf cpio-unpack && mkdir cpio-unpack && cd cpio-unpack && \
cat ../output/images/rootfs.cpio | cpio -idmv && \
cp /opt/la32r/sysroot/lib32/ld-linux-loongarch-ilp32s.so.1 ./lib32/ && \
find . | cpio --create --format='newc' | gzip -9 > ../output/images/rootfs-my.cpio.gz
PATH="/src/la32r-buildroot/output/host/bin:/src/la32r-buildroot/output/host/sbin:/opt/la32r/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" PKG_CONFIG="/src/la32r-buildroot/output/host/bin/pkg-config" PKG_CONFIG_SYSROOT_DIR="/" PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1 PKG_CONFIG_ALLOW_SYSTEM_LIBS=1 PKG_CONFIG_LIBDIR="/src/la32r-buildroot/output/host/lib/pkgconfig:/src/la32r-buildroot/output/host/share/pkgconfig" BR_BINARIES_DIR=/src/la32r-buildroot/output/images KCFLAGS=-Wno-attribute-alias /usr/bin/make -j29 HOSTCC="/usr/bin/gcc -O2 -isystem /src/la32r-buildroot/output/host/include -L/src/la32r-buildroot/output/host/lib -Wl,-rpath,/src/la32r-buildroot/output/host/lib" ARCH=loongarch INSTALL_MOD_PATH=/src/la32r-buildroot/output/target CROSS_COMPILE="/src/la32r-buildroot/output/host/bin/loongarch32r-linux-gnusf-" WERROR=0 REGENERATE_PARSERS=1 DEPMOD=/src/la32r-buildroot/output/host/sbin/depmod INSTALL_MOD_STRIP=1 -C /src/la32r-buildroot/output/build/linux-custom vmlinux
cp /src/la32r-buildroot/output/build/linux-custom/vmlinux /src/la32r-buildroot/output/images/vmlinux
ls -al /src/la32r-buildroot/output/images/rootfs-my.cpio.gz
ls -al /src/la32r-buildroot/output/images/vmlinux
#qemu-system-loongarch32 -M ls3a5k32 -kernel /src/la32r-buildroot/output/images/vmlinux -nographic -serial mon:stdio -m 1024 -append "console=ttyS0,115200 loglevel=9"
