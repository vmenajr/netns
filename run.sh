#!/usr/bin/env bash
export DISPLAY=:10
#[[ $(pgrep -lfa TCP-LISTEN) ]] || socat TCP-LISTEN:6010,bind=127.0.0.1,reuseaddr,fork UNIX-CONNECT:/tmp/.X11-unix/X10 &
#sudo ip netns exec test sudo -u $USER xterm
sudo ip netns exec test sudo -u $USER $@

