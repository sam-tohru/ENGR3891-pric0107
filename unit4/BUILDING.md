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
- Run the bin file and install -> IMPORTANT NOTE: Vivado sets install destination automatically at /tools, change this to /opt (as mega65-core will only check for  vivado in this location) 

### Git Repositories
1. Mega65-core: https://www.github.com/MEGA65/mega65-core

2. fpgajtag: https://www.github.com/MEGA65/mega65-core
	- cd fpgajtag
	- make


