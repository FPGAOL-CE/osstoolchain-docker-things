## OpenXC7 Dockerized User Guide

### Installation and basic usage

The pre-built Docker image containing the open-source 7-series FPGA development tools (OpenXC7) is available: 

`docker pull regymm/openxc7`

Or, the Dockerfile is available to be built locally at https://github.com/FPGAOL-CE/osstoolchain-docker-things/blob/master/openxc7/Dockerfile.openxc7

After pulling or building the image, installed FPGA tools will be available: 

```
$ docker run -it --rm regymm/openxc7:latest  
root@dee188b1f231:/# which yosys
/usr/local/bin/yosys
root@dee188b1f231:/# which nextpnr-xilinx 
/usr/local/bin/nextpnr-xilinx
root@dee188b1f231:/# which fasm
/prjxray/env/bin/fasm
root@dee188b1f231:/#
```

A simple blinky demo is available on GitHub at https://github.com/FPGAOL-CE/osstoolchain-docker-things/tree/master/openxc7/demo , and can be run with the following commands:

```
$ git clone https://github.com/FPGAOL-CE/osstoolchain-docker-things/
$ cd osstoolchain-docker-things/openxc7/demo
$ docker run -it --rm -v .:/mnt regymm/openxc7:latest make -C /mnt
```

After finishing, `blinky.bit` will be generated as well as some intermediate files. 

Contents of the demo files are also listed here: 

- blinky.v

```verilog
`default_nettype none   //do not allow undeclared wires
module blinky (
    input  wire clk,
    output wire led
    );

    reg [24:0] r_count = 0;

    always @(posedge(clk)) r_count <= r_count + 1;

    assign led = r_count[24];
endmodule
```

- blinky.xdc

```
set_property LOC E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]

set_property LOC H5 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports {led}]
```

- Makefile

  ```Makefile
  DB_DIR=/nextpnr-xilinx/xilinx/external/prjxray-db
  CHIPDB=/chipdb
  CHIPFAM=artix7
  
  #PART = xc7a100tcsg324-1
  PART = xc7a35tcsg324-1
  
  .PHONY: all
  all: blinky.bit
  
  .PHONY: program
  program: blinky.bit
  	openFPGALoader --board arty --bitstream $<
  
  blinky.json: blinky.v
  	yosys -p "synth_xilinx -flatten -abc9 -nobram -arch xc7 -top blinky; write_json blinky.json" $<
  
  # The chip database only needs to be generated once
  # that is why we don't clean it with make clean
  ${CHIPDB}/${PART}.bin:
  	pypy3 /nextpnr-xilinx/xilinx/python/bbaexport.py --device ${PART} --bba ${PART}.bba
  	bbasm -l ${PART}.bba ${CHIPDB}/${PART}.bin
  	rm -f ${PART}.bba
  
  blinky.fasm: blinky.json ${CHIPDB}/${PART}.bin
  	nextpnr-xilinx --chipdb ${CHIPDB}/${PART}.bin --xdc blinky.xdc --json blinky.json --fasm $@ --verbose --debug
  	
  blinky.frames: blinky.fasm
  	fasm2frames --part ${PART} --db-root ${DB_DIR}/${CHIPFAM} $< > $@ #FIXME: fasm2frames should be on PATH
  
  blinky.bit: blinky.frames
  	xc7frames2bit --part_file ${DB_DIR}/${CHIPFAM}/${PART}/part.yaml --part_name ${PART} --frm_file $< --output_file $@
  
  .PHONY: clean
  clean:
  	@rm -f *.bit
  	@rm -f *.frames
  	@rm -f *.fasm
  	@rm -f *.json
  ```

### Makefile Generation

The Makefile is quite tedious to write. An automation tool, CaaS Wizard (caasw), can be used. It uses a small config file to generate Makefiles that can be directly used with this Docker image (and Docker image for other FPGA families). 

This is the document for installation and configuration: https://github.com/FPGAOL-CE/caas-wizard/blob/main/docs/CaaS%20Wizard%20API%20Access.md

One generated Makefile is like this: https://github.com/FPGAOL-CE/core_jpeg/blob/main/Makefile.caas

### Example

A more complex example is the [TetriSaraj](https://github.com/FPGAOL-CE/openXC7-TetriSaraj) project with a picorv32 core inside. 

With a simple caas.conf specifying source code and FPGA chip (the Server entry doesn't matter for now. Please be careful about relative directories): 

```ini
[caas]
Server = http://127.0.0.1:18888

[project]
Backend = openxc7
Part = xc7a35tcpg236-1
Top = top
Constraint = ./1.hw/top.basys3.xdc
Sources = ./1.hw/top.basys3.v,./1.hw/ip.cpu/picosoc_noflash.v,./1.hw/ip.cpu/picorv32.v,./1.hw/ip.vga/*.v,./1.hw/ip.misc/*.v,./1.hw/ip.display/*.v,./*.v
```

These instructions will directly run the project: 

```
$ git clone https://github.com/FPGAOL-CE/openXC7-TetriSaraj/
$ cd openXC7-TetriSaraj
$ ~/caas-wizard/caasw.py --overwrite mfgen caas.conf . # Assuming my caasw is in this directory
$ ./run_caas.sh
(takes ~3 min to run)
(top.bit and top.log available at build/ directory)
```

