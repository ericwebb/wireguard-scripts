#!/bin/bash
# add peer script to wireguard by Eric Webb 8-3-2020 original script
clear
if [ `whoami` != root ]; then
    echo Please run this script as root or using sudo
    exit
fi
echo
echo "Please provide the name of the user"
read -p 'Name: ' namevar
clear
echo "removing client config for: $namevar"

ckey=$(cat clients/$namevar/$namevar.pub)

echo $ckey

if [ -n "$ckey" ]; then
sudo wg set wg0 peer $ckey remove
sudo wg show
else
echo "Please check name"
fi
