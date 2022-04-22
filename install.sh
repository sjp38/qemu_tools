#!/bin/bash

bindir=$(dirname "$0")
cd "$bindir" || exit 1

sudo apt install -y libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev \
	libgtk-3-dev libncurses5-dev libncursesw5-dev ninja-build \
	build-essential

if [ ! -d qemu ]
then
	git clone git://git.qemu-project.org/qemu.git
fi
cd qemu || exit 1
git remote update
git checkout v7.0.0

mkdir ../bin
cd ../bin || exit 1
../qemu/configure --enable-debug --enable-gtk --enable-curses
make -j"$(nproc)"
