#!/bin/bash

git clone git://git.qemu-project.org/qemu.git
cd qemu
git checkout v3.0.0

mkdir ../bin
cd ../bin
../qemu.configure --enable-debug
NR_CPUS=`grep "^processor" /proc/cpuinfo | wc -l`
make -j$NR_CPUS
