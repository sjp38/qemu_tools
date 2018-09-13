#!/bin/bash

BINDIR=`dirname $0`
cd $BINDIR

if [ $# -lt 1 ]
then
	echo "Usage: $0 <path to disk file> [<nr_cores> [<ram size> [ssh port]]]"
	exit 1
fi

DISK=$1

NR_CORES=$((`grep "^processor" /proc/cpuinfo | wc -l` / 2))
if [ $# -gt 1 ]
then
	NR_CORES=$2
fi

SZ_RAM=$(( `grep "^MemTotal" /proc/meminfo | awk '{print $2}'` / 4 ))K
if [ $# -gt 2 ]
then
	SZ_RAM=$3
fi

SSH_PORT=2242
if [ $# -gt 3 ]
then
	SSH_PORT=$4
fi

QEMU=./bin/x86_64-softmmu/qemu-system-x86_64
if [ ! -f $QEMU ]
then
	echo "Looks like QEMU not installed.  Do ./install.sh first"
	exit 1
fi

$QEMU -m $SZ_RAM -smp $NR_CORES -enable-kvm \
	-drive if=virtio,file=$DISK,cache=none -redir tcp:$SSH_PORT::22 \
	-nographic
