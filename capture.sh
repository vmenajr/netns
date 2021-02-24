#!/usr/bin/env bash
sudo tcpdump -v -i veth1 -w /vagrant/capture.pcap
