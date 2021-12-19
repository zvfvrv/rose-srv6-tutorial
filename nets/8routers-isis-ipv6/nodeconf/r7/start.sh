#!/bin/sh

BASE_DIR=nodeconf
NODE_NAME=r7
FRR_PATH=/usr/lib/frr
BASE_PATH=$BASE_DIR/$NODE_NAME
OUTPUT_PATH=/tmp/nodes/$NODE_NAME
#enable IPv4 forwarding
sysctl -w net.ipv4.ip_forward=1
#enable IPv6 forwarding
sysctl -w net.ipv6.conf.all.forwarding=1
#disable reverse path filtering (needed for dynamic routing)
#sysctl -w net.ipv4.conf.all.rp_filter=0
#sysctl -w net.ipv4.conf.default.rp_filter=0
#the following for loop also disables all and default
#for i in /proc/sys/net/ipv4/conf/*/rp_filter ; do
  #echo 0 > $i 
#done


echo "no service integrated-vtysh-config" >> /etc/frr/vtysh.conf
chown frr:frrvty $BASE_PATH
chown frr:frrvty $OUTPUT_PATH
#chown quagga:quagga $BASE_DIR/$NODE_NAME

$FRR_PATH/zebra -f "$PWD"/$BASE_PATH/zebra.conf -d -z $OUTPUT_PATH/zebra.sock -i $OUTPUT_PATH/zebra.pid

sleep 1

$FRR_PATH/isisd -f "$PWD"/$BASE_PATH/isisd.conf -d -z $OUTPUT_PATH/zebra.sock -i $OUTPUT_PATH/isisd.pid

# enable Segment Routing for IPv6
sysctl -w net.ipv6.conf.all.seg6_enabled=1
for dev in $(ip -o -6 a | awk '{ print $2 }' | grep -v "lo")
do
   sysctl -w net.ipv6.conf."$dev".seg6_enabled=1
done