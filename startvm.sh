#!/bin/bash

BINDIR=`dirname $0`
cd $BINDIR

if [ $# -ne 1 ]
then
	echo "Usage: $0 <path to disk file>"
	exit 1
fi

DISK=$1

./bin/x86_64-softmmu/qemu-system-x86_64 -m 64G -smp 16 -enable-kvm \
	-drive if=virtio,file=$DISK,cache=none -redir tcp:2242::22 -nographic
