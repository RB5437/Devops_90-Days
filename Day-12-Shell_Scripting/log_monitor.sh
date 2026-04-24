#!/bin/bash

log="/var/log/syslog"

errors=$(grep "ERROR" $log | tail -5)

if [ -n "$errors" ]
then
    echo "Errors found "
    echo "$errors"
else
    echo "No errors "
fi
