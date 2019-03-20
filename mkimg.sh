#!/bin/bash

CALL_DIR=`pwd`
BINDIR=`dirname $0`
cd $BINDIR

if [ $# -ne 2 ]
then
	echo "Usage: $0 <size> <image file path>"
	exit 1
fi

SZ_IMG=$1
FILE_PATH=$CALL_DIR/$2

./bin/qemu-img create -f qcow2 $FILE_PATH $SZ_IMG
