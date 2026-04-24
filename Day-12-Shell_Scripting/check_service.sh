#!/bin/bash

service="nginx"

if systemctl is-active --quiet $service
then
    echo "$service is Running"
else
    echo "$service is down "
    echo "restarting..."
    systemctl restart $service
fi
