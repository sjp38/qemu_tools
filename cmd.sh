#!/bin/bash

# Send command to unix domain socket for monitor or qmp.  The qemu instance
# should started with monitor or qmp unix domain socket.

if [ $# -ne 2 ]
then
	echo "Usage: $0 <monitor or qmp unix socket> <cmd>"
	exit 1
fi

sock=$1
cmd=$2

echo "$cmd" | socat - unix-connect:"$sock"
echo
