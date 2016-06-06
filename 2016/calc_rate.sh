#!/bin/bash
# This program shows how the src_currency rates against dst_currency.
# It does that by comparing the ratio between x:src and x:dst, where x is one of the top 4 currencies, and src is EUR.
# The smaller the delta over a given period, the more "fixed" rate dst_currency has against src_currency.

# Example results of 9 random countries, sorted by ascending delta, over a 10-year period:
# Currency,Avg,Delta
# UAH,6.03,0.00001
# NOK,8.04,0.00002
# PLN,3.77,0.0002
# TRY,1.57,0.0003
# BGN,1.95,0.001
# RON,3.5,0.001
# HRK,7.29,0.003
# MKD,61.48,0.09
# ALL,122.78,0.18
if [ -z "$1" ];
then
    echo "specify destination currency";
    exit 0
fi

dest_currencies=(USD JPY GBP CHF)
src_currency=EUR
dst_currency=$(echo $1 | awk '{print toupper($0)}')
array=()

# Calculate (x:src)/(x:dst) currencies into array
for var in "${dest_currencies[@]}"
do
    data1=$(curl -s "http://www.google.com/finance/getprices?q=$var$src_currency&x=CURRENCY&i=86400&p=10Y&f=d,c" | head -n 8 | tail -n 1 | awk '{split($0,a,","); print a[2]}')
    data2=$(curl -s "http://www.google.com/finance/getprices?q=$var$dst_currency&x=CURRENCY&i=86400&p=10Y&f=d,c" | head -n 8 | tail -n 1 | awk '{split($0,a,","); print a[2]}')
    calc=$(echo "$data2/$data1" | bc -l)
    echo -e "$var:\t$calc"
    array+=($calc)
done

# Calculate average of array
avg=0
for var in "${array[@]}"
do
    avg=$(echo $avg + $var | bc -l)
done
avg=$(echo $avg/${#array[@]} | bc -l)
echo -e "Avg:\t$avg"

# Calculate differences between average of array
d_sum=0
for var in "${array[@]}"
do
    delta=$(echo "define abs(x) {if (x<0) {return -x}; return x;}; abs($avg - $var)" | bc -l)
    d_sum=$(echo $d_sum + $delta | bc -l)
done
d_sum=$(echo $d_sum/${#array[@]} | bc -l)
echo -e "Delta:\t$d_sum"
