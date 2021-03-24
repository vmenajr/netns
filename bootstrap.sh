#!/usr/bin/env bash
yum -y install -y epel-release centos-release-scl
yum -y install -y wget curl xorg-x11-xauth xterm lsof strace socat nc tree tcpdump vim jq git cmake3 rh-git218
#yum -y install https://github.com/VSCodium/vscodium/releases/download/1.53.2/codium-1.53.2-1613090035.el7.x86_64.rpm
#yum -y install https://github.com/VSCodium/vscodium/releases/download/1.52.1/codium-1.52.1-1608165610.el7.x86_64.rpm
#yum -y install https://github.com/VSCodium/vscodium/releases/download/1.51.1/codium-1.51.1-1605141277.el7.x86_64.rpm
yum -y install https://github.com/VSCodium/vscodium/releases/download/1.48.2/codium-1.48.2-1598439338.el7.x86_64.rpm
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

cd ~vagrant

# Disable update checks
sudo -u vagrant mkdir -p .config/VSCodium/User
sudo -u vagrant cp -v /vagrant/defaults.json .config/VSCodium/User/settings.json

# Install the plugins
sudo -u vagrant wget -q https://open-vsx.org/api/vscodevim/vim/1.18.9/file/vscodevim.vim-1.18.9.vsix
sudo -u vagrant wget -q https://open-vsx.org/api/ccls-project/ccls/0.1.29/file/ccls-project.ccls-0.1.29.vsix
sudo -u vagrant wget -q https://open-vsx.org/api/redhat/java/0.76.0/file/redhat.java-0.76.0.vsix
#sudo -u vagrant wget -q https://open-vsx.org/api/donjayamanne/git-extension-pack/0.1.3/file/donjayamanne.git-extension-pack-0.1.3.vsix

# Not supported in 1.48.2
#sudo -u vagrant wget -q https://open-vsx.org/api/eamodio/gitlens/11.3.0/file/eamodio.gitlens-11.3.0.vsix

for f in *.vsix; do
    sudo -u vagrant codium --install-extension $f
done

# Get a sample
sudo -u vagrant git clone https://github.com/ttroy50/cmake-examples.git ~vagrant/examples

# Enable git-2.18 for vagrant
echo "source /opt/rh/rh-git218/enable" >> ~vagrant/.bashrc

