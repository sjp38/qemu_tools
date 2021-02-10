#!/bin/bash

call_dir=$(pwd)
bindir=$(dirname "$0")
cd "$bindir" || exit 1

if [ $# -ne 2 ]
then
	echo "Usage: $0 <size> <image file path>"
	exit 1
fi

sz_img=$1
file_path=$call_dir/$2

./bin/qemu-img create -f qcow2 "$file_path" "$sz_img"
