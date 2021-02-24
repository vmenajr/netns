#!/usr/bin/env bash
yum -y install -y wget curl xorg-x11-xauth xterm lsof strace socat nc tree tcpdump
yum -y install https://github.com/VSCodium/vscodium/releases/download/1.53.2/codium-1.53.2-1613090035.el7.x86_64.rpm
#rpm --import https://www.virtualbox.org/download/oracle_vbox.asc
#wget http://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo -O /etc/yum.repos.d/virtualbox.repo

# Remove the firewall
systemctl stop firewalld
systemctl mask firewalld

# Add iptables
#yum -y iptables-services
#iptables -nvL

# Configure network namespace
ip netns add test
ip link add veth0 type veth peer name veth1

# namespace device
ip link set veth0 netns test
ip netns exec test ip addr add 192.168.10.1/24 dev veth0 
ip netns exec test ip link set dev veth0 up

# global device
ip addr add 192.168.10.254/24 dev veth1
ip link set dev veth1 up

# Routing between them
ip netns exec test ip ro add default via 192.168.10.254
iptables -A POSTROUTING -t nat -o eth0 -s 192.168.10.0/24 -j MASQUERADE
sysctl -w net.ipv4.ip_forward=1

iptables -t nat -nvL

# Enable X11 localhost pass-thru
sudo -u vagrant socat UNIX-LISTEN:/tmp/.X11-unix/X10,fork TCP:localhost:6010 &


