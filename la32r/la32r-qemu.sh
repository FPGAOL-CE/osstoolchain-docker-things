#!/bin/bash
qemu-system-loongarch32 -M ls3a5k32 -kernel /src/la32r-buildroot/output/images/vmlinux -nographic -serial mon:stdio -m 8192 -append "console=ttyS0,115200 loglevel=9 rdinit=/init" -initrd /src/la32r-buildroot/rootfs-my.cpio.gz -smp 1
#qemu-system-loongarch32 -M ls3a5k32 -kernel /src/la32r-Linux/vmlinux -nographic -serial mon:stdio -m 128 -append "console=ttyS0,115200 rdinit=/init loglevel=9"  -monitor tcp::4278,server,nowait -smp 1 -gdb tcp::5295 -d int -D int.log
