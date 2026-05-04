#!/bin/bash

for i in {1..5}
do
  if [ $i -eq 3 ]
  then
    continue
  fi
  echo $i
done
