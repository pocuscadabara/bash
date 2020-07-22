#!/usr/bin/env bash

# Install KVM on Ubuntu 16
# Reference: https://www.cyberciti.biz/faq/installing-kvm-on-ubuntu-16-04-lts-server/

# Check for root user
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

apt-get install -y qemu-kvm libvirt-bin virtinst bridge-utils cpu-checker

# Verify installation
kvm-ok

# backup networking configuration
cp /etc/network/interfaces /etc/network/interfaces.bakup.kvm-install

# Configure bridge networking
cat << EOF > /etc/network/interfaces
source /etc/network/interfaces.d/*
auto lo
iface lo inet loopback
auto br0
iface br0 inet static
        address 192.168.2.10
        network 192.168.0.0
        netmask 255.255.255.0
        broadcast 192.168.2.255
        gateway 192.168.2.1
        dns-nameservers 192.168.2.1 8.8.8.8
        bridge_ports enp0s9
        bridge_stp off
        bridge_fd 0
        bridge_maxwait 0
