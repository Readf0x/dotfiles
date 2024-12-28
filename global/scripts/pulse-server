#!/usr/bin/env zsh

loki2="10.1.10.108"
loki3="10.1.10.115"

if ping -c 1 $loki2; then
	pactl load-module module-native-protocol-tcp port=4656 listen=$loki2 auth-anonymous=true
	ssh loki3 "pactl load-module module-tunnel-sink server=tcp:$loki2:4656"
fi
