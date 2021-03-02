#!/usr/bin/env bash
rm -f /vagrant/capture.pcap
sudo tcpdump -i veth1 -w /vagrant/capture.pcap
