qemu-system-riscv32 -M virt -bios /home/user/buildroot/output/images/fw_jump.elf -kernel /home/user/buildroot/output/images/Image -append "rootwait root=/dev/vda ro" -drive file=/home/user/buildroot/output/images/rootfs.ext2,format=raw,id=hd0 -device virtio-blk-device,drive=hd0 -netdev user,id=net0 -device virtio-net-device,netdev=net0 -nographic
