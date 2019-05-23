# Building the Mega65-Core
Was built on Ubuntu 18.04.2 LTS x86_64

### Packages - Installed via: Sudo apt install Package
1. git 
2. gcc
3. python (2.7.15)
4. gnat-8
5. autoconf
6. flex
7. bison
8. g++
9. libpng-dev
10. make

### Other Software
1. Vivado
	- Download Vivado HLx 2018.3: WebPACK and Editions - Linux Self Extracting Web Installer
	- Via: https://www.xilinx.com/support/download.html
	- Run the bin file and install -> **IMPORTANT NOTE:** Vivado sets install destination automatically at /tools, change this to /opt (as mega65-core will only check for  vivado in this location) 

### Git Repositories - Installed via: git clone HTTP-Addr
1. Mega65-core: https://www.github.com/MEGA65/mega65-core

2. fpgajtag: https://www.github.com/MEGA65/mega65-core
*Follow the code below to make*
```bash	
	cd fpgajtag
	make
```

**NOTE:** this worked for me, however the mega65 documentation states if make does not work for fpgajtag install the package - libusb-1.0-0-dev and try again or follow below
```bash
	sudo cp src.fpgajtag /usr/local/bin
	cd ..
	cd mega65-core
```

If installed the below should get a meaningful response
	- fpgajtag --version

### Making mega65-core
As part of this Workshop Unit 4 - only the following targets were needed to compile
*Following requires you to be in ~/mega65-core*
```bash
cd ~/mega65-core
```
**simulation**
```bash
make simulate
```
**_Compiled Successfully for me_**

**src/tools/monitor_load**
```bash
make src/tools/monitor_load
```
**_Compiled Successfully for me_**

**src/tools/monitor_save**
```bash
make src/tools/monitor_save
```
**_Compiled Successfully for me_**

**src/tools/mega65_ftp**
```bash
make src/tools/mega65_ftp
```
**_Compiled Successfully for me_**

**bin/te0725.bit**
```bash
make bin/te0725.bit
```
**_Did not compile for me yet_**
bin/te0725.bit is the only target that i have not gotten to run yet, Error is

#### General Make
```bash
cd ~/mega65-core
make
```


