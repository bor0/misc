#!/bin/bash
IFS=$'\n' read -d '' -r -a lines < input
len=${#lines[@]}
sums=()
for i in $(seq 0 $[len - 2])
  do
    first=${lines[$i]}
    second=${lines[$i+1]}
    third=${lines[$i+2]}
    sum=$[first + second + third]
    sums+=("${sum}")
  done

increased=0
for i in $(seq 1 $[len-1])
  do
    prev=${sums[$i-1]}
    current=${sums[$i]}
    if [[ $prev -lt $current ]]
    then
      increased=$((increased+1))
    fi
  done

echo $increased
