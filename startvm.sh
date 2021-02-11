#!/bin/bash

bindir=$(dirname $0)

function pr_usage {
	echo "Usage: $0 [OPTIONS] <path to disk file> [<nr_cores> [<ram size>]]"
	echo "  --graphic		start vm in graphic mode"
	echo "  --curses		start vm in curses mode"
	echo "  --sshport <port>	port for ssh server"
	echo "  --cdrom <image>		cdrom image"
	echo "  --mon <sock>		monitor unix domain socket"
	echo "  --qmp <sock>		qmp unix domain socket"
	echo "  --incoming <sock>	migration-listen port"
	echo "  -h, --help	print this message"
}

if [ $# -lt 1 ]
then
	pr_usage
	exit 1
fi

disk_cpu_mem=()
graphic="-nographic"
ssh_port="default"
cdrom=""
monitor=""
qmp=""
incoming=""
while [ $# -ne 0 ]; do
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
		cdrom="-cdrom $2"
		shift 2
		continue
		;;
	"--mon")
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
	"--help" | "-h")
		pr_usage
		exit 0
		;;
	*)
		if [ ${#disk_cpu_mem[@]} -gt 3 ]
		then
			pr_usage
			exit 1
		fi

		disk_cpu_mem+=($1)
		shift 1
		continue
		;;
	esac
done

if [ "$ssh_port" == "default" ]
then
	if [ "$incoming" == "" ]
	then
		ssh_port=2242
	else
		ssh_port=2252
	fi
fi

if [ ${#disk_cpu_mem[@]} -lt 1 ]
then
	pr_usage
	exit 1
fi

disk="${disk_cpu_mem[0]}"

nr_cores=${disk_cpu_mem[1]}
if [ "$nr_cores" == "" ]
then
	nr_cores=$(( $(grep "^processor" /proc/cpuinfo | wc -l) / 2 ))
fi

sz_ram=${disk_cpu_mem[2]}
if [ "$sz_ram" == "" ]
then
	sz_ram=$(( $(grep "^MemTotal" /proc/meminfo | awk '{print $2}') / 4 ))
	sz_ram="$((sz_ram / 1024 * 1024))K"
fi

qemu="$bindir/bin/x86_64-softmmu/qemu-system-x86_64"
if [ ! -f $qemu ]
then
	echo "Looks like QEMU not installed.  Do ./install.sh first"
	exit 1
fi

$qemu -m $sz_ram -smp $nr_cores -enable-kvm \
	-drive if=virtio,file=$disk,cache=none \
	-net user,hostfwd=tcp::$ssh_port-:22 -net nic \
	$graphic $cdrom $monitor $qmp $incoming
