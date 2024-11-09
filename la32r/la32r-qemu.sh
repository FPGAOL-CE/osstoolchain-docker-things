#!/bin/bash
qemu-system-loongarch32 -M ls3a5k32 -kernel /src/la32r-Linux/vmlinux -nographic -serial mon:stdio -m 128 -append "console=ttyS0,115200 rdinit=/init loglevel=9"  -monitor tcp::4278,server,nowait -smp 1 -gdb tcp::5295 -d int -D int.log
