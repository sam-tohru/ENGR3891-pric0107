echo "Initiating Build operation for Mega65-core"
echo "..."

	read -p "Do you wish to install the Pre-Requisite Packages: " yn
	case $yn in
		[Yy]* )

if (($EUID != 0)); 
	then echo "you should have sudo priveledge to install Packages"
	echo "exiting"
	exit
fi

apt-get update
apt-get install git
apt-get install gcc
apt-get install python
apt-get install gnat-8
apt-get install autoconf
apt-get install flex
apt-get install bison
apt-get install g++
apt-get install libpng-dev
apt-get install make
;; 

		[Nn]* )
echo "ok";;
esac

# Vivado install

read -p "Do you have Vivado installed: " yn
case $yn in
	[Yy]* )
		echo "okay good!"
		;;
	[Nn]* )
		echo "Please install Vivado... Exiting"
		exit
		;;
esac

# Git Repos
echo "Installing git repos"
cd ~
echo "cloning mega65-core"
git clone https://www.github.com/MEGA65/mega65-core.git

echo "cloning fpgajtag"
git clone https://www.github.com/cambridgehackers/fpgajtag.git
echo "making fpgajtag"
cd fpgajtag
make

# making mega65-core
echo "making mega65-core"
cd ~/mega65-core

echo "making simulate"
make simulate

echo "making src/tools/monitor_load"
make src/tools/monitor_load

echo " making src/tools/monitor_save"
make src/tools/monitor_save

echo "making src/tools/mega65_ftp"
make src/tools/mega65-ftp

echo "bin/te0725.bit"
make bin/te0725.bit

echo "made all that's needed"

read -p "Would you want to do a general make?: " yn
case $yn in
	[Yy]* )
		echo "okay, making!"
		make
		;;
	[Nn]* )
		echo "okay, exiting"
		exit
		;;
esac