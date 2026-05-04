#!/bin/bash


disk=$(df -h | awk 'NR==2 {print $5}' | tr -d '%')
echo "Disk Usage: $disk%"


if [ "$disk" -gt 80 ]
then
	echo "Disk Usage high"

else 
	echo "Disk is Normal"
fi
