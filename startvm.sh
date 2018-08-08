#!/bin/bash

BINDIR=`dirname $0`
cd $BINDIR

if [ $# -lt 1 ]
then
	echo "Usage: $0 <path to disk file> [<nr_cores> [ram size]]"
	exit 1
fi

DISK=$1

NR_CORES=16
if [ $# -gt 1 ]
then
	NR_CORES=$2
fi

SZ_RAM=64G
if [ $# -gt 1 ]
then
	SZ_RAM=$2
fi

./bin/x86_64-softmmu/qemu-system-x86_64 -m $SZ_RAM -smp $NR_CORES -enable-kvm \
	-drive if=virtio,file=$DISK,cache=none -redir tcp:2242::22 -nographic
