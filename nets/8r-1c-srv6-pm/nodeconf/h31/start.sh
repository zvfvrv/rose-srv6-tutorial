#!/bin/bash

BASE_DIR=/home/user/Progetto/1920-srv6-tutorial/nets/8routers-isis-ipv6/nodeconf
NODE_NAME=h31
GW_NAME=r3
IF_NAME=$NODE_NAME-$GW_NAME
IP_ADDR=fd00:0:31::2/64
GW_ADDR=fd00:0:31::1

ip -6 addr add $IP_ADDR dev $IF_NAME 
ip -6 route add default via $GW_ADDR dev $IF_NAME
