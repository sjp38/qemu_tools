#!/bin/bash

BINDIR=`dirname $0`
cd $BINDIR

sudo apt install -y libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev \
	libgtk-3-dev libncurses5-dev libncursesw5-dev

if [ ! -d qemu ]
then
	git clone git://git.qemu-project.org/qemu.git
fi
cd qemu
git checkout v4.2.0

mkdir ../bin
cd ../bin
../qemu/configure --enable-debug --enable-gtk --enable-curses
NR_CPUS=`grep "^processor" /proc/cpuinfo | wc -l`
make -j$NR_CPUS
