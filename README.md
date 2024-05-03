## osstoolchain-docker-things

#### OPENXC7

Pull image: `docker pull regymm/openxc7`
Build image: `docker build -t regymm/openxc7 -f Dockerfile.openxc7 .`

#### F4PGA

F4PGA image based on carlosedp/symbiflow

Pull image: `docker pull regymm/symbiflow`
Build image: `docker build -t regymm/symbiflow -f Dockerfile.symbiflow .`

#### VIVADO

The proprietary solution for Xilinx FPGAs. 

A local installation is required to be compress to tar.gz format for building the docker file, which certainly won't be released here. Vivado 2019.1 installation using offline full-sized installer is recommended. `xsetup --agree XilinxEULA,3rdPartyEULA --batch Install --config install_config.txt` can be used for command line installation. A config containing only 7-series devices is [here](vivado/install_config.txt). 

See [Dockerfile](vivado/Dockerfile.vivado) for details. 

#### RISCV TOOLCHAINS

RV32IMA minimal buildroot toolchain for MMU/No-MMU development. Based on my [No MMU buildroot port](https://github.com/regymm/buildroot) Contains a pre-built Linux kernel/rootfs ready for QEMU launch. 

Run image: `docker run regymm/buildroot-rv32mmu` and `docker run regymm/buildroot-rv32nommu`. 
