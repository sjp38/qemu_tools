#!/bin/bash

call_dir=`pwd`
bindir=`dirname $0`
cd $bindir

if [ $# -lt 1 ]
then
	echo "Usage: $0 [OPTIONS] <path to disk file> [<nr_cores> [<ram size>]]"
	echo "  --graphic       start vm in graphic mode"
	echo "  --curses        start vm in curses mode"
	echo "  --sshport       port for ssh server"
	echo "  --cdrom         cdrom image"
	echo "  --monitor	monitor unix domain socket"
	echo "  --qmp		qmp unix domain socket"
	echo "  --incoming	migration-listen port"
	exit 1
fi

graphic="-nographic"
ssh_port=2242
cdrom=""
monitor=""
qmp=""
incoming=""
while true; do
	case $1 in
	"--graphic")
		graphic="-display gtk"
		shift
		continue
		;;
	"--curses")
		graphic="-curses"
		shift
		continue
		;;
	"--sshport")
		ssh_port=$2
		shift 2
		continue
		;;
	"--cdrom")
		cdrom="-cdrom $call_dir/$2"
		shift 2
		continue
		;;
	"--monitor")
		monitor="-monitor unix:$2,server,nowait"
		shift 2
		continue
		;;
	"--qmp")
		qmp="-qmp unix:$2,server,nowait"
		shift 2
		continue
		;;
	"--incoming")
		incoming="-incoming unix:$2"
		shift 2
		continue
		;;
	*)
		break
		;;
	esac
done


disk="$call_dir/$1"

nr_cores=$((`grep "^processor" /proc/cpuinfo | wc -l` / 2))
if [ $# -gt 1 ]
then
	nr_cores=$2
fi

sz_ram=$(( `grep "^MemTotal" /proc/meminfo | awk '{print $2}'` / 4 ))
if [ $sz_ram -gt 1024 ]
then
	sz_ram=$((sz_ram / 1024 * 1024))
fi
sz_ram+="K"
if [ $# -gt 2 ]
then
	sz_ram=$3
fi

qemu=./bin/x86_64-softmmu/qemu-system-x86_64
if [ ! -f $qemu ]
then
	echo "Looks like QEMU not installed.  Do ./install.sh first"
	exit 1
fi

$qemu -m $sz_ram -smp $nr_cores -enable-kvm \
	-drive if=virtio,file=$disk,cache=none \
	-net user,hostfwd=tcp::$ssh_port-:22 -net nic \
	$graphic $cdrom $monitor $qmp $incoming
