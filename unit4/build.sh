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
git clone https://www.github.com/MEGA65/mega65-core
git clone https://www.github.com/