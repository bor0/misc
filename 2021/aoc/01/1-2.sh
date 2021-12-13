#!/bin/bash
IFS=$'\n' read -d '' -r -a lines < input
len=${#lines[@]}
increased=0
for i in $(seq 0 $[len - 2])
  do
    first=${lines[$i]}
    second=${lines[$i+1]}
    third=${lines[$i+2]}
    sum=$[first + second + third]
    if [ -n "$old" ] && [[ $old -lt $sum ]]; then
      increased=$((increased+1))
    fi
    old=$sum
  done

echo $increased
