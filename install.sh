#!/bin/bash

BINDIR=`dirname $0`
cd $BINDIR

sudo apt install -y libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev \
	libgtk2.0-dev

if [ ! -d qemu ]
then
	git clone git://git.qemu-project.org/qemu.git
fi
cd qemu
git checkout v3.0.0

mkdir ../bin
cd ../bin
../qemu/configure --enable-debug
NR_CPUS=`grep "^processor" /proc/cpuinfo | wc -l`
make -j$NR_CPUS
