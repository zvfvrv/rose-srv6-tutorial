#!/bin/sh

BASE_DIR=nodeconf
NODE_NAME=gobgp
GW_NAME=r3
IF_NAME=$NODE_NAME-$GW_NAME
BASE_PATH=$BASE_DIR/$NODE_NAME

IP_ADDR=fd00:0:34::2/64
GW_ADDR=fd00:0:34::1
IP_ADDR_v4=192.168.9.254/24
GW_ADDR_v4=192.168.9.3


ip -6 addr add $IP_ADDR dev $IF_NAME 
ip -6 route add default via $GW_ADDR dev $IF_NAME

ip addr add $IP_ADDR_v4 dev $IF_NAME
ip route add default via $GW_ADDR_v4 dev $IF_NAME

/usr/local/bin/gobgpd -f "$PWD"/$BASE_PATH/gobgpd.conf &