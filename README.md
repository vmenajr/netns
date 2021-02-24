# netns
Network namespace playground

A place to execute a single process in it's own network namespace.  This to simplify the capture of network traffic from said application.

## Requirements
- Internet access
- VirtualBox
- vagrant

## Setup
- clone the repo
- vagrant up

## Test
The initial test is for codium and as such the shell script in /vagrant/run.sh will execute codium in namespace test.
- vagrant ssh
- /vagrant/capture.sh &
- /vagrant/run.sh

*Note*: This excludes X11 traffic

## References
- [Intro to namespaces](https://blog.scottlowe.org/2013/09/04/introducing-linux-network-namespaces/)
- [socat intro](https://copyconstruct.medium.com/socat-29453e9fc8a6)
- [Process network mitm with ip netns](https://bytefreaks.net/gnulinux/how-to-capture-all-network-traffic-of-a-single-process)
- [socat mitm ](https://gist.github.com/jhass/5896418)
- [X11 routing with socat](https://unix.stackexchange.com/a/274703)
- [vagrant vbguest plugin](https://github.com/dotless-de/vagrant-vbguest)

