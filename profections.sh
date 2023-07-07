#!/usr/bin/env bash
# Enter birthday and asc sign: ./profections.sh 1963-03-29 2
source include.sh

d1=`date +%Y.%j`
d2=`date --date="$1" +%Y.%j`
d3=`echo "$d1-$d2" | bc -l`
age=`get_int $d3`
asc=$2

sign=`get_sign $age $asc`
echo -e ${Signs_S[$sign]}

