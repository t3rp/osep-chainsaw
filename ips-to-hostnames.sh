#!/usr/bin/env bash

# Check for valid lab connection
check=`ip a s tun0 | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d ' ' -f 2 | cut -d '.' -f 1`

# Grab fourth octet from tun0
tunnel=`ip a s tun0 | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d ' ' -f 2`
octet=`echo $tunnel | cut -d '.' -f 4`

# Replace ips
sed '/Begin-osep-lab-ips/,/End-osep-lab-ips/d' < /etc/hosts > newhosts

# Add osep/awae ips
echo "#Begin-osep-lab-ips
192.168.$octet.11 win-victim
192.168.$octet.12 win-dev
#End-osep-lab-ips" >> newhosts

# Check for valid connection
if [ "$check" != '192' ]; then
	printf "Double check the VPN connection."
	rm newhosts
	exit
else
	# Make a backup
	mv /etc/hosts /etc/hosts.back
	# Replace with new
	mv newhosts /etc/hosts
fi